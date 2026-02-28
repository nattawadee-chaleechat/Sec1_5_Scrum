// Contributer: chetsada kongsak
// [16/2/2569]
// - ส่วน createReview รับข้อมูลจาก route ส่งไป review.service
// ใช้ ChatGPT ช่วยเขียน

// Contributer: suttipad rodhom
// [26/2/2569]
// - แก้ไขการรับไฟล์ใน createReview (review.controller)
//   เปลี่ยนจาก req.file → req.files
//   เพื่อรองรับการอัปโหลดไฟล์หลายไฟล์ (multiple media upload)

const asyncHandler = require('express-async-handler');
const reviewService = require('../services/review.service');

const createReview = asyncHandler(async (req, res) => {
  const reviewerId = req.user.sub;
  const review = await reviewService.createReview(
    req.body,
    reviewerId,
    req.files // suttipad 26/2
              // เปลี่ยนจาก req.file เป็น req.files
              // เพื่อรองรับการอัปโหลดไฟล์หลายไฟล์ (multiple media upload)
  );

  res.status(201).json({
    success: true,
    message: 'Review created successfully',
    data: review
  });
});

// test
const getMyReviews = asyncHandler(async (req, res) => {
  const list = await reviewService.getReviewsByReviewer(req.user.sub);

  res.status(200).json({
    success: true,
    message: 'Review retrieved successfully',
    data: list
  });
});

const getDriverReviews = asyncHandler(async (req, res) => {
  const list = await reviewService.getReviewsByDriver(req.params.id);

  res.status(200).json({
    success: true,
    message: 'Review retrieved successfully',
    data: list
  });
});
// end test

module.exports = {
  createReview,
  getMyReviews,
  getDriverReviews
};