import FadeIn from '../ui/FadeIn';

interface SectionHeaderProps {
  badge?: string;
  title: string;
  subtitle?: string;
  gradient?: 'indigo' | 'purple' | 'pink' | 'green' | 'blue';
}

export default function SectionHeader({ badge, title, subtitle, gradient = 'indigo' }: SectionHeaderProps) {
  const gradients = {
    indigo: 'from-indigo-400 to-purple-400',
    purple: 'from-purple-400 to-pink-400',
    pink: 'from-pink-400 to-rose-400',
    green: 'from-green-400 to-emerald-400',
    blue: 'from-blue-400 to-cyan-400',
  };

  return (
    <FadeIn className="text-center mb-16">
      {badge && (
        <div className={`inline-flex items-center gap-2 px-4 py-2 rounded-full bg-${gradient}-500/10 border border-${gradient}-500/20 text-${gradient}-300 text-sm mb-6`}>
          {badge}
        </div>
      )}
      <h2 className="text-4xl md:text-6xl font-bold mb-6">
        <span className={`bg-gradient-to-l ${gradients[gradient]} bg-clip-text text-transparent`}>
          {title}
        </span>
      </h2>
      {subtitle && (
        <p className="text-slate-400 text-lg md:text-xl max-w-2xl mx-auto leading-relaxed">
          {subtitle}
        </p>
      )}
    </FadeIn>
  );
}
