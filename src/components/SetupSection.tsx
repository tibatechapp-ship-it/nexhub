import { useState } from 'react';
import CodeBlock from './CodeBlock';
import { useScrollAnimation } from '../hooks/useScrollAnimation';

const setupCode = `#!/bin/bash

# Colors for output
GREEN='\\033[0;32m'
YELLOW='\\033[1;33m'
NC='\\033[0m' # No Color

echo -e "\${GREEN} بدء إعداد بيئة المطور المحلي (Ollama + MCP)...\${NC}"

# 1. التحقق من وجود Ollama
if ! command -v ollama &> /dev/null; then
    echo -e "\${YELLOW}⚠️ Ollama غير مثبت. يرجى تثبيته أولاً من https://ollama.com\${NC}"
    exit 1
fi

# 2. سحب نموذج Qwen Coder
echo -e "\${GREEN}📥 جاري تحميل نموذج Qwen2.5-Coder...\${NC}"
ollama pull qwen2.5-coder:32b

# 3. تثبيت Node.js tools
if ! command -v npx &> /dev/null; then
    echo -e "\${YELLOW}⚠️ Node.js/npx غير موجود. يرجى تثبيت Node.js.\${NC}"
    exit 1
fi

# 4. تثبيت Semgrep
echo -e "\${GREEN}🔒 جاري تثبيت Semgrep للفحص الأمني...\${NC}"
pip install semgrep || pip3 install semgrep

# 5. إنشاء دليل للتكوين
mkdir -p .vscode
echo -e "\${GREEN}✅ تم إنشاء مجلد التكوين.\${NC}"

# 6. إنشاء ملف mcp-config.json تلقائياً
cat > .vscode/mcp-config.json <<EOL
{
  "mcpServers": {
    "ollama-core": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-ollama", "--model", "qwen2.5-coder:32b"],
      "env": {"OLLAMA_HOST": "http://localhost:11434"}
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "."]
    },
    "semgrep-security": {
      "command": "semgrep",
      "args": ["mcp-server"],
      "env": {"SEMGREP_RULES": "p/security-audit"}
    }
  }
}
EOL

echo -e "\${GREEN}✨ اكتمل الإعداد بنجاح!\${NC}"
echo -e "\${YELLOW}الخطوة التالية:\${NC}"
echo "1. افتح VS Code."
echo "2. تأكد من تثبيت إضافة تدعم MCP (مثل Cline أو Roo Code)."
echo "3. وجه الإضافة لاستخدام ملف .vscode/mcp-config.json."
echo "4. ابدأ المحادثة!"`;

export default function SetupSection() {
  const [copied, setCopied] = useState(false);
  const { ref, isVisible } = useScrollAnimation(0.1);

  const handleCopy = () => {
    navigator.clipboard.writeText(setupCode);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <section id="setup" className="py-24 px-4 relative">
      {/* Background accent */}
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-indigo-950/20 to-transparent"></div>
      
      <div ref={ref} className={`relative max-w-6xl mx-auto transition-all duration-1000 ${isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
        {/* Section header */}
        <div className="text-center mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-purple-500/10 border border-purple-500/20 text-purple-300 text-sm mb-4">
            <span>02</span>
            <span>•</span>
            <span>سكربت الإعداد</span>
          </div>
          <h2 className="text-4xl md:text-5xl font-bold mb-4">
            <span className="bg-gradient-to-l from-white to-slate-300 bg-clip-text text-transparent">
              setup-env.sh
            </span>
          </h2>
          <p className="text-slate-400 text-lg max-w-2xl mx-auto">
            سكربت آلي لتثبيت جميع الاعتماديات وتشغيل الخوادم اللازمة بنقرة واحدة
          </p>
        </div>

        {/* What the script does */}
        <div className="grid md:grid-cols-3 gap-4 mb-12">
          {[
            { step: '1', title: 'التحقق', desc: 'يتحقق من وجود Ollama و Node.js', icon: '✅' },
            { step: '2', title: 'التحميل', desc: 'يسحب نموذج Qwen2.5-Coder:32b', icon: '📥' },
            { step: '3', title: 'التثبيت', desc: 'يثبت Semgrep وينشئ ملفات التكوين', icon: '🔧' },
          ].map((item) => (
            <div key={item.step} className="p-5 rounded-xl bg-white/5 border border-white/10 hover:border-purple-500/30 transition-all group">
              <div className="flex items-center gap-3 mb-3">
                <span className="text-2xl">{item.icon}</span>
                <div>
                  <span className="text-xs text-purple-400 font-mono">الخطوة {item.step}</span>
                  <h3 className="font-bold text-white">{item.title}</h3>
                </div>
              </div>
              <p className="text-slate-400 text-sm">{item.desc}</p>
            </div>
          ))}
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
              <span className="text-xs text-slate-400 mr-3 font-mono">setup-env.sh</span>
            </div>
            <button
              onClick={handleCopy}
              className="px-3 py-1 rounded-md bg-white/5 hover:bg-white/10 text-xs text-slate-400 hover:text-white transition-all"
            >
              {copied ? '✅ تم النسخ' : '📋 نسخ'}
            </button>
          </div>
          <CodeBlock code={setupCode} language="bash" />
        </div>

        {/* Run command */}
        <div className="mt-8 flex flex-col sm:flex-row items-center gap-4 justify-center">
          <div className="flex items-center gap-3 px-5 py-3 rounded-xl bg-green-500/10 border border-green-500/20">
            <span className="text-green-400 font-mono text-sm">$</span>
            <code className="text-green-300 font-mono text-sm">chmod +x setup-env.sh && ./setup-env.sh</code>
          </div>
        </div>
      </div>
    </section>
  );
}
