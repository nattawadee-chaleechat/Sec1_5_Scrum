/*
contributed by: Piyawat
[description]
- เพิ่มroute เพิ่มเชื่อมกับfrontendในหน้าreview driver profile และ เชื่อมกับcontrollerและserviceที่สร้างขึ้นมาเพื่อดึงข้อมูลรีวิวของคนขับรถแต่ละคน
Update 14 Feb 2026
*/
const express = require("express");
const reviewDriverProfileController = require("../controllers/reviewdriverprofile.controller.js");
const validate = require('../middlewares/validate.js');
const { getDriverReviewsSchema } = require("../validations/reviewdriverprofile.validation.js");

const router = express.Router();

// --- Public / User-specific Routes ---
// GET /drivers/{driverId}/reviews (public/user-specific)แสดงหน้ารีวิวของคนขับรถแต่ละคน
router.get(
    '/:driverId/reviews',
    validate(getDriverReviewsSchema),
    reviewDriverProfileController.getDriverProfile
);

module.exports = router;