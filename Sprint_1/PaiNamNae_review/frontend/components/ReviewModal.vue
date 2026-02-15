<!-- 
๊Contributer: suttipad rodhom
-->

<template>
  <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
    <div class="w-full max-w-md p-6 bg-white rounded-2xl shadow-xl">

      <!-- รูปคนขับ -->
      <div class="flex justify-center mb-4">
        <img
          :src="driverImage"
          class="w-24 h-24 mx-auto rounded-full object-cover border shadow"
        />
      </div>

      <!-- ชื่อ -->
      <h2 class="text-xl font-bold text-center text-gray-800">
        {{ trip?.driver?.name || 'คนขับ' }}
      </h2>
      <p class="mt-1 text-sm text-center text-gray-600">
        ยินดีที่ได้ให้บริการ <br />
        กรุณาให้คะแนนการเดินทางของคุณ
      </p>

      <!-- ดาว -->
      <div class="flex justify-center mt-4 mb-5 text-3xl">
        <!-- 
            เพิ่มการ hover และการ คลิ๊ก เพื่อใช้เป็นคะแนนรีวิวตามดาว
            ใช้ AI ช่วยในการหาวิธีทำให้ดาวสามารถตามเมาส์ได้
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

      <!-- คอมเมนต์ -->
      <textarea
        rows="3"
        placeholder="เขียนรีวิวเพิ่มเติม (ไม่บังคับ)..."
        class="w-full p-3 mb-4 border rounded-lg focus:outline-none resize-none"
      ></textarea>

      <!-- Upload -->
      <div
        class="relative flex items-center justify-center h-36 p-6 mb-5 border-2 border-dashed border-gray-300 rounded-lg bg-gray-50 cursor-pointer"
      >
        <div class="text-center">
          <svg class="w-10 h-10 mx-auto mb-2 text-gray-400"
            fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
          </svg>
          <p class="text-sm font-medium text-gray-600">
            อัปโหลดรูป
          </p>
        </div>
      </div>

      <!-- ปุ่ม -->
      <div class="flex justify-between">
        <button
          class="text-gray-600 hover:text-gray-800"
        >
          ยกเลิก
        </button>
        <button
          class="px-5 py-2 text-white bg-green-600 rounded-lg hover:bg-green-700"
        >
          ส่งรีวิว
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  trip: Object
})

// ดึงรูปคนขับ 
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
</script>
