# Changelog

This file will contain all notable changes to this project.

---

## [Vesion 1.0.0] - [Chetsada]

### Update 12 March 2026

#### Description

- แก้ function fetchBookings() ให้ใช้ apiBase

#### File includes

- code\frontend\pages\admin\bookings\index.vue

#### AI Declare

- ใช้ ChatGPT ช่วยปรับตรงส่วนดึง bookingsAll.value

## [Vesion 1.0.0] - [Chetsada]

### Update 13 March 2026

#### Description

- เพิ่มตาราง PasswordHistory เก็บ password ที่เคยใช้แล้ว
- ที่ตาราง User เพิ่ม attribute สำหรับ
  - เก็บเวลาเปลี่ยน/หมดอายุของรหัส
  - เก็บคำนวนครั้งที่ใส่ผิด และเวลาล็อคไม่ให้ล็อกอิน

#### File includes

- code\backend\prisma\schema.prisma

#### AI Declare

- ใช้ ChatGPT ตรวจสอบความเรียบร้อย
  <<<<<<< HEAD

## password matched NCSC V.01 - [Nattawadee]

### Update 14 Mar 2026

#### File includes

- auth.validation.js passwordValidator.js user.validation.js

#### Description

- เพิ่มเงื่อนไขต้องมีอย่างน้อย 8 ตัว
- ห้ามมี spaces
- มีคำอย่างน้อย 3 คำ เช็คคำาม Dictionary จาก an-array-of-english-words ซึ่งมี ~275,000 English words

#### AI Declare

- ให้ claude.ai ช่วยหา Dictionary เพื่อนำมาใช้ในการตรวจคำ และช่วยคิดกรณีที่ต้องแยกคำติดกัน
- ช่วยเขียนโค้ด passwordValidator.js

## password matched NCSC V.02 - [Nattawadee]

### Update 15 Mar 2026

#### File includes

-auth.validation.js passwordValidator.js user.validation.js auth.controller.js auth.routes.js useAuth.js

#### Description

- แก้ไขให้ frontend เป็นไปตาม NCSC
- เช็ค word กับ backend ตอนกรอกpassword หน้า register

#### AI Declare

- ให้ claude.ai ช่วยแก้โค้ด กรณีเช็ค word กับ backend

## Password notification V.01 - [Nattawadee]

### Update 16 Mar 2026

#### File includes

- login.vue auth.controller.js

#### Description

- แจ้งเตือน เมื่อรหัสไม่ตรงตาม NCSC UK's guidelines ตอนที่ login

#### AI Declare

- ให้ claude.ai ช่วยหาข้อผิดพลาด ตอนที่แจ้งเตือนไม่ขึ้น
- ให้ claude.ai ช่วยไกด์การเขียนโค้ด

## PasswordValidation V.01 - [Piyawat]

### Update 16 Mar 2026

#### File includes

- auth.controller.js auth.validation.js passwordValidator.js user.validation.js profile\index.vue register\index.vue

#### Description

- เพิ่มเงื่อนไขต่างๆในการสร้างpassword ได้แก่ blacklist password รหัสผ่านต้องไม่มีชื่อผู้ใช้ อีเมล ชื่อจริง หรือนามสกุล

#### AI Declare

- ให้ chatgpt ช่วยหาข้อผิดพลาด และ ช่วยไกด์การเขียนโค้ด

## password matched NCSC V.02.02 - [Nattawadee]

### Update 17 Mar 2026

#### File includes

- auth.controller.js profile\index.vue register\index.vue

#### Description

- แก้ไขข้อความ เพื่อให้คลอบคลุมกรณีที่กำหนดไว้มากขึ้น user อ่านจะได้เข้าใจ ไม่หงุดหงิดตอนกรอกรหัสแล้วไม่ผ่าน

#### AI Declare

- ไม่ได้ใช้

## lock account V.01 - [Nattawadee]

### Update 17 Mar 2026

#### File includes

- auth.controller.js user.controller.js pages\login.vue

#### Description

- เมื่อกรอกรหัสผิดเกิน 3 ครั้ง จะทำการ lock account

#### AI Declare

- ให้ claude.ai ช่วยไกด์การเขียนโค้ด

## ADAPT_Blueprint version.01 - [Nattawadee,Chatsiri,Ratchapoom,Chetsada]

### Update 17 Mar 2026

#### file include

- ADAPT_Blueprint

#### AI Declare

- ไม่ได้ใช้

## PasswordValidation V.02 - [Piyawat]

### Update 16 Mar 2026

#### File includes

- auth.controller.js user.service.js auth.validation.js passwordValidator.js user.validation.js profile\index.vue register\index.vue login.vue

