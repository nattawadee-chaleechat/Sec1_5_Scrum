<!-- Contributer: Ratchapoom Thongdaeng
[Description]
- This file contains the Vue.js component for the "My Trip" page of the PaiNamNae web application.
- It allows users to view, manage, and track their trips with various statuses.
[What I Changed?]
- You can see comment tags like (Start)...and (Finish)...indicating where changes were made.
[Change Log]
- เพิ่ม status "สิ้นสุดการเดินทาง" [0:11|13/2/2569]
- เพิ่มส่วนของปุ่มสิ้นสุดการเดินทาง [0:24|13/2/2569]
- เพิ่มกรณีสำหรับ 'complete' (สิ้นสุดการเดินทาง) [0:31|13/2/2569]
- เพิ่ม action ของ 'complete' (สิ้นสุดการเดินทาง) [0:37|13/2/2569]
- เพิ่มสีให้ปุ่ม "สิ้นสุดการเดินทาง" [0:14|13/2/2569]

Contributer: Nattawadee Chaleechat 
[Description]
เพิ่ม "การเดินทางเสร็จสิ้น"
ในเมนู Tab เพื่อสามารถดูการเดินทางที่จบไปแล้ว

Contributer: Chetsada Kongsak
[Description]
Contributer:Chetsada 
[Description] เพิ่มส่วนของปุ่มรีวิวการเดินทาง 
ใช้ ChetGPT ช่วย

Contributer: Chetsada Kongsak
[17/2]
[Description] 
- ให้ fecth หน้า หลังจากกด ส่งรีวิว แล้วส่งผ่าน ที่ function ReviewSuccess
- ปิด + สร้างปุ่ม "รีวิวแล้ว"

[11:17|17/2]
[Description] 
- mytrip/index เพิ่มจำกัดเวลารีวิว canReview(trip) เช็ค ว่า booking จบไปแล้ว 7 วันไหม
  เพิ่มเงื่อนไขเช็คตรงส่วนปุ่ม "รีวิว"
- mytrip/index เพิ่มปุ่ม "หมดเวลารีวิวแล้ว (เกิน 7 วัน)" แทนที่ปุ่ม "รีวิว" กรณี booking จบไปแล้ว 7 วัน
ใช้ ChetGPT ช่วย

Contributer: Nattawadee Chaleechat Update 16 Feb 2026
[Description]
เพิ่มเงื่อนไขการแสดงผล 
หากไม่ได้กด สิ้นสุดการเดินทาง จะขึ้นปุ่มให้กด
หากกดปุ่มแล้ว จะแสดงข้อความ การเดินทางเสร็จสิ้นแล้ว (รอให้อีกฝ่ายยืนยันการสิ้นสุดการเดินทาง)

Contributer: Piyawat Sawatkul
[Description] เพิ่ม review popup ในส่วนของการเดินทางที่จบไปแล้ว เพื่อที่เห็นจำนวนและรายละเอียดreview driver 
รวมถึงเชื่อมข้อมูลรีวิวกับ driver ให้ถูกต้องโดยใช้ใช้AI ในการแก้ปัญหาข้อมูลที่ไม่ตรงกันระหว่าง API กับ UI

// Contributer: suttipad rodhom
// [26/2/2569]
// - ปรับ padding ข้อความสถานะรอยืนยันการสิ้นสุดการเดินทาง
//   (text-sm → px-4 py-2 text-sm)
// - เปลี่ยนหัวข้อ Modal จาก "รีวิวผู้ขับแล้ว" → "รีวิวทั้งหมด"
// - ปรับการแสดงผลจาก image เดี่ยว → รองรับ media หลายประเภท
//   - images
//   - videos (รองรับกดดู fullscreen)
//   - audio
//   - Google Drive links
// - เพิ่มระบบ Fullscreen Video พร้อม overlay และปุ่มปิด
// - เพิ่ม state fullscreenVideo สำหรับควบคุมวิดีโอแบบเต็มจอ
// - เพิ่มฟังก์ชัน openVideo() และ closeVideo()
// - ปรับการคำนวณ completedAt ให้ใช้ Date object โดยตรง
// - ปรับ logic canReview() ให้คำนวณเวลาจาก trip.completedAt โดยตรง

Contributer: Piyawat Sawatkul
[3/3/2569]
[Description] แสดงรายละเอียดของ เงื่อนไขเพิ่มเติมที่ ลูกค้าแต่ละคนที่เลือกในตอนจอง เช่น กระเป๋า ราคาต่อชิ้น 80 บาท (จำนวน 2)

Contributer: Chetsada
[3/3/2569]
- เพิ่มส่วนฟิลเตอร์กรองรีวิวตามดาว const selectedStarFilter เป็น state เก็บดาว
- เพิ่ม const filteredReviews สำหรับกรองดาว
- เพิ่ม const starCounts สำหรับนับจำนวนรีวิวในดาวนั้นๆ
- แก้การแสดงผลคะแนนรีวิว ที่ Driver Profile เพิ่ม .toFixed(1) ในส่วนตกหล่น ให้แสดงจุดทศนิยมแค่จุดเดียว
- เพิ่ม isReviewSubmitting กรณีกำลังส่งรีวิวแล้วปุ่มในหน้า review card ต้องกดไม่ได้ เหมือนกับ reviewpopup
- แก้ชื่อตัวแปรที่ส่งไป reviewModal
[AI Declare]
- ใช้ ChatGPT ออกแบบฟังก์ชัน 
-->

