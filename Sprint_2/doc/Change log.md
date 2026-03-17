# Changelog

This file will contain all notable changes to this project.

---

<<<<<<< HEAD
## [Vesion 1.0.0] - [Chatsiri]
### Update 1 March 2026
- เพิ่ม html "เงื่อนไขเพิ่มเติม route" ใน page\findTrip
- เพิ่ม html "เงื่อนไขเพิ่มเติม route" ใน page\myRoute
- เพิ่ม html "เงื่อนไขเพิ่มเติม trip" ใน page\myTrip
- รอ api backend เพื่อแสดงข้อมูล

### AI Declare
---
=======
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
## [Vesion 2.0.0] - [Chetsada]
### Update 1 March 2026
- สร้าง notifyArrivedOneSide สำหรับแจ้งเตือนผู้ใช้อีกฝั่งให้กด "สิ้นสุดการเดินทาง" เมื่ออีกฝั่งหนึ่งกดแล้ว ที่ backend\src\services\notification.service.js
- เพิ่มส่วนเรียกใช้ notifyArrivedOneSide ที่ฟังก์ชัน markPassenger/DriverArrived ใน backend\src\services\booking.service.js
### AI Declare
- ใช้ ChatGPT ช่วยปรับ notifyArrivedOneSide
--- 
## extraCharges V.01 - [Nattawadee]
### Update 1 Mar 2026
File includes route.controller.js route.service.js route.validation.js \createTrip\index.vue
- เพิ่มช่อง extraCharges ในหน้าสร้างเส้นทาง และเชื่อมกับ database
### AI Declare ใช้ chatgpt ช่วยหาจุดผิดพลาด เนื่องจากข้อมูลไม่บันทึกลง database
---
## Add function calculateBookingTotals V.01 - [Piyawat]
### Update 2 Mar 2026
File includes booking.service.js
- เพิ่มช่อง calculateBookingTotals สำหรับคำนวนราคาทั้งหมด
### AI Declare 
- ใช้ chatgpt สำหรับcheck ความผิดพลาด
### Update 3 Mar 2026
File includes booking.service.js , myTrip\index.vue
- เพิ่มแสดงรายละเอียดของ เงื่อนไขเพิ่มเติมที่ ลูกค้าแต่ละคนที่เลือกในตอนจอง รวมถึงแสดงจำนวนสิ่งของ
### AI Declare 
- ใช้ chatgpt สำหรับcheck ความผิดพลาด เนื่องจากหน้า เงื่อนไขเพิ่มเติม ที่ไม่แสดง
### Update 3 Mar 2026
File includes booking.service.js ,route.service.js, myTrip\index.vue ,myRoute\index.vue,findTrip\index.vue,myRoute\index.vue
- เพิ่มแสดงรายละเอียดของ เงื่อนไขเพิ่มเติมที่ ลูกค้าแต่ละคนที่เลือกในตอนจอง รวมถึงแสดงจำนวนสิ่งของ
- เพิ่มการแก้ไขของ ในเงื่อนไขเพิ่มเติม ในแก้ไขเส้นทาง
### AI Declare 
- ใช้ chatgpt สำหรับcheck ความผิดพลาด เนื่องจากหน้า เงื่อนไขเพิ่มเติม ที่ไม่แสดง รวมถึงการแก้ไขที่ไม่สามรถแก้ไขได้
---
## extraCharges V.02 - [Nattawadee]
### Update 3 Mar 2026
File includes booking.service.js booking.controller.js booking.validation.js findTrip\index.vue myRoute\index.vue
- เพิ่มเงื่อนไขที่คิดเงิน ให้ผู้โดยสารเลือก และกรอกจำนวน และคิดเงินอัตโนมัติ
- เพิ่มการคำนวณราคา ตอน booking create
- เพิ่มเงื่อนไขที่ผู้โดยสารเลือก และจำนวน ลง payload
- แก้ไขให้ price ตรงกับ booking total price
- เพิ่ม selectedCharges chargeQuantities เพื่อไม่ให้โดน validation กันออกตอนส่งข้อมูล
### Changes from version 1.
- เพิ่มเงื่อนไขและราคา ในหน้าการจอง ให้ผู้โดยสารเลือกเงื่อนไข และจำนวนได้
- คำนวณราคารวมทั้งหมด
- แสดงผลราคารวมที่ถูกต้อง
### AI Declare ใช้ chatgpt ช่วยหาจุดผิดพลาด เนื่องจากข้อมูลที่ต้องการดึงมาแสดงไม่ขึ้น
---
## [Vesion 1.0.1] - [Suttipad]
### Update 3 March 2026
- Review Modal (UAT)
  - จัดทำ Test Design, Test Data และ Test Report สำหรับ Review Modal
  - เพิ่ม Test Scenario:
    - รีวิวสำเร็จ
    - รีวิวไม่สำเร็จ
    - ดูรีวิวและกรอง 5★–1★
  - เพิ่มเงื่อนไข completedAt และการจำกัดเวลารีวิว 7 วัน
  - เพิ่มกรณีทดสอบไฟล์เกิน 20MB และลิงก์ที่ไม่ใช่ Google Drive
  - ทดสอบสิทธิ์การดูรีวิว (Guest / Passenger / Driver / Admin)
  - ผลการทดสอบ: Pass ทั้งหมด
- Review API (UAT)
  - จัดทำ Functional, Validation และ Performance Test
  - ทดสอบการสร้างรีวิว, ดึงรีวิว, ตรวจสอบ Token และ bookingId
  - ทดสอบ Response Time < 2 วินาที
  - ผลการทดสอบ: Pass ทั้งหมด
- AI Declare
  - ใช้ ChatGPT ช่วยจัดโครงสร้าง Test Case
  - ช่วยออกแบบ Test Data (Positive / Negative / Boundary)
  - ช่วยสรุป Test Repor
---
>>>>>>> origin/dev
