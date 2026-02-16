// Contributer: chetsada kongsak
// [16/2/2569]
// - ส่วน createReview รับข้อมูลจาก route ส่งไป review.service
// ใช้ ChatGPT ช่วยเขียน

const asyncHandler = require('express-async-handler');
const reviewService = require('../services/review.service');

const createReview = asyncHandler(async (req, res) => {
  const reviewerId = req.user.sub;

  const review = await reviewService.createReview(
    req.body,
    reviewerId,
    req.file // แก้ส่วนรับไฟล์ 16/2 2.55
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
