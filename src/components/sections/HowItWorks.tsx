import FadeIn from '../ui/FadeIn';
import SectionHeader from '../shared/SectionHeader';

export default function HowItWorks() {
  const steps = [
    {
      num: '01',
      title: 'الاستقبال',
      description: 'تستقبل VS Code طلبك عبر إضافة MCP متوافقة',
      icon: '💬',
      color: 'indigo',
    },
    {
      num: '02',
      title: 'التوجيه',
      description: 'يوجه MCP Client الطلب إلى الأدوات المناسبة',
      icon: '🔀',
      color: 'purple',
    },
    {
      num: '03',
      title: 'المعالجة',
      description: 'Ollama يحلل الطلب باستخدام النموذج المحلي',
      icon: '🧠',
      color: 'blue',
    },
    {
      num: '04',
      title: 'التنفيذ',
      description: 'الأدوات تنفذ العمليات (قراءة ملفات، تحليل كود)',
      icon: '⚡',
      color: 'green',
    },
    {
      num: '05',
      title: 'الفحص',
      description: 'Semgrep يفحص الكود للتأكد من الأمان',
      icon: '🛡️',
      color: 'pink',
    },
    {
      num: '06',
      title: 'التسليم',
      description: 'تستلم النتيجة النهائية الآمنة والمحسّنة',
      icon: '✅',
      color: 'amber',
    },
  ];

  return (
    <section id="how-it-works" className="py-32 px-4 relative">
      {/* Background */}
      <div className="absolute inset-0 bg-gradient-to-b from-slate-950 via-indigo-950/20 to-slate-950"></div>

      <div className="relative max-w-7xl mx-auto">
        <SectionHeader
          badge="⚙️ كيف يعمل"
          title="سير العمل الذكي"
          subtitle="من الطلب إلى النتيجة الآمنة في 6 خطوات فقط"
          gradient="indigo"
        />

        {/* Steps grid */}
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {steps.map((step, index) => (
            <FadeIn key={step.num} delay={index * 100}>
              <div className="group relative h-full">
                {/* Card */}
                <div className="relative h-full p-6 rounded-2xl bg-gradient-to-br from-white/5 to-white/[0.02] border border-white/10 hover:border-white/20 transition-all overflow-hidden">
                  {/* Background glow */}
                  <div className={`absolute inset-0 bg-gradient-to-br from-${step.color}-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity`}></div>
                  
                  {/* Content */}
                  <div className="relative">
                    {/* Step number */}
                    <div className={`text-6xl font-bold text-${step.color}-500/10 absolute top-0 left-0 group-hover:text-${step.color}-500/20 transition-colors`}>
                      {step.num}
                    </div>

                    {/* Icon */}
                    <div className="relative mb-6">
                      <div className={`inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-${step.color}-500/10 border border-${step.color}-500/20 group-hover:scale-110 transition-transform`}>
                        <span className="text-3xl">{step.icon}</span>
                      </div>
                    </div>

                    {/* Title */}
                    <h3 className="text-xl font-bold text-white mb-3 group-hover:text-indigo-300 transition-colors">
                      {step.title}
                    </h3>

                    {/* Description */}
                    <p className="text-slate-400 leading-relaxed">
                      {step.description}
                    </p>

                    {/* Arrow connector (for desktop) */}
                    {index < steps.length - 1 && index % 3 !== 2 && (
                      <div className="hidden lg:block absolute top-1/2 -left-3 transform -translate-y-1/2">
                        <svg className="w-6 h-6 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                        </svg>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            </FadeIn>
          ))}
        </div>

        {/* Flow visualization */}
        <FadeIn delay={600}>
          <div className="mt-16 p-8 rounded-3xl bg-gradient-to-br from-indigo-500/10 to-purple-500/10 border border-indigo-500/20">
            <div className="flex flex-wrap items-center justify-center gap-4 text-sm">
              <div className="px-4 py-2 rounded-lg bg-white/5 border border-white/10 text-slate-300">
                المستخدم
              </div>
              <svg className="w-6 h-6 text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7l5 5m0 0l-5 5m5-5H6" />
              </svg>
              <div className="px-4 py-2 rounded-lg bg-indigo-500/20 border border-indigo-500/30 text-indigo-300 font-bold">
                VS Code + MCP
              </div>
              <svg className="w-6 h-6 text-purple-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7l5 5m0 0l-5 5m5-5H6" />
              </svg>
              <div className="px-4 py-2 rounded-lg bg-purple-500/20 border border-purple-500/30 text-purple-300 font-bold">
                Ollama
              </div>
              <svg className="w-6 h-6 text-pink-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7l5 5m0 0l-5 5m5-5H6" />
              </svg>
              <div className="px-4 py-2 rounded-lg bg-pink-500/20 border border-pink-500/30 text-pink-300 font-bold">
                Semgrep
              </div>
              <svg className="w-6 h-6 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7l5 5m0 0l-5 5m5-5H6" />
              </svg>
              <div className="px-4 py-2 rounded-lg bg-green-500/20 border border-green-500/30 text-green-300 font-bold">
                النتيجة ✓
              </div>
            </div>
          </div>
        </FadeIn>
      </div>
    </section>
  );
}
