/* Contributer: Nattawadee Chaleechat [Description] เพิ่ม "การเดินทางเสร็จสิ้น"
ในเมนู Tab เพื่อสามารถดูการเดินทางที่จบไปแล้ว 
ในเมนู Tab เพื่อสามารถดูการเดินทางที่จบไปแล้ว 

Contributer: Piyawat Sawatkul
[Description] เพิ่ม review popup ในส่วนของการเดินทางที่จบไปแล้ว เพื่อที่เห็นจำนวนและรายละเอียดreview driver 
รวมถึงเชื่อมข้อมูลรีวิวกับ driver ให้ถูกต้องโดยใช้ใช้AI ในการแก้ปัญหาข้อมูลที่ไม่ตรงกันระหว่าง API กับ UI
*/

// Contributer: suttipad rodhom
// [26/2/2569]
// - ปรับ UI Modal รีวิว แสดงผลจาก "รีวิวผู้ขับ" → "รีวิวทั้งหมด"
// - เปลี่ยนหัวข้อเป็น "ความเห็นจากผู้โดยสาร"
// - ปรับ padding ข้อความสถานะการเดินทาง (text-sm → px-4 py-2 text-sm)
// - ปรับการแสดงผลจาก image เดี่ยว → รองรับ media หลายประเภท
//   - images
//   - videos (กดดู fullscreen ได้)
//   - audio
//   - Google Drive links
// - เพิ่มระบบ Fullscreen Video พร้อมปุ่มปิด
// - เพิ่ม state fullscreenVideo สำหรับควบคุมวิดีโอแบบเต็มจอ
// - เพิ่มฟังก์ชัน openVideo() และ closeVideo()

// Contributer: Ratchapoom Thongdaeng
// [27/2/2569]
// - Update เงื่อนไขเพิ่มเติม trip จาก Chatsiri
// - เพื่อให้แสดงเงื่อนไขเพิ่มเติม (routeExtraCharge) ในรายละเอียดเส้นทาง

