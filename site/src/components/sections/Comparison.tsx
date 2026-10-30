import { useState } from 'react';
import FadeIn from '../ui/FadeIn';
import SectionHeader from '../shared/SectionHeader';

export default function Comparison() {
  const [view, setView] = useState<'table' | 'cards'>('table');

  const tools = [
    {
      name: 'MCP + Ollama (مشروعنا)',
      type: 'بيئة محلية متكاملة',
      privacy: '🟢',
      security: '🟢',
      mcp: '🟢',
      setup: '🟡',
      cost: '🟢',
      strengths: ['خصوصية كاملة', 'فحص أمني تلقائي', 'تكامل MCP'],
      weaknesses: ['إعداد يدوي'],
      highlight: true,
    },
    {
      name: 'Continue',
      type: 'إضافة IDE',
      privacy: '🟢',
      security: '🟡',
      mcp: '🟡',
      setup: '🟢',
      cost: '🟢',
      strengths: ['سهل الإعداد', 'مجتمع كبير'],
      weaknesses: ['لا فحص أمني تلقائي'],
      highlight: false,
    },
    {
      name: 'Cline',
      type: 'إضافة VS Code',
      privacy: '🟢',
      security: '🟡',
      mcp: '🟢',
      setup: '🟢',
      cost: '🟢',
      strengths: ['MCP ممتاز', '11M+ مستخدم'],
      weaknesses: ['VS Code فقط'],
      highlight: false,
    },
    {
      name: 'Aider',
      type: 'سطر أوامر',
      privacy: '🟢',
      security: '🟡',
      mcp: '🔴',
      setup: '🟢',
      cost: '🟢',
      strengths: ['multi-file refactor', 'git تلقائي'],
      weaknesses: ['لا IDE', 'لا MCP'],
      highlight: false,
    },
    {
      name: 'GitHub Copilot',
      type: 'خدمة سحابية',
      privacy: '🔴',
      security: '🟡',
      mcp: '🔴',
      setup: '🟢',
      cost: '🔴',
      strengths: ['سهل جداً', 'مدعوم جيداً'],
      weaknesses: ['ليس محلي', '$19/شهر'],
      highlight: false,
    },
  ];

  return (
    <section id="comparison" className="py-32 px-4 relative">
      <div className="absolute inset-0 bg-gradient-to-b from-slate-950 via-purple-950/10 to-slate-950"></div>

      <div className="relative max-w-7xl mx-auto">
        <SectionHeader
          badge="📊 المقارنة"
          title="مقارنة مع المنافسين"
          subtitle="كيف يقارن مشروعنا مع الحلول المفتوحة المصدر والمشهورة"
          gradient="pink"
        />

        {/* View toggle */}
        <FadeIn>
          <div className="flex justify-center gap-3 mb-12">
            <button
              onClick={() => setView('table')}
              className={`px-6 py-3 rounded-xl font-bold transition-all ${
                view === 'table'
                  ? 'bg-gradient-to-l from-indigo-600 to-purple-600 text-white shadow-xl shadow-indigo-500/30'
                  : 'bg-white/5 text-slate-400 hover:bg-white/10 border border-white/10'
              }`}
            >
              📋 جدول
            </button>
            <button
              onClick={() => setView('cards')}
              className={`px-6 py-3 rounded-xl font-bold transition-all ${
                view === 'cards'
                  ? 'bg-gradient-to-l from-indigo-600 to-purple-600 text-white shadow-xl shadow-indigo-500/30'
                  : 'bg-white/5 text-slate-400 hover:bg-white/10 border border-white/10'
              }`}
            >
              🎴 بطاقات
            </button>
          </div>
        </FadeIn>

        {/* Table view */}
        {view === 'table' && (
          <FadeIn>
            <div className="overflow-x-auto rounded-3xl bg-white/5 border border-white/10 backdrop-blur-sm">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-white/10 bg-white/5">
                    <th className="text-right p-5 font-bold text-white text-base">الأداة</th>
                    <th className="text-center p-5 font-bold text-white">النوع</th>
                    <th className="text-center p-5 font-bold text-white">الخصوصية</th>
                    <th className="text-center p-5 font-bold text-white">الأمان</th>
                    <th className="text-center p-5 font-bold text-white">MCP</th>
                    <th className="text-center p-5 font-bold text-white">الإعداد</th>
                    <th className="text-center p-5 font-bold text-white">التكلفة</th>
                  </tr>
                </thead>
                <tbody>
                  {tools.map((tool, index) => (
                    <tr
                      key={tool.name}
                      className={`border-b border-white/5 hover:bg-white/5 transition-colors ${
                        tool.highlight ? 'bg-indigo-500/10' : ''
                      }`}
                    >
                      <td className="p-5">
                        <div className="flex items-center gap-3">
                          {tool.highlight && (
                            <span className="px-2 py-1 rounded-full bg-indigo-500/20 border border-indigo-500/30 text-indigo-300 text-xs font-bold">
                              مشروعنا
                            </span>
                          )}
                          <span className="font-bold text-white">{tool.name}</span>
                        </div>
                      </td>
                      <td className="p-5 text-center text-slate-300">{tool.type}</td>
                      <td className="p-5 text-center text-2xl">{tool.privacy}</td>
                      <td className="p-5 text-center text-2xl">{tool.security}</td>
                      <td className="p-5 text-center text-2xl">{tool.mcp}</td>
                      <td className="p-5 text-center text-2xl">{tool.setup}</td>
                      <td className="p-5 text-center text-2xl">{tool.cost}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </FadeIn>
        )}

        {/* Cards view */}
        {view === 'cards' && (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {tools.map((tool, index) => (
              <FadeIn key={tool.name} delay={index * 100}>
                <div className={`h-full p-6 rounded-3xl border backdrop-blur-sm ${
                  tool.highlight
                    ? 'bg-gradient-to-br from-indigo-500/10 to-purple-500/10 border-indigo-500/30'
                    : 'bg-white/5 border-white/10'
                }`}>
                  <div className="flex items-start justify-between mb-4">
                    <div>
                      <h3 className="text-xl font-bold text-white mb-1">{tool.name}</h3>
                      <p className="text-slate-400 text-sm">{tool.type}</p>
                    </div>
                    {tool.highlight && (
                      <span className="px-3 py-1 rounded-full bg-indigo-500/20 border border-indigo-500/30 text-indigo-300 text-xs font-bold">
                        مشروعنا
                      </span>
                    )}
                  </div>

                  <div className="space-y-3 mb-4">
                    <div className="flex items-center gap-2">
                      <span className="text-green-400 font-bold">✓</span>
                      <span className="text-slate-300 text-sm font-medium">نقاط القوة:</span>
                    </div>
                    <ul className="list-disc list-inside space-y-1 text-slate-400 text-sm mr-6">
                      {tool.strengths.map((s) => <li key={s}>{s}</li>)}
                    </ul>
                  </div>

                  <div className="space-y-3">
                    <div className="flex items-center gap-2">
                      <span className="text-red-400 font-bold">✗</span>
                      <span className="text-slate-300 text-sm font-medium">نقاط الضعف:</span>
                    </div>
                    <ul className="list-disc list-inside space-y-1 text-slate-400 text-sm mr-6">
                      {tool.weaknesses.map((w) => <li key={w}>{w}</li>)}
                    </ul>
                  </div>
                </div>
              </FadeIn>
            ))}
          </div>
        )}

        {/* Insights */}
        <FadeIn delay={400}>
          <div className="mt-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-500/10 to-purple-500/10 border border-indigo-500/20">
            <h3 className="text-2xl font-bold text-white mb-6 flex items-center gap-3">
              <span className="text-3xl">💡</span>
              <span>الاستفادة من المنافسين</span>
            </h3>
            <div className="grid md:grid-cols-2 gap-4">
              {[
                { from: 'Continue', what: 'إضافة autocomplete ذكي' },
                { from: 'Cline/Roo Code', what: 'نظام Plan/Act modes' },
                { from: 'Aider', what: 'multi-file refactor و git تلقائي' },
                { from: 'Tabby', what: 'دعم الفرق الصغيرة' },
              ].map((item) => (
                <div key={item.from} className="p-4 rounded-xl bg-white/5">
                  <h4 className="font-bold text-indigo-300 mb-2">من {item.from}</h4>
                  <p className="text-slate-400 text-sm">{item.what}</p>
                </div>
              ))}
            </div>
          </div>
        </FadeIn>
      </div>
    </section>
  );
}
