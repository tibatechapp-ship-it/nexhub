export default function Footer() {
  return (
    <footer className="py-12 px-4 border-t border-white/5">
      <div className="max-w-6xl mx-auto">
        <div className="grid md:grid-cols-3 gap-8 mb-12">
          {/* Brand */}
          <div>
            <div className="flex items-center gap-2 mb-4">
              <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center text-sm font-bold">
                M
              </div>
              <span className="font-bold text-lg">MCP Local Dev</span>
            </div>
            <p className="text-slate-400 text-sm leading-relaxed">
              بيئة تطوير محلية ذكية تجمع بين قوة النماذج اللغوية المحلية وأدوات الفحص الأمني.
            </p>
          </div>

          {/* Links */}
          <div>
            <h4 className="font-bold text-white mb-4">روابط مفيدة</h4>
            <ul className="space-y-2">
              {[
                { label: 'Ollama', url: 'https://ollama.com' },
                { label: 'MCP Protocol', url: 'https://modelcontextprotocol.io' },
                { label: 'Semgrep', url: 'https://semgrep.io' },
                { label: 'VS Code', url: 'https://code.visualstudio.com' },
                { label: 'Qwen Coder', url: 'https://huggingface.co/Qwen' },
              ].map((link) => (
                <li key={link.label}>
                  <a href={link.url} target="_blank" rel="noopener noreferrer" className="text-slate-400 hover:text-white text-sm transition-colors">
                    ← {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Tech stack */}
          <div>
            <h4 className="font-bold text-white mb-4">التقنيات المستخدمة</h4>
            <div className="flex flex-wrap gap-2">
              {['Ollama', 'MCP', 'Semgrep', 'LSP', 'Node.js', 'Qwen2.5', 'VS Code'].map((tech) => (
                <span key={tech} className="px-2 py-1 rounded-md bg-white/5 border border-white/10 text-xs text-slate-400">
                  {tech}
                </span>
              ))}
            </div>
          </div>
        </div>

        {/* Bottom */}
        <div className="pt-8 border-t border-white/5 flex flex-col sm:flex-row items-center justify-between gap-4">
          <p className="text-slate-500 text-sm">
            بيئة المطور المحلية المحسّنة — MVP
          </p>
          <div className="flex items-center gap-4">
            <span className="text-slate-500 text-sm">
              صُمم لـ Linux / macOS 🐧🍎
            </span>
            <span className="text-slate-600">|</span>
            <span className="text-slate-500 text-sm">
              متوافق مع Windows ⚙️
            </span>
          </div>
        </div>
      </div>
    </footer>
  );
}
