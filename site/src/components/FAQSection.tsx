import { useState } from 'react';
import { useScrollAnimation } from '../hooks/useScrollAnimation';

interface FAQItem {
  question: string;
  answer: string;
}

const faqData: FAQItem[] = [
  {
    question: 'ما هو MCP ولماذا أحتاجه؟',
    answer: 'MCP (Model Context Protocol) هو بروتوكول مفتوح يسمح للنماذج اللغوية بالتفاعل مع أدوات خارجية بشكل آمن ومنظم. تحتاجه لربط Ollama بأدوات مثل Semgrep و LSP و Filesystem.'
  },
  {
    question: 'هل يمكنني استخدام نموذج آخر غير Qwen2.5-Coder؟',
    answer: 'نعم! يمكنك استخدام أي نموذج متاح على Ollama مثل CodeLlama, DeepSeek Coder, أو StarCoder. فقط غيّر اسم النموذج في ملف mcp-config.json.'
  },
  {
    question: 'ما هي متطلبات الجهاز؟',
    answer: 'للنموذج qwen2.5-coder:32b تحتاج على الأقل 32GB RAM و GPU بذاكرة 24GB+. للنماذج الأصغر مثل 7b أو 14b، تحتاج موارد أقل.'
  },
  {
    question: 'هل يعمل على Windows؟',
    answer: 'نعم، لكن يُفضل Linux/macOS لأداء أفضل. على Windows، يمكنك استخدام WSL2 (Windows Subsystem for Linux) للحصول على تجربة مماثلة.'
  },
  {
    question: 'كيف أضيف أدوات MCP أخرى؟',
    answer: 'أضف قسماً جديداً في mcp-config.json تحت "mcpServers" مع تحديد الأمر والوسائط المطلوبة. تأكد من تثبيت الأداة أولاً.'
  },
  {
    question: 'هل البيانات تبقى محلية؟',
    answer: 'نعم! جميع النماذج والأدوات تعمل محلياً على جهازك. لا يتم إرسال أي بيانات إلى خوادم خارجية، مما يضمن خصوصية كاملة.'
  },
];

export default function FAQSection() {
  const [openIndex, setOpenIndex] = useState<number | null>(null);
  const { ref, isVisible } = useScrollAnimation(0.1);

  return (
    <section id="faq" className="py-24 px-4">
      <div ref={ref} className={`max-w-4xl mx-auto transition-all duration-1000 ${isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
        {/* Section header */}
        <div className="text-center mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-300 text-sm mb-4">
            <span>05</span>
            <span>•</span>
            <span>الأسئلة الشائعة</span>
          </div>
          <h2 className="text-4xl md:text-5xl font-bold mb-4">
            <span className="bg-gradient-to-l from-white to-slate-300 bg-clip-text text-transparent">
              أسئلة شائعة
            </span>
          </h2>
          <p className="text-slate-400 text-lg">
            إجابات على أكثر الأسئلة شيوعاً حول البيئة المحلية
          </p>
        </div>

        {/* FAQ items */}
        <div className="space-y-4">
          {faqData.map((item, index) => (
            <div
              key={index}
              className="rounded-xl bg-white/5 border border-white/10 overflow-hidden hover:border-white/20 transition-all"
            >
              <button
                onClick={() => setOpenIndex(openIndex === index ? null : index)}
                className="w-full px-6 py-5 flex items-center justify-between text-right hover:bg-white/5 transition-colors"
              >
                <span className="font-bold text-white text-lg">{item.question}</span>
                <span
                  className={`text-2xl text-indigo-400 transition-transform duration-300 ${
                    openIndex === index ? 'rotate-45' : ''
                  }`}
                >
                  +
                </span>
              </button>
              <div
                className={`overflow-hidden transition-all duration-300 ${
                  openIndex === index ? 'max-h-96' : 'max-h-0'
                }`}
              >
                <div className="px-6 pb-5 text-slate-400 leading-relaxed">
                  {item.answer}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
