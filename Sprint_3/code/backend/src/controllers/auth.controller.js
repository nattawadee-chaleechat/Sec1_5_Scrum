const asyncHandler = require("express-async-handler");
const { signToken } = require("../utils/jwt");
const userService = require("../services/user.service");
const ApiError = require("../utils/ApiError");

// Contributer: Nattawadee Chaleechat [Description] แก้ password ให้เป็นไปตาม NCSC UK's guidelines
const {
  isThreeRealWords,
  isBlacklistedPassword,
  generatePasswordSuggestion,
  getPasswordUserInfoToken,
} = require("../validations/passwordValidator");
// Contributer: Piyawat Sawatkul [Description] แก้ password และเพิ่มblacklist และชื่อที่เหมือนกับข้อมูลผู้ใช้

const validatePasswordAgainstUserInfo = (password, userInfo) => {
  const matchedToken = getPasswordUserInfoToken(password, userInfo);

  if (matchedToken) {
    throw new ApiError(
      400,
      "รหัสผ่านต้องไม่มีชื่อผู้ใช้ อีเมล ชื่อจริง หรือนามสกุล",
    );
  }
};

const login = asyncHandler(async (req, res) => {
  const { email, username, password } = req.body;
  // Contributer: Nattawadee Chaleechat [Description] เช็คการใส่รหัสผิดเกิน 3 ครั้ง
  const MAX_ATTEMPTS = 3;

  let user;
  if (email) {
    user = await userService.getUserByEmail(email);
  } else if (username) {
    user = await userService.getUserByUsername(username);
  }

  if (user && !user.isActive) {
    // Contributer: Nattawadee Chaleechat [Description] เพิ่ม throw new ApiError 403
    if (user.accountLockedUntil) {
      throw new ApiError(
        403,
        "บัญชีของคุณถูกระงับ เนื่องจากกรอกรหัสผ่านผิดเกิน 3 ครั้ง กรุณาติดต่อแอดมิน",
      );
    }
    throw new ApiError(401, "Your account has been deactivated.");
  }

  //Contributer: Nattawadee Chaleechat [Description] เช็คว่า account ถูก lock อยู่มั้ย
  //[AI Declare] : ให้ claude.ai ช่วยไกด์การเขียนโค้ด

  if (
    user.accountLockedUntil &&
    new Date() < new Date(user.accountLockedUntil)
  ) {
    throw new ApiError(403, "บัญชีของคุณถูกระงับชั่วคราว กรุณาติดต่อแอดมิน");
  }

  /*const passwordIsValid = user
    ? await userService.comparePassword(user, password)
    : false;
  if (!user || !passwordIsValid) {
    throw new ApiError(401, "Invalid credentials");
  }*/

  const passwordIsValid = await userService.comparePassword(user, password);

  // ถ้ากรอกรหัสผิด
  if (!passwordIsValid) {
    const newFailedAttempts = (user.failedLoginAttempts || 0) + 1;

    if (newFailedAttempts >= MAX_ATTEMPTS) {
      // lock account
      await userService.updateUserProfile(user.id, {
        failedLoginAttempts: newFailedAttempts,
        accountLockedUntil: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000), // lock ไปก่อน ค่อยให้ admin ปลดเอง
        isActive: false,
      });
      throw new ApiError(
        403,
        "บัญชีของคุณถูกระงับ เนื่องจากกรอกรหัสผ่านผิดเกิน 3 ครั้ง กรุณาติดต่อแอดมิน",
      );
    }

    // ยังไม่ครบ 3 ครั้ง อัปเดต counter
    await userService.updateUserProfile(user.id, {
      failedLoginAttempts: newFailedAttempts,
    });

    throw new ApiError(
      401,
      `Invalid credentials (สามารถกรอกได้อีก ${MAX_ATTEMPTS - newFailedAttempts} ครั้ง)`,
    );
  }

  // login สำเร็จ reset counter
  await userService.updateUserProfile(user.id, {
    failedLoginAttempts: 0,
    accountLockedUntil: null,
    lastLogin: new Date(),
  });

  // Contributer: Nattawadee Chaleechat [Description] เช็ค password ให้เป็นไปตาม NCSC UK's guidelines
  const isCompliant = isThreeRealWords(password);
  // เช็ครหัสผ่านหมดอายุหรือยัง (90 วัน)
  const isPasswordExpired =
    user.passwordExpiresAt && new Date() > new Date(user.passwordExpiresAt);
  const token = signToken({ sub: user.id, role: user.role });
  const {
    password: _,
    gender,
    phoneNumber,
    otpCode,
    nationalIdNumber,
    nationalIdPhotoUrl,
    nationalIdExpiryDate,
    selfiePhotoUrl,
    isVerified,
    isActive,
    lastLogin,
    createdAt,
    updatedAt,
    username: __,
    email: ___,
    ...safeUser
  } = user;

  res.status(200).json({
    success: true,
    message: "Login successful",
    data: {
      token,
      user: safeUser,
      // Contributer: Nattawadee Chaleechat [Description] เช็ค password ให้เป็นไปตาม NCSC UK's guidelines
      requirePasswordChange: !isCompliant || isPasswordExpired,
      ...(!isCompliant && {
        passwordChangeMessage:
          "รหัสผ่านของคุณไม่ปลอดภัยเพียงพอ กรุณาเปลี่ยนให้มีอย่างน้อย 3 คำ เช่น apple-mango-banana",
      }),
      ...(isPasswordExpired && {
        passwordChangeMessage:
          "รหัสผ่านของคุณหมดอายุแล้ว กรุณาเปลี่ยนรหัสผ่านใหม่",
      }),
    },
  });
});

