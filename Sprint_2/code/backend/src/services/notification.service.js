/* Contributer: Nattawadee Chaleechat 
[Description] 
เพิ่มการแจ้งเตือน เมื่อสถานะการเดินทางเปลี่ยนเป็น Completed
Update 17 Feb 2026
*/

// Contributer: suttipad rodhom
// update 1 March 2026
// - สร้าง notifyArrivedOneSide สำหรับแจ้งเตือนผู้ใช้อีกฝั่งให้กด "สิ้นสุดการเดินทาง" เมื่ออีกฝั่งหนึ่งกดแล้ว
// AI Declare
// - ใช้ ChatGPT ช่วยปรับ notifyArrivedOneSide

const prisma = require("../utils/prisma");
const ApiError = require("../utils/ApiError");

const baseSelect = {
  id: true,
  userId: true,
  type: true,
  title: true,
  body: true,
  link: true,
  metadata: true,
  readAt: true,
  adminReviewedAt: true,
  createdAt: true,
};

const buildWhere = (opts = {}) => {
  const { q, type, read, createdFrom, createdTo, userId, adminReviewed } = opts;

  return {
    ...(userId && { userId }),
    ...(type && { type }),
    ...(typeof read === "boolean"
      ? read
        ? { readAt: { not: null } }
        : { readAt: null }
      : {}),
    ...(typeof adminReviewed === "boolean"
      ? adminReviewed
        ? { adminReviewedAt: { not: null } }
        : { adminReviewedAt: null }
      : {}),
    ...(createdFrom || createdTo
      ? {
          createdAt: {
            ...(createdFrom ? { gte: new Date(createdFrom) } : {}),
            ...(createdTo ? { lte: new Date(createdTo) } : {}),
          },
        }
      : {}),
    ...(q
      ? {
          OR: [
            { title: { contains: q, mode: "insensitive" } },
            { body: { contains: q, mode: "insensitive" } },
          ],
        }
      : {}),
  };
};

const listMyNotifications = async (ownerId, opts = {}) => {
  const {
    page = 1,
    limit = 20,
    sortBy = "createdAt",
    sortOrder = "desc",
    ...filters
  } = opts;

  const where = buildWhere({ ...filters, userId: ownerId });

  const skip = (page - 1) * limit;
  const take = limit;

  const [total, data] = await prisma.$transaction([
    prisma.notification.count({ where }),
    prisma.notification.findMany({
      where,
      orderBy: { [sortBy]: sortOrder },
      skip,
      take,
      select: baseSelect,
    }),
  ]);

  return {
    data,
    pagination: {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
    },
  };
};

const listNotificationsAdmin = async (opts = {}) => {
  const {
    page = 1,
    limit = 20,
    sortBy = "createdAt",
    sortOrder = "desc",
    ...filters
  } = opts;

  const where = buildWhere(filters);

  const skip = (page - 1) * limit;
  const take = limit;

  const [total, data] = await prisma.$transaction([
    prisma.notification.count({ where }),
    prisma.notification.findMany({
      where,
      orderBy: { [sortBy]: sortOrder },
      skip,
      take,
      select: {
        ...baseSelect,
        user: {
          select: {
            id: true,
            email: true,
            username: true,
            firstName: true,
            lastName: true,
          },
        },
      },
    }),
  ]);

  return {
    data,
    pagination: {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
    },
  };
};

const getMyNotificationById = async (id, ownerId) => {
  const n = await prisma.notification.findUnique({
    where: { id },
    select: baseSelect,
  });
  if (!n || n.userId !== ownerId) {
    throw new ApiError(404, "Notification not found");
  }
  return n;
};

const createNotificationByAdmin = async (payload) => {
  const user = await prisma.user.findUnique({
    where: { id: payload.userId },
    select: { id: true },
  });
  if (!user) throw new ApiError(404, "User not found");

  const created = await prisma.notification.create({
    data: payload,
    select: baseSelect,
  });
  return created;
};

const markRead = async (id, ownerId) => {
  const n = await prisma.notification.findUnique({ where: { id } });
  if (!n || n.userId !== ownerId)
    throw new ApiError(404, "Notification not found");

  return prisma.notification.update({
    where: { id },
    data: { readAt: new Date() },
    select: baseSelect,
  });
};

const markUnread = async (id, ownerId) => {
  const n = await prisma.notification.findUnique({ where: { id } });
  if (!n || n.userId !== ownerId)
    throw new ApiError(404, "Notification not found");

  return prisma.notification.update({
    where: { id },
    data: { readAt: null },
    select: baseSelect,
  });
};

const adminMarkRead = async (id) => {
  const n = await prisma.notification.findUnique({ where: { id } });
  if (!n) throw new ApiError(404, "Notification not found");

  return prisma.notification.update({
    where: { id },
    data: { adminReviewedAt: new Date() },
    select: baseSelect,
  });
};

