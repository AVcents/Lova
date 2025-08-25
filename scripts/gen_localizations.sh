#!/usr/bin/env bash
set -e
if [ -f l10n.yaml ]; then
  flutter gen-l10n --yaml=l10n.yaml
else
  echo "Aucune config l10n.yaml trouvée. Étape à faire plus tard."
fi