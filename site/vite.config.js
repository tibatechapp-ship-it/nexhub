import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  // مسارات نسبية حتى يعمل البناء تحت أي مجلد (GitHub Pages: /nexhub/)
  base: "./",
  plugins: [react(), tailwindcss()],
  server: {
    host: "0.0.0.0",
    port: 3000,
    strictPort: true,
    hmr: {
      port: 3000,
    },
  },
  preview: {
    port: 3000,
  },
});
