import { useState, useEffect } from 'react';
import Hero from './components/Hero';
import Navigation from './components/Navigation';
import FeaturesSection from './components/FeaturesSection';
import ConfigSection from './components/ConfigSection';
import SetupSection from './components/SetupSection';
import PromptSection from './components/PromptSection';
import StepsSection from './components/StepsSection';
import FAQSection from './components/FAQSection';
import Footer from './components/Footer';
import ReadingProgress from './components/ReadingProgress';
import ScrollToTop from './components/ScrollToTop';

export default function App() {
  const [activeSection, setActiveSection] = useState('hero');

  useEffect(() => {
    const handleScroll = () => {
      const sections = ['hero', 'config', 'setup', 'prompt', 'steps', 'faq'];
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
    <div dir="rtl" className="min-h-screen bg-gradient-to-br from-slate-950 via-slate-900 to-indigo-950 text-white" style={{ fontFamily: "'Segoe UI', Tahoma, Arial, sans-serif" }}>
      <ReadingProgress />
      <Navigation activeSection={activeSection} setActiveSection={setActiveSection} />
      <Hero />
      <FeaturesSection />
      <ConfigSection />
      <SetupSection />
      <PromptSection />
      <StepsSection />
      <FAQSection />
      <Footer />
      <ScrollToTop />
    </div>
  );
}
