import { useScrollAnimation } from '../hooks/useScrollAnimation';

export default function StepsSection() {
  const { ref, isVisible } = useScrollAnimation(0.1);

  return (
    <section id="steps" className="py-24 px-4 relative">
      {/* Background accent */}
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-purple-950/20 to-transparent"></div>
      
      <div ref={ref} className={`relative max-w-6xl mx-auto transition-all duration-1000 ${isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
        {/* Section header */}
        <div className="text-center mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-green-500/10 border border-green-500/20 text-green-300 text-sm mb-4">
            <span>04</span>
            <span>•</span>
            <span>خطوات التشغيل</span>
          </div>
          <h2 className="text-4xl md:text-5xl font-bold mb-4">
            <span className="bg-gradient-to-l from-white to-slate-300 bg-clip-text text-transparent">
              ابدأ الآن
            </span>
          </h2>
          <p className="text-slate-400 text-lg max-w-2xl mx-auto">
            أربع خطوات بسيطة للبدء في استخدام البيئة المحلية المحسّنة
          </p>
        </div>

        {/* Steps */}
        <div className="space-y-6">
          {/* Step 1 */}
          <div className="group relative">
            <div className="absolute right-8 top-20 w-0.5 h-12 bg-gradient-to-b from-white/20 to-transparent"></div>
            <div className="flex items-start gap-6 p-6 rounded-2xl bg-white/5 border border-white/10 hover:border-white/20 transition-all group-hover:bg-white/[0.07]">
              <div className="flex-shrink-0 w-16 h-16 rounded-2xl bg-green-500/10 border border-green-500/20 flex items-center justify-center">
                <span className="text-2xl">▶️</span>
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-3 mb-2">
                  <span className="text-xs font-mono px-2 py-0.5 rounded bg-green-500/20 text-green-300">الخطوة 1</span>
                  <h3 className="text-xl font-bold text-white">التشغيل</h3>
                </div>
                <p className="text-slate-400 mb-3">نفّذ السكربت في جذر مشروعك</p>
                <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-lg bg-slate-800/50 border border-white/5" dir="ltr">
                  <span className="text-green-400 font-mono text-xs">$</span>
                  <code className="text-slate-300 font-mono text-xs">./setup-env.sh</code>
                </div>
              </div>
            </div>
          </div>

          {/* Step 2 */}
          <div className="group relative">
            <div className="absolute right-8 top-20 w-0.5 h-12 bg-gradient-to-b from-white/20 to-transparent"></div>
            <div className="flex items-start gap-6 p-6 rounded-2xl bg-white/5 border border-white/10 hover:border-white/20 transition-all group-hover:bg-white/[0.07]">
              <div className="flex-shrink-0 w-16 h-16 rounded-2xl bg-blue-500/10 border border-blue-500/20 flex items-center justify-center">
                <span className="text-2xl">💻</span>
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-3 mb-2">
                  <span className="text-xs font-mono px-2 py-0.5 rounded bg-blue-500/20 text-blue-300">الخطوة 2</span>
                  <h3 className="text-xl font-bold text-white">VS Code</h3>
                </div>
                <p className="text-slate-400 mb-3">افتح المشروع وثبّت إضافة Cline أو Roo Code</p>
                <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-lg bg-slate-800/50 border border-white/5" dir="ltr">
                  <span className="text-green-400 font-mono text-xs">$</span>
                  <code className="text-slate-300 font-mono text-xs">code .</code>
                </div>
              </div>
            </div>
          </div>

          {/* Step 3 */}
          <div className="group relative">
            <div className="absolute right-8 top-20 w-0.5 h-12 bg-gradient-to-b from-white/20 to-transparent"></div>
            <div className="flex items-start gap-6 p-6 rounded-2xl bg-white/5 border border-white/10 hover:border-white/20 transition-all group-hover:bg-white/[0.07]">
              <div className="flex-shrink-0 w-16 h-16 rounded-2xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center">
                <span className="text-2xl">🔗</span>
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-3 mb-2">
                  <span className="text-xs font-mono px-2 py-0.5 rounded bg-purple-500/20 text-purple-300">الخطوة 3</span>
                  <h3 className="text-xl font-bold text-white">الربط</h3>
                </div>
                <p className="text-slate-400 mb-3">وجّه الإضافة لاستخدام ملف .vscode/mcp-config.json</p>
                <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-lg bg-slate-800/50 border border-white/5" dir="ltr">
                  <span className="text-green-400 font-mono text-xs">$</span>
                  <code className="text-slate-300 font-mono text-xs">Settings → MCP Config</code>
                </div>
              </div>
            </div>
          </div>

          {/* Step 4 */}
          <div className="group relative">
            <div className="flex items-start gap-6 p-6 rounded-2xl bg-white/5 border border-white/10 hover:border-white/20 transition-all group-hover:bg-white/[0.07]">
              <div className="flex-shrink-0 w-16 h-16 rounded-2xl bg-pink-500/10 border border-pink-500/20 flex items-center justify-center">
                <span className="text-2xl">🧪</span>
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-3 mb-2">
                  <span className="text-xs font-mono px-2 py-0.5 rounded bg-pink-500/20 text-pink-300">الخطوة 4</span>
                  <h3 className="text-xl font-bold text-white">التجربة</h3>
                </div>
                <p className="text-slate-400 mb-3">ابدأ محادثة واطلب من النموذج استخدام الأدوات</p>
                <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-lg bg-slate-800/50 border border-white/5" dir="ltr">
                  <span className="text-green-400 font-mono text-xs">$</span>
                  <code className="text-slate-300 font-mono text-xs">اقرأ src/main.py وأفهم الدالة الرئيسية...</code>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Example prompt */}
        <div className="mt-16 p-6 rounded-2xl bg-gradient-to-br from-indigo-500/10 to-purple-500/10 border border-indigo-500/20">
          <div className="flex items-start gap-4">
            <div className="text-3xl">💡</div>
            <div>
              <h4 className="font-bold text-white text-lg mb-2">مثال للتجربة</h4>
              <p className="text-slate-400 mb-3">جرّب كتابة هذا الطلب في نافذة المحادثة:</p>
              <div className="p-4 rounded-xl bg-slate-900/50 border border-white/5" dir="rtl">
                <p className="text-indigo-300 font-mono text-sm leading-relaxed">
                  "اقرأ ملف <code className="text-amber-300">src/main.py</code>، افهم دالة المعالجة الرئيسية، 
                  ثم أضف فحصاً للأنواع (Type Checking) وتأكد من عدم وجود ثغرات أمنية باستخدام Semgrep."
                </p>
              </div>
              <p className="text-slate-500 text-sm mt-3">
                سيلاحظ أن النموذج يقوم بقراءة الملف، اقتراح التعديل، تشغيل فحص Semgrep تلقائياً، 
                وإعلامك بالنتيجة قبل تقديم الكود النهائي. ✨
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
