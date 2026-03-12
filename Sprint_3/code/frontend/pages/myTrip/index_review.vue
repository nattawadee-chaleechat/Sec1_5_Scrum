Contributer: Piyawat Sawatkul
[Description] แก้ปัญหานำข้อมูลจากbackendขึ้นfrontend ให้ถูกต้องโดยใช้AI ในการแก้ปัญหาข้อมูลที่ไม่ตรงกันระหว่าง API กับ UI
<template>
  <div>
    <div class="px-4 py-8 mx-auto max-w-7xl sm:px-6 lg:px-8">
      <div class="mb-8">
        <h2 class="text-2xl font-bold text-gray-900">รีวิวผู้ขับ</h2>
        <p class="mt-2 text-gray-600">
          ดูความเห็นจากผู้ขับเกี่ยวกับการเดินทางของคุณ
        </p>
      </div>

      <div class="bg-white border border-gray-300 rounded-lg shadow-md">
        <div class="p-6 border-b border-gray-300">
          <h3 class="text-lg font-semibold text-gray-900">รีวิวจากผู้ขับ</h3>
        </div>

        <div v-if="isLoading" class="p-12 text-center text-gray-500">
          <p>กำลังโหลดข้อมูล...</p>
        </div>

        <div v-else-if="reviews.length === 0" class="p-12 text-center text-gray-500">
          <p>ยังไม่มีรีวิวจากผู้ขับ</p>
        </div>

        <div v-else class="divide-y divide-gray-200">
          <div
            v-for="review in reviews"
            :key="review.id"
            class="p-6 transition-colors duration-200 cursor-pointer hover:bg-gray-50"
            @click="openReviewModal(review)"
          >
            <div class="flex items-start justify-between mb-4">
              <div class="flex-1">
                <div class="flex items-center justify-between">
                  <div>
                    <h4 class="text-lg font-semibold text-gray-900">
                      {{ review.routeInfo?.origin || 'ไม่ระบุ' }} →
                      {{ review.routeInfo?.destination || 'ไม่ระบุ' }}
                    </h4>
                    <p class="mt-1 text-sm text-gray-600">
                      ผู้ขับ: {{ review.driverName || 'ผู้ขับไม่ระบุชื่อ' }}
                    </p>
                  </div>
                  <div class="text-right">
                    <div class="flex text-lg text-yellow-400">
                      <span v-for="star in 5" :key="star">
                        {{ star <= Number(review.rating || 0) ? '★' : '☆' }}
                      </span>
                    </div>
                    <span class="text-sm text-gray-600">
                      {{ Number(review.rating || 0).toFixed(1) }}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <p class="text-sm text-gray-600 mb-3">
              {{ review.comment || 'ไม่มีความคิดเห็น' }}
            </p>

            <div v-if="review.images && review.images.length > 0" class="flex flex-wrap gap-2 mb-3">
              <img
                v-for="(image, idx) in review.images.slice(0, 3)"
                :key="idx"
                :src="image"
                :alt="`Review image ${idx + 1}`"
                class="object-cover w-20 h-20 rounded border border-gray-200"
              />
            </div>

            <div class="text-xs text-gray-500">
              {{ formatDate(review.createdAt) }}
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Review Modal -->
    <transition name="modal-fade">
      <div v-if="showModal" class="modal-overlay" @click.self="showModal = false">
        <div class="modal-content">
          <!-- Header -->
          <div class="flex items-center justify-between p-6 border-b border-gray-300">
            <h3 class="text-xl font-semibold text-gray-900">รีวิว</h3>
            <button @click="showModal = false" class="text-gray-400 hover:text-gray-600">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M6 18L18 6M6 6l12 12"
                ></path>
              </svg>
            </button>
          </div>

          <!-- Modal Body -->
          <div v-if="selectedReview" class="p-6">
            <!-- Route Info -->
            <div class="mb-6 pb-6 border-b border-gray-300">
              <h4 class="mb-3 font-semibold text-gray-900">ข้อมูลการเดินทาง</h4>
              <div class="flex items-center p-3 space-x-4 rounded-lg bg-gray-50">
                <div class="flex-1">
                  <div class="font-medium text-gray-900">
                    {{ selectedReview.routeInfo?.origin || 'ไม่ระบุ' }}
                  </div>
                  <div class="text-sm text-gray-600">จุดเริ่มต้น</div>
                </div>
                <div class="text-blue-600">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M9 5l7 7-7 7"
                    ></path>
                  </svg>
                </div>
                <div class="flex-1 text-right">
                  <div class="font-medium text-gray-900">
                    {{ selectedReview.routeInfo?.destination || 'ไม่ระบุ' }}
                  </div>
                  <div class="text-sm text-gray-600">จุดปลายทาง</div>
                </div>
              </div>
            </div>

            <!-- Driver Info -->
            <div class="mb-6 pb-6 border-b border-gray-300">
              <h4 class="mb-3 font-semibold text-gray-900">ข้อมูลผู้ขับ</h4>
              <div class="p-3 rounded-lg bg-gray-50">
                <div class="font-medium text-gray-900">
                  {{ selectedReview.driverName || 'ผู้ขับไม่ระบุชื่อ' }}
                </div>
                <div class="mt-2 flex items-center">
                  <div class="flex text-lg text-yellow-400">
                    <span v-for="star in 5" :key="star">
                      {{ star <= Number(selectedReview.rating || 0) ? '★' : '☆' }}
                    </span>
                  </div>
                  <span class="ml-2 text-sm text-gray-600">
                    {{ Number(selectedReview.rating || 0).toFixed(1) }} / 5.0
                  </span>
                </div>
              </div>
            </div>

            <!-- Review Comment -->
            <div class="mb-6 pb-6 border-b border-gray-300">
              <h4 class="mb-3 font-semibold text-gray-900">ความคิดเห็น</h4>
              <p class="p-3 text-sm text-gray-700 border border-gray-300 rounded-md bg-gray-50">
                {{ selectedReview.comment || 'ไม่มีความคิดเห็น' }}
              </p>
            </div>

            <!-- Review Images -->
            <div v-if="selectedReview.images && selectedReview.images.length > 0" class="mb-6">
              <h4 class="mb-3 font-semibold text-gray-900">รูปภาพที่แนบมา</h4>
              <div class="grid grid-cols-3 gap-2">
                <img
                  v-for="(image, idx) in selectedReview.images"
                  :key="idx"
                  :src="image"
                  :alt="`Review image ${idx + 1}`"
                  class="object-cover w-full rounded border border-gray-300 cursor-pointer aspect-square hover:opacity-90"
                  @click="viewImage(image)"
                />
              </div>
            </div>

            <!-- Date -->
            <div class="text-sm text-gray-600">
              <span class="font-medium">วันที่รีวิว:</span>
              {{ formatDate(selectedReview.createdAt) }}
            </div>

            <!-- Action Button -->
            <div class="mt-6 pt-6 border-t border-gray-300">
              <button
                @click="showModal = false"
                class="w-full px-4 py-2 text-white bg-blue-600 rounded-md hover:bg-blue-700 transition duration-200"
              >
                ปิด
              </button>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import dayjs from 'dayjs'
