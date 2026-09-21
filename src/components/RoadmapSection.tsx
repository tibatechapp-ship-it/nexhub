import { useScrollAnimation } from '../hooks/useScrollAnimation';

export default function RoadmapSection() {
  const { ref, isVisible } = useScrollAnimation(0.1);

  const phases = [
    {
      phase: 'المرحلة 1',
      title: 'التحسينات السريعة',
      timeline: 'أسبوع 1-2',
      color: 'green',
      items: [
        { text: 'إضافة autocomplete ذكي مستوحى من Continue', inspired: 'Continue', done: false },
        { text: 'تحسين واجهة المستخدم مع Plan/Act modes', inspired: 'Cline', done: false },
        { text: 'إضافة دعم JetBrains IDE', inspired: 'Tabby', done: false },
        { text: 'تحسين تجربة الإعداد بسكربت تفاعلي', inspired: 'Aider', done: false },
      ],
    },
    {
      phase: 'المرحلة 2',
      title: 'المميزات المتقدمة',
      timeline: 'شهر 1-2',
      color: 'blue',
      items: [
        { text: 'multi-file refactor عبر المشروع بالكامل', inspired: 'Aider', done: false },
        { text: 'git commits تلقائي مع رسائل وصفية', inspired: 'Aider', done: false },
        { text: 'دعم نماذج متعددة (routing)', inspired: 'Continue', done: false },
        { text: 'تحسينات أداء للفحص الأمني', inspired: 'Tabby', done: false },
      ],
    },
    {
      phase: 'المرحلة 3',
      title: 'التوسع والمجتمع',
      timeline: 'شهر 3-6',
      color: 'purple',
      items: [
        { text: 'دعم الفرق الصغيرة (Team mode)', inspired: 'Tabby', done: false },
        { text: 'إضافة MCP servers مخصصة', inspired: 'المجتمع', done: false },
        { text: 'نظام plugins للمطورين', inspired: 'Cline', done: false },
        { text: 'دعم لغات برمجة إضافية', inspired: 'المجتمع', done: false },
      ],
    },
  ];

  const colorClasses: Record<string, { bg: string; border: string; text: string; dot: string }> = {
    green: { bg: 'bg-green-500/10', border: 'border-green-500/20', text: 'text-green-300', dot: 'bg-green-500' },
    blue: { bg: 'bg-blue-500/10', border: 'border-blue-500/20', text: 'text-blue-300', dot: 'bg-blue-500' },
    purple: { bg: 'bg-purple-500/10', border: 'border-purple-500/20', text: 'text-purple-300', dot: 'bg-purple-500' },
  };

  return (
    <section id="roadmap" className="py-24 px-4 relative">
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-indigo-950/10 to-transparent"></div>
      
      <div ref={ref} className={`relative max-w-6xl mx-auto transition-all duration-1000 ${isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
        {/* Section header */}
        <div className="text-center mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-300 text-sm mb-4">
            <span>🗺️</span>
            <span>خارطة الطريق</span>
          </div>
          <h2 className="text-4xl md:text-5xl font-bold mb-4">
            <span className="bg-gradient-to-l from-white to-slate-300 bg-clip-text text-transparent">
              التطوير المستقبلي
            </span>
          </h2>
          <p className="text-slate-400 text-lg max-w-2xl mx-auto">
            خطة التطوير المستندة إلى أفضل الممارسات من المشاريع المنافسة
          </p>
        </div>

        {/* Timeline */}
        <div className="relative">
          {/* Vertical line */}
          <div className="absolute right-8 top-0 bottom-0 w-0.5 bg-gradient-to-b from-green-500/50 via-blue-500/50 to-purple-500/50 hidden md:block"></div>

          <div className="space-y-12">
            {phases.map((phase) => {
              const colors = colorClasses[phase.color];
              return (
                <div key={phase.phase} className="relative">
                  {/* Timeline dot */}
                  <div className={`absolute right-6 w-4 h-4 rounded-full ${colors.dot} hidden md:block ring-4 ring-slate-950`}></div>
                  
                  <div className={`mr-0 md:mr-16 p-6 rounded-2xl ${colors.bg} border ${colors.border}`}>
                    <div className="flex flex-wrap items-center gap-3 mb-4">
                      <span className={`px-3 py-1 rounded-full ${colors.bg} border ${colors.border} ${colors.text} text-xs font-bold`}>
                        {phase.phase}
                      </span>
                      <h3 className="text-xl font-bold text-white">{phase.title}</h3>
                      <span className="text-slate-500 text-sm">{phase.timeline}</span>
                    </div>

                    <div className="space-y-3">
                      {phase.items.map((item) => (
                        <div key={item.text} className="flex items-start gap-3 p-3 rounded-xl bg-white/5 hover:bg-white/10 transition-colors">
                          <div className={`w-5 h-5 rounded-full border-2 ${item.done ? 'bg-green-500 border-green-500' : 'border-slate-600'} flex-shrink-0 mt-0.5 flex items-center justify-center`}>
                            {item.done && (
                              <svg className="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                              </svg>
                            )}
                          </div>
                          <div className="flex-1">
                            <p className="text-slate-300 text-sm">{item.text}</p>
                            <p className="text-slate-500 text-xs mt-1">مستوحى من: <span className={colors.text}>{item.inspired}</span></p>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Contribution CTA */}
        <div className="mt-16 text-center p-8 rounded-2xl bg-gradient-to-br from-indigo-500/10 to-purple-500/10 border border-indigo-500/20">
          <h3 className="text-2xl font-bold text-white mb-4">🤝 ساهم في المشروع</h3>
          <p className="text-slate-400 mb-6 max-w-xl mx-auto">
            هذا المشروع مفتوح المصدر ونرحب بمساهمات المجتمع. سواء كنت مطوراً أو مستخدماً، يمكنك المساعدة في تحسينه.
          </p>
          <div className="flex flex-wrap justify-center gap-4">
            <a href="#" className="px-6 py-3 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-semibold transition-all hover:scale-105">
              المساهمة على GitHub
            </a>
            <a href="#" className="px-6 py-3 rounded-xl bg-white/5 border border-white/20 hover:bg-white/10 text-white font-semibold transition-all hover:scale-105">
              الإبلاغ عن مشكلة
            </a>
          </div>
        </div>
      </div>
    </section>
  );
}
