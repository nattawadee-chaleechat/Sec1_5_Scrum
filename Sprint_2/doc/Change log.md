# Changelog

This file will contain all notable changes to this project.

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