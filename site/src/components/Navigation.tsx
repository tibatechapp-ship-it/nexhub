import { useState } from 'react';

interface NavigationProps {
  activeSection: string;
  setActiveSection: (section: string) => void;
}

export default function Navigation({ activeSection, setActiveSection }: NavigationProps) {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const links = [
    { id: 'hero', label: 'الرئيسية' },
    { id: 'features', label: 'المميزات' },
    { id: 'config', label: 'التكوين' },
    { id: 'setup', label: 'الإعداد' },
    { id: 'prompt', label: 'الموجه' },
    { id: 'steps', label: 'التشغيل' },
    { id: 'comparison', label: 'المقارنة' },
    { id: 'roadmap', label: 'الخارطة' },
    { id: 'practices', label: 'الممارسات' },
    { id: 'faq', label: 'FAQ' },
  ];

  const handleLinkClick = (id: string) => {
    setActiveSection(id);
    setMobileMenuOpen(false);
  };

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 bg-slate-950/80 backdrop-blur-xl border-b border-white/5">
      <div className="max-w-7xl mx-auto px-4 py-3 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center text-sm font-bold">
            M
          </div>
          <span className="font-bold text-lg hidden sm:block">MCP Env</span>
        </div>
        
        {/* Desktop menu */}
        <div className="hidden md:flex items-center gap-1">
          {links.map((link) => (
            <a
              key={link.id}
              href={`#${link.id}`}
              onClick={() => handleLinkClick(link.id)}
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

        <div className="flex items-center gap-2">
          <a
            href="https://ollama.com"
            target="_blank"
            rel="noopener noreferrer"
            className="hidden sm:flex items-center gap-2 px-4 py-2 rounded-lg bg-indigo-600/20 border border-indigo-500/30 text-indigo-300 text-sm hover:bg-indigo-600/30 transition-colors"
          >
            <span>🦙</span>
            <span>Ollama</span>
          </a>

          {/* Mobile menu button */}
          <button
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            className="md:hidden p-2 rounded-lg bg-white/5 hover:bg-white/10 transition-colors"
            aria-label="القائمة"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              {mobileMenuOpen ? (
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              ) : (
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              )}
            </svg>
          </button>
        </div>
      </div>

      {/* Mobile menu */}
      {mobileMenuOpen && (
        <div className="md:hidden bg-slate-950/95 backdrop-blur-xl border-t border-white/5">
          <div className="px-4 py-4 space-y-2">
            {links.map((link) => (
              <a
                key={link.id}
                href={`#${link.id}`}
                onClick={() => handleLinkClick(link.id)}
                className={`block px-4 py-3 rounded-lg text-sm transition-all ${
                  activeSection === link.id
                    ? 'bg-white/10 text-white'
                    : 'text-slate-400 hover:text-white hover:bg-white/5'
                }`}
              >
                {link.label}
              </a>
            ))}
            <a
              href="https://ollama.com"
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center gap-2 px-4 py-3 rounded-lg bg-indigo-600/20 border border-indigo-500/30 text-indigo-300 text-sm"
            >
              <span>🦙</span>
              <span>Ollama</span>
            </a>
          </div>
        </div>
      )}
    </nav>
  );
}