import 'dayjs/locale/th'
import buddhistEra from 'dayjs/plugin/buddhistEra'

dayjs.locale('th')
dayjs.extend(buddhistEra)

const { $api } = useNuxtApp()

// State
const reviews = ref([])
const isLoading = ref(true)
const showModal = ref(false)
const selectedReview = ref(null)

// Helper function to format date
const formatDate = (dateStr) => {
  if (!dateStr) return 'ไม่ระบุวันที่'
  return dayjs(dateStr).format('D MMM BBBB')
}

// Open review modal
const openReviewModal = (review) => {
  selectedReview.value = review
  showModal.value = true
}

// View image in larger format
const viewImage = (imageUrl) => {
  // You can expand this to open an image viewer if needed
  window.open(imageUrl, '_blank')
}

// Fetch reviews on mount
onMounted(async () => {
  try {
    isLoading.value = true
    const response = await $api('/review/driver-reviews')
    if (response?.reviews) {
      reviews.value = response.reviews
    } else if (Array.isArray(response)) {
      reviews.value = response
    } else {
      reviews.value = []
    }
  } catch (error) {
    console.error('Failed to load reviews:', error)
    reviews.value = []
  } finally {
    isLoading.value = false
  }
})
</script>

<style scoped>
body,
* {
  font-family: 'Kanit', sans-serif;
}

.modal-overlay {
  position: fixed;
  z-index: 1000;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-content {
  background-color: white;
  border-radius: 0.75rem;
  max-width: 600px;
  width: 95%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
}

.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.3s cubic-bezier(0.52, 0.02, 0.19, 1.02);
}

.modal-fade-enter-active .modal-content,
.modal-fade-leave-active .modal-content {
  transition: all 0.3s cubic-bezier(0.52, 0.02, 0.19, 1.02);
}

.modal-fade-enter-from,
.modal-fade-leave-to {
  opacity: 0;
}

.modal-fade-enter-from .modal-content,
.modal-fade-leave-to .modal-content {
  transform: scale(0.9) translateY(1rem);
}
</style>
