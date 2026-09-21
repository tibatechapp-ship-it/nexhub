import FadeIn from '../ui/FadeIn';
import SectionHeader from '../shared/SectionHeader';

export default function Features() {
  const features = [
    {
      icon: '🔒',
      title: 'خصوصية كاملة',
      description: 'جميع العمليات تتم محلياً - لا يتم إرسال أي بيانات إلى خوادم خارجية',
      color: 'green',
    },
    {
      icon: '⚡',
      title: 'أداء عالي',
      description: 'نماذج محسّنة تعمل مباشرة على جهازك بدون تأخير الشبكة',
      color: 'blue',
    },
    {
      icon: '🛡️',
      title: 'أمان تلقائي',
      description: 'فحص Semgrep يكتشف الثغرات الأمنية قبل تسليم الكود',
      color: 'pink',
    },
    {
      icon: '🧠',
      title: 'ذكاء محلي',
      description: 'نموذج Qwen2.5-Coder يفهم الكود ويقترح تحسينات ذكية',
      color: 'purple',
    },
    {
      icon: '🔌',
      title: 'تكامل سهل',
      description: 'بروتوكول MCP يربط الأدوات بسلاسة مع VS Code',
      color: 'indigo',
    },
    {
      icon: '📊',
      title: 'تحليل عميق',
      description: 'LSP يوفر فهم دقيق للرموز والتعريفات في مشروعك',
      color: 'amber',
    },
  ];

  return (
    <section id="features" className="py-32 px-4 relative">
      <div className="absolute inset-0 bg-gradient-to-b from-slate-950 via-purple-950/10 to-slate-950"></div>

      <div className="relative max-w-7xl mx-auto">
        <SectionHeader
          badge="✨ المميزات"
          title="لماذا هذه البيئة؟"
          subtitle="مميزات تجعل من بيئة التطوير المحلية خياراً مثالياً للمطورين المحترفين"
          gradient="purple"
        />

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {features.map((feature, index) => (
            <FadeIn key={feature.title} delay={index * 100}>
              <div className="group relative h-full">
                <div className={`relative h-full p-8 rounded-3xl bg-gradient-to-br from-${feature.color}-500/10 to-transparent border border-${feature.color}-500/20 hover:border-${feature.color}-500/40 transition-all overflow-hidden`}>
                  {/* Background pattern */}
                  <div className="absolute inset-0 opacity-5">
                    <div className="absolute inset-0" style={{
                      backgroundImage: 'radial-gradient(circle at 2px 2px, currentColor 1px, transparent 0)',
                      backgroundSize: '20px 20px'
                    }}></div>
                  </div>

                  {/* Content */}
                  <div className="relative">
                    {/* Icon */}
                    <div className={`inline-flex items-center justify-center w-20 h-20 rounded-2xl bg-${feature.color}-500/20 border border-${feature.color}-500/30 mb-6 group-hover:scale-110 group-hover:rotate-3 transition-all`}>
                      <span className="text-4xl">{feature.icon}</span>
                    </div>

                    {/* Title */}
                    <h3 className={`text-2xl font-bold text-${feature.color}-300 mb-4 group-hover:text-${feature.color}-200 transition-colors`}>
                      {feature.title}
                    </h3>

                    {/* Description */}
                    <p className="text-slate-400 leading-relaxed text-lg">
                      {feature.description}
                    </p>
                  </div>
                </div>
              </div>
            </FadeIn>
          ))}
        </div>
      </div>
    </section>
  );
}
