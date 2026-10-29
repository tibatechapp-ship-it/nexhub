# NexHub

منصة Git محلية عربية للمطورين — بديل لـ GitHub/GitLab/Gitea
يعمل على جهازك، بدون حساب، بدون سحابة، RTL أصلي.

## المميزات (P0+P1+P2+P3+P4+P5+P6)

- صفر تسجيل — افتح مجلداً → ابدأ
- Offline 100% — كل شيء محلي
- عربي أولاً — RTL + خط Cairo + بحث عربي (تطبيع الألف/الياء/التاء)
- < 200ms فتح — لا انتظار
- متصفح كود + syntax highlight + Markdown
- بحث فوري في الأسماء والمحتوى ( عربي )
- Nexus Agent — وكيل AI ذكي مع function calling (7 أدوات)
- Nexus Chat — دردشة AI مع streaming و Markdown
- Nexus Memory — ذاكرة طويلة المدى (تفضيلات المستخدم)
- Diff Explain — شرح التغييرات في Commit
- Create Issue — إنشاء Issues على GitHub من داخل الدردشة
- محرر كود (edit+save) + syntax highlight
- صحة المستودع + إحصائيات + دروس
- ميزات لكل مستودع (features per repo) — تفعيل/تعطيل
- Terminal مدمج + CI + إشعارات + فريق + hooks

## Nexus Agent

وكيل AI ذكي يعمل داخل التطبيق مع 7 أدوات:
- `get_recent_commits` — جلب آخر Commits
- `get_commit_diff` — قراءة Diff لـ Commit
- `read_file` — قراءة ملف
- `list_files` — سرد الملفات
- `search_code` — البحث في الكود
- `apply_patch` — تطبيق تعديل
- `create_branch` — إنشاء فرع
- `save_to_memory` — حفظ تفضيل في الذاكرة
- `recall_memory` — استرجاع من الذاكرة
- `create_issue` — إنشاء Issue على GitHub

## المنصات

Android · iOS · Windows · Linux — كودبيس واحد (Flutter).

## المتطلبات

- Flutter ≥ 3.24
- `git` مثبت على الجهاز

## التشغيل

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run -d windows    # أو linux / android / ios
```

## الخصوصية

لا يجمع NexHub أي بيانات. مستودعاتك تبقى على جهازك.

## الترخيص

MIT
