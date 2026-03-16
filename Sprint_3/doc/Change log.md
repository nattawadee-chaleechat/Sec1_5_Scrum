# Changelog

This file will contain all notable changes to this project.

---

## [Vesion 1.0.0] - [Chetsada]
### Update 12 March 2026
Contributer: chetsada kongsak
- เพิ่มตาราง PasswordHistory เก็บ password ที่เคยใช้แล้ว
- ที่ตาราง User เพิ่ม  attribute สำหรับ 
   - เก็บเวลาเปลี่ยน/หมดอายุของรหัส 
   - เก็บคำนวนครั้งที่ใส่ผิด และเวลาล็อคไม่ให้ล็อกอิน

## password matched NCSC V.01 - [Nattawadee]
### Update 14 Mar 2026
File includes auth.validation.js passwordValidator.js user.validation.js
[Description]
- เพิ่มเงื่อนไขต้องมีอย่างน้อย 8 ตัว
- ห้ามมี spaces
- มีคำอย่างน้อย 3 คำ เช็คคำาม Dictionary  จาก an-array-of-english-words ซึ่งมี ~275,000 English words
[AI Declare]
- ให้ claude.ai ช่วยหา Dictionary เพื่อนำมาใช้ในการตรวจคำ และช่วยคิดกรณีที่ต้องแยกคำติดกัน
- ช่วยเขียนโค้ด passwordValidator.js

## password matched NCSC V.02 - [Nattawadee]
### Update 15 Mar 2026
File includes auth.validation.js passwordValidator.js user.validation.js auth.controller.js auth.routes.js useAuth.js 
[Description]
- แก้ไขให้ frontend เป็นไปตาม NCSC
- เช็ค word กับ backend ตอนกรอกpassword  หน้า register
[AI Declare]
- ให้ claude.ai ช่วยแก้โค้ด กรณีเช็ค word กับ backend

## Password notification V.01 - [Nattawadee]
### Update 16 Mar 2026
File includes login.vue auth.controller.js
[Description]
- แจ้งเตือน เมื่อรหัสไม่ตรงตาม NCSC UK's guidelines ตอนที่ login
[AI Declare]
- ให้ claude.ai ช่วยหาข้อผิดพลาด ตอนที่แจ้งเตือนไม่ขึ้น
- ให้ claude.ai ช่วยไกด์การเขียนโค้ด

---

## PasswordValidation V.01 - [Piyawat]
### Update 16 Mar 2026
File includes auth.controller.js auth.validation.js passwordValidator.js user.validation.js profile\index.vue register\index.vue
[Description]
- เพิ่มเงื่อนไขต่างๆในการสร้างpassword ได้แก่ blacklist password รหัสผ่านต้องไม่มีชื่อผู้ใช้ อีเมล ชื่อจริง หรือนามสกุล
[AI Declare]
- ให้ chatgpt ช่วยหาข้อผิดพลาด และ ช่วยไกด์การเขียนโค้ด

## password matched NCSC V.02.02 - [Nattawadee]
### Update 16 Mar 2026
File includes auth.controller.js profile\index.vue register\index.vue
[Description]
- แก้ไขข้อความ เพื่อให้คลอบคลุมกรณีที่กำหนดไว้มากขึ้น user อ่านจะได้เข้าใจ ไม่หงุดหงิดตอนกรอกรหัสแล้วไม่ผ่าน
[AI Declare]
- ไม่ได้ใช้


---