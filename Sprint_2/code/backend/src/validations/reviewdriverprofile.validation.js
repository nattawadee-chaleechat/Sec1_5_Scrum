/*
contributed by: Piyawat
[description]
- เพิ่มvalidate เพื่อเแก้ปัญหา error ที่เกิดจากการส่งค่า driverId ที่ไม่ถูกต้องในหน้า review driver profile
- กำหนดobject schema สำหรับการตรวจสอบค่าพารามิเตอร์และคิวรีในคำขอ GET /drivers/{driverId}/reviews
Update 14 Feb 2026
*/
const { z } = require('zod');

const getDriverReviewsSchema = z.object({
  params: z.object({
    driverId: z.string().cuid({ message: 'Invalid driver ID format' })
  }),
  query: z.object({
    cursor: z.coerce.number().int().positive().optional(),
    limit: z.coerce.number().int().min(1).max(50).default(10),
    rating: z.coerce.number().int().min(1).max(5).optional()
  })
});

module.exports = {
  getDriverProfileSchema: getDriverReviewsSchema,
  getDriverReviewsSchema,
};

