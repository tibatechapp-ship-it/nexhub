import { useState } from 'react';

interface NavigationProps {
  activeSection: string;
  setActiveSection: (section: string) => void;
}

export default function Navigation({ activeSection, setActiveSection }: NavigationProps) {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const links = [
    { id: 'hero', label: 'الرئيسية', icon: '🏠' },
    { id: 'how-it-works', label: 'كيف يعمل', icon: '⚙️' },
    { id: 'features', label: 'المميزات', icon: '✨' },
    { id: 'setup', label: 'الإعداد', icon: '🚀' },
    { id: 'comparison', label: 'المقارنة', icon: '📊' },
    { id: 'roadmap', label: 'الخارطة', icon: '🗺️' },
    { id: 'faq', label: 'FAQ', icon: '❓' },
  ];

  const handleLinkClick = (id: string) => {
    setActiveSection(id);
    setMobileMenuOpen(false);
  };

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 bg-slate-950/70 backdrop-blur-2xl border-b border-white/5">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <div className="flex items-center gap-3">
            <div className="relative">
              <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 via-purple-500 to-pink-500 flex items-center justify-center text-sm font-bold shadow-lg shadow-indigo-500/30">
                M
              </div>
              <div className="absolute inset-0 w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 via-purple-500 to-pink-500 blur-lg opacity-50"></div>
            </div>
            <div className="hidden sm:block">
              <div className="font-bold text-lg bg-gradient-to-l from-white to-slate-300 bg-clip-text text-transparent">
                MCP Env
              </div>
              <div className="text-xs text-slate-500">Local AI Development</div>
            </div>
          </div>
          
          {/* Desktop menu */}
          <div className="hidden lg:flex items-center gap-1 bg-white/5 rounded-full p-1 border border-white/10">
            {links.map((link) => (
              <a
                key={link.id}
                href={`#${link.id}`}
                onClick={() => handleLinkClick(link.id)}
                className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
                  activeSection === link.id
                    ? 'bg-gradient-to-l from-indigo-600 to-purple-600 text-white shadow-lg shadow-indigo-500/25'
                    : 'text-slate-400 hover:text-white hover:bg-white/5'
                }`}
              >
                {link.label}
              </a>
            ))}
          </div>

          {/* Right side */}
          <div className="flex items-center gap-3">
            <a
              href="https://ollama.com"
              target="_blank"
              rel="noopener noreferrer"
              className="hidden md:flex items-center gap-2 px-4 py-2 rounded-full bg-gradient-to-l from-indigo-600/20 to-purple-600/20 border border-indigo-500/30 text-indigo-300 text-sm font-medium hover:from-indigo-600/30 hover:to-purple-600/30 transition-all"
            >
              <span>🦙</span>
              <span>Ollama</span>
            </a>

            {/* Mobile menu button */}
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="lg:hidden p-2 rounded-xl bg-white/5 hover:bg-white/10 border border-white/10 transition-all"
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
      </div>

      {/* Mobile menu */}
      <div className={`lg:hidden transition-all duration-300 overflow-hidden ${mobileMenuOpen ? 'max-h-screen' : 'max-h-0'}`}>
        <div className="bg-slate-950/95 backdrop-blur-2xl border-t border-white/5 px-4 py-4 space-y-2">
          {links.map((link) => (
            <a
              key={link.id}
              href={`#${link.id}`}
              onClick={() => handleLinkClick(link.id)}
              className={`flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-all ${
                activeSection === link.id
                  ? 'bg-gradient-to-l from-indigo-600/20 to-purple-600/20 border border-indigo-500/30 text-white'
                  : 'text-slate-400 hover:text-white hover:bg-white/5'
              }`}
            >
              <span className="text-lg">{link.icon}</span>
              <span>{link.label}</span>
            </a>
          ))}
        </div>
      </div>
    </nav>
  );
}
