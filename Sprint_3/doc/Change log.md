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

---