<template>
  <div>
    <div class="px-4 py-8 mx-auto max-w-7xl sm:px-6 lg:px-8">
      <div class="mb-8">
        <h2 class="text-2xl font-bold text-gray-900">คำขอจองเส้นทางของฉัน</h2>
        <p class="mt-2 text-gray-600">
          ดูและจัดการคำขอจองจากผู้โดยสารในเส้นทางที่คุณสร้าง
        </p>
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
                {{
                  activeTab === "myRoutes" ? "เส้นทางของฉัน" : "รายการคำขอจอง"
                }}
              </h3>
            </div>

            <div v-if="isLoading" class="p-12 text-center text-gray-500">
              <p>กำลังโหลดข้อมูล...</p>
            </div>

            <!-- ===== แท็บ: เส้นทางของฉัน ===== -->
            <div
              v-else-if="activeTab === 'myRoutes'"
              class="divide-y divide-gray-200"
            >
              <div
                v-if="myRoutes.length === 0"
                class="p-12 text-center text-gray-500"
              >
                <p>ยังไม่มีเส้นทางที่คุณสร้าง</p>
              </div>

              <div
                v-for="route in myRoutes"
                :key="route.id"
                class="p-6 transition-colors duration-200 cursor-pointer trip-card hover:bg-gray-50"
                @click="toggleTripDetails(route.id)"
              >
                <div class="flex items-start justify-between mb-4">
                  <div class="flex-1">
                    <div class="flex items-center justify-between">
                      <h4 class="text-lg font-semibold text-gray-900">
                        {{ route.origin }} → {{ route.destination }}
                      </h4>
                      <span
                        class="status-badge"
                        :class="{
                          'status-confirmed': route.status === 'available',
                          'status-pending': route.status === 'full',
                        }"
                      >
                        {{
                          route.status === "available"
                            ? "เปิดรับผู้โดยสาร"
                            : "เต็ม"
                        }}
                      </span>
                    </div>
                    <p class="mt-1 text-sm text-gray-600">
                      วันที่: {{ route.date }}
                      <span class="mx-2 text-gray-300">|</span>
                      เวลา: {{ route.time }}
                      <span class="mx-2 text-gray-300">|</span>
                      ระยะเวลา: {{ route.durationText }}
                      <span class="mx-2 text-gray-300">|</span>
                      ระยะทาง: {{ route.distanceText }}
                    </p>
                    <div class="mt-1 text-sm text-gray-600">
                      <span class="font-medium">ที่นั่งว่าง:</span>
                      <span class="ml-1">{{ route.availableSeats }}</span>
                      <span class="mx-2 text-gray-300">|</span>
                      <span class="font-medium">ราคาต่อที่นั่ง:</span>
                      <span class="ml-1">{{ route.pricePerSeat }} บาท</span>
                    </div>
                  </div>
                </div>

                <!-- รายละเอียดเมื่อเปิด -->
                <div
                  v-if="selectedTripId === route.id"
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
                            route.origin
                          }}</span>
                          <span v-if="route.originAddress">
                            — {{ route.originAddress }}</span
                          >
                        </li>

                        <template v-if="route.stops && route.stops.length">
                          <li class="mt-2 text-gray-700">
                            • จุดแวะระหว่างทาง ({{ route.stops.length }} จุด):
                          </li>
                          <li v-for="(stop, idx) in route.stops" :key="idx">
                              - จุดแวะ {{ idx + 1 }}: {{ stop }}
                          </li>
                        </template>

                        <li class="mt-1">
                          • จุดปลายทาง:
                          <span class="font-medium text-gray-900">{{
                            route.destination
                          }}</span>
                          <span v-if="route.destinationAddress">
                            — {{ route.destinationAddress }}</span
                          >
                        </li>
                      </ul>
                    </div>
                    <div>
                      <h5 class="mb-2 font-medium text-gray-900">
                        รายละเอียดรถ
                      </h5>
                      <ul class="space-y-1 text-sm text-gray-600">
                        <li v-for="detail in route.carDetails" :key="detail">
                          • {{ detail }}
                        </li>
                      </ul>
                    </div>
                  </div>
                                    
                  <!-- [Start][Ratchapoom] Update เงื่อนไขเพิ่มเติม trip-->
                 <div class="mt-4 space-y-4" v-if="route.routeExtraCharge && route.routeExtraCharge.length">
                    <h5 class="mb-2 font-medium text-gray-900">เงื่อนไขเพิ่มเติม (เก็บเงินเพิ่ม)</h5>
                    <ul class="space-y-1 p-3 text-sm text-gray-700 border border-gray-300 rounded-md bg-gray-50">
                      <li v-for="charge in route.routeExtraCharge" :key="charge.id">
                        {{ charge.name }} ราคาต่อชิ้น {{ charge.unitPrice }} บาท
                      </li>
                    </ul>
                  </div>
                  <!-- [Finish]-->

                  <div class="mt-4 space-y-4">
                    <div v-if="route.conditions">
                      <h5 class="mb-2 font-medium text-gray-900">
                        เงื่อนไขการเดินทาง
                      </h5>
                      <p
                        class="p-3 text-sm text-gray-700 border border-gray-300 rounded-md bg-gray-50"
                      >
                        {{ route.conditions }}
                      </p>
                    </div>

                    <div v-if="route.photos && route.photos.length > 0">
                      <h5 class="mb-2 font-medium text-gray-900">
                        รูปภาพรถยนต์
                      </h5>
                      <div class="grid grid-cols-3 gap-2 mt-2">
                        <div
                          v-for="(photo, index) in route.photos.slice(0, 3)"
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

                    <!-- ผู้โดยสารของเส้นทางนี้ -->
                    <div v-if="route.passengers && route.passengers.length">
                      <h5 class="mb-2 font-medium text-gray-900">
                        ผู้โดยสาร ({{ route.passengers.length }} คน)
                      </h5>
                      <div class="space-y-3">
                        <div
                          v-for="p in route.passengers"
                          :key="p.id"
                          class="flex items-center space-x-3"
                        >
                          <img
                            :src="p.image"
                            :alt="p.name"
                            class="object-cover w-12 h-12 rounded-full"
                          />
                          <div class="flex-1">
                            <div class="flex items-center">
                              <span class="font-medium text-gray-900">{{
                                p.name
                              }}</span>
                              <div
                                v-if="p.isVerified"
                                class="relative group ml-1.5 flex items-center"
                              >
                                <svg
                                  class="w-4 h-4 text-blue-600"
                                  viewBox="0 0 24 24"
                                  fill="currentColor"
                                >
                                  <path
                                    fill-rule="evenodd"
                                    d="M8.603 3.799A4.49 4.49 0 0112 2.25c1.357 0 2.573.6 3.397 1.549a4.49 4.49 0 013.498 1.307 4.491 4.491 0 011.307 3.497A4.49 4.49 0 0121.75 12c0 1.357-.6 2.573-1.549 3.397a4.49 4.49 0 01-1.307 3.498 4.491 4.491 0 01-3.497 1.307A4.49 4.49 0 0112 21.75a4.49 4.49 0 01-3.397-1.549 4.49 4.49 0 01-3.498-1.306 4.491 4.491 0 01-1.307-3.498A4.49 4.49 0 012.25 12c0-1.357.6-2.573 1.549-3.397a4.49 4.49 0 011.307-3.497 4.49 4.49 0 013.497-1.307zm7.007 6.387a.75.75 0 10-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 00-1.06 1.06l2.25 2.25a.75.75 0 001.07-.01l3.5-4.875z"
                                    clip-rule="evenodd"
                                  />
                                </svg>
                              </div>
                            </div>
                            <div class="text-sm text-gray-600">
                              ที่นั่ง: {{ p.seats }}
                              <span v-if="p.email" class="mx-2 text-gray-300"
                                >|</span
                              >
                              <a
                                v-if="p.email"
                                :href="`mailto:${p.email}`"
                                class="text-blue-600 hover:underline"
                                @click.stop
                              >
                                {{ p.email }}
                              </a>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- ปุ่มขวาล่าง -->
                <div
                  class="flex justify-end"
                  :class="{ 'mt-4': selectedTripId !== route.id }"
                >
                  <NuxtLink
                    :to="`/myRoute/${route.id}/edit`"
                    class="px-4 py-2 text-sm text-white transition duration-200 bg-blue-600 rounded-md hover:bg-blue-700"
                    @click.stop
                  >
                    แก้ไขเส้นทาง
                  </NuxtLink>
                </div>
              </div>
            </div>

            <!-- ===== แท็บ: คำขอจอง (เดิม) ===== -->
            <div v-else class="divide-y divide-gray-200">
              <div
                v-if="filteredTrips.length === 0"
                class="p-12 text-center text-gray-500"
              >
                <p>ไม่พบรายการในหมวดหมู่นี้</p>
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
                      <!--(Start)เพิ่ม status "สิ้นสุดการเดินทาง" [16:31|14/2/2569]-->
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
                    <div
                      v-if="
                        activeTab === 'cancelled' &&
                        trip.status === 'cancelled' &&
                        trip.cancelReason
                      "
                      class="p-2 mt-2 border border-gray-200 rounded-md bg-gray-50"
                    >
                      <span class="text-sm text-gray-700">
                        เหตุผลการยกเลิกของผู้โดยสาร:
                        <span class="font-medium">{{
                          reasonLabel(trip.cancelReason)
                        }}</span>
                      </span>
                    </div>
                  </div>
                </div>

                <div class="flex items-center mb-4 space-x-4">
                  <img
                    :src="trip.passenger.image"
                    :alt="trip.passenger.name"
                    class="object-cover rounded-full w-15 h-15"
                  />
                  <div class="flex-1">
                    <div class="flex items-center">
                      <h5 class="font-medium text-gray-900">
                        {{ trip.passenger.name }}
                      </h5>

                      <div
                        v-if="trip.passenger.isVerified"
                        class="relative group ml-1.5 flex items-center"
                      >
                        <svg
                          class="w-5 h-5 text-blue-600"
                          viewBox="0 0 24 24"
                          fill="currentColor"
                        >
                          <path
                            fill-rule="evenodd"
                            d="M8.603 3.799A4.49 4.49 0 0112 2.25c1.357 0 2.573.6 3.397 1.549a4.49 4.49 0 013.498 1.307 4.491 4.491 0 011.307 3.497A4.49 4.49 0 0121.75 12c0 1.357-.6 2.573-1.549 3.397a4.49 4.49 0 01-1.307 3.498 4.491 4.491 0 01-3.497 1.307A4.49 4.49 0 0112 21.75a4.49 4.49 0 01-3.397-1.549 4.49 4.49 0 01-3.498-1.306 4.491 4.491 0 01-1.307-3.498A4.49 4.49 0 012.25 12c0-1.357.6-2.573 1.549-3.397a4.49 4.49 0 011.307-3.497 4.49 4.49 0 013.497-1.307zm7.007 6.387a.75.75 0 10-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 00-1.06 1.06l2.25 2.25a.75.75 0 001.07-.01l3.5-4.875z"
                            clip-rule="evenodd"
                          />
                        </svg>
                        <span
                          class="absolute px-2 py-1 mb-2 text-xs text-white transition-opacity -translate-x-1/2 bg-gray-800 rounded-md opacity-0 pointer-events-none bottom-full left-1/2 w-max group-hover:opacity-100"
                        >
                          ผู้โดยสารยืนยันตัวตนแล้ว
                        </span>
                      </div>
                    </div>

                    <div class="flex">
                      <p
                        v-if="trip.passenger.email"
                        class="text-xs text-gray-500 mt-0.5"
                      >
                        อีเมล:
                        <a
                          :href="`mailto:${trip.passenger.email}`"
                          class="text-blue-600 hover:underline"
                          @click.stop
                        >
                          {{ trip.passenger.email }}
                        </a>
                      </p>
                      <button
                        v-if="trip.passenger.email"
                        class="inline-flex items-center ml-1 text-gray-500 rounded hover:text-gray-700 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        title="คัดลอกอีเมล"
                        aria-label="คัดลอกอีเมล"
                        @click.stop="copyEmail(trip.passenger.email)"
                      >
                        <svg
                          class="w-4 h-4"
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M8 7h8a2 2 0 012 2v8a2 2 0 01-2 2H8a2 2 0 01-2-2V9a2 2 0 012-2z"
                          />
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M16 7V5a2 2 0 00-2-2H8a2 2 0 00-2 2v2"
                          />
                        </svg>
                      </button>
                    </div>

                    <!--reviewpopup-->
                    <div class="flex items-center mt-1 cursor-pointer" @click.stop="openReviewModal(trip)">
                      <div class="flex text-sm text-yellow-400">
                        <span>
                          {{ "★".repeat(Math.round(trip.passenger.rating))
                          }}{{
                            "☆".repeat(5 - Math.round(trip.passenger.rating))
                          }}
                        </span>
                      </div>
                      <span class="ml-2 text-sm text-gray-600">
                        {{ trip.passenger.rating }} ({{
                          trip.passenger.reviews
                        }}
                        รีวิว)
                      </span>
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

                <!-- รายละเอียดเส้นทาง + จุดแวะ -->
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
                  <template v-if="trip.status === 'pending'">
                    <button
                      @click.stop="openConfirmModal(trip, 'confirm')"
                      class="px-4 py-2 text-sm text-white transition duration-200 bg-blue-600 rounded-md hover:bg-blue-700"
                    >
                      ยืนยันคำขอ
                    </button>
                    <button
                      @click.stop="openConfirmModal(trip, 'reject')"
                      class="px-4 py-2 text-sm text-red-600 transition duration-200 border border-red-300 rounded-md hover:bg-red-50"
                    >
                      ปฏิเสธ
                    </button>
                  </template>

                  <button
                    v-else-if="trip.status === 'confirmed'"
                    class="px-4 py-2 text-sm text-white transition duration-200 bg-blue-600 rounded-md hover:bg-blue-700"
                  >
                    แชทกับผู้โดยสาร
                  </button>

                  <button
                    v-else-if="['rejected', 'cancelled'].includes(trip.status)"
                    @click.stop="openConfirmModal(trip, 'delete')"
                    class="px-4 py-2 text-sm text-gray-600 transition duration-200 border border-gray-300 rounded-md hover:bg-gray-50"
                  >
                    ลบรายการ
                  </button>
                  <!--(Start) Contributer: Ratchapoom Thongdaeng เพิ่มส่วนของปุ่มสิ้นสุดการเดินทาง [16:34|14/2/2569]-->

                  <!--Contributer: Nattawadee Chaleechat Update 16 Feb 2026-->
                  <!--[Description] เพิ่มเงื่อนไขการแสดงผล หากไม่ได้กด สิ้นสุดการเดินทาง จะขึ้นปุ่มให้กด หากกดปุ่มแล้ว จะแสดงข้อความ การเดินทางเสร็จสิ้นแล้ว (รอให้อีกฝ่ายยืนยันการสิ้นสุดการเดินทาง)-->

                  <button
                    v-if="
                      trip.status === 'confirmed' &&
                      !trip.driver_confirm_arrived
                    "
                    @click.stop="openConfirmModal(trip, 'complete')"
                    class="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition duration-200 text-sm"
                  >
                    สิ้นสุดการเดินทาง
                  </button>

                  <div
                    v-else-if="
                      trip.status === 'confirmed' &&
                      trip.driver_confirm_arrived &&
                      !trip.passenger_confirm_arrived
                    "
                    class="px-4 py-2 text-sm text-yellow-600 font-medium"
                  >
                    รอ ผู้โดยสาร ยืนยันการสิ้นสุดการเดินทาง
                  </div>
                  <!--(Finish)-->
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- แผนที่ -->
        <div class="lg:col-span-1">
          <div
            class="sticky overflow-hidden bg-white border border-gray-300 rounded-lg shadow-md top-8"
          >
            <div class="p-3 border-gray-300">
              <h3 class="text-lg font-semibold text-gray-900">แผนที่เส้นทาง</h3>
              <p class="mt-1 text-sm text-gray-600">
                {{
                  selectedLabel ? selectedLabel : "คลิกที่รายการเพื่อดูเส้นทาง"
                }}
              </p>
            </div>
            <div ref="mapContainer" id="map"></div>
          </div>
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

          <!-- Passenger Profile -->
          <div class="p-6">
            <div class="flex flex-col items-center">
              <img 
                :src="driverInfo?.image || driverInfo?.profilePicture"
                :alt="driverInfo?.name || 'Passenger'"
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
                  {{ (driverInfo?.rating || 0).toFixed(1) }} 
                  ({{ driverInfo?.reviews || 0 }} รีวิว)
                </span>
              </div>
            </div>
          </div>

          <div class="flex items-center justify-between p-6 border-b border-gray-300">
            <h2 class="text-xl font-semibold text-gray-900">ความเห็นจากผู้โดยสาร</h2>
          </div>

          <div v-if="!review || review.length === 0" class="p-6 text-center text-gray-500">
            ยังไม่มีรีวิว
          </div>

          <!-- Reviews List -->
          <div v-else>
            <div v-for="item in review" :key="item.id" class="p-3 mx-3 border-b border-gray-300">
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
                    <!-- overlay -->
                    <div class="absolute inset-0 bg-black/30 group-hover:bg-black/50 transition"></div>
                    <!-- play icon -->
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
import { ref, computed, onMounted, watch } from "vue";
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
import ConfirmModal from "~/components/ConfirmModal.vue";
import { useToast } from "~/composables/useToast";

