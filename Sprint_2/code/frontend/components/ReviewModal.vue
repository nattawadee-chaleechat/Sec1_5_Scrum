// Contributor: Suttipad Rodhom
// [01/03/2569]
// - เพิ่มช่องแนบ Google Drive link (ตรวจสอบเฉพาะ drive.google.com / docs.google.com)
// - เพิ่มระบบอัปโหลด media สูงสุด 3 ไฟล์ (image / video / audio)
// - จำกัดขนาดไฟล์ไม่เกิน 20MB ต่อไฟล์
// - เพิ่ม preview media แบบ dynamic ตามประเภทไฟล์
// - เพิ่ม validation:
//   - จำกัดประเภทไฟล์
//   - จำกัดจำนวนไฟล์
//   - ตรวจสอบความถูกต้องของ Google Drive link
// - เพิ่มการ disabled ปุ่มส่งรีวิว

// Contributor: Chetsada
// [01/03/2569]
- เพิ่ม 'submitting' emitเข็คว่ากดรีวิวแล้ว เพื่อป้องกันการกดซ้ำ ใน review card

<template>
  <div
    class="fixed inset-0 z-50 flex items-center justify-center bg-black/40"
    @click="$emit('close')"  
  >
    <div
      class="w-full max-w-md p-6 bg-white rounded-2xl shadow-xl"
      @click.stop              
    >

      <div class="flex justify-center mb-4">
        <img
          :src="driverImage"
          class="w-24 h-24 mx-auto rounded-full object-cover border shadow"
        />
      </div>

      <h2 class="text-xl font-bold text-center text-gray-800">
        {{ trip?.driver?.name || 'คนขับ' }}
      </h2>

      <p class="mt-1 text-sm text-center text-gray-600">
        ยินดีที่ได้ให้บริการ <br />
        กรุณาให้คะแนนการเดินทางของคุณ
      </p>

      <!-- Rating -->
      <div class="flex justify-center mt-4 mb-5 text-3xl">
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

      <!-- Comment -->
      <textarea
        v-model="comment"
        rows="3"
        placeholder="เขียนรีวิวเพิ่มเติม (ไม่บังคับ)..."
        class="w-full p-3 mb-4 border rounded-lg focus:ring-2 focus:ring-green-500 focus:outline-none resize-none"
      ></textarea>

      <!-- Link -->
      <input
        v-model="link"
        type="text"
        placeholder="แนบลิงก์ (ไม่บังคับ เช่น Google Drive)"
        class="w-full p-3 mb-4 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none"
      />

      <!-- Upload Media -->
      <div
        @click="triggerFileInput"
        class="relative flex flex-wrap gap-2 items-center justify-center min-h-36 p-4 mb-5 border-2 border-dashed border-gray-300 rounded-lg bg-gray-50 hover:bg-gray-100 hover:border-green-400 transition cursor-pointer"
      >
        <div v-if="previewMedia.length === 0" class="text-center w-full">
          <p class="text-sm font-medium text-gray-600">คลิกเพื่ออัปโหลด</p>
          <p class="text-xs text-gray-500">
            รูปภาพ วิดีโอ หรือเสียง สูงสุด 3 ไฟล์ (ไม่เกิน 20MB/ไฟล์)
          </p>
        </div>

        <div
          v-for="(item, index) in previewMedia"
          :key="index"
          class="relative w-24 h-24 flex items-center justify-center bg-gray-100 rounded-md"
        >
          <img
            v-if="item.type === 'image'"
            :src="item.url"
            class="object-cover w-full h-full rounded-md"
          />

          <video
            v-else-if="item.type === 'video'"
            :src="item.url"
            class="object-cover w-full h-full rounded-md"
            muted
          ></video>

          <div
            v-else-if="item.type === 'audio'"
            class="flex flex-col items-center justify-center text-xs text-gray-600"
          >
            🎵
            <span>Audio</span>
          </div>

          <button
            @click.stop="removeFile(index)"
            class="absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center"
          >
            ✕
          </button>
        </div>

        <input
          type="file"
          ref="fileInput"
          @change="handleFiles"
          class="hidden"
          accept="image/*,video/*,audio/*"
          multiple
        />
      </div>

      <!-- Buttons -->
      <div class="flex justify-between">
        <button
          @click="$emit('close')"
          class="text-gray-600 hover:text-gray-800"
        >
          ยกเลิก
        </button>

        <button
          @click="submitReview"
          :disabled="isSubmitting"
          class="px-5 py-2 text-white rounded-lg transition"
          :class="isSubmitting 
            ? 'bg-green-400 cursor-not-allowed' 
            : 'bg-green-600 hover:bg-green-700'"
        >
          <span v-if="isSubmitting">กำลังส่ง...</span>
          <span v-else>ส่งรีวิว</span>
        </button>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAuth } from '~/composables/useAuth'
