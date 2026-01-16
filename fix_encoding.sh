#!/usr/bin/env bash
set -e

# Ignorar carpetas basura de FrontPage
EXCLUDES='-not -path "*/_vti_*/*" -not -path "*/.git/*"'

echo "Probando encoding en un archivo ejemplo..."
sample=$(find . -type f \( -iname "*.htm" -o -iname "*.html" \) $EXCLUDES | head -n 1)
echo "Sample: $sample"

try_convert () {
  enc="$1"
  if iconv -f "$enc" -t UTF-8 "$sample" >/dev/null 2>&1; then
    echo "$enc"
    return 0
  fi
  return 1
}

FROM_ENCODING=""
if try_convert "WINDOWS-1252" >/dev/null; then FROM_ENCODING="WINDOWS-1252"; fi
if [ -z "$FROM_ENCODING" ] && try_convert "ISO-8859-1" >/dev/null; then FROM_ENCODING="ISO-8859-1"; fi

if [ -z "$FROM_ENCODING" ]; then
  echo "ERROR: No puedo determinar encoding origen (WINDOWS-1252 o ISO-8859-1)."
  echo "Abre el sample en VS Code y mira abajo a la derecha que pone."
  exit 1
fi

echo "Usando encoding origen: $FROM_ENCODING"
echo "Convirtiendo todos los HTML/HTM a UTF-8 (ignorando _vti_* )..."

converted=0
failed=0

while IFS= read -r f; do
  tmp="${f}.utf8tmp"
  if iconv -f "$FROM_ENCODING" -t UTF-8 "$f" > "$tmp" 2>/dev/null; then
    mv "$tmp" "$f"
    converted=$((converted+1))
  else
    rm -f "$tmp"
    failed=$((failed+1))
    echo "WARN: iconv fallo en: $f"
  fi
done < <(find . -type f \( -iname "*.html" -o -iname "*.htm" \) $EXCLUDES)

echo "Convertidos a UTF-8: $converted archivos"
echo "Fallos iconv: $failed archivos"

echo "Insertando <meta charset=\"utf-8\"> donde falte..."
while IFS= read -r f; do
  if grep -qi '<meta[^>]*charset' "$f"; then
    continue
  fi
  perl -0777 -i -pe '
    s/(<head\b[^>]*>\s*)/$1<meta charset="utf-8">\n/i
      if !/<meta\s+charset\s*=/i;
  ' "$f"
done < <(find . -type f \( -iname "*.html" -o -iname "*.htm" \) $EXCLUDES)

echo "OK: conversion + meta charset completadas."