dayjs.locale("th");
dayjs.extend(buddhistEra);

const { $api } = useNuxtApp();
const { toast } = useToast();

// --- State Management ---
const activeTab = ref("pending");
const selectedTripId = ref(null);
const isLoading = ref(false);
const mapContainer = ref(null);
const allTrips = ref([]);
const myRoutes = ref([]);

// --- Review Modal State ---
const showreview = ref(false);
const review = ref([]);
const driverInfo = ref(null);
const fullscreenVideo = ref(null);

// ---------- Google Maps states ----------
let gmap = null;
let activePolyline = null;
let startMarker = null;
let endMarker = null;
let geocoder = null;
let placesService = null;
const mapReady = ref(false);
const GMAPS_CB = "__gmapsReady__";
// NEW: เก็บหมุดจุดแวะ
let stopMarkers = [];

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
  { status: "myRoutes", label: "เส้นทางของฉัน" },
];

definePageMeta({ middleware: "auth" });

// --- Helpers ---
function cleanAddr(a) {
  return (a || "")
    .replace(/,?\s*(Thailand|ไทย|ประเทศ)\s*$/i, "")
    .replace(/\s{2,}/g, " ")
    .trim();
}

const reasonLabelMap = {
  CHANGE_OF_PLAN: "เปลี่ยนแผน/มีธุระกะทันหัน",
  FOUND_ALTERNATIVE: "พบวิธีเดินทางอื่นแล้ว",
  DRIVER_DELAY: "คนขับล่าช้าหรือเลื่อนเวลา",
  PRICE_ISSUE: "ราคาหรือค่าใช้จ่ายไม่เหมาะสม",
  WRONG_LOCATION: "เลือกจุดรับ–ส่งผิด",
  DUPLICATE_OR_WRONG_DATE: "จองซ้ำหรือจองผิดวัน",
  SAFETY_CONCERN: "กังวลด้านความปลอดภัย",
  WEATHER_OR_FORCE_MAJEURE: "สภาพอากาศ/เหตุสุดวิสัย",
  COMMUNICATION_ISSUE: "สื่อสารไม่สะดวก/ติดต่อไม่ได้",
};
function reasonLabel(v) {
  return reasonLabelMap[v] || v;
}

