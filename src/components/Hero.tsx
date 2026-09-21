import { useEffect, useState } from 'react';

export default function Hero() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  return (
    <section id="hero" className="relative min-h-screen flex items-center justify-center overflow-hidden px-4 pt-16">
      {/* Animated background elements */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute top-1/4 right-1/4 w-96 h-96 bg-indigo-500/10 rounded-full blur-3xl animate-pulse"></div>
        <div className="absolute bottom-1/4 left-1/4 w-80 h-80 bg-purple-500/10 rounded-full blur-3xl animate-pulse" style={{ animationDelay: '1s' }}></div>
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-blue-500/5 rounded-full blur-3xl"></div>
      </div>

      {/* Grid pattern overlay */}
      <div className="absolute inset-0 opacity-[0.03]" style={{
        backgroundImage: 'linear-gradient(rgba(255,255,255,0.1) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.1) 1px, transparent 1px)',
        backgroundSize: '60px 60px'
      }}></div>

      <div className={`relative z-10 text-center max-w-5xl mx-auto transition-all duration-1000 ${mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
        {/* Badge */}
        <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/5 border border-white/10 backdrop-blur-sm mb-8">
          <span className="w-2 h-2 bg-green-400 rounded-full animate-pulse"></span>
          <span className="text-sm text-slate-300">MVP • جاهز للتنفيذ</span>
        </div>

        {/* Main heading */}
        <h1 className="text-5xl md:text-7xl font-bold mb-6 leading-tight">
          <span className="bg-gradient-to-l from-white via-blue-100 to-indigo-200 bg-clip-text text-transparent">
            بيئة المطور المحلية
          </span>
          <br />
          <span className="bg-gradient-to-l from-indigo-400 via-purple-400 to-pink-400 bg-clip-text text-transparent">
            المحسّنة
          </span>
        </h1>

        {/* Subtitle */}
        <p className="text-xl md:text-2xl text-slate-400 mb-8 max-w-3xl mx-auto leading-relaxed">
          إعداد كامل لبيئة تطوير محلية ذكية باستخدام <span className="text-indigo-300 font-semibold">Ollama</span> و <span className="text-purple-300 font-semibold">MCP</span> مع
          فحص أمني تلقائي عبر <span className="text-pink-300 font-semibold">Semgrep</span>
        </p>

        {/* Feature pills */}
        <div className="flex flex-wrap justify-center gap-3 mb-12">
          {['🦙 Ollama', '🔌 MCP Protocol', '🔒 Semgrep', '📁 Filesystem', '🧠 LSP Bridge'].map((item, i) => (
            <span 
              key={item} 
              className="px-4 py-2 rounded-lg bg-white/5 border border-white/10 text-sm text-slate-300 backdrop-blur-sm hover:bg-white/10 hover:border-white/20 transition-all cursor-default"
              style={{ animationDelay: `${i * 100}ms` }}
            >
              {item}
            </span>
          ))}
        </div>

        {/* CTA */}
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <a href="#config" className="px-8 py-4 bg-gradient-to-l from-indigo-600 to-purple-600 rounded-xl font-semibold text-lg hover:from-indigo-500 hover:to-purple-500 transition-all shadow-lg shadow-indigo-500/25 hover:shadow-indigo-500/40 hover:scale-105">
            ابدأ الإعداد ←
          </a>
          <a href="#steps" className="px-8 py-4 bg-white/5 border border-white/20 rounded-xl font-semibold text-lg hover:bg-white/10 transition-all backdrop-blur-sm hover:scale-105">
            خطوات التشغيل
          </a>
        </div>

        {/* Architecture diagram */}
        <div className="mt-16 p-6 rounded-2xl bg-white/5 border border-white/10 backdrop-blur-sm hover:border-white/20 transition-all">
          <div className="flex flex-wrap items-center justify-center gap-4 text-sm">
            <div className="px-4 py-3 rounded-lg bg-indigo-500/20 border border-indigo-500/30 text-indigo-300 hover:scale-105 transition-transform">
              VS Code
            </div>
            <span className="text-slate-500 animate-pulse">←→</span>
            <div className="px-4 py-3 rounded-lg bg-purple-500/20 border border-purple-500/30 text-purple-300 hover:scale-105 transition-transform">
              MCP Client
            </div>
            <span className="text-slate-500 animate-pulse">←→</span>
            <div className="flex flex-col gap-2">
              <div className="px-4 py-2 rounded-lg bg-green-500/20 border border-green-500/30 text-green-300 text-center hover:scale-105 transition-transform">
                Ollama Server
              </div>
              <div className="flex gap-2">
                <div className="px-3 py-1 rounded bg-pink-500/20 border border-pink-500/30 text-pink-300 text-xs hover:scale-105 transition-transform">
                  Semgrep
                </div>
                <div className="px-3 py-1 rounded bg-blue-500/20 border border-blue-500/30 text-blue-300 text-xs hover:scale-105 transition-transform">
                  LSP
                </div>
                <div className="px-3 py-1 rounded bg-amber-500/20 border border-amber-500/30 text-amber-300 text-xs hover:scale-105 transition-transform">
                  Filesystem
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Scroll indicator */}
        <div className="mt-12 animate-bounce">
          <svg className="w-6 h-6 mx-auto text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 14l-7 7m0 0l-7-7m7 7V3" />
          </svg>
        </div>
      </div>
    </section>
  );
}
