const asyncHandler = require("express-async-handler");
const { signToken } = require("../utils/jwt");
const userService = require("../services/user.service");
const ApiError = require("../utils/ApiError");

// Contributer: Nattawadee Chaleechat [Description] แก้ password ให้เป็นไปตาม NCSC UK's guidelines
const { isThreeRealWords } = require("../validations/passwordValidator");

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
    data: { token, user: safeUser },
  });
});

const changePassword = asyncHandler(async (req, res) => {
  const userId = req.user.sub;
  const { currentPassword, newPassword } = req.body;

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
const validatePassword = asyncHandler(async (req, res) => {
  console.log("validatePassword called", req.body);

  const { password } = req.body;

  if (!password) {
    throw new ApiError(400, "Password is required");
  }

  const isValid = isThreeRealWords(password);

  if (!isValid) {
    throw new ApiError(
      400,
      "รหัสผ่านต้องประกอบด้วยอย่างน้อย 3 คำ คั่นด้วย - หรือ _ เช่น apple-mango-banana หรือ CamelCase เช่น AppleMangoBanana",
    );
  }

  res.status(200).json({
    success: true,
    message: "Password is valid",
  });
});

module.exports = { login, changePassword, validatePassword };