<template>
  <div>
    <div class="px-4 py-8 mx-auto max-w-7xl sm:px-6 lg:px-8">
      <div class="mb-8">
        <h2 class="text-2xl font-bold text-gray-900">การเดินทางของฉัน</h2>
        <p class="mt-2 text-gray-600">จัดการและติดตามการเดินทางทั้งหมดของคุณ</p>
      </div>

      <div
        class="p-6 mb-8 bg-white border border-gray-300 rounded-lg shadow-md"
      >
        <div class="flex flex-wrap gap-2">
          <button
            v-for="tab in tabs"
            :key="tab.status"
            @click="activeTab = tab.status"
            :class="[
              'tab-button px-4 py-2 rounded-md font-medium',
              { active: activeTab === tab.status },
            ]"
          >
            {{ tab.label }} ({{ getTripCount(tab.status) }})
          </button>
        </div>
      </div>

      <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
        <div class="lg:col-span-2">
          <div class="bg-white border border-gray-300 rounded-lg shadow-md">
            <div class="p-6 border-b border-gray-300">
              <h3 class="text-lg font-semibold text-gray-900">
                รายการการเดินทาง
              </h3>
            </div>

            <div v-if="isLoading" class="p-12 text-center text-gray-500">
              <p>กำลังโหลดข้อมูลการเดินทาง...</p>
            </div>

            <div v-else class="divide-y divide-gray-200">
              <div
                v-if="filteredTrips.length === 0"
                class="p-12 text-center text-gray-500"
              >
                <p>ไม่พบรายการเดินทางในหมวดหมู่นี้</p>
              </div>

              <div
                v-for="trip in filteredTrips"
                :key="trip.id"
                class="p-6 transition-colors duration-200 cursor-pointer trip-card hover:bg-gray-50"
                @click="toggleTripDetails(trip.id)"
              >
                <div class="flex items-start justify-between mb-4">
                  <div class="flex-1">
                    <div class="flex items-center justify-between">
                      <h4 class="text-lg font-semibold text-gray-900">
                        {{ trip.origin }} → {{ trip.destination }}
                      </h4>
                      <span
                        v-if="trip.status === 'pending'"
                        class="status-badge status-pending"
                        >รอดำเนินการ</span
                      >
                      <span
                        v-else-if="trip.status === 'confirmed'"
                        class="status-badge status-confirmed"
                        >ยืนยันแล้ว</span
                      >
                      <span
                        v-else-if="trip.status === 'rejected'"
                        class="status-badge status-rejected"
                        >ปฏิเสธ</span
                      >
                      <span
                        v-else-if="trip.status === 'cancelled'"
                        class="status-badge status-cancelled"
                        >ยกเลิก</span
                      >

                      <!--(Start)เพิ่ม status "สิ้นสุดการเดินทาง" [0:11|13/2/2569]-->

                      <span
                        v-else-if="trip.status === 'completed'"
                        class="status-badge status-completed"
                        >สิ้นสุดการเดินทาง</span
                      >
                      <!--(Finish)-->
                    </div>
                    <p class="mt-1 text-sm text-gray-600">
                      จุดนัดพบ: {{ trip.pickupPoint }}
                    </p>
                    <p class="text-sm text-gray-600">
                      วันที่: {{ trip.date }}
                      <span class="mx-2 text-gray-300">|</span>
                      เวลา: {{ trip.time }}
                      <span class="mx-2 text-gray-300">|</span>
                      ระยะเวลา: {{ trip.durationText }}
                      <span class="mx-2 text-gray-300">|</span>
                      ระยะทาง: {{ trip.distanceText }}
                    </p>
                  </div>
                </div>

                <div class="flex items-center mb-4 space-x-4">
                  <img
                    :src="trip.driver.image"
                    :alt="trip.driver.name"
                    class="object-cover w-12 h-12 rounded-full"
                  />
                  <div class="flex-1">
                    <h5 class="font-medium text-gray-900">
                      {{ trip.driver.name }}
                    </h5>
                    <!-- Driver Profile -->
                    <div class="flex items-center cursor-pointer" @click.stop="openReviewModalDriver(trip)">
                      <div class="flex text-sm text-yellow-400">
                        <span>
                          {{ "★".repeat(Math.floor(trip.driver.rating))
                          }}{{ "☆".repeat(5 - Math.floor(trip.driver.rating)) }}
                        </span>
                      </div>
                      <span class="ml-2 text-sm text-gray-600"
                        >{{ (trip.driver.rating ?? 0).toFixed(1) }}
                        ({{ trip.driver.reviews ?? 0}} รีวิว)
                        </span
                      >
                    </div>
                  </div>
                  <div class="text-right">
                    <div class="text-lg font-bold text-blue-600">
                      {{ trip.price }} บาท
                    </div>
                    <div class="text-sm text-gray-600">
                      จำนวน {{ trip.seats }} ที่นั่ง
                    </div>
                  </div>
                </div>

                <div
                  v-if="selectedTripId === trip.id"
                  class="pt-4 mt-4 mb-5 duration-300 border-t border-gray-300 animate-in slide-in-from-top"
                >
                  <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
                    <div>
                      <h5 class="mb-2 font-medium text-gray-900">
                        รายละเอียดเส้นทาง
                      </h5>
                      <ul class="space-y-1 text-sm text-gray-600">
                        <li>
                          • จุดเริ่มต้น:
                          <span class="font-medium text-gray-900">{{
                            trip.origin
                          }}</span>
                          <span v-if="trip.originAddress">
                            — {{ trip.originAddress }}</span
                          >
                        </li>

                        <template v-if="trip.stops && trip.stops.length">
                          <li class="mt-2 text-gray-700">
                            • จุดแวะระหว่างทาง ({{ trip.stops.length }} จุด):
                          </li>
                          <li v-for="(stop, idx) in trip.stops" :key="idx">
                              - จุดแวะ {{ idx + 1 }}: {{ stop }}
                          </li>
                        </template>

                        <li class="mt-1">
                          • จุดปลายทาง:
                          <span class="font-medium text-gray-900">{{
                            trip.destination
                          }}</span>
                          <span v-if="trip.destinationAddress">
                            — {{ trip.destinationAddress }}</span
                          >
                        </li>
                      </ul>
                    </div>
                    <div>
                      <h5 class="mb-2 font-medium text-gray-900">
                        รายละเอียดรถ
                      </h5>
                      <ul class="space-y-1 text-sm text-gray-600">
                        <li v-for="detail in trip.carDetails" :key="detail">
                          • {{ detail }}
                        </li>
                      </ul>
                    </div>
                  </div>
                  <!-- เงื่อนไขเก็บเงินเพิ่ม -->
                  <div
                    v-if="trip.extraCharges && trip.extraCharges.length"
                    class="mt-4"
                  >
                    <h5 class="mb-2 font-medium text-gray-900">
                      เงื่อนไขเพิ่มเติมอื่น ๆ
                    </h5>
                    <ul
                      class="p-3 space-y-1 text-sm text-gray-700 bg-gray-50 border border-gray-300 rounded-md"
                    >
                      <li
                        v-for="charge in trip.extraCharges"
                        :key="charge.id || charge.name"
                      >
                        • {{ charge.name }} ราคาต่อชิ้น {{ charge.unitPrice }} บาท
                        <span v-if="charge.quantity"> (จำนวน {{ charge.quantity }})</span>
                      </li>
                    </ul>
                  </div>
                  <div class="mt-4 space-y-4">
                    <div v-if="trip.conditions">
                      <h5 class="mb-2 font-medium text-gray-900">
                        เงื่อนไขการเดินทาง
                      </h5>
                      <p
                        class="p-3 text-sm text-gray-700 border border-gray-300 rounded-md bg-gray-50"
                      >
                        {{ trip.conditions }}
                      </p>
                    </div>

                    <div v-if="trip.photos && trip.photos.length > 0">
                      <h5 class="mb-2 font-medium text-gray-900">
                        รูปภาพรถยนต์
                      </h5>
                      <div class="grid grid-cols-3 gap-2 mt-2">
                        <div
                          v-for="(photo, index) in trip.photos.slice(0, 3)"
                          :key="index"
                        >
                          <img
                            :src="photo"
                            alt="Vehicle photo"
                            class="object-cover w-full transition-opacity rounded-lg shadow-sm cursor-pointer aspect-video hover:opacity-90"
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div
                  class="flex justify-end space-x-3"
                  :class="{ 'mt-4': selectedTripId !== trip.id }"
                >
                  <!-- PENDING: ยกเลิกได้ -->
                  <button
                    v-if="trip.status === 'pending'"
                    @click.stop="openCancelModal(trip)"
                    class="px-4 py-2 text-sm text-red-600 transition duration-200 border border-red-300 rounded-md hover:bg-red-50"
                  >
                    ยกเลิกการจอง
                  </button>

                  <!-- CONFIRMED: เพิ่มปุ่มยกเลิก + คงปุ่มแชท -->
                  <template v-else-if="trip.status === 'confirmed'">
                    <button
                      @click.stop="openCancelModal(trip)"
                      class="px-4 py-2 text-sm text-red-600 transition duration-200 border border-red-300 rounded-md hover:bg-red-50"
                    >
                      ยกเลิกการจอง
                    </button>
                    <button
                      class="px-4 py-2 text-sm text-white transition duration-200 bg-blue-600 rounded-md hover:bg-blue-700"
                    >
                      แชทกับผู้ขับ
                    </button>
                  </template>

                  <!-- REJECTED / CANCELLED: ลบได้ -->
                  <button
                    v-else-if="['rejected', 'cancelled'].includes(trip.status)"
                    @click.stop="openConfirmModal(trip, 'delete')"
                    class="px-4 py-2 text-sm text-gray-600 transition duration-200 border border-gray-300 rounded-md hover:bg-gray-50"
                  >
                    ลบรายการ
                  </button>

                  <!--(Start) Contributer: Ratchapoom Thongdaeng เพิ่มส่วนของปุ่มสิ้นสุดการเดินทาง [0:24|13/2/2569]-->

                  <!--Contributer: Nattawadee Chaleechat Update 16 Feb 2026-->
                  <!--[Description] เพิ่มเงื่อนไขการแสดงผล หากไม่ได้กด สิ้นสุดการเดินทาง จะขึ้นปุ่มให้กด หากกดปุ่มแล้ว จะแสดงข้อความ การเดินทางเสร็จสิ้นแล้ว (รอให้อีกฝ่ายยืนยันการสิ้นสุดการเดินทาง)-->

                  <button
                    v-if="
                      trip.status === 'confirmed' &&
                      !trip.passenger_confirm_arrived
                    "
                    @click.stop="openConfirmModal(trip, 'complete')"
                    class="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition duration-200 text-sm"
                  >
                    สิ้นสุดการเดินทาง
                  </button>

                  <div
                    v-else-if="
                      trip.status === 'confirmed' &&
                      trip.passenger_confirm_arrived &&
                      !trip.driver_confirm_arrived
                    "
                    class="px-4 py-2 text-sm text-yellow-600 font-medium"
                  >
                    รอ ผู้ขับ ยืนยันการสิ้นสุดการเดินทาง
                  </div>
                  <!--(Finish)-->

                  <!--(Start) 
                    Contributer:Chetsada 
                    [23:52|15/2/2569]
                    [Description] เพิ่มส่วนของปุ่มรีวิวการเดินทาง 
                    ใช้ ChatGPT

                    [23:52|15/2/2569]
                    [Description] เพิ่ม isReviewSubmitting
                    ใช้ ChatGPT
                  -->
                  <ReviewModal
                    v-if="showReviewModal"
                    :trip="reviewTripModal"
                    :submitting="isReviewSubmitting" 
                    @close="closeReview"
                    @reviewed="ReviewSuccess()"
                    @submitting="isReviewSubmitting = $event" 
                  />
                  <button
                    v-if="trip.status === 'completed' && !trip.reviewed && canReview(trip)"
                    @click.stop="openReviewModal(trip)"
                      :disabled="isReviewSubmitting"
                    class="px-4 py-2 bg-blue-600 text-white rounded-md transition"
                      :class="isReviewSubmitting 
                          ? 'opacity-40 cursor-not-allowed' 
                          : 'hover:bg-blue-700'"
                  >
                      <span v-if="isReviewSubmitting">กำลังส่งรีวิว...</span>
                      <span v-else>รีวิวการเดินทาง</span>
                  </button>
                  <!-- Contributer:Chetsada 
                    [Description] เพิ่มส่วนของปุ่ม รีวิวแล้ว
                    [17/2/2569] -->
                  <button
                    v-else-if="trip.status === 'completed' && trip.reviewed"
                    disabled
                    class="px-4 py-2 bg-gray-300 text-gray-600 rounded-md"
                  >
                    รีวิวแล้ว
                    </button>
                  <!--(Finish)-->
                  <!-- Contributer:Chetsada 
                    [Description] เพิ่มส่วนของปุ่ม หมดเวลารีวิว
                    [17/2/2569] -->
                  <button
                    v-else-if="trip.status === 'completed' && !trip.reviewed && !canReview(trip)"
                    disabled
                    class="px-4 py-2 bg-blue-100 text-gray-600 rounded-md"
                  >
                    หมดเวลารีวิวแล้ว (เกิน 7 วัน)
                  </button>
                  <!--(Finish)-->
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="lg:col-span-1">
          <div
            class="sticky overflow-hidden bg-white border border-gray-300 rounded-lg shadow-md top-8"
          >
            <div class="p-6 border-b border-gray-300">
              <h3 class="text-lg font-semibold text-gray-900">แผนที่เส้นทาง</h3>
            </div>
            <div ref="mapContainer" id="map" class="h-96"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal: เลือกเหตุผลการยกเลิก -->
    <div
      v-if="isCancelModalVisible"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/40"
      @click.self="closeCancelModal"
    >
      <div class="w-full max-w-md p-6 bg-white rounded-lg shadow-xl">
        <h3 class="text-lg font-semibold text-gray-900">
          เลือกเหตุผลการยกเลิก
        </h3>
        <p class="mt-1 text-sm text-gray-600">
          โปรดเลือกเหตุผลตามตัวเลือกที่กำหนด
        </p>

        <div class="mt-4">
          <label class="block mb-1 text-sm text-gray-700">เหตุผล</label>
          <select
            v-model="selectedCancelReason"
            class="w-full px-3 py-2 border border-gray-300 rounded-md"
          >
            <option value="" disabled>-- เลือกเหตุผล --</option>
            <option
              v-for="r in cancelReasonOptions"
              :key="r.value"
              :value="r.value"
            >
              {{ r.label }}
            </option>
          </select>
          <p v-if="cancelReasonError" class="mt-2 text-sm text-red-600">
            {{ cancelReasonError }}
          </p>
        </div>

        <div class="flex justify-end gap-2 mt-6">
          <button
            @click="closeCancelModal"
            class="px-4 py-2 text-sm text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200"
          >
            ปิด
          </button>
          <button
            @click="submitCancel"
            :disabled="!selectedCancelReason || isSubmittingCancel"
            class="px-4 py-2 text-sm text-white bg-red-600 rounded-md hover:bg-red-700 disabled:opacity-50"
          >
            {{ isSubmittingCancel ? "กำลังส่ง..." : "ยืนยันการยกเลิก" }}
          </button>
        </div>
      </div>
    </div>

    <ConfirmModal
      :show="isModalVisible"
      :title="modalContent.title"
      :message="modalContent.message"
      :confirmText="modalContent.confirmText"
      :variant="modalContent.variant"
      @confirm="handleConfirmAction"
      @cancel="closeConfirmModal"
    />

    <!--reviewpopup-->
    <transition name="modal-fade">
      <div v-if="showreview" class="modal-overlay" @click.self="showreview=false">
        <div class="modal-content">
          <!-- Header -->
          <div class="flex items-center justify-between p-6 border-b border-gray-300">
            <h3 class="text-xl font-semibold text-gray-900">รีวิวทั้งหมด</h3>
            <button @click="showreview=false" class="text-gray-400 hover:text-gray-600">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M6 18L18 6M6 6l12 12"></path>
              </svg>
            </button>
          </div>

          <!-- Driver Profile -->
          <div class="p-6">
            <div class="flex flex-col items-center">
              <img 
                :src="driverInfo?.image || driverInfo?.profilePicture"
                :alt="driverInfo?.name || 'Driver'"
                class="object-cover w-22 h-22 rounded-full">
              
              <div class="font-medium text-gray-900 mt-2">
                {{ driverInfo?.name || 'ไม่มีข้อมูล' }}
              </div>
              
              <div class="flex items-center mt-1">
                <div class="flex text-sm text-yellow-400">
                  <span v-for="star in 5" :key="star">
                    {{ star <= Math.floor(driverInfo?.rating || 0) ? '★' : '☆' }}
                  </span>
                </div>
                <span class="ml-2 text-sm text-gray-600">
                  {{ (driverInfo?.rating ?? 0).toFixed(1) }} 
                  ({{ driverInfo?.reviews ?? 0}} รีวิว)
                </span>
              </div>
            </div>
          </div>

          <div class="flex items-center justify-between p-6 border-b border-gray-300">
            <h2 class="text-xl font-semibold text-gray-900">ความเห็นจากผู้โดยสาร</h2>
          </div>

          <!-- chetsada 3/3 เพื่อส่วนฟิวเตอร์รีวิวตามดาว -->
          <div class="flex justify-center gap-2 px-6 py-4 border-b border-gray-300">
              <!-- ปุ่มดาวทั้งหมด -->
              <button
                  @click="selectedStarFilter = 0"
                  :class="selectedStarFilter === 0 
                  ? 'bg-blue-600 text-white' 
                  : 'bg-gray-100 text-gray-700'"
                  class="px-3 py-1 text-sm rounded-full transition"
              >
                  ทั้งหมด ({{ starCounts[0] }})
              </button>

              <!-- ปุ่มกรองดาว -->
              <button
                  v-for="star in [5,4,3,2,1]"
                  :key="star"
                  @click="selectedStarFilter = star"
                  :class="selectedStarFilter === star 
                  ? 'bg-blue-600 text-white' 
                  : 'bg-gray-100 text-gray-700'"
                  class="px-3 py-1 text-sm rounded-full transition"
              >
                  {{ star }} ★ ({{ starCounts[star] }})
              </button>
          </div>

          <div v-if="!review || review.length === 0" class="p-6 text-center text-gray-500">
              ยังไม่มีรีวิว
          </div>

          <div v-else-if="filteredReviews.length === 0"class="p-6 text-center text-gray-500">
              ไม่มีรีวิวตามตัวกรองนี้
          </div>
          <!-- จบ -->

          <!-- Reviews List -->
          <div v-else>
            <div v-for="item in filteredReviews" :key="item.id" class="p-3 mx-3 border-b border-gray-300">
              <div class="flex items-center justify-between">
                <div class="font-medium text-gray-900">
                  {{ item.reviewerName || 'ผู้ใช้ไม่ระบุชื่อ' }}
                </div>
                <div class="flex items-center">
                  <div class="flex text-sm text-yellow-400">
                    <span v-for="star in 5" :key="star">
                      {{ star <= Number(item.review?.rating || 0) ? '★' : '☆' }}
                    </span>
                  </div>
                </div>
              </div>
              
              <!-- Comment -->
              <div class="mb-2 text-sm text-gray-900">
                {{ item.comment || 'ไม่มีความคิดเห็น' }}
              </div>
              
              <!-- Review Media -->
              <div class="flex flex-wrap gap-3 mb-3">

                <!-- Images -->
                <template v-if="item.images && item.images.length">
                  <div
                    v-for="(img, index) in item.images"
                    :key="'img-' + index"
                    class="w-28 h-28 rounded-xl overflow-hidden shadow-sm border bg-gray-100"
                  >
                    <img
                      v-if="img && img.url"
                      :src="img.url"
                      class="w-full h-full object-cover hover:scale-105 transition duration-300"
                    />
                  </div>
                </template>

                <!-- Videos -->
                <template v-if="item.videos && item.videos.length">
                  <div
                    v-for="(vid, index) in item.videos"
                    :key="'vid-' + index"
                    class="relative w-28 h-28 rounded-xl overflow-hidden shadow-sm border cursor-pointer group bg-black"
                    @click="vid && vid.url ? openVideo(vid.url) : null"
                  >
                    <video
                      v-if="vid && vid.url"
                      :src="vid.url"
                      class="w-full h-full object-cover"
                      muted
                      preload="metadata"
                    />
                    <div class="absolute inset-0 bg-black/30 group-hover:bg-black/50 transition"></div>
                    <div class="absolute inset-0 flex items-center justify-center">
                      <div class="bg-white/80 rounded-full p-2 shadow">
                        <svg class="w-6 h-6 text-black" fill="currentColor" viewBox="0 0 24 24">
                          <path d="M8 5v14l11-7z" />
                        </svg>
                      </div>
                    </div>
                  </div>
                </template>

                <!-- Fullscreen Video -->
                <transition name="modal-fade">
                  <div
                    v-if="fullscreenVideo"
                    class="fixed inset-0 bg-black/90 flex items-center justify-center z-50"
                    @click.self="closeVideo"
                  >
                    <button class="absolute top-5 right-5 text-white text-3xl" @click="closeVideo">✕</button>
                    <video
                      :src="fullscreenVideo"
                      controls
                      autoplay
                      muted
                      class="max-w-full max-h-full rounded-lg"
                    />
                  </div>
                </transition>

                <!-- Audio -->
                <template v-if="item.audio && item.audio.length">
                  <div
                    v-for="(audio, index) in item.audio"
                    :key="'audio-' + index"
                    class="w-full bg-gray-50 p-2 rounded-lg border"
                  >
                    <audio
                      v-if="audio && audio.url"
                      :src="audio.url"
                      controls
                      class="w-full"
                    />
                  </div>
                </template>

                <!-- Links -->
                <template v-if="item.links && item.links.length">
                  <div
                    v-for="(linkItem, index) in item.links"
                    :key="'link-' + index"
                    class="w-full"
                  >
                    <a
                      v-if="linkItem && linkItem.url"
                      :href="linkItem.url"
                      target="_blank"
                      class="flex items-center gap-3 p-3 rounded-xl bg-blue-50 hover:bg-blue-100 transition border shadow-sm break-all"
                    >
                      <span class="text-lg">🔗</span>
                      <span class="text-blue-600 font-medium truncate">{{ linkItem.url }}</span>
                    </a>
                  </div>
                </template>

              </div>
              
              <div class="text-sm text-gray-500">
                {{ item.createdAt ? dayjs(item.createdAt).format('D MMM BBBB') : 
                item.createAt ? dayjs(item.createAt).format('D MMM BBBB') : 
                'ไม่ระบุวันที่' }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, nextTick } from "vue";
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
import ConfirmModal from "~/components/ConfirmModal.vue";
import { useToast } from "~/composables/useToast";

