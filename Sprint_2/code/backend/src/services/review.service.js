// Contributer: chetsada kongsak
// [16/2/2569]
// - ฟังก์ชั้น createReview ไว้รับข้อมูลให้ตรงกับ database

// Contributer: chetsada kongsak & suttipad rodhom
// [17/2/2569]
// ใน const createReview เพิ่ม การแจ้งเตือน คนขับ เมื่อได้รีวิว 17/2

// Contributer: chetsada kongsak
// [17/2/2569]
// ใน const createReview จับไม่ให้รีวิวหลังจากจบ booking ไปแล้ว 7 วัน 

// AI declare
// - ใช้ ChatGPT ช่วยเขียน const ,แก้ไข error

// Contributer: suttipad rodhom
// [26/2/2569]
// - ปรับ createReview ให้รองรับ multiple media (image, video, audio)
// - เปลี่ยน parameter จาก file → files
// - เปลี่ยนการอ้างอิงเวลารีวิวจาก updatedAt → completedAt
// - เพิ่มรองรับ link แนบในรีวิว
// - เปลี่ยน field จาก picture → media
// - จำกัดไฟล์สูงสุด 3 ไฟล์

const prisma = require('../utils/prisma');
const ApiError = require('../utils/ApiError');
const { uploadToCloudinary } = require('../utils/cloudinary');

const createReview = async (data, reviewerId, files) => {
  const { bookingId, star, comment, link} = data;

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

  // chetsada 17/2
  // เช็คว่าเกิน 7 วันไหม
  const completedAt = booking.completedAt; 
  const now = new Date();

  const differentTime = now - completedAt; // ms
  const differentDays = differentTime / (1000 * 60 * 60 * 24);

  if (differentDays > 7) {
    throw new ApiError(400, 'Review period expired (over 7 days)');
  }
  // 

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
  let media = [];

  // ===== Upload Files =====
  if (files && files.length > 0) {

    if (files.length > 3) {
      throw new ApiError(400, 'Maximum 3 files allowed');
    }

    for (const file of files) {

      const result = await uploadToCloudinary(
        file.buffer,
        'reviews',
        'auto'
      );

      let type = 'image';

      if (file.mimetype.startsWith('video/')) {
        type = 'video';
      } else if (file.mimetype.startsWith('audio/')) {
        type = 'audio';
      }

      media.push({
        type,
        url: result.secure_url || result.url
      });
    }
  }

  // ===== Handle Link =====
  if (link) {
    try {
      new URL(link);

      media.push({
        type: 'link',
        url: link
      });
    } catch {
      throw new ApiError(400, 'Invalid link format');
    }
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
        media
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

//  test chatGPT
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
