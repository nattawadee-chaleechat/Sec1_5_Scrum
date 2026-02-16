// Contributer: chetsada kongsak
// [16/2/2569]
// - ฟังก์ชั้น createReview ไว้รับข้อมูลให้ตรงกับ database
// ใช้ ChatGPT ช่วยเขียน

const prisma = require('../utils/prisma');
const ApiError = require('../utils/ApiError');
const { uploadToCloudinary } = require('../utils/cloudinary');

const createReview = async (data, reviewerId, file) => {
  const { bookingId, star, comment} = data;

  const booking = await prisma.booking.findUnique({
    where: { id: bookingId },
    include: { route: true }
  });

  if (!booking) throw new ApiError(404, 'Booking not found');
  // คนรีวิวไม่ใช่ passsenger
  if (booking.passengerId !== reviewerId)
    throw new ApiError(403, 'Forbidden');

  if (booking.status !== 'COMPLETED')
    throw new ApiError(400, 'Trip not completed');

  const exists = await prisma.review.findUnique({
    where: {
      bookingId_reviewerId: {
        bookingId,
        reviewerId
      }
    }
  });

  if (exists)
    throw new ApiError(400, 'Already reviewed');

  // เพิ่มตัวแปรไว้รับ url รูปภาพ 16/2
  let pictureUrl = null;
  if (file) {
    const result = await uploadToCloudinary(file.buffer, 'reviews');
    pictureUrl = result.url;
  }
  //
  return prisma.review.create({
    data: {
      bookingId,
      reviewerId,
      reviewedUserId: booking.route.driverId, // ChatGPT ปรับ driverId 16/2
      star,
      comment,
      picture: pictureUrl // 16/2
    }
  });
};
//  test
const getReviewsByReviewer = (id) => {
  return prisma.review.findMany({
    where: { reviewerId: id },
    orderBy: { createdAt: 'desc' }
  });
};
const getReviewsByDriver = (id) => {
  return prisma.review.findMany({
    where: { reviewedUserId: id },
    orderBy: { createdAt: 'desc' }
  });
};
// 

module.exports = {
  createReview,
  getReviewsByReviewer,
  getReviewsByDriver,
  uploadToCloudinary
};