import ReviewModal from "~/components/ReviewModal.vue"; // chetsada 15/2 2:34

// Setup dayjs for Thai locale
dayjs.locale("th");
dayjs.extend(buddhistEra);

const { $api } = useNuxtApp();
const { toast } = useToast();

// --- State Management ---
const activeTab = ref("pending");
const selectedTripId = ref(null);
const isLoading = ref(false);
const mapContainer = ref(null);

// --- Review Modal State ---
const showreview = ref(false);
const review = ref([]);
// chetsada ให้รีวิวขึ้น
const showReviewModal = ref(false);
const reviewTripModal = ref(null); 
const isReviewSubmitting = ref(false) // รอส่งรีวิวแล้วกดออกหน้าป๊อปอัพ
const selectedStarFilter = ref(0) // state ฟิลเตอร์ดาวรีวิว เลือก 0 คือแสดงรีวิวทั้งหมด


const driverInfo = ref(null);
const fullscreenVideo = ref(null);

let map = null;
let currentPolyline = null;
let currentMarkers = [];
const allTrips = ref([]);

let gmap = null; // Google Map instance
let activePolyline = null;
let startMarker = null;
let endMarker = null;
let geocoder = null;
let placesService = null;
const mapReady = ref(false);
let stopMarkers = [];

const driverRatingCache = new Map();