#### Description

- เพิ่มเงื่อนไขต่างๆในการสร้างpassword ได้แก่ password ต้องไม่ซ้ำกับของเดิม เพิ่มรหัสผ่านแนะนำจาก an-array-of-english-words random 3 คำมาต่อกัน
- เมื่อครบ90วัน รหัสผ่านจะหมดอายุ ทำให้ผู้ใช้ต้องเปลี่ยนรหัสผ่านใหม่

#### AI Declare

- ให้ chatgpt ช่วยหาข้อผิดพลาด และ ช่วยไกด์การเขียนโค้ด

## user manual [Vesion 1.0.0] - [Ratchapoom]

### Update 17 March 2026

#### Description

- เพิ่ม user manual
- เพิ่ม AI Declaration

#### AI Declare

- ให้ chatgpt ในการปรับแต่งภาษาภายในเอกสารให้มีความเป็นภาษาเขียนและเป็นทางการมากขึ้น

## PasswordValidation V.03 - [Piyawat]

### Update 17 March 2026

#### Description

- update for admin can edit password fix login page

#### AI Declare

- ให้ chatgpt แก้ไขข้อผิดพลาด

## PasswordValidation V.031- [Piyawat]

### Update 17 March 2026

#### Description

- แก้ไขข้อความ

#### AI Declare

- ไม่ได้ใช้

## PasswordValidation V.032 - [Piyawat]

### Update 17 March 2026

#### Description

- แก้ไขหน้าlogin ให้ถูกต้อง

#### AI Declare

- ให้ chatgpt แก้ไขข้อผิดพลาด

## PasswordValidation V.033 - [Piyawat]

### Update 17 March 2026

#### Description

- แก้ไขlogin และ เพิ่มราคาcharge ห้ามน้อยกว่า

#### AI Declare

- ให้ chatgpt แก้ไขข้อผิดพลาด

## PasswordValidation V.034 - [Piyawat]

### Update 17 March 2026

#### Description

- ตอนสมัครสมาชิกใหม่ ระบบจะตั้งวันเริ่มใช้รหัสผ่านและวันหมดอายุทันที

#### AI Declare

- ให้ chatgpt แก้ไขข้อผิดพลาด

## Review & Additional Charge V.02 - [Suttipad]

### Update 16 Mar 2026

#### File includes

- Sprint_3/code/backend/src/routes/test.routes.js, Sprint_3/doc/Change log.md, Sprint_3/doc/UATTesRepot_Additional_Charges.pdf, Sprint_3/test/Code/UAT_Additional_Charges.robot, Sprint_3/test/Code/UAT_ReviewModal.robot, Sprint_3/test/Test data/UATTestData_Additional_Charges.pdf, Sprint_3test/Test data/UATTestData_ReviewModa.pdf, Sprint_3/test/Test design/UATTestDesign_Additional_Charges.pdf, Sprint_3/test/Test design/UATTestDesignReviewModal.pdf

#### Description

- อัพเดต Review เพิ่ม test case เกี่ยวกับการใส่ไฟล์อื่นนอกจาก Media
- อัพเดต Additional Charge เพิ่ม test case เกี่ยวกับการลบและใส่เงื่อนไขแต่ลูกค้าไม่เลือก

#### AI Declare

- ใช้ ChatGPT เป็นเครื่องมือช่วยในการปรับปรุงโค้ดและให้คำแนะนำด้านการพัฒนา

## sprint backlog V.01

### Update 17 March 2026

#### File includes

- sprint backlog.xlsx

#### Description

- ระบุ volunteer ค่า esitmate time และเวลาที่ทำจริง (actual time) เป็นหน่วยชั่วโมง ของแต่ละ task ที่เกี่ยวข้องกับงานที่รับเข้ามา

#### AI Declare

- ไม่ได้ใช้

## Review & Additional Charge V.03 - [Suttipad]

### Update 16 Mar 2026

#### File includes

- Sprint_3/doc/Change log.md, Sprint_3/doc/APITestReport_ReviewModal.pdf, Sprint_3/test/Code/API_ReviewModal.robot, Sprint_3/test/Test data/APITestData_ReviewModal.pdf, Sprint_3/test/Test design/APITestDesign_ReviewModal.pdf, Sprint_3/test/Test design/UATTestDesign_ReviewModal.pdf

#### Description

- เปลี่ยนชื่อไฟล์ และเพื่อ API Review

#### AI Declare

- ไม่ได้ใช้

## sprint backlog V.02

### Update 17 March 2026

#### File includes

- sprint backlog.xlsx

#### Description

- เพิ่มกราฟ

#### AI Declare

- ไม่ได้ใช้

---
