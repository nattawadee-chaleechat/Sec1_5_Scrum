//Contributer: Nattawadee Chaleechat [Description] เพิ่ม password validation เพื่อให้เป็นไปตาม NCSC UK's guidelines
// Ai declare : ให้ claude.ai ช่วยหา Dictionary เพื่อนำมาใช้ในการตรวจคำ และช่วยคิดกรณีที่ต้องแยกคำติดกัน
// ซึ่งต้องแจ้ง user ในหน้า UI ว่าแนะนำให้ใช้ - หรือ _ คั่นคำ

const allWords = require("an-array-of-english-words");

// สร้าง Set ครั้งเดียวตอน server startup
const wordSet = new Set(allWords.filter((w) => w.length >= 3));

/**
 * ตรวจว่า password มีคำจริงอย่างน้อย 3 คำ
 * รองรับ: apple-mango-banana, PurpleMonkeyDish, hello_world_today
 */
const isThreeRealWords = (val) => {
  const parts = val
    // lowercase→UPPER: "appleM" → "apple M"
    .replace(/([a-z])([A-Z])/g, "$1 $2")
    // UPPER→Upper: "MAngo" → "M Ango" (ป้องกัน ALL CAPS ติดกัน)
    .replace(/([A-Z])([A-Z][a-z])/g, "$1 $2")
    .split(/[\s\-_]+/) // แยกด้วย - , _
    .filter((w) => /[a-zA-Z]/.test(w)); // กรองตัวเลขล้วนออก

  console.log("parts:", parts);

  const realWords = parts.filter((w) => wordSet.has(w.toLowerCase()));
  console.log("realWords:", realWords);

  return realWords.length >= 3;
};

module.exports = { isThreeRealWords };