const GMAPS_CB = "__gmapsReady__";

const tabs = [
  { status: "pending", label: "รอดำเนินการ" },
  { status: "confirmed", label: "ยืนยันแล้ว" },
  { status: "rejected", label: "ปฏิเสธ" },
  { status: "cancelled", label: "ยกเลิก" },
  /*
  Contributer: Nattawadee Chaleechat
  [Description]
  เพิ่ม "การเดินทางเสร็จสิ้น" ในเมนู Tab เพื่อสามารถดูการเดินทางที่จบไปแล้ว
  */
  { status: "completed", label: "การเดินทางเสร็จสิ้น" },
  { status: "all", label: "ทั้งหมด" },
];

definePageMeta({ middleware: "auth" });

const cancelReasonOptions = [
  { value: "CHANGE_OF_PLAN", label: "เปลี่ยนแผน/มีธุระกะทันหัน" },
  { value: "FOUND_ALTERNATIVE", label: "พบวิธีเดินทางอื่นแล้ว" },
  { value: "DRIVER_DELAY", label: "คนขับล่าช้าหรือเลื่อนเวลา" },
  { value: "PRICE_ISSUE", label: "ราคาหรือค่าใช้จ่ายไม่เหมาะสม" },
  { value: "WRONG_LOCATION", label: "เลือกจุดรับ–ส่งผิด" },
  { value: "DUPLICATE_OR_WRONG_DATE", label: "จองซ้ำหรือจองผิดวัน" },
  { value: "SAFETY_CONCERN", label: "กังวลด้านความปลอดภัย" },
  { value: "WEATHER_OR_FORCE_MAJEURE", label: "สภาพอากาศ/เหตุสุดวิสัย" },
  { value: "COMMUNICATION_ISSUE", label: "สื่อสารไม่สะดวก/ติดต่อไม่ได้" },
];

