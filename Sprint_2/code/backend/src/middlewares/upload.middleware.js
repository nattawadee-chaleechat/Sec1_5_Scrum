const multer = require('multer');
const ApiError = require('../utils/ApiError');

// เก็บไฟล์ไว้ใน memory เพื่อส่งต่อไป Cloudinary
const storage = multer.memoryStorage();

const upload = multer({
  storage,

  // จำกัดขนาดไฟล์ 20MB ต่อไฟล์
  limits: { fileSize: 20 * 1024 * 1024 },

  fileFilter: (req, file, cb) => {

    const isImage = file.mimetype.startsWith('image/');
    const isVideo = file.mimetype.startsWith('video/');
    const isAudio = file.mimetype.startsWith('audio/');

    if (isImage || isVideo || isAudio) {
      cb(null, true);
    } else {
      cb(new ApiError(400, 'Only image, video, and audio files are allowed!'), false);
    }
  },
});

module.exports = upload;