import { useToast } from '~/composables/useToast'

const { toast } = useToast()
const { token } = useAuth()

const props = defineProps({
  trip: Object,
  submitting: Boolean
})

const emit = defineEmits(['close', 'reviewed', 'submitting'])

const rating = ref(0)
const hoverRating = ref(0)
const comment = ref('')
const link = ref('')
const mediaFiles = ref([])
const previewMedia = ref([])
const fileInput = ref(null)
const isSubmitting = ref(false)

const driverImage = computed(() => {
  const profile = props.trip?.driver?.image
  if (profile && profile.startsWith('http')) return profile
  if (profile) return `http://localhost:5000/uploads/${profile}`

  const name =
    props.trip?.driver?.firstName ||
    props.trip?.driver?.name ||
    'U'

  return `https://ui-avatars.com/api/?name=${encodeURIComponent(name)}`
})

function triggerFileInput() {
  fileInput.value.click()
}

function handleFiles(event) {
  const files = Array.from(event.target.files)
  if (!files.length) return

  const total = [...mediaFiles.value, ...files]
  if (total.length > 3) {
    toast.error('อัปโหลดได้สูงสุด 3 ไฟล์')
    return
  }

  for (const file of files) {
    if (
      !file.type.startsWith('image/') &&
      !file.type.startsWith('video/') &&
      !file.type.startsWith('audio/')
    ) {
      toast.error('อนุญาตเฉพาะรูป วิดีโอ หรือเสียง')
      return
    }

    if (file.size > 20 * 1024 * 1024) {
      toast.error('ไฟล์ต้องไม่เกิน 20MB')
      return
    }

    mediaFiles.value.push(file)

    let type = 'image'
    if (file.type.startsWith('video/')) type = 'video'
    else if (file.type.startsWith('audio/')) type = 'audio'

    previewMedia.value.push({
      type,
      url: URL.createObjectURL(file)
    })
  }
}

function isGoogleDriveLink(url) {
  try {
    const parsed = new URL(url)
    return (
      parsed.hostname === "drive.google.com" ||
      parsed.hostname === "docs.google.com"
    )
  } catch {
    return false
  }
}

function removeFile(index) {
  mediaFiles.value.splice(index, 1)
  previewMedia.value.splice(index, 1)
}

async function submitReview() {

  if (isSubmitting.value) return

  if (!rating.value) {
    toast.warning('กรุณาให้คะแนนก่อนส่งรีวิว')
    return
  }

  if (link.value && link.value.trim() !== '') {
    if (!isGoogleDriveLink(link.value.trim())) {
      toast.error('แนบลิงก์ได้เฉพาะ Google Drive เท่านั้น')
      return
    }
  }

  try {
    isSubmitting.value = true
    emit('submitting', true)

    const formData = new FormData()
    formData.append('bookingId', props.trip.id)
    formData.append('star', rating.value)
    formData.append('comment', comment.value || '')
    formData.append('driverId', props.trip.driver.id)

    if (link.value && link.value.trim() !== '') {
      formData.append('link', link.value.trim())
    }

    mediaFiles.value.forEach(file => {
      formData.append('media', file)
    })

    await $fetch('http://localhost:3000/api/reviews', {
      method: 'POST',
      headers: { Authorization: `Bearer ${token.value}` },
      body: formData
    })

    toast.success('ส่งรีวิวสำเร็จ')
    emit('reviewed')
    emit('close')

  } catch (error) {
    toast.error('เกิดข้อผิดพลาด กรุณาลองใหม่')
  } finally {
    isSubmitting.value = false
    emit('submitting', false)
  }
}
</script>