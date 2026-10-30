import { useScrollAnimation } from '../hooks/useScrollAnimation';

export default function BestPracticesSection() {
  const { ref, isVisible } = useScrollAnimation(0.1);

  const practices = [
    {
      category: '🔐 الأمان والخصوصية',
      items: [
        {
          title: 'استخدم Semgrep بشكل استباقي',
          description: 'لا تنتج حتى يطلب منك - اجعل الفحص الأمني جزءاً من سير العمل اليومي',
          source: 'أفضل ممارسة من مشاريع DevSecOps',
        },
        {
          title: 'احتفظ بنماذج متعددة',
          description: 'نموذج صغير (7b) للمهام السريعة، ونموذج كبير (32b) للمهام المعقدة',
          source: 'نمط شائع في Continue و Tabby',
        },
        {
          title: 'راجع كل اقتراح',
          description: 'حتى النماذج المحلية قد تخطئ - المراجعة البشرية ضرورية دائماً',
          source: 'درس مستفاد من Aider',
        },
      ],
    },
    {
      category: '⚡ الأداء والإنتاجية',
      items: [
        {
          title: 'قسّم المهام الكبيرة',
          description: 'بدلاً من طلب refactor كامل، اطلب تغييرات صغيرة ومتتالية',
          source: 'أفضل ممارسة من Cline/Roo Code',
        },
        {
          title: 'استخدم context بذكاء',
          description: 'وفر السياق الصحيح للنموذج - الملفات ذات الصلة فقط',
          source: 'نمط من Continue',
        },
        {
          title: 'استفد من LSP',
          description: 'اترك LSP يفهم الكود بدلاً من إخبار النموذج بكل شيء',
          source: 'ميزة فريدة في MCP',
        },
      ],
    },
    {
      category: '🤝 العمل الجماعي',
      items: [
        {
          title: 'وثّق الإعداد',
          description: 'شارك ملف setup-env.sh مع الفريق لضمان بيئة موحدة',
          source: 'أفضل ممارسة من Tabby',
        },
        {
          title: 'استخدم git commits وصفية',
          description: 'اجعل النموذج يكتب رسائل commit واضحة ومفصلة',
          source: 'ميزة قوية في Aider',
        },
        {
          title: 'راجع الأكواد المولدة',
          description: 'أنشئ عملية PR review حتى للأكواد المولدة بالذكاء الاصطناعي',
          source: 'سياسة أمان مؤسسية',
        },
      ],
    },
  ];

  return (
    <section id="practices" className="py-24 px-4 relative">
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-green-950/10 to-transparent"></div>
      
      <div ref={ref} className={`relative max-w-6xl mx-auto transition-all duration-1000 ${isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
        {/* Section header */}
        <div className="text-center mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-green-500/10 border border-green-500/20 text-green-300 text-sm mb-4">
            <span>🎯</span>
            <span>أفضل الممارسات</span>
          </div>
          <h2 className="text-4xl md:text-5xl font-bold mb-4">
            <span className="bg-gradient-to-l from-white to-slate-300 bg-clip-text text-transparent">
              كيف تحقق أقصى استفادة
            </span>
          </h2>
          <p className="text-slate-400 text-lg max-w-2xl mx-auto">
            نصائح عملية مستمدة من تجربة المجتمع وأفضل الممارسات في الصناعة
          </p>
        </div>

        {/* Practices grid */}
        <div className="grid md:grid-cols-3 gap-8">
          {practices.map((group) => (
            <div key={group.category} className="space-y-4">
              <h3 className="text-xl font-bold text-white mb-4 sticky top-20 bg-slate-950/80 backdrop-blur-sm p-2 rounded-lg">
                {group.category}
              </h3>
              {group.items.map((item) => (
                <div
                  key={item.title}
                  className="p-4 rounded-xl bg-white/5 border border-white/10 hover:border-white/20 transition-all group"
                >
                  <h4 className="font-bold text-white mb-2 group-hover:text-indigo-300 transition-colors">
                    {item.title}
                  </h4>
                  <p className="text-slate-400 text-sm mb-3">{item.description}</p>
                  <p className="text-slate-600 text-xs italic">{item.source}</p>
                </div>
              ))}
            </div>
          ))}
        </div>

        {/* Quick tips */}
        <div className="mt-16 p-6 rounded-2xl bg-gradient-to-br from-green-500/10 to-blue-500/10 border border-green-500/20">
          <h3 className="text-xl font-bold text-white mb-6 flex items-center gap-2">
            <span>⚡</span>
            <span>نصائح سريعة</span>
          </h3>
          <div className="grid md:grid-cols-2 gap-4">
            {[
              { icon: '🎯', text: 'ابدأ بنموذج صغير (7b) للتجربة، ثم انتقل للأحجام الأكبر' },
              { icon: '💾', text: 'احتفظ بنسخة احتياطية من ملفات التكوين في git' },
              { icon: '🔄', text: 'حدّث النماذج دورياً للحصول على أفضل أداء' },
              { icon: '📝', text: 'وثّق أوامرك المفضلة في ملف .prompt' },
              { icon: '🧪', text: 'اختبر على مشاريع صغيرة قبل الانتقال للإنتاج' },
              { icon: '🌐', text: 'شارك تجربتك مع المجتمع لتحسين الأداة' },
            ].map((tip) => (
              <div key={tip.text} className="flex items-start gap-3 p-3 rounded-xl bg-white/5">
                <span className="text-2xl">{tip.icon}</span>
                <p className="text-slate-300 text-sm">{tip.text}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
