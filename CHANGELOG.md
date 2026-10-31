# Changelog

كل التغييرات الجوهرية تُوثّق هنا، وفق [Keep a Changelog](https://keepachangelog.com/) وإصدارات دلالية.

## [Unreleased]

## [1.1.0] — 2026-10-31

> أسبوع 2 من [خارطة المنتَجة](https://github.com/tibatechapp-ship-it/vixona-github-profile/blob/main/docs/productization-plan.md) — «الهوية والسرد» مكتملة.
> ملاحظة: خطت الخطة إصدار v0.4، لكن v1.0.0 صدرت قبلها؛ الرقم التالي بالترتيب الدلالي الصحيح هو 1.1.0 — المحتوى نفسه: التحسينان معاً.

### Added
- **جولة onboarding أول تشغيل** (5 خطوات، `/onboarding`): توجيه الزائر الأول تلقائياً، إتمام/تخطي محفوظان ولا تعود الجولة — 7 اختبارات widget حتمية (38→45)، analyze صفر
- **`docs/quickstart-ar.md` — البدء السريع المصوّر**: الطريق الذهبي من التثبيت إلى أول commit، بمخطط SVG عربي (`docs/assets/quickstart-golden-path.svg`)، خطوات مطابقة لجولة التشغيل الفعلية
- **حرس الوثائق في CI** (`docs` job): `tool/check_docs.py` يفشل إن اختفى الدليل أو انكسرت صوره/روابطه النسبية — «رابط تحقق الحياة» من الخطة
- **وظيفة `release` في Build workflow**: كل tag `v*` يرفق حزمه تلقائياً على GitHub Release (APK split-per-abi + حزم سطح المكتب مضغوطة) — إرفاق الإصدار لم يعد يدوياً

### Changed
- README: تحديث الحالة والأدلة (45 اختباراً، onboarding + quickstart منجزان بإثبات)

## [1.0.0] — 2026-10-31

> **الإصدار الأول المستقر** — بيئة مطوّر عربية RTL كاملة: Nexus Agent بسبع أدوات، محرر كود، Terminal مدمج، دمج بذكاء تعارضات، وضع ليلي ولغة عربية أولى.

### Added
- **`site/` — دليل بيئة المطور المحلية**: موقع React + Vite + Tailwind 4 (عربي RTL) يشرح إعداد Ollama + MCP + Semgrep، مدمج من مستودع `olmo` (فرع `enhanced-local-development-environment-f5e83`) عبر git subtree بتاريخه الكامل — منشور على GitHub Pages
- **workflow `Site`**: بناء + typecheck للموقع على كل تغيير في `site/`، ونشر تلقائي إلى GitHub Pages من `main`
- مبدّل أزرار SegmentedButton للثيم + اختبارات الثيم (38) + خط Cairo برخصة OFL
- **الوضع الليلي (Dark Mode)**: مبدّل مظهر في الإعدادات بثلاثة أوضاع (فاتح / داكن / حسب النظام) — الاختيار محفوظ في SharedPreferences (مفتاح `nexhub_theme_mode`) ويُقرأ عند الإقلاع، عبر `appThemeModeProvider` الجديد في `core/theme/theme_provider.dart` وفق نمط مبدّل اللغة القائم
- **مبدّل لغة (ar/en/system)** في الإعدادات — فك قفل `Locale('ar')` مع حفظ التفضيل في SharedPreferences
- مُفسّر تعارضات الدمج يُفتح تلقائياً عند فشل الدمج (كان بلا مستدعي — ميت الكود)
- تأكيدات إتلاف (حذف مستودع/يومية/مقتطف، إجهاض دمج) وحماية رسالة commit بالكتابة عليها
- Ctrl+S / Cmd+S للحفظ في المحرر + tooltips لكل أزرار الأيقونات (صفر زر صامت)

### Changed
- فائض AppBar تحت 900px ← 3 إجراءات متكررة + قائمة موسومة تُحيي Terminal وSyncSheet وRepoFeatures
- ألوان الحالة الصلبة ← أدوار colorScheme (تتبع الثيم الفاتح/الداكن)

## [0.3.0] — آخر إصدار مُعنون

- Nexus Agent (7 أدوات function calling) + Nexus Chat + ذاكرة طويلة المدى
- متصفح كود، بحث عربي مُطبّع، Terminal مدمج
