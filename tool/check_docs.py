#!/usr/bin/env python3
"""حرس الوثائق (خارطة المنتَجة أسبوع 2 — nexhub): وجود + صور + روابط.

يُشغَّل في وظيفة docs ضمن ci.yml: يفشل إن اختفى الدليل السريع، أو أشار
إلى صورة غير موجودة، أو كسر رابطاً نسبياً. لا يتحقق من روابط الإنترنت
(تُفحص يدوياً عند التعديل) — فقط ما في المستودع.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
QUICKSTART = ROOT / "docs" / "quickstart-ar.md"

_MD_LINK = re.compile(r"\[[^\]]+\]\(([^)\s]+)\)")
_IMG = re.compile(r"<img[^>]+src=\"([^\"]+)\"")


def fail(msg: str) -> None:
    print(f"✗ {msg}")
    sys.exit(1)


def resolve(base: Path, target: str) -> Path:
    target = target.split("#", 1)[0]
    if not target:
        return base  # رابط مرساة داخل نفس الملف — سليم
    return (base.parent / target).resolve()


def main() -> int:
    if not QUICKSTART.is_file():
        fail("docs/quickstart-ar.md غير موجود")

    text = QUICKSTART.read_text(encoding="utf-8")

    images = _IMG.findall(text) + [t for t in _MD_LINK.findall(text)
                                   if t.lower().endswith((".png", ".jpg", ".jpeg", ".svg", ".webp"))]
    if not images:
        fail("الدليل «مصوّر» بلا أي صورة — أضف مخططاً أو لقطة حقيقية")
    for img in images:
        p = resolve(QUICKSTART, img)
        if not p.is_file():
            fail(f"صورة مفقودة: {img}")
    print(f"✓ الصور ({len(images)}): كلها موجودة")

    for target in _MD_LINK.findall(text):
        if "://" in target or target.startswith(("#", "mailto:")):
            continue
        p = resolve(QUICKSTART, target)
        if not p.is_file():
            fail(f"رابط نسبي مكسور: {target}")
    print("✓ الروابط النسبية: كلها تُحل")

    for required in ("Releases", "أول Commit", "افتح المجلد", "GitHub"):
        if required not in text:
            fail(f"قسم أساسي مفقود من الدليل: {required}")
    print("✓ الأقسام الأساسية: موجودة")
    print("docs check: PASSED")
    return 0


if __name__ == "__main__":
    sys.exit(main())
