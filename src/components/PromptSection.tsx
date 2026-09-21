import { useState } from 'react';
import CodeBlock from './CodeBlock';
import { useScrollAnimation } from '../hooks/useScrollAnimation';

const promptCode = `You are an expert local software engineer running on a secure environment with Ollama.
Your goal is to write efficient, secure, and clean code.

AVAILABLE TOOLS:
1. \`filesystem\`: Use this to read, write, and list files in the project directory. Always check file existence before editing.
2. \`lsp-bridge\`: Use this to understand code definitions, references, and symbols. Do not guess; ask the LSP server for accurate context.
3. \`semgrep-security\`: BEFORE finalizing any code that handles user input, authentication, or external APIs, you MUST run this tool to check for security vulnerabilities. If issues are found, fix them immediately and re-run the check.

WORKFLOW:
1. Understand the request using \`lsp-bridge\` to get context.
2. Plan the changes briefly.
3. Implement changes using \`filesystem\`.
4. Run \`semgrep-security\` on the modified files.
5. If security checks pass, present the solution. If not, iterate until fixed.

CONSTRAINTS:
- Do not hallucinate file paths. Verify via \`filesystem\`.
- Keep responses concise and focused on the code logic.
- Prioritize security and performance.`;

export default function PromptSection() {
  const [copied, setCopied] = useState(false);
  const { ref, isVisible } = useScrollAnimation(0.1);

  const handleCopy = () => {
    navigator.clipboard.writeText(promptCode);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <section id="prompt" className="py-24 px-4">
      <div ref={ref} className={`max-w-6xl mx-auto transition-all duration-1000 ${isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
        {/* Section header */}
        <div className="text-center mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-pink-500/10 border border-pink-500/20 text-pink-300 text-sm mb-4">
            <span>03</span>
            <span>•</span>
            <span>موجه النظام</span>
          </div>
          <h2 className="text-4xl md:text-5xl font-bold mb-4">
            <span className="bg-gradient-to-l from-white to-slate-300 bg-clip-text text-transparent">
              System Prompt
            </span>
          </h2>
          <p className="text-slate-400 text-lg max-w-2xl mx-auto">
            يوجّه النموذج لاستخدام الأدوات المرفقة بشكل صحيح وآمن
          </p>
        </div>

        {/* Workflow visualization */}
        <div className="mb-12 p-6 rounded-2xl bg-white/5 border border-white/10">
          <h3 className="text-lg font-bold text-white mb-6 text-center">🔄 سير العمل التلقائي</h3>
          <div className="flex flex-wrap items-center justify-center gap-3">
            <div className="flex items-center gap-3">
              <div className="p-3 rounded-xl bg-blue-500/10 border border-blue-500/20 text-center min-w-[100px]">
                <div className="text-xs text-slate-500 mb-1">1</div>
                <div className="text-sm font-bold text-white">فهم الطلب</div>
                <div className="text-xs text-slate-400 font-mono mt-1">lsp-bridge</div>
              </div>
              <span className="text-slate-600 text-lg hidden sm:block">←</span>
            </div>
            <div className="flex items-center gap-3">
              <div className="p-3 rounded-xl bg-purple-500/10 border border-purple-500/20 text-center min-w-[100px]">
                <div className="text-xs text-slate-500 mb-1">2</div>
                <div className="text-sm font-bold text-white">التخطيط</div>
                <div className="text-xs text-slate-400 font-mono mt-1">brief plan</div>
              </div>
              <span className="text-slate-600 text-lg hidden sm:block">←</span>
            </div>
            <div className="flex items-center gap-3">
              <div className="p-3 rounded-xl bg-green-500/10 border border-green-500/20 text-center min-w-[100px]">
                <div className="text-xs text-slate-500 mb-1">3</div>
                <div className="text-sm font-bold text-white">التنفيذ</div>
                <div className="text-xs text-slate-400 font-mono mt-1">filesystem</div>
              </div>
              <span className="text-slate-600 text-lg hidden sm:block">←</span>
            </div>
            <div className="flex items-center gap-3">
              <div className="p-3 rounded-xl bg-pink-500/10 border border-pink-500/20 text-center min-w-[100px]">
                <div className="text-xs text-slate-500 mb-1">4</div>
                <div className="text-sm font-bold text-white">الفحص الأمني</div>
                <div className="text-xs text-slate-400 font-mono mt-1">semgrep</div>
              </div>
              <span className="text-slate-600 text-lg hidden sm:block">←</span>
            </div>
            <div className="flex items-center gap-3">
              <div className="p-3 rounded-xl bg-amber-500/10 border border-amber-500/20 text-center min-w-[100px]">
                <div className="text-xs text-slate-500 mb-1">5</div>
                <div className="text-sm font-bold text-white">التسليم</div>
                <div className="text-xs text-slate-400 font-mono mt-1">solution</div>
              </div>
            </div>
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
              <span className="text-xs text-slate-400 mr-3 font-mono">system-prompt.txt</span>
            </div>
            <button
              onClick={handleCopy}
              className="px-3 py-1 rounded-md bg-white/5 hover:bg-white/10 text-xs text-slate-400 hover:text-white transition-all"
            >
              {copied ? '✅ تم النسخ' : '📋 نسخ'}
            </button>
          </div>
          <CodeBlock code={promptCode} language="prompt" />
        </div>

        {/* Key points */}
        <div className="mt-8 grid md:grid-cols-3 gap-4">
          {[
            { icon: '🔍', title: 'لا تخمين', desc: 'تحقق من المسارات عبر filesystem' },
            { icon: '🛡️', title: 'الأولوية للأمان', desc: 'فحص Semgrep قبل كل تسليم' },
            { icon: '⚡', title: 'إيجاز ودقة', desc: 'ردود مركزة على منطق الكود' },
          ].map((item) => (
            <div key={item.title} className="p-4 rounded-xl bg-white/5 border border-white/10 text-center">
              <div className="text-2xl mb-2">{item.icon}</div>
              <h4 className="font-bold text-white text-sm mb-1">{item.title}</h4>
              <p className="text-slate-400 text-xs">{item.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
