const express = require('express');
const authRoutes = require('./auth.routes');
const userRoutes = require('./user.routes');
const vehicleRoutes = require('./vehicle.routes');
const routeRoutes   = require('./route.routes');
const driverVerifRoutes = require('./driverVerification.routes');
const bookingRoutes = require('./booking.routes');
const notificationRoutes = require('./notification.routes')
const mapRoutes = require('./maps.routes')
const reviewDriverProfileRoutes = require('./reviewdriverprofile.routes'); // ดึงข้อมูล reviewDriverProfile routes
const reviewRoutes = require('./review.routes') // chetsada 15/2

const router = express.Router();
//เพิ่ม router driversเพื่อlink กับURL ในน้าreview driver profile
router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/vehicles', vehicleRoutes);
router.use('/routes', routeRoutes);
router.use('/driver-verifications', driverVerifRoutes);
router.use('/bookings', bookingRoutes);
router.use('/notifications', notificationRoutes);
router.use('/api/maps', mapRoutes);
router.use('/review', reviewDriverProfileRoutes);
router.use('/reviews', reviewRoutes); // chetsada 15/2

module.exports = router;