// --- Computed ---
const filteredTrips = computed(() => {
  if (activeTab.value === "all") return allTrips.value;
  return allTrips.value.filter((trip) => trip.status === activeTab.value);
});

// สำหรับหัวข้อบนแผนที่
const selectedLabel = computed(() => {
  if (activeTab.value === "myRoutes") {
    const r = myRoutes.value.find((x) => x.id === selectedTripId.value);
    return r ? `${r.origin} → ${r.destination}` : null;
  }
  const t = allTrips.value.find((x) => x.id === selectedTripId.value);
  return t ? `${t.origin} → ${t.destination}` : null;
});

// --- Passenger Rating Cache and Functions ---
const passengerRatingCache = new Map();
//แปลงapi ให้เป็น UI แบบเดียวกัน
function normalizeRatingSummary(response) {
  let rating = null;
  let reviews = null;

  if (response?.passenger) {
    const r = Number(response.passenger.rating);
    const c = Number(response.passenger.reviews);
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
async function fetchPassengerRatingSummary(passengerId) {
  if (!passengerId) return null;
  if (passengerRatingCache.has(passengerId))
    return passengerRatingCache.get(passengerId);

  try {
    const response = await $api(`/review/${passengerId}/reviews`);
    const summary = normalizeRatingSummary(response);
    passengerRatingCache.set(passengerId, summary);
    return summary;
  } catch (error) {
    console.warn("Failed to load passenger rating:", passengerId, error);
    return null;
  }
}

// --- Methods ---
async function fetchMyRoutes() {
  isLoading.value = true;
  try {
    const routes = await $api("/routes/me");

    const passengerIds = Array.from(
      new Set(
        routes
          .flatMap((r) => (r.bookings || []).map((b) => b?.passenger?.id))
          .filter(Boolean),
      ),
    );
    const passengerSummaryById = new Map();
    await Promise.allSettled(
      passengerIds.map(async (passengerId) => {
        const summary = await fetchPassengerRatingSummary(passengerId);
        if (summary) passengerSummaryById.set(passengerId, summary);
      }),
    );

    const allowedRouteStatuses = new Set(["AVAILABLE", "FULL", "IN_TRANSIT"]);

    const formatted = [];
    const ownRoutes = [];

    for (const r of routes) {
      const carDetailsList = [];
      const routeStatus = String(r.status || "").toUpperCase();
      if (!allowedRouteStatuses.has(routeStatus)) continue;

      if (r.vehicle) {
        carDetailsList.push(
          `${r.vehicle.vehicleModel} (${r.vehicle.vehicleType})`,
        );
        if (
          Array.isArray(r.vehicle.amenities) &&
          r.vehicle.amenities.length > 0
        ) {
          carDetailsList.push(...r.vehicle.amenities);
        }
      } else {
        carDetailsList.push("ไม่มีข้อมูลรถ");
      }

      const start = r.startLocation;
      const end = r.endLocation;
      const coords = [
        [start.lat, start.lng],
        [end.lat, end.lng],
      ];

      // stops / stopsCoords จาก waypoints
      const wp = r.waypoints || {};
      const baseList =
        Array.isArray(wp.used) && wp.used.length
          ? wp.used
          : Array.isArray(wp.requested)
            ? wp.requested
            : [];
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
              ? `(${p.lat.toFixed(6)}, ${p.lng.toFixed(6)})`
              : "";
          const title = name || fallback;
          return address ? `${title} — ${address}` : title;
        })
        .filter(Boolean);

      const stopsCoords = orderedList
        .map((p) =>
          p && typeof p.lat === "number" && typeof p.lng === "number"
            ? {
                lat: p.lat,
                lng: p.lng,
                name: p.name || "",
                address: p.address || "",
              }
            : null,
        )
        .filter(Boolean);

      // แปลงเป็น "คำขอจอง" ต่อ booking
      for (const b of r.bookings || []) {
        const passengerSummary = passengerSummaryById.get(b?.passenger?.id);
        formatted.push({
          id: b.id,
          status: (b.status || "").toLowerCase(),

          // Contributer: Nattawadee Chaleechat
          // เพิ่มfield driver_confirm_arrived, passenger_confirm_arrived เมื่อทำการ fetchMyRoutes() ดึงข้อมูลจาก backend จะได้ค่ามาด้วย
          driver_confirm_arrived: b.driver_confirm_arrived,
          passenger_confirm_arrived: b.passenger_confirm_arrived,

          origin:
            start?.name ||
            `(${Number(start.lat).toFixed(2)}, ${Number(start.lng).toFixed(2)})`,
          destination:
            end?.name ||
            `(${Number(end.lat).toFixed(2)}, ${Number(end.lng).toFixed(2)})`,
          originHasName: !!start?.name,
          destinationHasName: !!end?.name,
          pickupPoint: b.pickupLocation?.name || "-",
          date: dayjs(r.departureTime).format("D MMMM BBBB"),
          time: dayjs(r.departureTime).format("HH:mm น."),
          price: (r.pricePerSeat || 0) * (b.numberOfSeats || 0),
          seats: b.numberOfSeats || 0,
          passenger: {
            id: b.passenger?.id,
            name:
              `${b.passenger?.firstName || ""} ${b.passenger?.lastName || ""}`.trim() ||
              "ผู้โดยสาร",
            image:
              b.passenger?.profilePicture ||
              `https://ui-avatars.com/api/?name=${encodeURIComponent(b.passenger?.firstName || "P")}&background=random&size=64`,
            email: b.passenger?.email || "",
            isVerified: !!b.passenger?.isVerified,
            rating: passengerSummary?.rating ?? 0,
            reviews: passengerSummary?.reviews ?? 0,
          },
          coords,
          polyline: r.routePolyline || null,
          stops,
          stopsCoords,
          cancelReason: b.cancelReason || null,
          carDetails: carDetailsList,
          conditions: r.conditions,
          photos: r.vehicle?.photos || [],
          originAddress: start?.address ? cleanAddr(start.address) : null,
          destinationAddress: end?.address ? cleanAddr(end.address) : null,
          durationText:
            (typeof r.duration === "string"
              ? formatDuration(r.duration)
              : r.duration) ||
            (r.durationSeconds
              ? `${Math.round(r.durationSeconds / 60)} นาที`
              : "-"),
          distanceText:
            (typeof r.distance === "string"
              ? formatDistance(r.distance)
              : r.distance) ||
            (r.distanceMeters
              ? `${(r.distanceMeters / 1000).toFixed(1)} กม.`
              : "-"),
        });
      }

      // เก็บ “เส้นทางของฉัน”
      const confirmedBookings = (r.bookings || []).filter(
        (b) => (b.status || "").toUpperCase() === "CONFIRMED",
      );
      ownRoutes.push({
        id: r.id,
        status: (r.status || "").toLowerCase(),
        origin:
          start?.name ||
          `(${Number(start.lat).toFixed(2)}, ${Number(start.lng).toFixed(2)})`,
        destination:
          end?.name ||
          `(${Number(end.lat).toFixed(2)}, ${Number(end.lng).toFixed(2)})`,
        originAddress: start?.address ? cleanAddr(start.address) : null,
        destinationAddress: end?.address ? cleanAddr(end.address) : null,
        date: dayjs(r.departureTime).format("D MMMM BBBB"),
        time: dayjs(r.departureTime).format("HH:mm น."),
        pricePerSeat: r.pricePerSeat || 0,
        availableSeats: r.availableSeats ?? 0,
        coords: [
          [start.lat, start.lng],
          [end.lat, end.lng],
        ],
        polyline: r.routePolyline || null,
        stops,
        stopsCoords,
        carDetails: r.vehicle
          ? [
              `${r.vehicle.vehicleModel} (${r.vehicle.vehicleType})`,
              ...(r.vehicle.amenities || []),
            ]
          : ["ไม่มีข้อมูลรถ"],
        photos: r.vehicle?.photos || [],
        conditions: r.conditions || "",
        //[Start] Contributer: Ratchapoom Thongdaeng 
        // [Description] เพิ่มข้อมูล routeExtraCharge จาก API response เพื่อแสดงใน UI
        routeExtraCharge: r.routeExtraCharge || [],
        //[Finish]
        passengers: confirmedBookings.map((b) => {
          const passengerSummary = passengerSummaryById.get(b?.passenger?.id);
          return {
            id: b.id,
            passengerId: b.passenger?.id,
            seats: b.numberOfSeats || 0,
            status: "confirmed",
            name:
              `${b.passenger?.firstName || ""} ${b.passenger?.lastName || ""}`.trim() ||
              "ผู้โดยสาร",
            image:
              b.passenger?.profilePicture ||
              `https://ui-avatars.com/api/?name=${encodeURIComponent(b.passenger?.firstName || "P")}&background=random&size=64`,
            email: b.passenger?.email || "",
            isVerified: !!b.passenger?.isVerified,
            rating: passengerSummary?.rating ?? 0,
            reviews: passengerSummary?.reviews ?? 0,
          };
        }),
        durationText:
          (typeof r.duration === "string"
            ? formatDuration(r.duration)
            : r.duration) ||
          (r.durationSeconds
            ? `${Math.round(r.durationSeconds / 60)} นาที`
            : "-"),
        distanceText:
          (typeof r.distance === "string"
            ? formatDistance(r.distance)
            : r.distance) ||
          (r.distanceMeters
            ? `${(r.distanceMeters / 1000).toFixed(1)} กม.`
            : "-"),
      });
    }

    allTrips.value = formatted;
    myRoutes.value = ownRoutes;

    // รอแผนที่พร้อม แล้ว reverse เฉพาะกรณีที่ backend ไม่มี name (เฉพาะ list คำขอจอง)
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
    console.error("Failed to fetch routes:", error);
    allTrips.value = [];
    myRoutes.value = [];
    toast.error(
      "เกิดข้อผิดพลาด",
      error?.data?.message || "ไม่สามารถโหลดข้อมูลได้",
    );
  } finally {
    isLoading.value = false;
  }
}

