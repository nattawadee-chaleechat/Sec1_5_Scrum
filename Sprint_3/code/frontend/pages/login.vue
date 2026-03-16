<template>
  <div class="min-h-[80vh] flex items-center justify-center p-4">
    <main
      class="bg-white rounded-lg shadow-lg max-w-md w-full p-8 border border-gray-300"
    >
      <h1 class="text-3xl font-bold text-blue-600 mb-6 text-center">
        เข้าสู่ระบบ
      </h1>
      <form @submit.prevent="submit" id="loginForm">
        <!-- username / Email -->
        <div class="mb-4">
          <label
            for="identifier"
            class="block text-sm font-medium text-gray-700 mb-1"
            >ชื่อผู้ใช้ หรือ อีเมล<span class="text-red-500">*</span></label
          >
          <input
            type="text"
            id="identifier"
            v-model="identifier"
            required
            placeholder="กรอกชื่อผู้ใช้หรืออีเมล"
            class="w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>

        <!-- รหัสผ่าน -->
        <div class="mb-6">
          <label
            for="password"
            class="block text-sm font-medium text-gray-700 mb-1"
            >รหัสผ่าน <span class="text-red-500">*</span></label
          >
          <input
            type="password"
            id="password"
            v-model="password"
            required
            minlength="6"
            placeholder="กรอกรหัสผ่าน"
            class="w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>

        <!-- ปุ่มเข้าสู่ระบบ -->
        <button
          type="submit"
          class="w-full py-3 bg-blue-600 text-white rounded-md font-medium hover:bg-blue-700 transition duration-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
        >
          เข้าสู่ระบบ
        </button>
        <!-- <div v-if="errorMessage" style="color: red">{{ errorMessage }}</div> -->

        <!-- Contributer: Nattawadee Chaleechat [Description] เพิ่มการแจ้งเตือนกรอกรหัสผิด -->
        <div
          v-if="errorMessage"
          class="mt-3 p-3 rounded-md"
          :class="
            failedAttempts > 0
              ? 'bg-orange-50 border border-orange-400'
              : 'bg-red-50 border border-red-400'
          "
        >
          <p
            class="text-sm font-medium"
            :class="failedAttempts > 0 ? 'text-orange-700' : 'text-red-600'"
          >
            {{ errorMessage }}
          </p>
          <p v-if="failedAttempts > 0" class="text-orange-600 text-xs mt-1">
            ⚠️ หากกรอกผิดครบ 3 ครั้ง บัญชีของคุณจะถูกระงับและต้องติดต่อแอดมิน
          </p>
        </div>
      </form>

      <!-- Contributer: Nattawadee Chaleechat [Description] เพิ่มการแจ้งเตือนว่ารหัสไม่ปลอดภัย เพื่อให้เป็นไปตาม NCSC UK's guidelines -->
      <!-- Ai declare : ให้ claude.ai ช่วยไกด์การเขียนโค้ด -->
      <div
        v-if="showPasswordWarning"
        class="mt-4 p-4 bg-yellow-50 border border-yellow-400 rounded-md"
      >
        <p class="text-yellow-800 text-sm font-medium mb-2">
          ⚠️ รหัสผ่านของคุณไม่ปลอดภัยเพียงพอ
        </p>
        <p class="text-yellow-700 text-sm mb-3">
          กรุณาเปลี่ยนรหัสผ่านให้ประกอบด้วยคำอย่างน้อย 3 คำ เช่น
          <span class="font-mono font-bold">apple-mango-banana</span>
        </p>
        <div class="flex gap-2">
          <button
            @click="goToChangePassword"
            class="flex-1 py-2 bg-yellow-500 text-white rounded-md text-sm font-medium hover:bg-yellow-600 transition duration-200"
          >
            เปลี่ยนรหัสผ่านตอนนี้
          </button>
          <button
            @click="dismissWarning"
            class="flex-1 py-2 bg-gray-200 text-gray-700 rounded-md text-sm font-medium hover:bg-gray-300 transition duration-200"
          >
            ข้ามไปก่อน
          </button>
        </div>
      </div>

      <!-- Contributer: Nattawadee Chaleechat [Description] เพิ่ม Popup account blocked หากใส่รหัสผิดเกิน 3 ครั้ง -->
      <!-- Ai declare : ให้ claude.ai ช่วยไกด์การเขียนโค้ด -->
      <!-- Popup account blocked -->
      <div
        v-if="showBlockedPopup"
        class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
      >
        <div class="bg-white rounded-lg p-6 max-w-sm w-full mx-4 shadow-xl">
          <div class="text-center mb-4">
            <p class="text-4xl mb-2">🔒</p>
            <h2 class="text-xl font-bold text-red-600">บัญชีถูกระงับ</h2>
          </div>
          <p class="text-gray-700 text-sm text-center mb-4">
            บัญชีของคุณถูกระงับชั่วคราว เนื่องจากกรอกผิดเกิน 3 ครั้ง
            กรุณาติดต่อแอดมินเพื่อปลดล็อคบัญชี Email : admin@painamnae.com
          </p>
          <div class="flex gap-2">
            <button
              @click="contactAdmin"
              class="flex-1 py-2 bg-blue-600 text-white rounded-md text-sm font-medium hover:bg-blue-700"
            >
              ติดต่อแอดมิน
            </button>
            <button
              @click="showBlockedPopup = false"
              class="flex-1 py-2 bg-gray-200 text-gray-700 rounded-md text-sm font-medium hover:bg-gray-300"
            >
              ปิด
            </button>
          </div>
        </div>
      </div>

      <!-- ลิงก์สมัครสมาชิก -->
      <p class="mt-6 text-center text-gray-600 text-sm">
        ยังไม่มีบัญชี?
        <a href="/register" class="text-blue-600 hover:underline"
          >สมัครสมาชิก</a
        >
      </p>
    </main>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { useAuth } from "~/composables/useAuth";