const isCancelModalVisible = ref(false);
const isSubmittingCancel = ref(false);
const selectedCancelReason = ref("");
const cancelReasonError = ref("");
const tripToCancel = ref(null);

// --- Computed Properties ---
const filteredTrips = computed(() => {
  if (activeTab.value === "all") return allTrips.value;
  return allTrips.value.filter((trip) => trip.status === activeTab.value);
});

const selectedTrip = computed(() => {
  return (
    allTrips.value.find((trip) => trip.id === selectedTripId.value) || null
  );
});

// chetsada 3/3 กรองรีวิว
const filteredReviews = computed(() => {
  if (selectedStarFilter.value === 0) {
    return review.value
  }
  return review.value.filter(r => 
    Number(r.review?.rating || r.star || 0) === selectedStarFilter.value,
  )
})
// นับจำนวนรีวิวในแต่ละดาว
const starCounts = computed(() => {
    const counts = {0:0,1:0,2:0,3:0,4:0,5:0}
    review.value.forEach(r => {
        const star = Number(r.review?.rating || r.star || 0)
        if (counts[star] !== undefined) {
            counts[star]++
        }
        counts[0]++    
    })
  return counts
})
// จบ

//แปลงapi ให้เป็น UI แบบเดียวกัน
function normalizeRatingSummary(response) {
  let rating = null;
  let reviews = null;

  if (response?.driver) {
    const r = Number(response.driver.rating);
    const c = Number(response.driver.reviews);
    rating = Number.isFinite(r) ? r : null;
    reviews = Number.isFinite(c) ? c : null;
  }

  if ((rating == null || reviews == null) && Array.isArray(response?.reviews)) {
    const values = response.reviews
      .map((item) => Number(item?.review?.rating ?? item?.rating))
      .filter((v) => Number.isFinite(v));
    if (values.length) {
      const sum = values.reduce((acc, v) => acc + v, 0);
      rating = sum / values.length;
      reviews = values.length;
    } else if (reviews == null) {
      reviews = response.reviews.length;
    }
  }

  return {
    rating: Number.isFinite(rating) ? rating : 0,
    reviews: Number.isFinite(reviews) ? reviews : 0,
  };
}
//ป้องกันยิง API ซ้ำทุกครั้ง
async function fetchDriverRatingSummary(driverId) {
  if (!driverId) return null;
  if (driverRatingCache.has(driverId)) return driverRatingCache.get(driverId);

  try {
    const response = await $api(`/review/${driverId}/reviews`);
    const summary = normalizeRatingSummary(response);
    driverRatingCache.set(driverId, summary);
    return summary;
  } catch (error) {
    console.warn("Failed to load driver rating:", driverId, error);
    return null;
  }
}

function cleanAddr(a) {
  return (a || "")
    .replace(/,?\s*(Thailand|ไทย|ประเทศ)\s*$/i, "")
    .replace(/\s{2,}/g, " ")
    .trim();
}

// chetsada 15/2 23:56
function openReviewModal(trip) {
  reviewTripModal.value = trip;
  showReviewModal.value = true;
  selectedStarFilter.value = 0;
}

// chetsada 16/2 2:56
function closeReview() {
  showReviewModal.value = false;
  reviewTripModal.value = null;
}
//

async function openVideo(url) {
  fullscreenVideo.value = url;
}

function closeVideo() {
  fullscreenVideo.value = null;
}

// --- Methods ---
async function fetchMyTrips() {
  isLoading.value = true;
  try {
    const bookings = await $api("/bookings/me");

    const driverIds = Array.from(
      new Set(
        bookings
          .map((b) => b?.route?.driver?.id)
          .filter(Boolean),
      ),
    );
    const driverSummaryById = new Map();
    await Promise.allSettled(
      driverIds.map(async (driverId) => {
        const summary = await fetchDriverRatingSummary(driverId);
        if (summary) driverSummaryById.set(driverId, summary);
      }),
    );

    // map ข้อมูลพื้นฐานก่อน (ตั้งชื่อชั่วคราวเป็นพิกัด แล้วไป reverse geocode ภายหลัง)
    const formatted = bookings.map((b) => {
      const driverSummary = driverSummaryById.get(b?.route?.driver?.id);
      const driverData = {
        id: b.route.driver.id,
        name: `${b.route.driver.firstName} ${b.route.driver.lastName}`.trim(),
        image:
          b.route.driver.profilePicture ||
          `https://ui-avatars.com/api/?name=${encodeURIComponent(b.route.driver.firstName || "U")}&background=random&size=64`,
        rating: driverSummary?.rating ?? 0,
        reviews: driverSummary?.reviews ?? 0,
      };

      const carDetails = [];
      if (b.route.vehicle) {
        carDetails.push(
          `${b.route.vehicle.vehicleModel} (${b.route.vehicle.vehicleType})`,
        );
        if (
          Array.isArray(b.route.vehicle.amenities) &&
          b.route.vehicle.amenities.length
        ) {
          carDetails.push(...b.route.vehicle.amenities);
        }
      } else {
        carDetails.push("ไม่มีข้อมูลรถ");
      }

      const start = b.route.startLocation;
      const end = b.route.endLocation;

      const wp = b.route.waypoints || {};
      const baseList =
        (Array.isArray(wp.used) && wp.used.length
          ? wp.used
          : Array.isArray(wp.requested)
            ? wp.requested
            : []) || [];
      const orderedList =
        Array.isArray(wp.optimizedOrder) &&
        wp.optimizedOrder.length === baseList.length
          ? wp.optimizedOrder.map((i) => baseList[i])
          : baseList;

      const stops = orderedList
        .map((p) => {
          const name = p?.name || "";
          const address = cleanAddr(p?.address || "");
          const fallback =
            p?.lat != null && p?.lng != null
              ? `(${Number(p.lat).toFixed(6)}, ${Number(p.lng).toFixed(6)})`
              : "";
          const title = name || fallback;
          return address ? `${title} — ${address}` : title;
        })
        .filter(Boolean);

      const stopsCoords = orderedList
        .map((p) =>
          p && typeof p.lat === "number" && typeof p.lng === "number"
            ? {
                lat: Number(p.lat),
                lng: Number(p.lng),
                name: p.name || "",
                address: p.address || "",
              }
            : null,
        )
        .filter(Boolean);

      const selectedExtraCharges = Array.isArray(b.bookingExtraCharge)
        ? b.bookingExtraCharge.map((item) => ({
            id: item.routeExtraChargeId || item.id,
            name: item.name,
            unitPrice: item.unitPrice,
            quantity: item.quantity,
            totalExtraPrice: item.totalExtraPrice,
          }))
        : [];

      return {
        id: b.id,

        completedAt: new Date(b.completedAt),
        reviewed: Array.isArray(b.review) && b.review.length > 0, // chetsada 16/2 1:25 // ChatGPT ช่วย
        // Contributer: Nattawadee Chaleechat
        // เพิ่มfield driver_confirm_arrived, passenger_confirm_arrived เมื่อทำการ fetchMyTrips() ดึงข้อมูลจาก backend จะได้ค่ามาด้วย
        driver_confirm_arrived: b.driver_confirm_arrived ?? false,
        passenger_confirm_arrived: b.passenger_confirm_arrived ?? false,

        status: String(b.status || "").toLowerCase(),
        origin:
          start?.name ||
          `(${Number(start.lat).toFixed(2)}, ${Number(start.lng).toFixed(2)})`,
        destination:
          end?.name ||
          `(${Number(end.lat).toFixed(2)}, ${Number(end.lng).toFixed(2)})`,
        originAddress: start?.address ? cleanAddr(start.address) : null,
        destinationAddress: end?.address ? cleanAddr(end.address) : null,
        originHasName: !!start?.name,
        destinationHasName: !!end?.name,
        pickupPoint: b.pickupLocation?.name || "-",
        date: dayjs(b.route.departureTime).format("D MMMM BBBB"),
        time: dayjs(b.route.departureTime).format("HH:mm น."),
        price: b.totalPrice ?? (b.route.pricePerSeat || 0) * (b.numberOfSeats || 1),//
        seats: b.numberOfSeats || 1,
        driver: driverData,
        coords: [
          [start.lat, start.lng],
          [end.lat, end.lng],
        ],
        polyline: b.route.routePolyline || null, // ใช้เมื่อมี
        stops,
        stopsCoords,
        carDetails,
        extraCharges: selectedExtraCharges,
        conditions: b.route.conditions,
        photos: b.route.vehicle?.photos || [],
        durationText:
          (typeof b.route.duration === "string"
            ? formatDuration(b.route.duration)
            : b.route.duration) ||
          (typeof b.route.durationSeconds === "number"
            ? `${Math.round(b.route.durationSeconds / 60)} นาที`
            : "-"),
        distanceText:
          (typeof b.route.distance === "string"
            ? formatDistance(b.route.distance)
            : b.route.distance) ||
          (typeof b.route.distanceMeters === "number"
            ? `${(b.route.distanceMeters / 1000).toFixed(1)} กม.`
            : "-"),
      };
    });

    allTrips.value = formatted;

    // รอให้แผนที่พร้อมก่อน แล้วค่อย reverse geocode เพื่อได้ "ชื่อสถานที่" สวยๆ
    await waitMapReady();

    const jobs = allTrips.value.map(async (t, idx) => {
      const [o, d] = await Promise.all([
        reverseGeocode(t.coords[0][0], t.coords[0][1]),
        reverseGeocode(t.coords[1][0], t.coords[1][1]),
      ]);
      const oParts = await extractNameParts(o);
      const dParts = await extractNameParts(d);

      if (!allTrips.value[idx].originHasName && oParts.name) {
        allTrips.value[idx].origin = oParts.name;
      }
      if (!allTrips.value[idx].destinationHasName && dParts.name) {
        allTrips.value[idx].destination = dParts.name;
      }
    });

    await Promise.allSettled(jobs);
  } catch (error) {
    console.error("Failed to fetch my trips:", error);
    allTrips.value = [];
  } finally {
    isLoading.value = false;
  }
}

