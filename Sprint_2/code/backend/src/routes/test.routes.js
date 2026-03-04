const express = require("express");
const router = express.Router();
const prisma = require("../utils/prisma");

router.post("/reset-bookings", async (req, res) => {
  try {
    const passenger = await prisma.user.findUnique({
      where: { username: "somsee123" },
    });

    if (!passenger) {
      return res.status(404).json({ message: "Passenger not found" });
    }

    await prisma.review.deleteMany({
      where: {
        reviewerId: passenger.id,
      },
    });

    await prisma.booking.updateMany({
      where: {
        passengerId: passenger.id,
      },
      data: {
        status: "CONFIRMED",
        completedAt: null,
        driver_confirm_arrived: false,
        passenger_confirm_arrived: false,
      },
    });

    res.status(200).json({
      message: "Reset success for somsee123 only",
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Reset failed" });
  }
});

router.post("/set-completed-8-days", async (req, res) => {
  try {
    const passenger = await prisma.user.findUnique({
      where: { username: "somsee123" },
    });

    if (!passenger) {
      return res.status(404).json({ message: "Passenger not found" });
    }

    const eightDaysAgo = new Date();
    eightDaysAgo.setDate(eightDaysAgo.getDate() - 8);

    await prisma.booking.updateMany({
      where: {
        passengerId: passenger.id,
        status: "COMPLETED",
      },
      data: {
        completedAt: eightDaysAgo,
      },
    });

    res.status(200).json({
      message: "Completed date updated for somsee123",
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Update failed" });
  }
});

module.exports = router;