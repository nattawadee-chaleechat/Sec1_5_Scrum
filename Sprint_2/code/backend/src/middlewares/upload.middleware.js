// Contributer: suttipad rodhom
// [26/2/2569]
// - ปรับ Multer ให้รองรับ image, video และ audio
// - เพิ่มขนาดไฟล์สูงสุดเป็น 20MB ต่อไฟล์
// - ใช้ memoryStorage เพื่อส่งไฟล์ต่อไปยัง Cloudinary

const multer = require('multer');
const ApiError = require('../utils/ApiError');

// เก็บไฟล์ไว้ใน memory เพื่อส่งต่อไป Cloudinary
const storage = multer.memoryStorage();

const upload = multer({
  storage,

  // suttipad 26/2 จำกัดขนาดไฟล์ 20MB ต่อไฟล์
  limits: { fileSize: 20 * 1024 * 1024 },

  fileFilter: (req, file, cb) => {

    // suttipad 26/2 ตรวจสอบประเภทไฟล์จาก mimetype
    const isImage = file.mimetype.startsWith('image/');
    const isVideo = file.mimetype.startsWith('video/');
    const isAudio = file.mimetype.startsWith('audio/');
    
    // suttipad 26/2 อนุญาตเฉพาะไฟล์ image, video และ audio
    if (isImage || isVideo || isAudio) {
      cb(null, true);
    } else {
      cb(new ApiError(400, 'Only image, video, and audio files are allowed!'), false);
    }
  },
});

module.exports = upload;