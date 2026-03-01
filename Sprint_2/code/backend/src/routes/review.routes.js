// Contributer: chetsada kongsak
// [16/2/2569]
// - ทำส่วนสำหรับ api สร้าง review
// ใช้ ChatGPT ช่วยปรับแก้ upload ภาพ

// Contributer: suttipad rodhom
// [26/2/2569]
// - ปรับ route createReview ให้รองรับการอัปโหลดไฟล์หลายไฟล์
// - ลบ upload.single('picture') ออก
// - ใช้ upload.array('media', 3) แทน (จำกัดไม่เกิน 3 ไฟล์)

const express = require('express');
const validate = require('../middlewares/validate');
const { protect } = require('../middlewares/auth');
const upload = require('../middlewares/upload.middleware');

const reviewController = require('../controllers/reviews.controller');
const { createReviewSchema } = require('../validations/review.validation');

const router = express.Router();

// api สร้าง review  /api/reviews
router.post(
  '/',
  protect,
  upload.array('media', 3), // suttipad 26/2
                            // รองรับการอัปโหลดไฟล์ชื่อ field "media" ได้สูงสุด 3 ไฟล์
                            // ไฟล์จะถูกเก็บใน req.files
  validate({ body: createReviewSchema }),
  reviewController.createReview
);

// --- สำหรับ test (ChetGPT)
// ดูรีวิวที่ user รีวิวทั้งหมด
router.get(
  '/me', 
  protect, 
  reviewController.getMyReviews
);
// ดูรีวิวที่ passenger ได้รับรีวิวทั้งหมด {status:...,data:[dict,dict]}
router.get(
  '/driver/:id', // กดดูของคนขับ ไม่ต้องใช้สิทธิ์ 
  reviewController.getDriverReviews
);
// --- สำหรับ test

module.exports = router;