function waitMapReady() {
  return new Promise((resolve) => {
    if (mapReady.value) return resolve(true);
    const t = setInterval(() => {
      if (mapReady.value) {
        clearInterval(t);
        resolve(true);
      }
    }, 50);
  });
}

function reverseGeocode(lat, lng) {
  return new Promise((resolve) => {
    if (!geocoder) return resolve(null);
    geocoder.geocode({ location: { lat, lng } }, (results, status) => {
      if (status !== "OK" || !results?.length) return resolve(null);
      resolve(results[0]);
    });
  });
}

async function extractNameParts(geocodeResult) {
  if (!geocodeResult) return { name: null, area: null };

  const comps = geocodeResult.address_components || [];
  const byType = (t) => comps.find((c) => c.types.includes(t))?.long_name;
  const byTypeShort = (t) => comps.find((c) => c.types.includes(t))?.short_name;

  const types = geocodeResult.types || [];
  const isPoi =
    types.includes("point_of_interest") ||
    types.includes("establishment") ||
    types.includes("premise");

  let name = null;
  if (isPoi && geocodeResult.place_id) {
    const poiName = await getPlaceName(geocodeResult.place_id);
    if (poiName) name = poiName;
  }
  if (!name) {
    const streetNumber = byType("street_number");
    const route = byType("route");
    name =
      streetNumber && route
        ? `${streetNumber} ${route}`
        : route || geocodeResult.formatted_address || null;
  }

  const sublocality =
    byType("sublocality") ||
    byType("neighborhood") ||
    byType("locality") ||
    byType("administrative_area_level_2");
  const province =
    byType("administrative_area_level_1") ||
    byTypeShort("administrative_area_level_1");

  let area = null;
  if (sublocality && province) area = `${sublocality}, ${province}`;
  else if (province) area = province;

  if (name) name = name.replace(/,?\s*(Thailand|ไทย)\s*$/i, "");
  return { name, area };
}

function getPlaceName(placeId) {
  return new Promise((resolve) => {
    if (!placesService || !placeId) return resolve(null);
    placesService.getDetails({ placeId, fields: ["name"] }, (place, status) => {
      if (status === google.maps.places.PlacesServiceStatus.OK && place?.name)
        resolve(place.name);
      else resolve(null);
    });
  });
}

const getTripCount = (status) => {
  if (status === "all") return allTrips.value.length;
  return allTrips.value.filter((trip) => trip.status === status).length;
};

const toggleTripDetails = (tripId) => {
  const tripForMap = allTrips.value.find((trip) => trip.id === tripId);
  if (tripForMap) {
    updateMap(tripForMap);
  }

  if (selectedTripId.value === tripId) {
    selectedTripId.value = null;
  } else {
    selectedTripId.value = tripId;
  }
};

// chetsada 17/2 ให้ fecth หน้า หลังจากกด ส่งรีวิว แล้วส่งผ่าน
async function ReviewSuccess() {
  await fetchMyTrips()   
  closeReview()
}
// chetsada 17/2 เช็ค ว่าจบไปแล้ว 7 วันไหม
function canReview(trip) {
  if (!trip.completedAt) return false;
  const now = new Date();

  const differentTime = now - trip.completedAt; // ms
  const differentDays = differentTime / (1000 * 60 * 60 * 24);

  return differentDays <= 7;
}

