interface NavigationProps {
  activeSection: string;
  setActiveSection: (section: string) => void;
}

export default function Navigation({ activeSection, setActiveSection }: NavigationProps) {
  const links = [
    { id: 'hero', label: 'الرئيسية' },
    { id: 'config', label: 'التكوين' },
    { id: 'setup', label: 'الإعداد' },
    { id: 'prompt', label: 'الموجه' },
    { id: 'steps', label: 'التشغيل' },
  ];

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 bg-slate-950/80 backdrop-blur-xl border-b border-white/5">
      <div className="max-w-7xl mx-auto px-4 py-3 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center text-sm font-bold">
            M
          </div>
          <span className="font-bold text-lg hidden sm:block">MCP Env</span>
        </div>
        
        <div className="flex items-center gap-1">
          {links.map((link) => (
            <a
              key={link.id}
              href={`#${link.id}`}
              onClick={() => setActiveSection(link.id)}
              className={`px-3 py-2 rounded-lg text-sm transition-all ${
                activeSection === link.id
                  ? 'bg-white/10 text-white'
                  : 'text-slate-400 hover:text-white hover:bg-white/5'
              }`}
            >
              {link.label}
            </a>
          ))}
        </div>

        <a
          href="https://ollama.com"
          target="_blank"
          rel="noopener noreferrer"
          className="hidden sm:flex items-center gap-2 px-4 py-2 rounded-lg bg-indigo-600/20 border border-indigo-500/30 text-indigo-300 text-sm hover:bg-indigo-600/30 transition-colors"
        >
          <span>🦙</span>
          <span>Ollama</span>
        </a>
      </div>
    </nav>
  );
}
