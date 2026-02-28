import tailwindcssVite from "@tailwindcss/vite";

export default defineNuxtConfig({
  compatibilityDate: "2025-05-15",
  devtools: { enabled: true },
  
  // แก้ไข 1: ปิดระบบ Manifest เพื่อแก้ Error ตอนรัน
  experimental: {
    appManifest: false
  },

  runtimeConfig: {
    public: {
      // แก้ไข 2: ชี้เป้าไปที่เครื่องตัวเอง (Backend Port 3000)
      apiBase: "http://localhost:3000/api",
      googleMapsApiKey: process.env.NUXT_PUBLIC_GOOGLE_MAPS_API_KEY || "",
    },
  },
  devServer: {
    port: 3001,
  },
  plugins: ["~/plugins/api.client.js"],
  app: {
    head: {
      title: "ไปนำแหน่",
      meta: [{ name: "description", content: "รายละเอียด" }],
      charset: "utf-8",
      viewport: "width=device-width, initial-scale=1, maximum-scale=1",
      link: [
        {
          rel: "stylesheet",
          href: "https://fonts.googleapis.com/css2?family=Kanit:wght@300;400;500;600;700&display=swap",
        },
      ],
    },
  },
  vite: {
    plugins: [tailwindcssVite()],
  },
  css: ["leaflet/dist/leaflet.css", "~/assets/css/input.css"],
  build: {
    transpile: ["leaflet"],
  },
});