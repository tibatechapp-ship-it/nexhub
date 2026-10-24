# NexHub

منصة Git محلية عربية للمطورين — بديل لـ GitHub/GitLab/Gitea
يعمل على جهازك، بدون حساب، بدون سحابة، RTL أصلي.

## المميزات (P0+P1)

- صفر تسجيل — افتح مجلداً → ابدأ
- Offline 100% — كل شيء محلي
- عربي أولاً — RTL + خط Cairo + بحث عربي (تطبيع الألف/الياء/التاء)
- < 200ms فتح — لا انتظار
- 5 شاشات — بساطة راديكالية
- متصفح كود + syntax highlight + Markdown
- بحث فوري في الأسماء والمحتوى ( عربي )

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
