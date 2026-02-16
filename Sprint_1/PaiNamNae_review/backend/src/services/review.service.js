// Contributer: chetsada kongsak
// [16/2/2569]
// - ฟังก์ชั้น createReview ไว้รับข้อมูลให้ตรงกับ database
// [17/2/2569]
// เพิ่ม การแจ้งเตือน คนขับ เมื่อได้รีวิว 17/2

// Contributer: chetsada kongsak & suttipad rodhom
// [17/2/2569]
// เพิ่ม การแจ้งเตือน คนขับ เมื่อได้รีวิว 17/2


// AI declare
// - ใช้ ChatGPT ช่วยเขียน const ,แก้ไข error

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

  // เพิ่ม การแจ้งเตือน คนขับ เมื่อได้รีวิว 17/2
  // ChatGPT
  // ใช้ transaction ให้เช็คทำเสร็จพร้อมกัน ถ้ารีวิวสร้างได้ จะส่งแจ้งเตือน
  return prisma.$transaction(async (tx) => {

    // สร้าง Review
    const review = await tx.review.create({
      data: {
        bookingId,
        reviewerId,
        reviewedUserId: booking.route.driverId,
        star,
        comment,
        picture: pictureUrl
      }
    });

    // สร้าง Notification ให้ Driver
    await tx.notification.create({
      data: {
        userId: booking.route.driverId,
        type: "REVIEW",
        title: "คุณได้รับรีวิวใหม่",
        body: `คุณได้รับ ${star} ดาว จากผู้โดยสาร`,
        metadata: {
          kind: "REVIEW_CREATED",
          reviewId: review.id,
          bookingId,
          reviewerId,
          star
        }
      }
    });

    return review;
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
