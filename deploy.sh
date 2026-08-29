#!/usr/bin/env bash
# Sincroniza el deck desde el repo TEG y republica en GitHub Pages.
set -euo pipefail
SRC="$HOME/teg/portalasig-teg/teg/presentaciones/defensa"
DST="$HOME/teg/portalasig-defensa"
rsync -av --delete --exclude 'defensa-teg.pdf' --exclude '.git' --exclude 'deploy.sh' --exclude 'README.md' --exclude '.nojekyll' "$SRC"/ "$DST"/
google-chrome --headless=new --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$DST/defensa-teg.pdf" "file://$SRC/index.html" 2>/dev/null
cd "$DST"
git add -A
git -c user.name="Frank Ponte" -c user.email="frank@users.noreply.github.com" \
  commit -m "update: deck $(date '+%Y-%m-%d %H:%M')" || { echo "✔ Sin cambios que publicar"; exit 0; }
git push
echo "✔ Publicado: https://portalasig-microservices.github.io/portalasig-defensa/ (visible en ~1 min)"
