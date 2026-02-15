<!-- 
๊Contributer: suttipad rodhom
ไฟล์นี้เป็นหน้า Popup สำหรับให้ผู้ใช้รีวิวการเดินทาง
มีการให้คะแนนเป็นดาว เขียนคอมเมนต์ และแนบรูปภาพได้
-->

<template>
  <!-- overlay ดำครอบทั้งหน้า เพื่อให้เป็นลักษณะ modal -->
  <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
    <div class="w-full max-w-md p-6 bg-white rounded-2xl shadow-xl">

      <!-- แสดงรูปโปรไฟล์คนขับ -->
      <div class="flex justify-center mb-4">
        <img
          :src="driverImage"
          class="w-24 h-24 mx-auto rounded-full object-cover border shadow"
        />
      </div>

      <!-- แสดงชื่อคนขับ -->
      <h2 class="text-xl font-bold text-center text-gray-800">
        {{ trip?.driver?.name || 'คนขับ' }}
      </h2>

      <!-- ข้อความอธิบาย -->
      <p class="mt-1 text-sm text-center text-gray-600">
        ยินดีที่ได้ให้บริการ <br />
        กรุณาให้คะแนนการเดินทางของคุณ
      </p>

      <!-- ระบบให้คะแนนแบบ 5 ดาว -->
      <div class="flex justify-center mt-4 mb-5 text-3xl">
        <!-- 
          ใช้ v-for สร้างดาว 5 ดวง
          - คลิกเพื่อเลือกคะแนน
          - hover เพื่อให้สีดาวตามเมาส์
          - ใช้ hoverRating ถ้ามีการชี้เมาส์
        -->
        <span
          v-for="star in 5"
          :key="star"
          @click="rating = star"
          @mouseover="hoverRating = star"
          @mouseleave="hoverRating = 0"
          class="cursor-pointer transition"
          :class="(hoverRating || rating) >= star ? 'text-yellow-400' : 'text-gray-300'"
        >
          ★
        </span>
      </div>

      <!-- กล่องเขียนคอมเมนต์เพิ่มเติม -->
      <textarea
        v-model="comment"
        rows="3"
        placeholder="เขียนรีวิวเพิ่มเติม (ไม่บังคับ)..."
        class="w-full p-3 mb-4 border rounded-lg focus:ring-2 focus:ring-green-500 focus:outline-none resize-none"
      ></textarea>

      <!-- ส่วนอัปโหลดรูป -->
      <div
        @click="triggerFileInput"
        class="relative flex items-center justify-center h-36 p-6 mb-5 border-2 border-dashed border-gray-300 rounded-lg bg-gray-50 hover:bg-gray-100 hover:border-green-400 transition cursor-pointer"
      >
        <!-- ถ้ายังไม่มีรูป ให้แสดงไอคอน -->
        <div v-if="!previewImage" class="text-center">
          <p class="text-sm font-medium text-gray-600">คลิกเพื่ออัปโหลด</p>
          <p class="text-xs text-gray-500">JPG, PNG (ไม่เกิน 10MB)</p>
        </div>

        <!-- ถ้ามีรูปแล้วให้แสดง preview -->
        <img
          v-else
          :src="previewImage"
          class="object-cover w-full h-full rounded-md"
        />

        <!-- input file ซ่อนเอาไว้ -->
        <input
          type="file"
          ref="fileInput"
          @change="handleFile"
          class="hidden"
          accept="image/png, image/jpeg"
        />
      </div>

      <!-- ปุ่มยกเลิก และ ส่งรีวิว -->
      <div class="flex justify-between">
        <button
          @click="$emit('close')"
          class="text-gray-600 hover:text-gray-800"
        >
          ยกเลิก
        </button>

        <button
          @click="submitReview"
          class="px-5 py-2 text-white bg-green-600 rounded-lg hover:bg-green-700"
        >
          ส่งรีวิว
        </button>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAuth } from '~/composables/useAuth'
import { useToast } from '~/composables/useToast'

// ใช้ toast สำหรับแสดง popup แจ้งเตือน
const { toast } = useToast()

const props = defineProps({
  trip: Object
})

const emit = defineEmits(['close'])

// ตัวแปรเก็บค่าคะแนน และค่าที่ hover
const rating = ref(0)
const hoverRating = ref(0)

// เก็บข้อความรีวิว
const comment = ref('')

// เก็บไฟล์รูป และรูป preview
const imageFile = ref(null)
const previewImage = ref(null)
const fileInput = ref(null)

// คำนวณรูปโปรไฟล์คนขับ
// ถ้ามี URL เต็มใช้เลย
// ถ้าเป็นชื่อไฟล์ จะไปดึงจาก backend
// ถ้าไม่มีเลย ใช้ ui-avatars แทน
const driverImage = computed(() => {
  const profile = props.trip?.driver?.profilePicture

  if (profile && profile.startsWith('http')) {
    return profile
  }

  if (profile) {
    return `http://localhost:5000/uploads/${profile}`
  }

  const name =
    props.trip?.driver?.firstName ||
    props.trip?.driver?.name ||
    'U'

  return `https://ui-avatars.com/api/?name=${encodeURIComponent(name)}&background=random&size=64`
})

// กดพื้นที่ upload แล้ว trigger input file
function triggerFileInput() {
  fileInput.value.click()
}

// จัดการไฟล์ที่เลือก
function handleFile(event) {
  const file = event.target.files[0]
  if (!file) return

  // จำกัดขนาดไม่เกิน 10MB
  if (file.size > 10 * 1024 * 1024) {
    toast.error('อัปโหลดไม่สำเร็จ', 'ไฟล์ต้องไม่เกิน 10MB')
    return
  }

  imageFile.value = file
  previewImage.value = URL.createObjectURL(file)

  toast.success('อัปโหลดสำเร็จ', 'เพิ่มรูปภาพเรียบร้อย')
}

const { token } = useAuth()

// ฟังก์ชันส่งรีวิวไป backend
async function submitReview() {
  try {
    // เช็คว่ามีการให้คะแนนก่อน
    if (!rating.value) {
      toast.warning('ยังไม่ได้ให้คะแนน', 'กรุณาให้คะแนนก่อนส่งรีวิว')
      return
    }

    if (!token.value) {
      toast.error('ไม่ได้เข้าสู่ระบบ', 'กรุณาเข้าสู่ระบบก่อน')
      return
    }

    const formData = new FormData()
    formData.append('rating', rating.value)
    formData.append('comment', comment.value || '')
    formData.append('bookingId', props.trip.id)
    formData.append('driverId', props.trip.driver.id)

    // แนบรูปถ้ามี
    if (imageFile.value) {
      formData.append('photos', imageFile.value)
    }

    await $fetch('http://localhost:3000/api/reviews', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token.value}`
      },
      body: formData
    })

    toast.success('ส่งรีวิวสำเร็จ', 'ขอบคุณสำหรับความคิดเห็นของคุณ')

    // หน่วงเวลานิดนึงก่อนปิด popup
    setTimeout(() => {
      emit('close')
    }, 800)

  } catch (error) {
    console.error(error?.data || error)

    toast.error(
      'ส่งรีวิวไม่สำเร็จ',
      error?.data?.message || 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง'
    )
  }
}
</script>
