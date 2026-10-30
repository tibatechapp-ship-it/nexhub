import { useState, useEffect } from 'react';
import Navigation from './components/layout/Navigation';
import Hero from './components/sections/Hero';
import HowItWorks from './components/sections/HowItWorks';
import Features from './components/sections/Features';
import Setup from './components/sections/Setup';
import Comparison from './components/sections/Comparison';
import Roadmap from './components/sections/Roadmap';
import FAQ from './components/sections/FAQ';
import Footer from './components/layout/Footer';
import ReadingProgress from './components/ui/ReadingProgress';
import ScrollToTop from './components/ui/ScrollToTop';

export default function App() {
  const [activeSection, setActiveSection] = useState('hero');

  useEffect(() => {
    const handleScroll = () => {
      const sections = ['hero', 'how-it-works', 'features', 'setup', 'comparison', 'roadmap', 'faq'];
      const scrollPos = window.scrollY + 200;

      for (let i = sections.length - 1; i >= 0; i--) {
        const el = document.getElementById(sections[i]);
        if (el && el.offsetTop <= scrollPos) {
          setActiveSection(sections[i]);
          break;
        }
      }
    };

    window.addEventListener('scroll', handleScroll, { passive: true });
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <div dir="rtl" className="min-h-screen bg-slate-950 text-white overflow-x-hidden">
      <ReadingProgress />
      <Navigation activeSection={activeSection} setActiveSection={setActiveSection} />
      <Hero />
      <HowItWorks />
      <Features />
      <Setup />
      <Comparison />
      <Roadmap />
      <FAQ />
      <Footer />
      <ScrollToTop />
    </div>
  );
}