const getTripCount = (status) => {
  if (status === "all") return allTrips.value.length;
  if (status === "myRoutes") return myRoutes.value.length;
  return allTrips.value.filter((trip) => trip.status === status).length;
};

const toggleTripDetails = (id) => {
  // หา item ตามแท็บที่เปิดอยู่ เพื่ออัปเดตแผนที่
  const item =
    activeTab.value === "myRoutes"
      ? myRoutes.value.find((r) => r.id === id)
      : allTrips.value.find((t) => t.id === id);
  if (item) updateMap(item);

  selectedTripId.value = selectedTripId.value === id ? null : id;
};

// ---------- Google Maps helpers ----------
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
    const streetNumber = comps.find((c) =>
      c.types.includes("street_number"),
    )?.long_name;
    const route = comps.find((c) => c.types.includes("route"))?.long_name;
    name =
      streetNumber && route
        ? `${streetNumber} ${route}`
        : route || geocodeResult.formatted_address || null;
  }
  if (name) name = name.replace(/,?\s*(Thailand|ไทย)\s*$/i, "");
  return { name };
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

async function updateMap(trip) {
  if (!trip) return;
  await waitMapReady();
  if (!gmap) return;

  // cleanup เดิม
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

  startMarker = new google.maps.Marker({
    position: start,
    map: gmap,
    label: "A",
  });
  endMarker = new google.maps.Marker({ position: end, map: gmap, label: "B" });

  // หมุดจุดแวะ
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

  // polyline
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

// --- Modal ---
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
  if (action === "confirm") {
    modalContent.value = {
      title: "ยืนยันคำขอจอง",
      message: `ยืนยันคำขอของผู้โดยสาร "${trip.passenger.name}" ใช่หรือไม่?`,
      confirmText: "ยืนยันคำขอ",
      action: "confirm",
      variant: "primary",
    };
  } else if (action === "reject") {
    modalContent.value = {
      title: "ปฏิเสธคำขอจอง",
      message: `ต้องการปฏิเสธคำขอของ "${trip.passenger.name}" ใช่หรือไม่?`,
      confirmText: "ปฏิเสธ",
      action: "reject",
      variant: "danger",
    };
  } else if (action === "delete") {
    modalContent.value = {
      title: "ยืนยันการลบรายการ",
      message: `ต้องการลบคำขอนี้ออกจากรายการใช่หรือไม่?`,
      confirmText: "ลบรายการ",
      action: "delete",
      variant: "danger",
    };
    //(Start) เพิ่มกรณีสำหรับ 'complete' (สิ้นสุดการเดินทาง) [16:37|14/2/2569]
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
  const bookingId = tripToAction.value.id;
  try {
    if (action === "confirm") {
      await $api(`/bookings/${bookingId}/status`, {
        method: "PATCH",
        body: { status: "CONFIRMED" },
      });
      toast.success("สำเร็จ", "ยืนยันคำขอแล้ว");
    } else if (action === "reject") {
      await $api(`/bookings/${bookingId}/status`, {
        method: "PATCH",
        body: { status: "REJECTED" },
      });
      toast.success("สำเร็จ", "ปฏิเสธคำขอแล้ว");
      //(Start) เพิ่ม action ของ 'complete' (สิ้นสุดการเดินทาง) [16:38|14/2/2569]
      // Nattawadee แก้ไขเพิ่มเติม
    } else if (action === "complete") {
      await $api(`/bookings/${bookingId}/arrive-driver`, {
        method: "PATCH",
        body: { status: "COMPLETED" },
      });
      await fetchMyRoutes();
      toast.success("สิ้นสุดการเดินทางสำเร็จ", 'ขอบคุณที่ใช้บริการ "ไปนำแหน่"');
      //(Finish)
    } else if (action === "delete") {
      await $api(`/bookings/${bookingId}`, { method: "DELETE" });
      toast.success("ลบรายการสำเร็จ", "ลบคำขอออกจากรายการแล้ว");
    }
    closeConfirmModal();
    await fetchMyRoutes();
  } catch (error) {
    console.error(`Failed to ${action} booking:`, error);
    toast.error(
      "เกิดข้อผิดพลาด",
      error?.data?.message || "ไม่สามารถดำเนินการได้",
    );
    closeConfirmModal();
  }
};

const copyEmail = async (email) => {
  try {
    await navigator.clipboard.writeText(email);
    toast.success("คัดลอกแล้ว", email);
  } catch (e) {
    toast.error("คัดลอกไม่สำเร็จ", "ลองใหม่อีกครั้ง");
  }
};

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
    else meters += n;
  }

  if (meters >= 1000) {
    const km = Math.round((meters / 1000) * 10) / 10;
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
    else minutes += n;
  }

  const h = Math.floor(minutes / 60);
  const m = Math.round(minutes % 60);
  return h ? (m ? `${h} ชม. ${m} นาที` : `${h} ชม.`) : `${m} นาที`;
}

