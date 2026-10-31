<p align="center">
  <img src=".github/assets/banner.svg" alt="NexHub — مساحة عمل المطوّر العربية" width="100%">
</p>

# NexHub — مساحة عمل المطوّر العربية

> **كل أدوات التطوير اليومية في تطبيق واحد يعمل بلا إنترنت**: مستودعاتك، كودك، بحثك العربي، ووكيل AI — على جهازك، بلا حساب، بلا سحابة، بلا انتظار.

## ما هو NexHub؟ (تعريف المنتج)

**NexHub = مساحة عمل تطوير محلية عربية**: عميل Git كامل + لوحة مستودعات + أدوات المطوّر اليومية، في تطبيق واحد يعمل **بلا حساب ولا سحابة ولا إنترنت**.

- **لمن**: المطوّر العربي والفرق الصغيرة الذين يريدون واجهة عربية RTL أصلية لإدارة مستودعاتهم — أو يعملون في بيئات مقيدة الشبكة، والمبتدئ الذي تخيفه واجهات Git الإنجليزية.
- **ما ليس**: ليس استضافة سحابية ولا بديلاً عن خوادم GitHub — بل **طبقة واجهة عربية فوق Git على جهازك**؛ الكود لا يترك الجهاز أبداً. حيادها عن السحابة ميزة لا نقص.
- **التمايز**: العربية أولاً (RTL أصلي لا ترجمة لاحقة) + الخصوصية المطلقة (بلا حساب، بلا تتبع) + «افتح المجلد وابدأ» بلا تسجيل.
- **الحالة بصراحة**: analyze صفر و38 اختباراً وCI أخضر مع نشر موقع التوثيق على Pages. القادم معلن في [خارطة المنتَجة](https://github.com/tibatechapp-ship-it/vixona-github-profile/blob/main/docs/productization-plan.md): جولة onboarding سرد ذاتي + دليل سريع مصوّر + إصدار v0.4.

<p align="center">
  <a href="https://github.com/tibatechapp-ship-it/nexhub/actions/workflows/ci.yml"><img src="https://github.com/tibatechapp-ship-it/nexhub/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/tibatechapp-ship-it/nexhub/actions/workflows/build.yml"><img src="https://github.com/tibatechapp-ship-it/nexhub/actions/workflows/build.yml/badge.svg" alt="Build"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
  <a href="https://github.com/tibatechapp-ship-it/nexhub/releases"><img src="https://img.shields.io/github/v/release/tibatechapp-ship-it/nexhub" alt="Release"></a>
  <img src="https://img.shields.io/badge/Flutter-%E2%89%A53.24-02569B?logo=flutter&logoColor=white" alt="Flutter ≥3.24">
  <img src="https://img.shields.io/badge/Offline-100%25-success" alt="Offline 100%">
</p>

---

## ✅ يعمل اليوم — بالدليل (2026-10-31)

| القدرة | الدليل القابل للتحقق |
|---|---|
| جودة محكمة | `flutter analyze` = **صفر ملاحظات** (بوابة CI) + **38/38 اختبار** خضراء |
| CI مزدوج | [CI](https://github.com/tibatechapp-ship-it/nexhub/actions/workflows/ci.yml) + [Build](https://github.com/tibatechapp-ship-it/nexhub/actions/workflows/build.yml) أخضران على main |
| موقع منشور | دليل بيئة المطور على [GitHub Pages](https://tibatechapp-ship-it.github.io/nexhub/) — ينشر تلقائياً من `site/` |
| إصدارات | إصدارات مُوسومة في [Releases](https://github.com/tibatechapp-ship-it/nexhub/releases) — منها v1.0.0 |
| أربع منصات | Android · iOS · Windows · Linux — كودبيس واحد |

## ✨ المميزات

- **صفر تسجيل** — افتح مجلداً → ابدأ. Offline 100%: كل شيء محلي.
- **عربي أولاً** — RTL أصلي، خط Cairo، بحث عربي بتطبيع (الألف/الياء/التاء)، ومبدّل لغة (عربي/إنجليزي/النظام) محفوظ في التفضيلات.
- **أقل من 200ms فتح** — لا انتظار، لا spinners.
- **متصفح ومحرر كود** — syntax highlight + Markdown + تعديل وحفظ (Ctrl+S).
- **بحث فوري** في الأسماء والمحتوى بالعربية.
- **وكيل Nexus Agent** — 10 أدوات function calling داخل التطبيق:

| الأداة | الوظيفة |
|---|---|
| `get_recent_commits` | جلب آخر Commits |
| `get_commit_diff` | قراءة Diff لِـ Commit |
| `read_file` / `list_files` | قراءة ملف / سرد الملفات |
| `search_code` | البحث في الكود |
| `apply_patch` | تطبيق تعديل |
| `create_branch` | إنشاء فرع |
| `save_to_memory` / `recall_memory` | ذاكرة طويلة المدى لتفضيلاتك |
| `create_issue` | إنشاء Issue على GitHub من الدردشة |

- **Nexus Chat** — دردشة AI ببث حي وMarkdown، و**Diff Explain** يشرح تغييرات أي Commit.
- **ميزات لكل مستودع** — تفعيل/تعطيل حسب حاجتك.
- **Terminal مدمج** + CI + إشعارات + فريق + hooks.
- **مُفسّر تعارضات دمج** يُفتح تلقائياً عند فشل الدمج.
- **وصولية** — tooltips لكل الأزرار، تأكيدات إتلاف، وضع ليلي ثلاثي (فاتح/داكن/النظام).

## 🌐 الموقع ودليل بيئة المطور

`site/` يحوي دليل **إعداد بيئة المطور المحلية** (React + Vite + Tailwind 4، عربي RTL):
Ollama للنماذج المحلية + MCP لربط الأدوات + Semgrep للفحص الأمني — مدمج من مستودع
`olmo` بتاريخه الكامل عبر git subtree.

```bash
cd site && npm ci && npm run dev   # http://localhost:3000
```

يُنشر تلقائياً إلى GitHub Pages من `.github/workflows/site.yml`:
<https://tibatechapp-ship-it.github.io/nexhub/>

## 🚀 البدء

المتطلبات: Flutter ≥ 3.24 و`git` مثبت.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run -d windows    # أو linux / android / ios
```

> بعد أي تعديل على ملفات ARB أعِد `flutter gen-l10n` قبل التشغيل
> (ملف التوليد مُتجاهل في .gitignore ولا يُرفع).

## 🧪 التطوير والاختبار

```bash
flutter analyze           # صفر ملاحظات — بوابة الـCI
flutter test              # 38 اختباراً (git_service، nexus_tools، ...)
```

## 🔒 الخصوصية

لا يجمع NexHub أي بيانات. مستودعاتك تبقى على جهازك — هذا ليس «وضع خصوصية» بل البنية نفسها.

## 🗺️ القادم

من [خارطة المنتَجة](https://github.com/tibatechapp-ship-it/vixona-github-profile/blob/main/docs/productization-plan.md):
1. **جولة onboarding** أول تشغيل: 5 خطوات من «أنشئ مستودعاً» إلى «أول commit» — مُختبَرة widget-wise
2. **دليل سريع مصوّر** عربي (`docs/quickstart-ar.md`)
3. **إصدار v0.4** بالتحسينات أعلاه

## 🤝 المساهمة

نرحب بمساهماتك! اقرأ [CONTRIBUTING.md](CONTRIBUTING.md) (بيئة التطوير، بوابات الجودة، سير العمل)، و[SECURITY.md](SECURITY.md) للإبلاغ الأمني. الـIssues والـPRs لهما قوالب جاهزة.

## 📄 الترخيص

MIT — وخط [Cairo](https://openfontlicense.org) المضمّن في `assets/fonts/` بموجب SIL OFL 1.1 (النص الكامل: [`assets/fonts/OFL.txt`](assets/fonts/OFL.txt)).

## 🧭 المكان في المحفظة

NexHub درجة رابعة في [محفظة TibaTech](https://github.com/tibatechapp-ship-it/vixona-github-profile) — [بطاقة الأداء](https://github.com/tibatechapp-ship-it/vixona-github-profile/blob/main/docs/scorecard.md) · [خارطة المنتَجة](https://github.com/tibatechapp-ship-it/vixona-github-profile/blob/main/docs/productization-plan.md). سجل التغييرات: [CHANGELOG.md](CHANGELOG.md).
