import { useState, useEffect } from 'react';

interface CodeBlockProps {
  code: string;
  language?: string;
}

export default function CodeBlock({ code, language = 'text' }: CodeBlockProps) {
  return (
    <div className="overflow-x-auto p-6" dir="ltr">
      <pre className="text-sm leading-relaxed">
        <code className={`language-${language} text-slate-300 font-mono`}>
          {code.split('\n').map((line, i) => (
            <div key={i} className="flex hover:bg-white/5 transition-colors rounded">
              <span className="inline-block w-8 text-left text-slate-600 select-none mr-4 text-xs leading-relaxed flex-shrink-0">
                {i + 1}
              </span>
              <span className="flex-1">
                {highlightSyntaxSafe(line, language)}
              </span>
            </div>
          ))}
        </code>
      </pre>
    </div>
  );
}

// Safe syntax highlighting without dangerouslySetInnerHTML
function highlightSyntaxSafe(line: string, language: string): JSX.Element {
  if (language === 'json') {
    return <JsonHighlight line={line} />;
  }
  
  if (language === 'bash') {
    return <BashHighlight line={line} />;
  }

  if (language === 'text' || language === 'prompt') {
    return <PromptHighlight line={line} />;
  }

  return <span>{line}</span>;
}

function JsonHighlight({ line }: { line: string }) {
  const parts: JSX.Element[] = [];
  let lastIndex = 0;
  
  // Match JSON patterns
  const patterns = [
    { regex: /("(?:[^"\\]|\\.)*")\s*:/g, className: 'text-indigo-400' },
    { regex: /:\s*("(?:[^"\\]|\\.)*")/g, className: 'text-green-400' },
    { regex: /:\s*(\d+)/g, className: 'text-amber-400' },
    { regex: /:\s*(true|false|null)/g, className: 'text-purple-400' },
    { regex: /([{}[\],])/g, className: 'text-slate-500' },
  ];

  // Simple approach: just color the whole line based on content
  if (line.includes('"') && line.includes(':')) {
    const keyMatch = line.match(/^(\s*"[^"]+")\s*:/);
    if (keyMatch) {
      return (
        <>
          <span className="text-indigo-400">{keyMatch[1]}</span>
          <span className="text-slate-500">:</span>
          <span className="text-green-400">{line.slice(keyMatch[0].length)}</span>
        </>
      );
    }
  }

  if (line.match(/[{}[\],]/)) {
    return <span className="text-slate-500">{line}</span>;
  }

  return <span>{line}</span>;
}

function BashHighlight({ line }: { line: string }) {
  // Comment
  if (line.trim().startsWith('#')) {
    return <span className="text-slate-500">{line}</span>;
  }

  // Commands
  const commands = ['echo', 'if', 'then', 'fi', 'else', 'exit', 'command', 'mkdir', 'cat', 'chmod', 'pip', 'pip3', 'ollama', 'npx'];
  const words = line.split(/\s+/);
  
  return (
    <>
      {words.map((word, i) => {
        if (commands.includes(word)) {
          return <span key={i} className="text-purple-400">{word}{i < words.length - 1 ? ' ' : ''}</span>;
        }
        if (word.startsWith('$')) {
          return <span key={i} className="text-amber-400">{word}{i < words.length - 1 ? ' ' : ''}</span>;
        }
        if (word.startsWith('"') || word.startsWith("'")) {
          return <span key={i} className="text-green-400">{word}{i < words.length - 1 ? ' ' : ''}</span>;
        }
        return <span key={i}>{word}{i < words.length - 1 ? ' ' : ''}</span>;
      })}
    </>
  );
}

function PromptHighlight({ line }: { line: string }) {
  // Backticks
  if (line.includes('`')) {
    const parts = line.split(/(`[^`]+`)/g);
    return (
      <>
        {parts.map((part, i) => {
          if (part.startsWith('`') && part.endsWith('`')) {
            return <span key={i} className="text-indigo-300 bg-indigo-500/10 px-1 rounded">{part}</span>;
          }
          // Keywords
          if (part.match(/\b(MUST|ALWAYS|NEVER)\b/)) {
            return <span key={i} className="text-red-400 font-bold">{part}</span>;
          }
          return <span key={i}>{part}</span>;
        })}
      </>
    );
  }

  // Numbered lists
  if (line.match(/^\d+\.\s/)) {
    return (
      <>
        <span className="text-amber-400">{line.match(/^\d+\.\s/)?.[0]}</span>
        <span>{line.slice(line.match(/^\d+\.\s/)?.[0].length || 0)}</span>
      </>
    );
  }

  return <span>{line}</span>;
}
