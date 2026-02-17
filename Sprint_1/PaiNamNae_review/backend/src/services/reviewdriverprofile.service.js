/*
contributed by: Piyawat
[description]
-เพิ่มgetDriverProfile เพื่อเพิ่มหน้าโปรไฟล์ของคนขับรถในหน้ารีวิวของคนขับรถแต่ละคน 
-เพิ่มgetAverageRating เพื่อดึงข้อมูลคะแนนเฉลี่ยของคนขับรถแต่ละคนในหน้ารีวิวของคนขับรถแต่ละคน
-เพิ่มgetDriverReview เพื่อดึงข้อมูลรีวิวทั้งหมดของคนขับรถแต่ละคนในหน้ารีวิวของคนขับ 
Update 14 Feb 2026
*/ 
const prisma = require("../utils/prisma");    
const ApiError = require('../utils/ApiError');

const getDriverProfile = async (driverId) => {
    const driver = await prisma.user.findUnique({ where: { id: driverId}, 
        select: {
            firstName: true,
            lastName: true,
            gender: true,
            profilePicture: true,
            isVerified: true,
            role: true,
        }
    });
    if (!driver ) {
        throw new ApiError(404, 'Driver not found');
    }
    return  driver
};
//if (!driver || driver.role !== 'DRIVER') {

const getAverageRating = async (reviewedUserId) => {
    const averageRating = await prisma.review.aggregate({
        where: { 
            reviewedUserId: reviewedUserId,
            booking: { is: { status: 'COMPLETED' } } },
        
        _avg: { star: true },//คำนวณค่าเฉลี่ยของดาว
        _count: { _all: true },//นับจำนวนรีวิวทั้งหมด
    });
    return {
        averageRating: averageRating._avg.star ?? 0,
        totalReviews: averageRating._count._all ?? 0
    };
};
//ดึงข้อมูลรีวิวทั้งหมดของคนขับรถแต่ละคนในหน้ารีวิวของคนขับ
const getDriverReview = async (driverId) => {
     const reviews = await prisma.review.findMany({
        where: {
            reviewedUserId: driverId,
            booking: {
                is: { status: 'COMPLETED' }
            }
        },
        select: {
            id: true,
            star: true,
            comment: true,
            picture: true,
            createdAt: true,
            reviewer: {
                select: {
                    id: true,
                    firstName: true,
                    lastName: true,
                    profilePicture: true,
                }
            }
        },
        orderBy: { createdAt: 'desc' },
        
    });
    return reviews.map(r => ({
        id: r.id,
        reviewerName: `${r.reviewer.firstName} ${r.reviewer.lastName}`,
        review: { rating: r.star },
        comment: r.comment,
        image: typeof r.picture === 'string' ? r.picture : null,
        images: Array.isArray(r.picture) ? r.picture : null,//แปลงรูปภาพ
        createAt: r.createdAt
    }));
};
module.exports = {
    getDriverProfile,
    getAverageRating,
    getDriverReview,
};