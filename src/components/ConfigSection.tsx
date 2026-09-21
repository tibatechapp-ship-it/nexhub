import { useState } from 'react';
import CodeBlock from './CodeBlock';
import { useScrollAnimation } from '../hooks/useScrollAnimation';

const configCode = `{
  "mcpServers": {
    "ollama-core": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-ollama",
        "--model",
        "qwen2.5-coder:32b"
      ],
      "env": {
        "OLLAMA_HOST": "http://localhost:11434"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/path/to/your/project/root"
      ]
    },
    "lsp-bridge": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-lsp",
        "--language",
        "typescript"
      ],
      "note": "كرر هذا القسم لكل لغة تستخدمها"
    },
    "semgrep-security": {
      "command": "semgrep",
      "args": ["mcp-server"],
      "env": {
        "SEMGREP_RULES": "p/security-audit,p/correctness"
      }
    }
  }
}`;

export default function ConfigSection() {
  const [copied, setCopied] = useState(false);
  const { ref, isVisible } = useScrollAnimation(0.1);

  const handleCopy = () => {
    navigator.clipboard.writeText(configCode);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <section id="config" className="py-24 px-4">
      <div ref={ref} className={`max-w-6xl mx-auto transition-all duration-1000 ${isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
        {/* Section header */}
        <div className="text-center mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-indigo-500/10 border border-indigo-500/20 text-indigo-300 text-sm mb-4">
            <span>01</span>
            <span>•</span>
            <span>ملف التكوين</span>
          </div>
          <h2 className="text-4xl md:text-5xl font-bold mb-4">
            <span className="bg-gradient-to-l from-white to-slate-300 bg-clip-text text-transparent">
              mcp-config.json
            </span>
          </h2>
          <p className="text-slate-400 text-lg max-w-2xl mx-auto">
            العصب المركزي — يربط VS Code بـ Ollama وأدوات LSP و Semgrep
          </p>
        </div>

        {/* Config cards */}
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4 mb-12">
          <div className="p-5 rounded-xl bg-indigo-500/5 border border-indigo-500/20 hover:border-indigo-500/40 transition-all">
            <div className="text-3xl mb-3">🦙</div>
            <h3 className="font-mono text-sm font-bold text-white mb-1">ollama-core</h3>
            <p className="text-slate-400 text-sm">النموذج اللغوي المحلي</p>
          </div>
          <div className="p-5 rounded-xl bg-amber-500/5 border border-amber-500/20 hover:border-amber-500/40 transition-all">
            <div className="text-3xl mb-3">📁</div>
            <h3 className="font-mono text-sm font-bold text-white mb-1">filesystem</h3>
            <p className="text-slate-400 text-sm">الوصول لنظام الملفات</p>
          </div>
          <div className="p-5 rounded-xl bg-blue-500/5 border border-blue-500/20 hover:border-blue-500/40 transition-all">
            <div className="text-3xl mb-3">🧠</div>
            <h3 className="font-mono text-sm font-bold text-white mb-1">lsp-bridge</h3>
            <p className="text-slate-400 text-sm">تحليل الكود والرموز</p>
          </div>
          <div className="p-5 rounded-xl bg-pink-500/5 border border-pink-500/20 hover:border-pink-500/40 transition-all">
            <div className="text-3xl mb-3">🔒</div>
            <h3 className="font-mono text-sm font-bold text-white mb-1">semgrep-security</h3>
            <p className="text-slate-400 text-sm">الفحص الأمني التلقائي</p>
          </div>
        </div>

        {/* Code block */}
        <div className="relative rounded-2xl overflow-hidden border border-white/10 bg-slate-900/50 backdrop-blur-sm">
          <div className="flex items-center justify-between px-4 py-3 bg-white/5 border-b border-white/5">
            <div className="flex items-center gap-2">
              <div className="flex gap-1.5">
                <div className="w-3 h-3 rounded-full bg-red-500/80"></div>
                <div className="w-3 h-3 rounded-full bg-yellow-500/80"></div>
                <div className="w-3 h-3 rounded-full bg-green-500/80"></div>
              </div>
              <span className="text-xs text-slate-400 mr-3 font-mono">mcp-config.json</span>
            </div>
            <button
              onClick={handleCopy}
              className="px-3 py-1 rounded-md bg-white/5 hover:bg-white/10 text-xs text-slate-400 hover:text-white transition-all"
            >
              {copied ? '✅ تم النسخ' : '📋 نسخ'}
            </button>
          </div>
          <CodeBlock code={configCode} language="json" />
        </div>

        {/* Important note */}
        <div className="mt-8 p-5 rounded-xl bg-amber-500/5 border border-amber-500/20">
          <div className="flex items-start gap-3">
            <span className="text-2xl">⚠️</span>
            <div>
              <h4 className="font-bold text-amber-300 mb-1">ملاحظة هامة</h4>
              <p className="text-slate-400 text-sm leading-relaxed">
                استبدل <code className="px-2 py-0.5 rounded bg-white/10 text-amber-300 font-mono text-xs">/path/to/your/project/root</code> بالمسار الفعلي لمشروعك، 
                وتأكد من تثبيت <code className="px-2 py-0.5 rounded bg-white/10 text-amber-300 font-mono text-xs">semgrep</code> و <code className="px-2 py-0.5 rounded bg-white/10 text-amber-300 font-mono text-xs">npx</code> مسبقاً.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
