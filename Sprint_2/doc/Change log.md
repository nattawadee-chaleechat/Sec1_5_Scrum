# Changelog

This file will contain all notable changes to this project.

---

## [Vesion 1.0.0] - [Chetsada]
### Update 26 February 2026
- เพิ่มตาราง RouteExtraCharge สัมพันธ์ manny-to-one กับ Route
- เพิ่มตาราง BookingExtraCharge สัมพันธ์ manny-to-one กับ Booking และ manny-to-one กับ RouteExtraCharge เพื่อใช้เก็บข้อมูลการสร้างตัวเลือกสำหรับเก็บเงินเพิ่มในการเดินทางนั้นๆ
### AI Declare
- ใช้ ChatGPT ช่วยตรวจสอบกรณีต่างๆ ของ schema ที่ออกแบบไว้
---
## [Vesion 1.0.0] - [Suttipad]
### Update 28 February 2026
- เพิ่ม completedAt ในตาราง Booking สำหรับเก็บเวลาที่การเดินทางเสร็จสมบูรณ์
- เปลี่ยนฟิลด์ในตาราง Review จาก picture → media (Json @db.Json) เพื่อรองรับหลายประเภทไฟล์
- เพิ่มการบันทึก completedAt เมื่อทั้ง Driver และ Passenger กดยืนยันครบ
- ปรับ createReview ให้รองรับ multiple media (image, video, audio)
- เปลี่ยน parameter จาก file → files
- เปลี่ยนการอ้างอิงเวลารีวิวจาก updatedAt → completedAt
- จำกัดไฟล์แนบสูงสุด 3 ไฟล์
- เพิ่มรองรับการแนบ link ในรีวิว
- เพิ่มการ disabled ปุ่มส่งรีวิว
- เพิ่ม validation อนุญาตเฉพาะ URL จาก drive.google.com
- ปรับ getDriverReview ให้รองรับ media array แทน picture
- ปรับโครงสร้าง select, orderBy และ response format ให้รองรับ media หลายประเภท
- ปรับ Multer ให้รองรับ image, video และ audio
- เพิ่มขนาดไฟล์สูงสุด 20MB ต่อไฟล์
- ใช้ memoryStorage เพื่อส่งไฟล์ไปยัง Cloudinary
- ปรับ route จาก upload.single('picture') → upload.array('media', 3)
- เปลี่ยนหัวข้อ Modal จาก “รีวิวผู้ขับ” → “รีวิวทั้งหมด”
- เปลี่ยนหัวข้อเป็น “ความเห็นจากผู้โดยสาร”
- ปรับ padding ข้อความสถานะการเดินทาง (text-sm → px-4 py-2 text-sm)
- ปรับการแสดงผลจาก image เดี่ยว → รองรับ media หลายประเภท (image / video / audio / Google Drive link)
- เพิ่มระบบ Fullscreen Video พร้อม overlay และปุ่มปิด
- เพิ่ม state fullscreenVideo
- เพิ่มฟังก์ชัน openVideo() และ closeVideo()
- ปรับการคำนวณ completedAt ให้ใช้ Date object โดยตรง
- ปรับ logic canReview() ให้คำนวณเวลาจาก trip.completedAt โดยตรง

### AI Declare
- ใช้ ChatGPT ช่วยออกแบบโครงสร้าง media แบบ Json array
- ใช้ ChatGPT ช่วยออกแบบ validation URL และ logic จำกัดไฟล์
- ใช้ ChatGPT ช่วย debug flow completedAt และการคำนวณ 7 วัน
- ใช้ ChatGPT ช่วยจัดโครงสร้าง Multer และ multiple upload
- ใช้ ChatGPT ช่วยออกแบบระบบ Fullscreen Video ใน Modal
---
## [Vesion 1.0.0] - [Chetsada]
### Update 1 March 2026
- สร้าง notifyArrivedOneSide สำหรับแจ้งเตือนผู้ใช้อีกฝั่งให้กด "สิ้นสุดการเดินทาง" เมื่ออีกฝั่งหนึ่งกดแล้ว ที่ backend\src\services\notification.service.js
- เพิ่มส่วนเรียกใช้ notifyArrivedOneSide ที่ฟังก์ชัน markPassenger/DriverArrived ใน backend\src\services\booking.service.js
### AI Declare
- ใช้ ChatGPT ช่วยปรับ notifyArrivedOneSide
---
## [Vesion 1.0.0] - [Chetsada]
### Update 3 March 2026
- ที่ ..frontend\pages\myTrip\index.vue
    ..frontend\pages\myRoute\index.vue
    ..frontend\pages\findTrip\index.vue
      - เพิ่มส่วนฟิลเตอร์กรองรีวิวตามดาว const selectedStarFilter เป็น state เก็บดาว
      - เพิ่ม const filteredReviews สำหรับกรองดาว
      - เพิ่ม const starCounts สำหรับนับจำนวนรีวิวในดาวนั้นๆ
- ที่ ..frontend\pages\myTrip\index.vue and \myRoute\index.vue
      - แก้การแสดงผลคะแนนรีวิว ที่ Driver Profile เพิ่ม .toFixed(1) ในส่วนตกหล่น ให้แสดงจุดทศนิยมแค่จุดเดียว
    ..frontend\pages\myTrip\index.vue
      - เพิ่ม isReviewSubmitting กรณีกำลังส่งรีวิวในหน้า reviewpopup แล้วปุ่มในหน้า review card ต้องกดไม่ได้ เหมือนกัน
      - แก้การตอบสนองของปุ่ม "รีวิวการเดินทาง"
      - แก้ชื่อตัวแปรที่ส่งไป reviewModal
    ..frontend\components\ReviewModal.vue
      - เพิ่ม 'submitting' emit เข็คว่ากดรีวิวแล้ว เพื่อป้องกันการกดซ้ำ ใน review card
### AI Declare
- ใช้ ChatGPT ออกแบบฟังก์ชัน และเขียน vue แสดงฟิลเตอร์ดาว
- ใช้ ChatGPT แนะนำการจัดการปุ่มใน review card หลังจากกด ส่งรีวิว
---