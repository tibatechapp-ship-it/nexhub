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
                {highlightLine(line, language)}
              </span>
            </div>
          ))}
        </code>
      </pre>
    </div>
  );
}

function highlightLine(line: string, language: string): JSX.Element {
  if (language === 'json') {
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
  }
  
  if (language === 'bash') {
    if (line.trim().startsWith('#')) {
      return <span className="text-slate-500">{line}</span>;
    }
    const commands = ['echo', 'if', 'then', 'fi', 'else', 'exit', 'command', 'mkdir', 'cat', 'chmod', 'pip', 'ollama', 'npx'];
    return (
      <>
        {line.split(/\s+/).map((word, i, arr) => {
          const isLast = i === arr.length - 1;
          const space = isLast ? '' : ' ';
          if (commands.includes(word)) {
            return <span key={i} className="text-purple-400">{word}{space}</span>;
          }
          if (word.startsWith('$')) {
            return <span key={i} className="text-amber-400">{word}{space}</span>;
          }
          if (word.startsWith('"') || word.startsWith("'")) {
            return <span key={i} className="text-green-400">{word}{space}</span>;
          }
          return <span key={i}>{word}{space}</span>;
        })}
      </>
    );
  }

  if (language === 'prompt') {
    if (line.includes('`')) {
      const parts = line.split(/(`[^`]+`)/g);
      return (
        <>
          {parts.map((part, i) => {
            if (part.startsWith('`') && part.endsWith('`')) {
              return <span key={i} className="text-indigo-300 bg-indigo-500/10 px-1 rounded">{part}</span>;
            }
            if (part.match(/\b(MUST|ALWAYS|NEVER)\b/)) {
              return <span key={i} className="text-red-400 font-bold">{part}</span>;
            }
            return <span key={i}>{part}</span>;
          })}
        </>
      );
    }
    if (line.match(/^\d+\.\s/)) {
      const match = line.match(/^\d+\.\s/);
      return (
        <>
          <span className="text-amber-400">{match?.[0]}</span>
          <span>{line.slice(match?.[0].length || 0)}</span>
        </>
      );
    }
  }

  return <span>{line}</span>;
}