const changePassword = asyncHandler(async (req, res) => {
  const userId = req.user.sub;
  const { currentPassword, newPassword } = req.body;

  const user = await userService.getUserById(userId);
  validatePasswordAgainstUserInfo(newPassword, user);

  const result = await userService.updatePassword(
    userId,
    currentPassword,
    newPassword,
  );

  if (!result.success) {
    if (result.error === "INCORRECT_PASSWORD") {
      throw new ApiError(401, "Incorrect current password.");
    }
    if (result.error === "PASSWORD_UNCHANGED") {
      throw new ApiError(
        400,
        "New password must not be the same as your current password",
      );
    }
    if (result.error === "PASSWORD_REUSED") {
      throw new ApiError(
        400,
        "รหัสผ่านใหม่ต้องไม่ซ้ำกับ 5 รหัสผ่านที่เคยใช้ล่าสุด",
      );
    }
    throw new ApiError(500, "Could not update password.");
  }

  res.status(200).json({
    success: true,
    message: "Password changed successfully",
    data: null,
  });
});

// Contributer: Nattawadee Chaleechat [Description] แก้ password ให้เป็นไปตาม NCSC UK's guidelines
// Ai declare : ให้ claude.ai ช่วยไกด์การเขียนโค้ด
//Contributer: Piyawat Sawatkul [Description] แก้ password และเพิ่มblacklist ให้เป็นไปตาม NCSC UK's guidelines
// Ai declare : ให้ chatgpt ช่วยไกด์การเขียนโค้ด
const validatePassword = asyncHandler(async (req, res) => {
  //console.log("validatePassword called", req.body);

  const { password, username, email, firstName, lastName } = req.body;

  if (!password) {
    throw new ApiError(400, "Password is required");
  }

  // Piyawat Sawatkul ตรวจว่า password ไม่มีข้อมูลผู้ใช้หรือชื่อบริการ
  validatePasswordAgainstUserInfo(password, {
    username,
    email,
    firstName,
    lastName,
  });

  const isBlacklisted = isBlacklistedPassword(password);
  if (isBlacklisted) {
    throw new ApiError(400, "Password is too common and not allowed");
  }

  const hasThreeRealWords = isThreeRealWords(password);
  if (!hasThreeRealWords) {
    throw new ApiError(
      400,
      "รหัสผ่านต้องประกอบด้วยอย่างน้อย 3 คำ (คำอังกฤษ 3 ตัวอักษรขึ้นไป) คั่นด้วย - หรือ _ เช่น apple-mango-banana หรือ CamelCase เช่น AppleMangoBanana และต้องไม่มีชื่อผู้ใช้ อีเมล ชื่อจริง หรือนามสกุล",
    );
  }

  res.status(200).json({
    success: true,
    message: "Password is valid",
  });
});

const getPasswordSuggestion = asyncHandler(async (_req, res) => {
  const suggestion = generatePasswordSuggestion(3, "-");

  res.status(200).json({
    success: true,
    message: "Password suggestion generated",
    data: {
      suggestion,
    },
  });
});

module.exports = {
  login,
  changePassword,
  validatePassword,
  getPasswordSuggestion,
};