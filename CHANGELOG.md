# Changelog

كل التغييرات الجوهرية تُوثّق هنا، وفق [Keep a Changelog](https://keepachangelog.com/) وإصدارات دلالية.

## [Unreleased]

### Added
- **`site/` — دليل بيئة المطور المحلية**: موقع React + Vite + Tailwind 4 (عربي RTL) يشرح إعداد Ollama + MCP + Semgrep، مدمج من مستودع `olmo` (فرع `enhanced-local-development-environment-f5e83`) عبر git subtree بتاريخه الكامل
- **workflow `Site`**: بناء + typecheck للموقع على كل تغيير في `site/`، ونشر تلقائي إلى GitHub Pages من `main`
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