const identifier = ref("");
const password = ref("");
const errorMessage = ref("");
const router = useRouter();
const { login } = useAuth();

// Contributer: Nattawadee Chaleechat
const showPasswordWarning = ref(false);
const showBlockedPopup = ref(false);
const failedAttempts = ref(0);
const MAX_ATTEMPTS = 3;

const submit = async () => {
  errorMessage.value = "";

  // Contributer: Nattawadee Chaleechat [Description] เพิ่มการแจ้งเตือนว่ารหัสไม่ปลอดภัย เพื่อให้เป็นไปตาม NCSC UK's guidelines
  // Ai declare : ให้ claude.ai ช่วยไกด์การเขียนโค้ด

  showPasswordWarning.value = false;
  showBlockedPopup.value = false;

  try {
    const res = await login(identifier.value, password.value);
    console.log("res:", JSON.stringify(res));

    failedAttempts.value = 0;
    if (res?.requirePasswordChange) {
      showPasswordWarning.value = true; // แสดง banner ไม่ redirect ทันที
    } else {
      router.push("/");
    }
  } catch (e) {
    console.error(e);
    //errorMessage.value = e?.data?.message || "เข้าสู่ระบบไม่สำเร็จ";

    console.log("statusCode:", e?.statusCode);
    console.log("status:", e?.status);

    //Contributer: Nattawadee Chaleechat [Description] ถ้า account ถูก block แสดง popup แทน error ปกติ
    // Ai declare : ให้ claude.ai ช่วยไกด์การเขียนโค้ด

    // เช็ค statusCode จาก backend
    if (e?.statusCode === 403) {
      // account ถูก lock แล้ว
      showBlockedPopup.value = true;
      failedAttempts.value = 0;
      return;
    }

    // รหัสผิดปกติ นับ frontend attempts
    failedAttempts.value++;
    const remaining = MAX_ATTEMPTS - failedAttempts.value;

    if (remaining <= 0) {
      showBlockedPopup.value = true;
      failedAttempts.value = 0;
    } else {
      errorMessage.value = `เข้าสู่ระบบไม่สำเร็จ (สามารถกรอกได้อีก ${remaining} ครั้ง)`;
    }
  }
};

const goToChangePassword = () => {
  router.push("/profile");
};

const dismissWarning = () => {
  router.push("/");
};

const contactAdmin = () => {
  window.open("mailto: admin@painamnae.com", "_blank");
};
</script>

<style scoped></style>
