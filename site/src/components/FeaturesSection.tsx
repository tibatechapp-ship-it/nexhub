import { useScrollAnimation } from '../hooks/useScrollAnimation';

export default function FeaturesSection() {
  const { ref, isVisible } = useScrollAnimation(0.1);

  return (
    <section id="features" className="py-24 px-4 relative">
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-indigo-950/10 to-transparent"></div>
      
      <div ref={ref} className={`relative max-w-6xl mx-auto transition-all duration-1000 ${isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
        {/* Section header */}
        <div className="text-center mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-indigo-500/10 border border-indigo-500/20 text-indigo-300 text-sm mb-4">
            <span>✨</span>
            <span>المميزات</span>
          </div>
          <h2 className="text-4xl md:text-5xl font-bold mb-4">
            <span className="bg-gradient-to-l from-white to-slate-300 bg-clip-text text-transparent">
              لماذا هذه البيئة؟
            </span>
          </h2>
          <p className="text-slate-400 text-lg max-w-2xl mx-auto">
            مميزات تجعل من بيئة التطوير المحلية خياراً مثالياً للمطورين المحترفين
          </p>
        </div>

        {/* Features grid */}
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {/* Feature 1 - Privacy */}
          <div className="p-6 rounded-2xl bg-green-500/10 border border-green-500/20 hover:border-green-500/40 transition-all hover:scale-105 group">
            <div className="text-4xl mb-4 group-hover:scale-110 transition-transform">🔒</div>
            <h3 className="text-xl font-bold text-green-300 mb-2">خصوصية كاملة</h3>
            <p className="text-slate-400 text-sm leading-relaxed">جميع العمليات تتم محلياً - لا يتم إرسال أي بيانات إلى خوادم خارجية</p>
          </div>

          {/* Feature 2 - Performance */}
          <div className="p-6 rounded-2xl bg-blue-500/10 border border-blue-500/20 hover:border-blue-500/40 transition-all hover:scale-105 group">
            <div className="text-4xl mb-4 group-hover:scale-110 transition-transform">⚡</div>
            <h3 className="text-xl font-bold text-blue-300 mb-2">أداء عالي</h3>
            <p className="text-slate-400 text-sm leading-relaxed">نماذج محسّنة تعمل مباشرة على جهازك بدون تأخير الشبكة</p>
          </div>

          {/* Feature 3 - Security */}
          <div className="p-6 rounded-2xl bg-pink-500/10 border border-pink-500/20 hover:border-pink-500/40 transition-all hover:scale-105 group">
            <div className="text-4xl mb-4 group-hover:scale-110 transition-transform">🛡️</div>
            <h3 className="text-xl font-bold text-pink-300 mb-2">أمان تلقائي</h3>
            <p className="text-slate-400 text-sm leading-relaxed">فحص Semgrep يكتشف الثغرات الأمنية قبل تسليم الكود</p>
          </div>

          {/* Feature 4 - Intelligence */}
          <div className="p-6 rounded-2xl bg-purple-500/10 border border-purple-500/20 hover:border-purple-500/40 transition-all hover:scale-105 group">
            <div className="text-4xl mb-4 group-hover:scale-110 transition-transform">🧠</div>
            <h3 className="text-xl font-bold text-purple-300 mb-2">ذكاء محلي</h3>
            <p className="text-slate-400 text-sm leading-relaxed">نموذج Qwen2.5-Coder يفهم الكود ويقترح تحسينات ذكية</p>
          </div>

          {/* Feature 5 - Integration */}
          <div className="p-6 rounded-2xl bg-indigo-500/10 border border-indigo-500/20 hover:border-indigo-500/40 transition-all hover:scale-105 group">
            <div className="text-4xl mb-4 group-hover:scale-110 transition-transform">🔌</div>
            <h3 className="text-xl font-bold text-indigo-300 mb-2">تكامل سهل</h3>
            <p className="text-slate-400 text-sm leading-relaxed">بروتوكول MCP يربط الأدوات بسلاسة مع VS Code</p>
          </div>

          {/* Feature 6 - Analysis */}
          <div className="p-6 rounded-2xl bg-amber-500/10 border border-amber-500/20 hover:border-amber-500/40 transition-all hover:scale-105 group">
            <div className="text-4xl mb-4 group-hover:scale-110 transition-transform">📊</div>
            <h3 className="text-xl font-bold text-amber-300 mb-2">تحليل عميق</h3>
            <p className="text-slate-400 text-sm leading-relaxed">LSP يوفر فهم دقيق للرموز والتعريفات في مشروعك</p>
          </div>
        </div>
      </div>
    </section>
  );
}
