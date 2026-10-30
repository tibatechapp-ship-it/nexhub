import FadeIn from '../ui/FadeIn';
import SectionHeader from '../shared/SectionHeader';

export default function Roadmap() {
  const phases = [
    {
      phase: 'المرحلة 1',
      title: 'التحسينات السريعة',
      timeline: 'أسبوع 1-2',
      color: 'green',
      items: [
        { text: 'autocomplete ذكي', from: 'Continue' },
        { text: 'Plan/Act modes', from: 'Cline' },
        { text: 'دعم JetBrains', from: 'Tabby' },
        { text: 'سكربت تفاعلي', from: 'Aider' },
      ],
    },
    {
      phase: 'المرحلة 2',
      title: 'المميزات المتقدمة',
      timeline: 'شهر 1-2',
      color: 'blue',
      items: [
        { text: 'multi-file refactor', from: 'Aider' },
        { text: 'git commits تلقائي', from: 'Aider' },
        { text: 'نماذج متعددة', from: 'Continue' },
        { text: 'تحسينات الأداء', from: 'Tabby' },
      ],
    },
    {
      phase: 'المرحلة 3',
      title: 'التوسع والمجتمع',
      timeline: 'شهر 3-6',
      color: 'purple',
      items: [
        { text: 'Team mode', from: 'Tabby' },
        { text: 'MCP servers مخصصة', from: 'المجتمع' },
        { text: 'نظام plugins', from: 'Cline' },
        { text: 'لغات إضافية', from: 'المجتمع' },
      ],
    },
  ];

  return (
    <section id="roadmap" className="py-32 px-4 relative">
      <div className="absolute inset-0 bg-gradient-to-b from-slate-950 via-blue-950/10 to-slate-950"></div>

      <div className="relative max-w-6xl mx-auto">
        <SectionHeader
          badge="🗺️ خارطة الطريق"
          title="التطوير المستقبلي"
          subtitle="خطة التطوير المستندة إلى أفضل الممارسات من المشاريع المنافسة"
          gradient="blue"
        />

        {/* Timeline */}
        <div className="relative">
          {/* Vertical line */}
          <div className="absolute right-8 top-0 bottom-0 w-1 bg-gradient-to-b from-green-500/50 via-blue-500/50 to-purple-500/50 hidden md:block rounded-full"></div>

          <div className="space-y-12">
            {phases.map((phase, index) => (
              <FadeIn key={phase.phase} delay={index * 150}>
                <div className="relative">
                  {/* Timeline dot */}
                  <div className={`absolute right-6 w-5 h-5 rounded-full bg-${phase.color}-500 hidden md:block ring-4 ring-slate-950 shadow-lg shadow-${phase.color}-500/50`}></div>
                  
                  <div className={`mr-0 md:mr-16 p-8 rounded-3xl bg-gradient-to-br from-${phase.color}-500/10 to-transparent border border-${phase.color}-500/20`}>
                    <div className="flex flex-wrap items-center gap-4 mb-6">
                      <span className={`px-4 py-2 rounded-full bg-${phase.color}-500/20 border border-${phase.color}-500/30 text-${phase.color}-300 text-sm font-bold`}>
                        {phase.phase}
                      </span>
                      <h3 className="text-2xl font-bold text-white">{phase.title}</h3>
                      <span className="text-slate-500 text-sm">{phase.timeline}</span>
                    </div>

                    <div className="grid md:grid-cols-2 gap-4">
                      {phase.items.map((item) => (
                        <div key={item.text} className="flex items-start gap-3 p-4 rounded-xl bg-white/5 hover:bg-white/10 transition-colors">
                          <div className={`w-6 h-6 rounded-full border-2 border-${phase.color}-500/50 flex-shrink-0 mt-0.5`}></div>
                          <div className="flex-1">
                            <p className="text-slate-300 font-medium">{item.text}</p>
                            <p className="text-slate-500 text-sm mt-1">مستوحى من: <span className={`text-${phase.color}-300`}>{item.from}</span></p>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              </FadeIn>
            ))}
          </div>
        </div>

        {/* CTA */}
        <FadeIn delay={500}>
          <div className="mt-16 text-center p-10 rounded-3xl bg-gradient-to-br from-indigo-500/10 to-purple-500/10 border border-indigo-500/20">
            <h3 className="text-3xl font-bold text-white mb-4">🤝 ساهم في المشروع</h3>
            <p className="text-slate-400 mb-8 max-w-xl mx-auto text-lg">
              هذا المشروع مفتوح المصدر ونرحب بمساهمات المجتمع
            </p>
            <div className="flex flex-wrap justify-center gap-4">
              <a href="#" className="px-8 py-4 rounded-2xl bg-gradient-to-l from-indigo-600 to-purple-600 hover:from-indigo-500 hover:to-purple-500 text-white font-bold text-lg transition-all hover:scale-105 shadow-xl shadow-indigo-500/30">
                المساهمة على GitHub
              </a>
              <a href="#" className="px-8 py-4 rounded-2xl bg-white/5 border border-white/20 hover:bg-white/10 text-white font-bold text-lg transition-all hover:scale-105">
                الإبلاغ عن مشكلة
              </a>
            </div>
          </div>
        </FadeIn>
      </div>
    </section>
  );
}
