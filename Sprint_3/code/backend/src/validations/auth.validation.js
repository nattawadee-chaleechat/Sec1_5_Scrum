const { z } = require("zod");

//Contributer: Nattawadee Chaleechat [Description] แก้ไข password validation เพิ่มเงื่อนไขต้องมีอย่างน้อย 8 ตัว ห้ามมี spaces และมีคำอย่างน้อย 3 คำ
const { isThreeRealWords } = require("../validations/passwordValidator");

const passwordRules = z
  .string()
  .min(8, "Password must be at least 8 characters")
  .regex(/^\S+$/, "Password must not contain spaces")
  .refine(isThreeRealWords, {
    message:
      "Password must contain at least 3 real words (e.g. apple-mango-banana)",
  });

const loginSchema = z
  .object({
    email: z.string().email("Invalid email format").optional(),
    username: z
      .string()
      .min(6, "Username must be at least 6 characters")
      .optional(),
    // ยังไม่เช็ค เพราะหากตั้งรหัสก่อนหน้านี้ จะเข้าไม่ได้ ต้องเปลี่ยนไปแจ้งเตือนแทนว่าให้เปลี่ยนรหัส
    password: z.string().min(6, "Password must be at least 6 characters"),
  })
  .refine((data) => data.email || data.username, {
    message: "Either email or username is required",
  });

const changePasswordSchema = z
  .object({
    currentPassword: z.string().min(1, "Current password is required"),
    //Contributer: Nattawadee Chaleechat [Description] แก้ไข password validation
    newPassword: passwordRules,
    confirmNewPassword: z.string().min(6, "Password confirmation is required"),
  })
  .refine((data) => data.newPassword === data.confirmNewPassword, {
    message: "New password and confirmation do not match",
    path: ["confirmNewPassword"],
  })
  //Contributer: Nattawadee Chaleechat [Description] เช็ค password ว่า มันซ้ำอันเก่ามั้ย
  .refine((data) => data.newPassword !== data.currentPassword, {
    message: "New password must not be the same as your current password",
    path: ["newPassword"],
  });

module.exports = { loginSchema, changePasswordSchema };
