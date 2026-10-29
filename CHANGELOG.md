# Changelog

كل التغييرات الجوهرية تُوثّق هنا، وفق [Keep a Changelog](https://keepachangelog.com/) وإصدارات دلالية.

## [Unreleased]

### Added
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