const markAllRead = async (ownerId) => {
  const result = await prisma.notification.updateMany({
    where: { userId: ownerId, readAt: null },
    data: { readAt: new Date() },
  });
  return { updated: result.count };
};

const deleteMyNotification = async (id, ownerId) => {
  const n = await prisma.notification.findUnique({ where: { id } });
  if (!n || n.userId !== ownerId)
    throw new ApiError(404, "Notification not found");

  await prisma.notification.delete({ where: { id } });
  return { id };
};

const deleteNotificationByAdmin = async (id) => {
  const n = await prisma.notification.findUnique({ where: { id } });
  if (!n) throw new ApiError(404, "Notification not found");

  await prisma.notification.delete({ where: { id } });
  return { id };
};

const countUnread = async (ownerId) => {
  const total = await prisma.notification.count({
    where: { userId: ownerId, readAt: null },
  });
  return { unread: total };
};

/*
Contributer: Nattawadee Chaleechat 
[Description] เพิ่ม การแจ้งเตือน เมื่อการเดินทางเสร็จสิ้น ส่งไปให้คนขับและผู้โดยสาร
*/
const notifyTripCompleted = async (bookingId) => {
  const booking = await prisma.booking.findUnique({
    where: { id: bookingId },
    include: {
      passenger: true,
      route: {
        include: { driver: true },
      },
    },
  });

  // 17/2 ผมแก้ ฟังก์ชันคุณหน่อย ไม่รู้ว่าคุณประกาศตรงไหน
  // Passenger
  await prisma.notification.create({
    data: {
      userId: booking.passenger.id,
      type: "SYSTEM",
      title: "การเดินทางเสร็จสิ้นแล้ว",
      body: "การเดินทางของคุณได้จบลงแล้ว ขอบคุณที่ให้บริการ",
      metadata: {
        kind: "TRIP_COMPLETED",
        bookingId,
      },
    },
  });
  // แจ้งให้รีวิว
  await prisma.notification.create({
    data: {
      userId: booking.passenger.id,
      type: "SYSTEM",
      title: "การเดินทางครั้งนี้เป็นยังไงบ้าง ?",
      body: "คุณรู้สึกยังไงกับการเดินทางครั้งนี้ มารีวิวผู้ขับกัน",
      metadata: {
        kind: "TRIP_COMPLETED",
        bookingId,
      },
    },
  });

  // Driver
  await prisma.notification.create({
    data: {
      userId: booking.route.driver.id,
      type: "SYSTEM",
      title: "คุณส่งผู้โดยสารเรียบร้อยแล้ว",
      body: "การเดินทางเสร็จสิ้น ขอบคุณที่ให้บริการ",
      metadata: {
        kind: "TRIP_COMPLETED",
        bookingId,
      },
    },
  });
};

// 1/3 chetsada  function แจ้งเตือนให้อีกฝั่งกด "สิ้นสุดการเดินทาง"
const notifyArrivedOneSide = async (bookingId, pressby) => {
  const booking = await prisma.booking.findUnique({
    where: { id: bookingId },
    include: {
      passenger: true,
      route: { include: { driver: true } },
    },
  });

  if (!booking) throw new ApiError(404, "Booking not found");

  // driver กด แจ้ง passenger
  if (pressby === "DRIVER") {
    await prisma.notification.create({
      data: {
        userId: booking.passenger.id,
        type: "SYSTEM",
        title: "คนขับยืนยันการเดินทางแล้ว",
        body: "คนขับได้ยืนยันว่าการเดินทางเสร็จแล้ว กรุณายืนยันของคุณเพื่อปิดงาน ที่ปุ่ม 'สิ้นสุดการเดินทาง'",
        metadata: { 
          kind: "ARRIVED_DRIVER", 
          bookingId 
        },
      },
    });
  }

  // passenger กด แจ้ง driver
  if (pressby === "PASSENGER") {
    await prisma.notification.create({
      data: {
        userId: booking.route.driver.id,
        type: "SYSTEM",
        title: "ผู้โดยสารยืนยันการเดินทางแล้ว",
        body: "ผู้โดยสารได้ยืนยันว่าถึงที่หมายแล้ว กรุณายืนยันของคุณเพื่อปิดงาน ที่ปุ่ม 'สิ้นสุดการเดินทาง'",
        metadata: { 
          kind: "ARRIVED_PASSENGER", 
          bookingId 
        },
      },
    });
  }
};

module.exports = {
  listMyNotifications,
  listNotificationsAdmin,
  getMyNotificationById,
  createNotificationByAdmin,
  markRead,
  markUnread,
  markAllRead,
  deleteMyNotification,
  deleteNotificationByAdmin,
  countUnread,
  adminMarkRead,
  notifyTripCompleted,
  notifyArrivedOneSide,
};
