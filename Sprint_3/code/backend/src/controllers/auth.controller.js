const asyncHandler = require("express-async-handler");
const { signToken } = require("../utils/jwt");
const userService = require("../services/user.service");
const ApiError = require("../utils/ApiError");

// Contributer: Nattawadee Chaleechat [Description] แก้ password ให้เป็นไปตาม NCSC UK's guidelines
const {
  isThreeRealWords,
  isBlacklistedPassword,
  generatePasswordSuggestion,
} = require("../validations/passwordValidator");
// Contributer: Piyawat Sawatkul [Description] แก้ password และเพิ่มblacklist และชื่อที่เหมือนกับข้อมูลผู้ใช้

const getUserTokens = ({ username, email, firstName, lastName }) =>
  [
    username?.toLowerCase(),
    email?.toLowerCase().split("@")[0],
    firstName?.toLowerCase(),
    lastName?.toLowerCase(),
  ].filter(Boolean);

const validatePasswordAgainstUserInfo = (password, userInfo) => {
  const pwLower = password.toLowerCase();
  const userTokens = getUserTokens(userInfo);
  const matchedToken = userTokens.find(
    (token) => token.length >= 3 && pwLower.includes(token),
  );

  if (matchedToken) {
    throw new ApiError(
      400,
      "รหัสผ่านต้องไม่มีชื่อผู้ใช้ อีเมล ชื่อจริง หรือนามสกุล",
    );
  }
};

const login = asyncHandler(async (req, res) => {
  const { email, username, password } = req.body;

  let user;
  if (email) {
    user = await userService.getUserByEmail(email);
  } else if (username) {
    user = await userService.getUserByUsername(username);
  }

  if (user && !user.isActive) {
    throw new ApiError(401, "Your account has been deactivated.");
  }

  const passwordIsValid = user
    ? await userService.comparePassword(user, password)
    : false;
  if (!user || !passwordIsValid) {
    throw new ApiError(401, "Invalid credentials");
  }

  // Contributer: Nattawadee Chaleechat [Description] เช็ค password ให้เป็นไปตาม NCSC UK's guidelines
  const isCompliant = isThreeRealWords(password);

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
      requirePasswordChange: !isCompliant,
      ...(!isCompliant && {
        passwordChangeMessage:
          "รหัสผ่านของคุณไม่ปลอดภัยเพียงพอ กรุณาเปลี่ยนให้มีอย่างน้อย 3 คำ เช่น apple-mango-banana",
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
  console.log("validatePassword called", req.body);

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
