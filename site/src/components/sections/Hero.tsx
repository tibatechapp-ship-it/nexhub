import { useEffect, useState } from 'react';
import FadeIn from '../ui/FadeIn';

export default function Hero() {
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      setMousePosition({
        x: (e.clientX / window.innerWidth - 0.5) * 20,
        y: (e.clientY / window.innerHeight - 0.5) * 20,
      });
    };

    window.addEventListener('mousemove', handleMouseMove);
    return () => window.removeEventListener('mousemove', handleMouseMove);
  }, []);

  return (
    <section id="hero" className="relative min-h-screen flex items-center justify-center overflow-hidden px-4 pt-16">
      {/* Animated gradient orbs */}
      <div className="absolute inset-0 overflow-hidden">
        <div
          className="absolute top-1/4 right-1/4 w-[500px] h-[500px] bg-indigo-500/20 rounded-full blur-[100px] animate-pulse"
          style={{ transform: `translate(${mousePosition.x}px, ${mousePosition.y}px)` }}
        ></div>
        <div
          className="absolute bottom-1/4 left-1/4 w-[400px] h-[400px] bg-purple-500/20 rounded-full blur-[100px] animate-pulse"
          style={{ transform: `translate(${-mousePosition.x}px, ${-mousePosition.y}px)`, animationDelay: '1s' }}
        ></div>
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-gradient-to-br from-indigo-500/5 via-purple-500/5 to-pink-500/5 rounded-full blur-[120px]"></div>
      </div>

      {/* Grid pattern */}
      <div className="absolute inset-0 opacity-[0.02]" style={{
        backgroundImage: 'linear-gradient(rgba(255,255,255,0.1) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.1) 1px, transparent 1px)',
        backgroundSize: '80px 80px'
      }}></div>

      <div className="relative z-10 text-center max-w-6xl mx-auto">
        {/* Badge */}
        <FadeIn delay={100}>
          <div className="inline-flex items-center gap-3 px-5 py-2.5 rounded-full bg-gradient-to-l from-indigo-500/10 to-purple-500/10 border border-indigo-500/20 backdrop-blur-sm mb-8">
            <span className="relative flex h-2 w-2">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75"></span>
              <span className="relative inline-flex rounded-full h-2 w-2 bg-green-500"></span>
            </span>
            <span className="text-sm text-slate-300 font-medium">MVP • جاهز للتنفيذ • مفتوح المصدر</span>
          </div>
        </FadeIn>

        {/* Main heading */}
        <FadeIn delay={200}>
          <h1 className="text-6xl md:text-8xl font-bold mb-8 leading-tight">
            <span className="block bg-gradient-to-l from-white via-blue-100 to-indigo-200 bg-clip-text text-transparent">
              بيئة المطور
            </span>
            <span className="block bg-gradient-to-l from-indigo-400 via-purple-400 to-pink-400 bg-clip-text text-transparent mt-2">
              المحلية المحسّنة
            </span>
          </h1>
        </FadeIn>

        {/* Subtitle */}
        <FadeIn delay={300}>
          <p className="text-xl md:text-2xl text-slate-400 mb-12 max-w-3xl mx-auto leading-relaxed">
            إعداد كامل لبيئة تطوير محلية ذكية باستخدام{' '}
            <span className="text-indigo-300 font-semibold">Ollama</span> و{' '}
            <span className="text-purple-300 font-semibold">MCP</span> مع فحص أمني تلقائي عبر{' '}
            <span className="text-pink-300 font-semibold">Semgrep</span>
          </p>
        </FadeIn>

        {/* Tech pills */}
        <FadeIn delay={400}>
          <div className="flex flex-wrap justify-center gap-3 mb-12">
            {[
              { icon: '🦙', label: 'Ollama', color: 'indigo' },
              { icon: '🔌', label: 'MCP Protocol', color: 'purple' },
              { icon: '🔒', label: 'Semgrep', color: 'pink' },
              { icon: '📁', label: 'Filesystem', color: 'amber' },
              { icon: '🧠', label: 'LSP Bridge', color: 'blue' },
            ].map((item) => (
              <div
                key={item.label}
                className={`px-5 py-3 rounded-xl bg-${item.color}-500/10 border border-${item.color}-500/20 backdrop-blur-sm hover:scale-105 transition-transform cursor-default group`}
              >
                <div className="flex items-center gap-2">
                  <span className="text-xl group-hover:scale-110 transition-transform">{item.icon}</span>
                  <span className="text-sm font-medium text-slate-300">{item.label}</span>
                </div>
              </div>
            ))}
          </div>
        </FadeIn>

        {/* CTA buttons */}
        <FadeIn delay={500}>
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-16">
            <a
              href="#setup"
              className="group relative px-8 py-4 bg-gradient-to-l from-indigo-600 to-purple-600 rounded-2xl font-bold text-lg hover:from-indigo-500 hover:to-purple-500 transition-all shadow-2xl shadow-indigo-500/30 hover:shadow-indigo-500/50 hover:scale-105"
            >
              <span className="relative z-10">ابدأ الإعداد الآن</span>
              <div className="absolute inset-0 bg-gradient-to-l from-indigo-600 to-purple-600 rounded-2xl blur-xl opacity-50 group-hover:opacity-75 transition-opacity"></div>
            </a>
            <a
              href="#how-it-works"
              className="px-8 py-4 bg-white/5 border border-white/20 rounded-2xl font-bold text-lg hover:bg-white/10 transition-all backdrop-blur-sm hover:scale-105"
            >
              كيف يعمل؟ ←
            </a>
          </div>
        </FadeIn>

        {/* Architecture diagram */}
        <FadeIn delay={600}>
          <div className="relative p-8 rounded-3xl bg-gradient-to-br from-white/5 to-white/[0.02] border border-white/10 backdrop-blur-sm hover:border-white/20 transition-all">
            <div className="absolute inset-0 bg-gradient-to-br from-indigo-500/5 to-purple-500/5 rounded-3xl"></div>
            <div className="relative flex flex-wrap items-center justify-center gap-6 text-sm">
              <div className="px-6 py-4 rounded-xl bg-indigo-500/20 border border-indigo-500/30 text-indigo-300 font-bold hover:scale-105 transition-transform">
                VS Code
              </div>
              <div className="flex items-center gap-2">
                <div className="w-2 h-2 rounded-full bg-indigo-400 animate-pulse"></div>
                <div className="w-12 h-0.5 bg-gradient-to-l from-indigo-400 to-purple-400"></div>
                <div className="w-2 h-2 rounded-full bg-purple-400 animate-pulse"></div>
              </div>
              <div className="px-6 py-4 rounded-xl bg-purple-500/20 border border-purple-500/30 text-purple-300 font-bold hover:scale-105 transition-transform">
                MCP Client
              </div>
              <div className="flex items-center gap-2">
                <div className="w-2 h-2 rounded-full bg-purple-400 animate-pulse"></div>
                <div className="w-12 h-0.5 bg-gradient-to-l from-purple-400 to-pink-400"></div>
                <div className="w-2 h-2 rounded-full bg-pink-400 animate-pulse"></div>
              </div>
              <div className="flex flex-col gap-3">
                <div className="px-6 py-3 rounded-xl bg-green-500/20 border border-green-500/30 text-green-300 text-center font-bold hover:scale-105 transition-transform">
                  Ollama Server
                </div>
                <div className="flex gap-2">
                  {['Semgrep', 'LSP', 'Filesystem'].map((tool) => (
                    <div key={tool} className="px-3 py-1.5 rounded-lg bg-white/5 border border-white/10 text-slate-300 text-xs font-medium hover:scale-105 transition-transform">
                      {tool}
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </FadeIn>

        {/* Scroll indicator */}
        <FadeIn delay={700}>
          <div className="mt-16 animate-bounce">
            <svg className="w-8 h-8 mx-auto text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 14l-7 7m0 0l-7-7m7 7V3" />
            </svg>
          </div>
        </FadeIn>
      </div>
    </section>
  );
}
