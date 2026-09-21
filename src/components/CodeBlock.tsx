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
            <div key={i} className="flex">
              <span className="inline-block w-8 text-left text-slate-600 select-none mr-4 text-xs leading-relaxed">
                {i + 1}
              </span>
              <span className="flex-1">
                {highlightSyntax(line, language)}
              </span>
            </div>
          ))}
        </code>
      </pre>
    </div>
  );
}

function highlightSyntax(line: string, language: string): JSX.Element {
  if (language === 'json') {
    // Simple JSON highlighting
    let highlighted = line
      .replace(/("(?:[^"\\]|\\.)*")\s*:/g, '<span class="text-indigo-400">$1</span>:')
      .replace(/:\s*("(?:[^"\\]|\\.)*")/g, ': <span class="text-green-400">$1</span>')
      .replace(/:\s*(\d+)/g, ': <span class="text-amber-400">$1</span>')
      .replace(/:\s*(true|false|null)/g, ': <span class="text-purple-400">$1</span>')
      .replace(/([{}[\],])/g, '<span class="text-slate-500">$1</span>');
    return <span dangerouslySetInnerHTML={{ __html: highlighted }} />;
  }
  
  if (language === 'bash') {
    let highlighted = line
      .replace(/(#.*)$/g, '<span class="text-slate-500">$1</span>')
      .replace(/\b(echo|if|then|fi|else|exit|command|mkdir|cat|chmod)\b/g, '<span class="text-purple-400">$1</span>')
      .replace(/("(?:[^"\\]|\\.)*")/g, '<span class="text-green-400">$1</span>')
      .replace(/(\$[A-Z_]+)/g, '<span class="text-amber-400">$1</span>');
    return <span dangerouslySetInnerHTML={{ __html: highlighted }} />;
  }

  if (language === 'text' || language === 'prompt') {
    let highlighted = line
      .replace(/(`[^`]+`)/g, '<span class="text-indigo-300 bg-indigo-500/10 px-1 rounded">$1</span>')
      .replace(/\b(MUST|ALWAYS|NEVER)\b/g, '<span class="text-red-400 font-bold">$1</span>')
      .replace(/^(\d+\.\s)/g, '<span class="text-amber-400">$1</span>');
    return <span dangerouslySetInnerHTML={{ __html: highlighted }} />;
  }

  return <span>{line}</span>;
}
