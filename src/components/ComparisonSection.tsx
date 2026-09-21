import { useState } from 'react';
import { useScrollAnimation } from '../hooks/useScrollAnimation';

export default function ComparisonSection() {
  const [activeTab, setActiveTab] = useState<'table' | 'details'>('table');
  const { ref, isVisible } = useScrollAnimation(0.1);

  const competitors = [
    {
      name: 'MCP + Ollama (مشروعنا)',
      type: 'بيئة محلية متكاملة',
      privacy: '🟢 كاملة',
      security: '🟢 Semgrep تلقائي',
      mcp: '🟢 دعم كامل',
      setup: '🟡 متوسط',
      cost: '🟢 مجاني',
      strengths: ['خصوصية كاملة', 'فحص أمني تلقائي', 'تكامل MCP', 'تحكم كامل'],
      weaknesses: ['إعداد يدوي', 'يتطلب موارد عالية'],
    },
    {
      name: 'Continue',
      type: 'إضافة VS Code/JetBrains',
      privacy: '🟢 محلية',
      security: '🟡 يدوي',
      mcp: '🟡 محدود',
      setup: '🟢 سهل',
      cost: '🟢 مجاني',
      strengths: ['سهل الإعداد', 'مجتمع كبير', 'autocomplete + chat', 'دعم IDEs متعددة'],
      weaknesses: ['لا فحص أمني تلقائي', 'MCP محدود'],
    },
    {
      name: 'Cline',
      type: 'إضافة VS Code',
      privacy: '🟢 محلية',
      security: '🟡 يدوي',
      mcp: '🟢 ممتاز',
      setup: '🟢 سهل',
      cost: '🟢 مجاني',
      strengths: ['دعم MCP ممتاز', 'Plan/Act modes', '11M+ مستخدم', 'سهل الاستخدام'],
      weaknesses: ['لا فحص أمني تلقائي', 'VS Code فقط'],
    },
    {
      name: 'Roo Code',
      type: 'إضافة VS Code',
      privacy: '🟢 محلية',
      security: '🟡 يدوي',
      mcp: '🟢 ممتاز',
      setup: '🟢 سهل',
      cost: '🟢 مجاني',
      strengths: ['مميزات متقدمة', 'أكواد كبيرة', 'تحكم دقيق', 'نشط التطوير'],
      weaknesses: ['أقل استقراراً', 'VS Code فقط'],
    },
    {
      name: 'Aider',
      type: 'أداة سطر أوامر',
      privacy: '🟢 محلية',
      security: '🟡 يدوي',
      mcp: '🔴 لا',
      setup: '🟢 سهل',
      cost: '🟢 مجاني',
      strengths: ['multi-file refactor', 'git commits تلقائي', 'terminal-first', 'قوي جداً'],
      weaknesses: ['لا IDE', 'لا MCP', 'يتطلب خبرة'],
    },
    {
      name: 'Tabby',
      type: 'خادم ذاتي الاستضافة',
      privacy: '🟢 محلية',
      security: '🟡 يدوي',
      mcp: '🔴 لا',
      setup: '🟡 متوسط',
      cost: '🟢 مجاني',
      strengths: ['للفرق', 'SSO + audit logs', 'autocomplete ممتاز', 'مركزي'],
      weaknesses: ['لا MCP', 'معقد للفرق الصغيرة', 'موارد عالية'],
    },
    {
      name: 'GitHub Copilot',
      type: 'خدمة سحابية',
      privacy: '🔴 سحابي',
      security: '🟡 محدود',
      mcp: '🔴 لا',
      setup: '🟢 سهل جداً',
      cost: '🔴 $19/شهر',
      strengths: ['سهل جداً', 'مدعوم جيداً', 'تكامل GitHub'],
      weaknesses: ['ليس محلي', 'اشتراك شهري', 'بيانات سحابية'],
    },
  ];

  return (
    <section id="comparison" className="py-24 px-4 relative">
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-purple-950/10 to-transparent"></div>
      
      <div ref={ref} className={`relative max-w-7xl mx-auto transition-all duration-1000 ${isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
        {/* Section header */}
        <div className="text-center mb-16">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-purple-500/10 border border-purple-500/20 text-purple-300 text-sm mb-4">
            <span>📊</span>
            <span>المقارنة</span>
          </div>
          <h2 className="text-4xl md:text-5xl font-bold mb-4">
            <span className="bg-gradient-to-l from-white to-slate-300 bg-clip-text text-transparent">
              مقارنة مع المنافسين
            </span>
          </h2>
          <p className="text-slate-400 text-lg max-w-2xl mx-auto">
            كيف يقارن مشروعنا مع الحلول المفتوحة المصدر والمشهورة في السوق
          </p>
        </div>

        {/* Tabs */}
        <div className="flex justify-center gap-2 mb-8">
          <button
            onClick={() => setActiveTab('table')}
            className={`px-6 py-3 rounded-xl font-semibold transition-all ${
              activeTab === 'table'
                ? 'bg-purple-600 text-white shadow-lg shadow-purple-500/25'
                : 'bg-white/5 text-slate-400 hover:bg-white/10'
            }`}
          >
            جدول المقارنة
          </button>
          <button
            onClick={() => setActiveTab('details')}
            className={`px-6 py-3 rounded-xl font-semibold transition-all ${
              activeTab === 'details'
                ? 'bg-purple-600 text-white shadow-lg shadow-purple-500/25'
                : 'bg-white/5 text-slate-400 hover:bg-white/10'
            }`}
          >
            التفاصيل
          </button>
        </div>

        {/* Table view */}
        {activeTab === 'table' && (
          <div className="overflow-x-auto rounded-2xl bg-white/5 border border-white/10 backdrop-blur-sm">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-white/10">
                  <th className="text-right p-4 font-bold text-white">الأداة</th>
                  <th className="text-center p-4 font-bold text-white">النوع</th>
                  <th className="text-center p-4 font-bold text-white">الخصوصية</th>
                  <th className="text-center p-4 font-bold text-white">الأمان</th>
                  <th className="text-center p-4 font-bold text-white">MCP</th>
                  <th className="text-center p-4 font-bold text-white">الإعداد</th>
                  <th className="text-center p-4 font-bold text-white">التكلفة</th>
                </tr>
              </thead>
              <tbody>
                {competitors.map((comp, index) => (
                  <tr
                    key={comp.name}
                    className={`border-b border-white/5 hover:bg-white/5 transition-colors ${
                      index === 0 ? 'bg-indigo-500/10' : ''
                    }`}
                  >
                    <td className="p-4 font-bold text-white">{comp.name}</td>
                    <td className="p-4 text-center text-slate-300">{comp.type}</td>
                    <td className="p-4 text-center">{comp.privacy}</td>
                    <td className="p-4 text-center">{comp.security}</td>
                    <td className="p-4 text-center">{comp.mcp}</td>
                    <td className="p-4 text-center">{comp.setup}</td>
                    <td className="p-4 text-center">{comp.cost}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}

        {/* Details view */}
        {activeTab === 'details' && (
          <div className="grid md:grid-cols-2 gap-6">
            {competitors.map((comp, index) => (
              <div
                key={comp.name}
                className={`p-6 rounded-2xl border backdrop-blur-sm ${
                  index === 0
                    ? 'bg-indigo-500/10 border-indigo-500/30'
                    : 'bg-white/5 border-white/10'
                }`}
              >
                <div className="flex items-start justify-between mb-4">
                  <div>
                    <h3 className="text-xl font-bold text-white mb-1">{comp.name}</h3>
                    <p className="text-slate-400 text-sm">{comp.type}</p>
                  </div>
                  {index === 0 && (
                    <span className="px-3 py-1 rounded-full bg-indigo-500/20 border border-indigo-500/30 text-indigo-300 text-xs font-bold">
                      مشروعنا
                    </span>
                  )}
                </div>

                <div className="space-y-3 mb-4">
                  <div className="flex items-center gap-2">
                    <span className="text-green-400 font-bold">✓</span>
                    <span className="text-slate-300 text-sm">نقاط القوة:</span>
                  </div>
                  <ul className="list-disc list-inside space-y-1 text-slate-400 text-sm mr-6">
                    {comp.strengths.map((s) => (
                      <li key={s}>{s}</li>
                    ))}
                  </ul>
                </div>

                <div className="space-y-3">
                  <div className="flex items-center gap-2">
                    <span className="text-red-400 font-bold">✗</span>
                    <span className="text-slate-300 text-sm">نقاط الضعف:</span>
                  </div>
                  <ul className="list-disc list-inside space-y-1 text-slate-400 text-sm mr-6">
                    {comp.weaknesses.map((w) => (
                      <li key={w}>{w}</li>
                    ))}
                  </ul>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Key insights */}
        <div className="mt-12 p-6 rounded-2xl bg-gradient-to-br from-indigo-500/10 to-purple-500/10 border border-indigo-500/20">
          <h3 className="text-xl font-bold text-white mb-4 flex items-center gap-2">
            <span>💡</span>
            <span>الاستفادة من المنافسين</span>
          </h3>
          <div className="grid md:grid-cols-2 gap-4">
            <div className="p-4 rounded-xl bg-white/5">
              <h4 className="font-bold text-indigo-300 mb-2">من Continue</h4>
              <p className="text-slate-400 text-sm">إضافة autocomplete ذكي لتحسين تجربة المستخدم اليومية</p>
            </div>
            <div className="p-4 rounded-xl bg-white/5">
              <h4 className="font-bold text-purple-300 mb-2">من Cline/Roo Code</h4>
              <p className="text-slate-400 text-sm">تبني نظام Plan/Act modes للعمل المنظم</p>
            </div>
            <div className="p-4 rounded-xl bg-white/5">
              <h4 className="font-bold text-pink-300 mb-2">من Aider</h4>
              <p className="text-slate-400 text-sm">إضافة multi-file refactor و git commits تلقائي</p>
            </div>
            <div className="p-4 rounded-xl bg-white/5">
              <h4 className="font-bold text-green-300 mb-2">من Tabby</h4>
              <p className="text-slate-400 text-sm">دعم الفرق الصغيرة مع إعداد مركزي اختياري</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
