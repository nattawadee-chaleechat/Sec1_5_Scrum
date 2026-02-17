/*
contributed by: Piyawat
[description]
- เพิ่มcontrollerหน้าreview driver profile เพื่อดึงข้อมูลโปรไฟล์ของคนขับรถ ข้อมูลคะแนนเฉลี่ย และรีวิวของคนขับรถแต่ละคนมาแสดงในหน้ารีวิวของคนขับรถแต่ละคนจากserviceที่สร้างขึ้นมา
Update 16 Feb 2026
*/
const asynchandler = require("express-async-handler");
const reviewDriverProfileService = require("../services/reviewdriverprofile.service");
const ApiError = require('../utils/ApiError');

//ดีงมาจากservice :getDriverProfile,getAverageRating,getDriverReview
const getDriverProfile = asynchandler(async (req, res) => {

    const driverId = req.params.driverId;
    const [driverProfile, ratingData, reviews] = await Promise.all([
        reviewDriverProfileService.getDriverProfile(driverId),
        reviewDriverProfileService.getAverageRating(driverId),
        reviewDriverProfileService.getDriverReview(driverId)
    ]);
    res.status(200).json({ 
        success: true,
        message: "Driver profile retrieved", 
        data: { driverProfile, ratingData, reviews }

    });
});

module.exports = {
    getDriverProfile
};