// --- Lifecycle ---
useHead({
  title: "คำขอจองเส้นทางของฉัน - ไปนำแหน่",
  script:
    process.client && !window.google?.maps
      ? [
          {
            key: "gmaps",
            src: `https://maps.googleapis.com/maps/api/js?key=${useRuntimeConfig().public.googleMapsApiKey}&libraries=places,geometry&callback=${GMAPS_CB}`,
            async: true,
            defer: true,
          },
        ]
      : [],
});

onMounted(() => {
  if (window.google?.maps) {
    initializeMap();
    fetchMyRoutes().then(() => {
      if (activeTab.value === "myRoutes") {
        if (myRoutes.value.length) updateMap(myRoutes.value[0]);
      } else {
        if (filteredTrips.value.length) updateMap(filteredTrips.value[0]);
      }
    });
    return;
  }

  window[GMAPS_CB] = () => {
    try {
      delete window[GMAPS_CB];
    } catch {}
    initializeMap();
    fetchMyRoutes().then(() => {
      if (activeTab.value === "myRoutes") {
        if (myRoutes.value.length) updateMap(myRoutes.value[0]);
      } else {
        if (filteredTrips.value.length) updateMap(filteredTrips.value[0]);
      }
    });
  };
});

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

watch(activeTab, () => {
  selectedTripId.value = null;
  if (activeTab.value === "myRoutes") {
    if (myRoutes.value.length > 0) updateMap(myRoutes.value[0]);
  } else {
    if (filteredTrips.value.length > 0) updateMap(filteredTrips.value[0]);
  }
});

