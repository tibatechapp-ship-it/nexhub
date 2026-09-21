import { useState } from 'react';
import FadeIn from '../ui/FadeIn';
import SectionHeader from '../shared/SectionHeader';
import CodeBlock from '../ui/CodeBlock';

const configCode = `{
  "mcpServers": {
    "ollama-core": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-ollama", "--model", "qwen2.5-coder:32b"],
      "env": { "OLLAMA_HOST": "http://localhost:11434" }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/project"]
    },
    "semgrep-security": {
      "command": "semgrep",
      "args": ["mcp-server"],
      "env": { "SEMGREP_RULES": "p/security-audit,p/correctness" }
    }
  }
}`;

const setupCode = `#!/bin/bash
# إعداد بيئة المطور المحلية

# التحقق من Ollama
if ! command -v ollama &> /dev/null; then
    echo "⚠️ Ollama غير مثبت. ثبّته من https://ollama.com"
    exit 1
fi

# تحميل النموذج
ollama pull qwen2.5-coder:32b

# تثبيت Semgrep
pip install semgrep

# إنشاء التكوين
mkdir -p .vscode
echo "✨ اكتمل الإعداد!"`;

const promptCode = `You are an expert local software engineer.
AVAILABLE TOOLS:
1. filesystem: Read, write, list files
2. lsp-bridge: Code analysis
3. semgrep-security: Security checks

WORKFLOW:
1. Understand → 2. Plan → 3. Implement → 4. Check → 5. Deliver`;

export default function Setup() {
  const [activeTab, setActiveTab] = useState<'config' | 'setup' | 'prompt'>('config');
  const [copied, setCopied] = useState(false);

  const handleCopy = (code: string) => {
    navigator.clipboard.writeText(code);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const tabs = {
    config: { label: 'التكوين', icon: '⚙️', code: configCode, lang: 'json' },
    setup: { label: 'الإعداد', icon: '🚀', code: setupCode, lang: 'bash' },
    prompt: { label: 'الموجه', icon: '💬', code: promptCode, lang: 'prompt' },
  };

  const currentTab = tabs[activeTab];

  return (
    <section id="setup" className="py-32 px-4 relative">
      <div className="absolute inset-0 bg-gradient-to-b from-slate-950 via-indigo-950/20 to-slate-950"></div>

      <div className="relative max-w-6xl mx-auto">
        <SectionHeader
          badge="🚀 الإعداد"
          title="ثلاث خطوات للبدء"
          subtitle="كل ما تحتاجه لبدء استخدام البيئة المحلية المحسّنة"
          gradient="green"
        />

        {/* Steps */}
        <FadeIn>
          <div className="grid md:grid-cols-3 gap-6 mb-12">
            {[
              { num: '1', title: 'التشغيل', desc: 'نفّذ سكربت الإعداد', icon: '▶️' },
              { num: '2', title: 'الربط', desc: 'وجّه VS Code للملف', icon: '🔗' },
              { num: '3', title: 'الاستخدام', desc: 'ابدأ المحادثة', icon: '💬' },
            ].map((step) => (
              <div key={step.num} className="p-6 rounded-2xl bg-white/5 border border-white/10 hover:border-white/20 transition-all text-center">
                <div className="text-4xl mb-3">{step.icon}</div>
                <div className="text-xs text-indigo-400 font-mono mb-2">الخطوة {step.num}</div>
                <h3 className="text-lg font-bold text-white mb-2">{step.title}</h3>
                <p className="text-slate-400 text-sm">{step.desc}</p>
              </div>
            ))}
          </div>
        </FadeIn>

        {/* Code tabs */}
        <FadeIn delay={200}>
          <div className="rounded-3xl bg-slate-900/50 border border-white/10 overflow-hidden backdrop-blur-sm">
            {/* Tab buttons */}
            <div className="flex items-center gap-2 p-4 bg-white/5 border-b border-white/5">
              {(Object.keys(tabs) as Array<keyof typeof tabs>).map((key) => (
                <button
                  key={key}
                  onClick={() => setActiveTab(key)}
                  className={`flex items-center gap-2 px-5 py-2.5 rounded-xl text-sm font-medium transition-all ${
                    activeTab === key
                      ? 'bg-gradient-to-l from-indigo-600 to-purple-600 text-white shadow-lg'
                      : 'text-slate-400 hover:text-white hover:bg-white/5'
                  }`}
                >
                  <span>{tabs[key].icon}</span>
                  <span>{tabs[key].label}</span>
                </button>
              ))}
              
              <div className="flex-1"></div>
              
              <button
                onClick={() => handleCopy(currentTab.code)}
                className="px-4 py-2 rounded-xl bg-white/5 hover:bg-white/10 text-xs text-slate-400 hover:text-white transition-all border border-white/10"
              >
                {copied ? '✅ تم' : '📋 نسخ'}
              </button>
            </div>

            {/* Code content */}
            <CodeBlock code={currentTab.code} language={currentTab.lang} />
          </div>
        </FadeIn>

        {/* Warning */}
        <FadeIn delay={300}>
          <div className="mt-8 p-6 rounded-2xl bg-amber-500/5 border border-amber-500/20">
            <div className="flex items-start gap-4">
              <span className="text-3xl">⚠️</span>
              <div>
                <h4 className="font-bold text-amber-300 mb-2">ملاحظة هامة</h4>
                <p className="text-slate-400 leading-relaxed">
                  استبدل <code className="px-2 py-0.5 rounded bg-white/10 text-amber-300 font-mono text-sm">/path/to/project</code> بالمسار الفعلي لمشروعك، 
                  وتأكد من تثبيت <code className="px-2 py-0.5 rounded bg-white/10 text-amber-300 font-mono text-sm">semgrep</code> و <code className="px-2 py-0.5 rounded bg-white/10 text-amber-300 font-mono text-sm">npx</code> مسبقاً.
                </p>
              </div>
            </div>
          </div>
        </FadeIn>
      </div>
    </section>
  );
}