async function updateMap(trip) {
  if (!trip) return;
  await waitMapReady();
  if (!gmap) return;

  // cleanup ของเดิม
  if (activePolyline) {
    activePolyline.setMap(null);
    activePolyline = null;
  }
  if (startMarker) {
    startMarker.setMap(null);
    startMarker = null;
  }
  if (endMarker) {
    endMarker.setMap(null);
    endMarker = null;
  }
  if (stopMarkers.length) {
    stopMarkers.forEach((m) => m.setMap(null));
    stopMarkers = [];
  }

  const start = {
    lat: Number(trip.coords[0][0]),
    lng: Number(trip.coords[0][1]),
  };
  const end = {
    lat: Number(trip.coords[1][0]),
    lng: Number(trip.coords[1][1]),
  };

  // หมุด A/B
  startMarker = new google.maps.Marker({
    position: start,
    map: gmap,
    label: "A",
  });
  endMarker = new google.maps.Marker({ position: end, map: gmap, label: "B" });

  if (Array.isArray(trip.stopsCoords) && trip.stopsCoords.length) {
    stopMarkers = trip.stopsCoords.map(
      (s, idx) =>
        new google.maps.Marker({
          position: { lat: s.lat, lng: s.lng },
          map: gmap,
          icon: "http://maps.google.com/mapfiles/ms/icons/green-dot.png",
          title: s.name || s.address || `จุดแวะ ${idx + 1}`,
        }),
    );
  }

  // เส้นทางจาก polyline ถ้ามี
  if (trip.polyline && google.maps.geometry?.encoding) {
    const path = google.maps.geometry.encoding.decodePath(trip.polyline);
    activePolyline = new google.maps.Polyline({
      path,
      map: gmap,
      strokeColor: "#2563eb",
      strokeOpacity: 0.9,
      strokeWeight: 5,
    });
    const bounds = new google.maps.LatLngBounds();
    path.forEach((p) => bounds.extend(p));

    if (trip.stopsCoords?.length) {
      trip.stopsCoords.forEach((s) =>
        bounds.extend(new google.maps.LatLng(s.lat, s.lng)),
      );
    }

    gmap.fitBounds(bounds);
  } else {
    // ไม่มี polyline → fit จากจุด A-B + จุดแวะ
    const bounds = new google.maps.LatLngBounds();
    bounds.extend(start);
    bounds.extend(end);
    if (trip.stopsCoords?.length) {
      trip.stopsCoords.forEach((s) =>
        bounds.extend(new google.maps.LatLng(s.lat, s.lng)),
      );
    }
    gmap.fitBounds(bounds);
  }
}

// --- Modal Logic ---
const isModalVisible = ref(false);
const tripToAction = ref(null);
const modalContent = ref({
  title: "",
  message: "",
  confirmText: "",
  action: null,
  variant: "danger",
});

const openConfirmModal = (trip, action) => {
  tripToAction.value = trip;
  if (action === "cancel") {
    // ตอนนี้ไม่ใช้ทางยืนยันตรง ๆ แล้ว แต่คงโครงไว้เผื่ออนาคต
    modalContent.value = {
      title: "ยืนยันการยกเลิกการจอง",
      message: `คุณต้องการยกเลิกการเดินทางไปที่ "${trip.destination}" ใช่หรือไม่?`,
      confirmText: "ใช่, ยกเลิกการจอง",
      action: "cancel",
      variant: "danger",
    };
  } else if (action === "delete") {
    modalContent.value = {
      title: "ยืนยันการลบรายการ",
      message: `คุณต้องการลบรายการเดินทางไปที่ "${trip.destination}" ออกจากประวัติใช่หรือไม่?`,
      confirmText: "ใช่, ลบรายการ",
      action: "delete",
      variant: "danger",
    };
    //(Start) เพิ่มกรณีสำหรับ 'complete' (สิ้นสุดการเดินทาง) [0:31|13/2/2569]
    //ใช้ Gemini AI ช่วยเขียน
  } else if (action === "complete") {
    modalContent.value = {
      title: "ยืนยันการสิ้นสุดการเดินทาง",
      message: `คุณมาถึงที่ "${trip.destination}" แล้วใช่หรือไม่?`,
      confirmText: "ใช่! สิ้นสุดการเดินทาง",
      action: "complete",
      variant: "success",
    };
  }
  //(Finish)
  isModalVisible.value = true;
};

const closeConfirmModal = () => {
  isModalVisible.value = false;
  tripToAction.value = null;
};

const handleConfirmAction = async () => {
  if (!tripToAction.value) return;
  const action = modalContent.value.action;
  const tripId = tripToAction.value.id;
  try {
    if (action === "cancel") {
      // ไม่ยิง PATCH ตรง ๆ — ต้องให้ผู้ใช้เลือกเหตุผลก่อน
      openCancelModal(tripToAction.value);
      closeConfirmModal();
      return;
      //(Start) เพิ่ม action ของ 'complete' (สิ้นสุดการเดินทาง) [0:37|13/2/2569]
      // Nattawadee แก้ไขเพิ่มเติม
    } else if (action === "complete") {
      await $api(`/bookings/${tripId}/arrive-passenger`, {
        method: "PATCH",
        body: { status: "COMPLETED" },
      });
      await fetchMyTrips();
      console.log("UPDATED TRIPS:",allTrips.value); // แก้ชื่อให้ตรง
      toast.success("สิ้นสุดการเดินทางสำเร็จ", 'ขอบคุณที่ใช้บริการ "ไปนำแหน่"');
      //(Finish)
    } else if (action === "delete") {
      await $api(`/bookings/${tripId}`, { method: "DELETE" });
      toast.success("ลบรายการสำเร็จ", "รายการได้ถูกลบออกจากประวัติแล้ว");
    }
    closeConfirmModal();
    await fetchMyTrips();
  } catch (error) {
    console.error(`Failed to ${action} booking:`, error);
    toast.error(
      "เกิดข้อผิดพลาด",
      error.data?.message || "ไม่สามารถดำเนินการได้",
    );
    closeConfirmModal();
  }
};

function openCancelModal(trip) {
  tripToCancel.value = trip;
  selectedCancelReason.value = "";
  cancelReasonError.value = "";
  isCancelModalVisible.value = true;
}

function closeCancelModal() {
  isCancelModalVisible.value = false;
  tripToCancel.value = null;
}

async function submitCancel() {
  if (!selectedCancelReason.value) {
    cancelReasonError.value = "กรุณาเลือกเหตุผล";
    return;
  }
  if (!tripToCancel.value) return;

  isSubmittingCancel.value = true;
  try {
    await $api(`/bookings/${tripToCancel.value.id}/cancel`, {
      method: "PATCH",
      body: { reason: selectedCancelReason.value }, // ✅ ตรงกับ schema ฝั่ง backend
    });
    toast.success("ยกเลิกการจองสำเร็จ", "ระบบบันทึกเหตุผลแล้ว");
    closeCancelModal();
    await fetchMyTrips();
  } catch (err) {
    console.error("Cancel booking failed:", err);
    toast.error("เกิดข้อผิดพลาด", err?.data?.message || "ไม่สามารถยกเลิกได้");
  } finally {
    isSubmittingCancel.value = false;
  }
}

function formatDistance(input) {
  if (typeof input !== "string") return input;
  const parts = input.split("+");
  if (parts.length <= 1) return input;

  let meters = 0;
  for (const seg of parts) {
    const n = parseFloat(seg.replace(/[^\d.]/g, ""));
    if (Number.isNaN(n)) continue;
    if (/กม/.test(seg)) meters += n * 1000;
    else if (/เมตร|ม\./.test(seg)) meters += n;
    else meters += n; // สมมติเป็นเมตรถ้าไม่พบหน่วย
  }

  if (meters >= 1000) {
    const km = Math.round((meters / 1000) * 10) / 10; // ปัดทศนิยม 1 ตำแหน่ง
    return `${km % 1 === 0 ? km.toFixed(0) : km} กม.`;
  }
  return `${Math.round(meters)} ม.`;
}

function formatDuration(input) {
  if (typeof input !== "string") return input;
  const parts = input.split("+");
  if (parts.length <= 1) return input;

  let minutes = 0;
  for (const seg of parts) {
    const n = parseFloat(seg.replace(/[^\d.]/g, ""));
    if (Number.isNaN(n)) continue;
    if (/ชม/.test(seg)) minutes += n * 60;
    else minutes += n; // นาที
  }

  const h = Math.floor(minutes / 60);
  const m = Math.round(minutes % 60);
  return h ? (m ? `${h} ชม. ${m} นาที` : `${h} ชม.`) : `${m} นาที`;
}

