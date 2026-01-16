
#!/usr/bin/env bash
set -euo pipefail

DIR="${1:-}"
if [[ -z "$DIR" || ! -d "$DIR" ]]; then
  echo "Uso: $0 <carpeta>"
  echo "Ejemplo: $0 etapa_2001_2002/internet/leyLSSI"
  exit 1
fi

echo "Normalizando nombres a minusculas en: $DIR"
echo

# 1) Renombrar directorios (de profundo a superficial)
find "$DIR" -depth -print0 | while IFS= read -r -d '' path; do
  base="$(basename "$path")"
  dirn="$(dirname "$path")"
  lower="$(printf "%s" "$base" | tr '[:upper:]' '[:lower:]')"

  if [[ "$base" != "$lower" ]]; then
    tmp="${dirn}/.__tmp__${lower}"
    # paso intermedio para forzar cambio de case en macOS
    mv "$path" "$tmp"
    mv "$tmp" "${dirn}/${lower}"
    echo "REN: $path -> ${dirn}/${lower}"
  fi
done

echo
echo "Reescribiendo referencias dentro de HTML/HTM (a minusculas)..."
echo

# 2) Reescribir referencias en HTML/HTM a minúsculas para archivos conocidos
# Recorremos todos los archivos (no solo html) para construir lista de nombres reales
# y reemplazamos apariciones case-insensitive en html/htm.
mapfile_list() {
  # bash 3.2 no tiene mapfile, así que volcamos a un archivo temporal
  tmpfile="$(mktemp)"
  find "$DIR" -type f -print > "$tmpfile"
  echo "$tmpfile"
}

FILES_LIST="$(mapfile_list)"

# Para cada fichero real dentro de DIR, sustituye ocurrencias en html/htm
while IFS= read -r f; do
  name="$(basename "$f")"
  lower="$(printf "%s" "$name" | tr '[:upper:]' '[:lower:]')"
  if [[ "$name" == "$lower" ]]; then
    continue
  fi

  # Reemplazo case-insensitive de ese nombre por su versión en minúsculas,
  # solo dentro de html/htm de la carpeta.
  find "$DIR" -type f \( -iname "*.html" -o -iname "*.htm" \) -print0 \
    | xargs -0 perl -pi -e "s/\Q$name\E/$lower/gi"
done < "$FILES_LIST"

rm -f "$FILES_LIST"

echo "OK: nombres y referencias normalizados."
