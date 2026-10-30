# site/ — موقع دليل بيئة المطور المحلية

موقع تعريفي/تعليمي (React + Vite + Tailwind CSS 4) عربي RTL يشرح إعداد بيئة
تطوير محلية ذكية: **Ollama** (نماذج محلية) + **MCP** (ربط الأدوات) +
**Semgrep** (فحص أمني تلقائي). مدمج هنا من مستودع `olmo` (فرع
`enhanced-local-development-environment-f5e83`) عبر git subtree، بتاريخه الكامل.

## التشغيل

```bash
cd site
npm ci
npm run dev        # http://localhost:3000
npm run typecheck  # tsc --noEmit
npm run build      # → site/dist
npm run preview    # معاينة البناء
```

## النشر

`.github/workflows/site.yml` يبني الموقع عند أي تغيير داخل `site/` ويرفع `dist`
إلى GitHub Pages (المصدر: GitHub Actions) عند الدفع إلى `main`:

<https://tibatechapp-ship-it.github.io/nexhub/>

`vite.config.js` يستخدم `base: "./"` (مسارات نسبية) لذلك يعمل البناء تحت أي
مسار فرعي بلا تعديل.

## البنية

```
site/
├── index.html                 # القالب (RTL، بلا أي CDN خارجي)
├── src/
│   ├── App.tsx                # تركيب الأقسام + تتبّع القسم النشط عند التمرير
│   ├── main.tsx
│   ├── index.css              # Tailwind 4 (@import "tailwindcss" + @theme)
│   ├── hooks/useScrollAnimation.ts
│   └── components/
│       ├── layout/            # Navigation, Footer
│       ├── sections/          # Hero, HowItWorks, Features, Setup, Comparison, Roadmap, FAQ
│       ├── shared/            # SectionHeader
│       └── ui/                # FadeIn, CodeBlock, ReadingProgress, ScrollToTop
├── tsconfig.json
└── vite.config.js
```

## ملاحظات الدمج

- الحزم غير المستخدمة من المستودع الأصلي (@dnd-kit, supabase, recharts, framer-motion,
  uuid, react-router-dom, canvas-confetti, date-fns) أُزيلت — المشروع يستورد `react`
  و`react-dom` فقط.
- مكوّنات مكرّرة/ميتة (نسخ `components/*Section.tsx` القديمة) حُذفت؛ `FAQSection` و
  `Footer` نُقلا إلى مكانهما الصحيح (`sections/FAQ.tsx`, `layout/Footer.tsx`) بعد أن
  كانت `App.tsx` تستوردهما من مسارات غير موجودة (كان البناء يفشل).
- سكربتات iframe/تتبّع الأخطاء الخاصة ببيئة sandbox الأصلية أُزيلت من `index.html`.