// --- Lifecycle and Watchers ---
useHead({
  title: "การเดินทางของฉัน - ไปนำแหน่",
  link: [
    {
      rel: "stylesheet",
      href: "https://fonts.googleapis.com/css2?family=Kanit:wght@300;400;500;600;700&display=swap",
    },
  ],
  script:
    process.client && !window.google?.maps
      ? [
          {
            key: "gmaps",
            src: `https://maps.googleapis.com/maps/api/js?key=${useRuntimeConfig().public.googleMapsApiKey}&libraries=places,geometry&callback=__gmapsReady__`,
            async: true,
            defer: true,
          },
        ]
      : [],
});

onMounted(() => {
  // ถ้า script โหลดแล้ว
  if (window.google?.maps) {
    initializeMap();
    fetchMyTrips().then(() => {
      // ถ้ามีข้อมูลแล้วและยังไม่ได้เลือก ให้โชว์แผนที่ของรายการแรกในแท็บปัจจุบัน
      if (filteredTrips.value.length) updateMap(filteredTrips.value[0]);
    });
    return;
  }

  // ยังไม่โหลดเสร็จ: ตั้ง callback
  window[GMAPS_CB] = () => {
    try {
      delete window[GMAPS_CB];
    } catch {}
    initializeMap();
    fetchMyTrips().then(() => {
      if (filteredTrips.value.length) updateMap(filteredTrips.value[0]);
    });
  };
});

// Review Modal Functions
async function openReviewModalDriver(trip) {
    showreview.value = true;
    driverInfo.value = trip.driver;
    review.value = [];

    try{
        if (!trip?.driver?.id) {
            console.error('Driver ID is missing');
            return;
        }

        // console.log('Opening review modal for driver:', trip.driver.id);
        const response = await $api(`/review/${trip.driver.id}/reviews`);

        // Extract reviews from various possible response structures
        let reviewsData = [];
        let driverProfile = null;
        let ratingData = null;

        // Try response.data structure first (most likely based on backend code)
        if (response?.data) {
            // console.log('Response has .data property');
            reviewsData = response.data.reviews || [];
            driverProfile = response.data.driverProfile || null;
            ratingData = response.data.ratingData || null;
            // console.log('Extracted from response.data - reviews:', reviewsData.length);
        } 
        // Try direct reviews property
        else if (response?.reviews && Array.isArray(response.reviews)) {
            reviewsData = response.reviews;
            // console.log('Extracted from response.reviews - count:', reviewsData.length);
        } 
        // Try as direct array
        else if (Array.isArray(response)) {
            reviewsData = response;
            // console.log('Response is direct array - count:', reviewsData.length);
        } 
        // Fallback: try to find reviews in any array property
        else {
            // console.log('Response structure:', Object.keys(response || {}));
            for (const key in response) {
                if (Array.isArray(response[key]) && response[key].length > 0) {
                    if (key.includes('review') || response[key][0]?.reviewerName) {
                        reviewsData = response[key];
                        // console.log(`Found reviews in response.${key}:`, reviewsData.length);
                        break;
                    }
                }
            }
        }

        review.value = reviewsData;
        // console.log('Final reviews array:', review.value.length, 'items');

        // Update driver info
        if (response) {
            const ratingValue = ratingData?.averageRating ?? response.driver?.rating ?? trip.driver?.rating ?? 0;
            const reviewsCount = ratingData?.totalReviews ?? response.driver?.reviews ?? trip.driver?.reviews ?? reviewsData.length;
            
            driverInfo.value = {
                ...driverInfo.value,
                id: driverProfile?.id || trip.driver?.id,
                name: driverProfile?.firstName && driverProfile?.lastName
                    ? `${driverProfile.firstName} ${driverProfile.lastName}`
                    : response.name || trip.driver?.name,
                profilePicture: driverProfile?.profilePicture || trip.driver?.image,
                image: driverProfile?.profilePicture || trip.driver?.image,
                isVerified: driverProfile?.isVerified ?? trip.driver?.isVerified,
                rating: ratingValue,
                reviews: reviewsCount
            };
            
            // console.log('Driver info updated:', {
            //     name: driverInfo.value.name,
            //     rating: driverInfo.value.rating,
            //     reviews: driverInfo.value.reviews
            // });
        }
        
        // if (reviewsData.length > 0) {
        //     console.log('First review structure:', JSON.stringify(reviewsData[0], null, 2));
        // }
        
    }catch(error){
        console.error('Failed to load reviews - Error:', error.message);
        console.error('Error details:', error);
        review.value = [];
    }
}

function initializeMap() {
  if (!mapContainer.value || gmap) return;
  gmap = new google.maps.Map(mapContainer.value, {
    center: { lat: 13.7563, lng: 100.5018 },
    zoom: 6,
    mapTypeControl: false,
    streetViewControl: false,
    fullscreenControl: true,
  });
  geocoder = new google.maps.Geocoder();
  placesService = new google.maps.places.PlacesService(gmap);
  mapReady.value = true;
}
</script>

<style scoped>
.trip-card {
  transition: all 0.3s ease;
  cursor: pointer;
}

.trip-card:hover {
  /* transform: translateY(-2px); */
  box-shadow: 0 10px 25px rgba(59, 130, 246, 0.1);
}

.tab-button {
  transition: all 0.3s ease;
}

.tab-button.active {
  background-color: #3b82f6;
  color: white;
  box-shadow: 0 4px 14px rgba(59, 130, 246, 0.3);
}

.tab-button:not(.active) {
  background-color: white;
  color: #6b7280;
  border: 1px solid #d1d5db;
}

.tab-button:not(.active):hover {
  background-color: #f9fafb;
  color: #374151;
}

#map {
  height: 100%;
  min-height: 600px;
  border-radius: 0 0 0.5rem 0.5rem;
}

.status-badge {
  display: inline-flex;
  align-items: center;
  padding: 0.25rem 0.75rem;
  border-radius: 9999px;
  font-size: 0.875rem;
  font-weight: 500;
}

.status-pending {
  background-color: #fef3c7;
  color: #d97706;
}

.status-confirmed {
  background-color: #d1fae5;
  color: #065f46;
}

.status-rejected {
  background-color: #fee2e2;
  color: #dc2626;
}

.status-cancelled {
  background-color: #f3f4f6;
  color: #6b7280;
}

/*(Start) เพิ่มสีให้ปุ่ม "สิ้นสุดการเดินทาง" [0:14|13/2/2569]*/
/*ใช้ Gemini AI ช่วยเขียน*/
.status-completed {
  background-color: #e0f2fe;
  color: #0284c7;
}
/*(Finish) */

@keyframes slide-in-from-top {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-in {
  animation-fill-mode: both;
}

.slide-in-from-top {
  animation-name: slide-in-from-top;
}

.duration-300 {
  animation-duration: 300ms;
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

<!--
ขั้นตอนการรัน Project
1. clone project
2. cd backend
   npm install
3. cd ../frontend
   npm install
4. Create a .env file in the backend directory with the following:

# Server
PORT=3000

# Database
DATABASE_URL="postgresql://<user>:<password>@<host>:<port>/<database>?schema=public"

# JWT Secret
JWT_SECRET=your_super_secret_jwt_key

# Cloudinary Credentials
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# Google Maps API Key (Backend)
GOOGLE_MAPS_API_KEY=your_google_maps_api_key_for_backend

# Google Maps API Key (Frontend)
NUXT_PUBLIC_GOOGLE_MAPS_API_KEY=your_google_maps_api_key_for_frontend

5. Edit the .evn file in Frontend
   NUXT_PUBLIC_GOOGLE_MAPS_API_KEY=your_google_maps_api_key_for_frontend

6. cd backend
   npx prisma generate
   npx prisma migrate dev --name init
7. cd backend
   npm run dev # starts Express server on http://localhost:3000
8. cd frontend
   npm run dev # starts Nuxt.js on http://localhost:3001
-->