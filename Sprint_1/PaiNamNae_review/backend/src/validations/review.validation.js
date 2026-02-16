// chetsada 16/2 0:02
// chetsada 16/2 0:18
// Contributer: chetsada kongsak
// -  เพิ่ม createReviewSchema ใน review.validation ตรวจสอบข้อมูลที่รับเข้า
// ใช้ ChatGPT ช่วยปรับ

const { z } = require('zod');

const createReviewSchema = z.object({
  bookingId: z.string().cuid(),
  star: z.coerce.number().int().min(1).max(5),
  comment: z.string().optional(),
});

module.exports = {
  createReviewSchema,
};