// Review Modal Functions
async function openVideo(url) {
  fullscreenVideo.value = url;
}

function closeVideo() {
  fullscreenVideo.value = null;
}

async function openReviewModal(trip) {
  showreview.value = true;
  driverInfo.value = trip.passenger;
  review.value = [];

  try {
    if (!trip?.passenger?.id) {
      console.error('Passenger ID is missing');
      return;
    }

    const response = await $api(`/review/${trip.passenger.id}/reviews`);

    if (response?.reviews) {
      review.value = response.reviews;
    } else if (Array.isArray(response)) {
      review.value = response;
    } else {
      review.value = [];
    }

    if (response) {
      driverInfo.value = {
        ...driverInfo.value,
        name: response.name || trip.passenger?.name,
        profilePicture: response.profilePicture || trip.passenger?.image,
        image: response.profilePicture || trip.passenger?.image,
        isVerified: response.isVerified ?? trip.passenger?.isVerified,
        rating: response.driver?.rating ?? trip.passenger?.rating,
        reviews: response.driver?.reviews ?? trip.passenger?.reviews
      };
    }
    
    console.log('Reviews loaded:', review.value.length);
  } catch (error) {
    console.error('Failed to load reviews:', error);
    review.value = [];
  }
}

</script>

<style scoped>
/* (สไตล์ทั้งหมดคงเดิม) */
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

/*(Start) เพิ่มสีให้ปุ่ม "สิ้นสุดการเดินทาง" [16:40|14/2/2569]*/
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