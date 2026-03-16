# Changelog

This file will contain all notable changes to this project.

---

## [Vesion 1.0.0] - [Chetsada]
### Update 11 March 2026
- แก้ function fetchBookings() ให้ใช้ apiBase 
#### File includes
- code\frontend\pages\admin\bookings\index.vue
#### AI Declare
- ใช้ ChatGPT ช่วยปรับตรงส่วนดึง bookingsAll.value
---
## [Vesion 1.0.0] - [Chetsada]
### Update 13 March 2026
- เพิ่มตาราง PasswordHistory เก็บ password ที่เคยใช้แล้ว
- ที่ตาราง User เพิ่ม  attribute สำหรับ 
   - เก็บเวลาเปลี่ยน/หมดอายุของรหัส 
   - เก็บคำนวนครั้งที่ใส่ผิด และเวลาล็อคไม่ให้ล็อกอิน
#### File includes
- code\backend\prisma\schema.prisma
#### AI Declare
- ใช้ ChatGPT ตรวจสอบความเรียบร้อย
---