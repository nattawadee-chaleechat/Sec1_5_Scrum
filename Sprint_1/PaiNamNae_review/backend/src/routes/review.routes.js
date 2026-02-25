// Contributer: chetsada kongsak
// [16/2/2569]
// - ทำส่วนสำหรับ api สร้าง review
// ใช้ ChatGPT ช่วยปรับแก้ upload ภาพ

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
  upload.single('picture'),
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