#!/usr/bin/env bash
# ============================================================
# tablet-spacing-fix.sh
# Spustit z rootu projektu: bash tablet-spacing-fix.sh
# ============================================================

set -e

echo "🔧 Opravuji spacing na tabletech..."

# ── 1. HLAVNÍ KONTEJNERY – více horizontálního paddingu na md ──────────────
# Všechny stránky používají  px-6 overflow-hidden
# Změna:  px-6 → px-6 sm:px-8 md:px-12

PAGES=(
  "src/pages/index.astro"
  "src/pages/cenik.astro"
  "src/pages/portfolio.astro"
  "src/pages/o-mne.astro"
  "src/pages/404.astro"
  "src/pages/dekujeme.astro"
  "src/pages/obchodni-podminky.astro"
  "src/pages/ochrana-udaju.astro"
)

for PAGE in "${PAGES[@]}"; do
  if [ -f "$PAGE" ]; then
    # main container
    sed -i 's/\(max-w-6xl 2xl:max-w-7xl mx-auto \)px-6 overflow-hidden/\1px-6 sm:px-8 md:px-12 overflow-hidden/g' "$PAGE"
    # max-w-4xl variant (ochrana-udaju, obchodni-podminky)
    sed -i 's/\(max-w-4xl mx-auto \)px-6 py-/\1px-6 sm:px-8 md:px-12 py-/g' "$PAGE"
    echo "  ✓ $PAGE"
  else
    echo "  ⚠ Nenalezeno: $PAGE"
  fi
done

# objednavka.astro má jiný pattern (má navíc pb-12 pt-20...)
if [ -f "src/pages/objednavka.astro" ]; then
  sed -i 's/\(max-w-6xl 2xl:max-w-7xl mx-auto \)px-6 overflow-hidden pb-12/\1px-6 sm:px-8 md:px-12 overflow-hidden pb-12/g' "src/pages/objednavka.astro"
  echo "  ✓ src/pages/objednavka.astro"
fi

# ── 2. CENÍK – pricing karty: nepřepínat na 3 sloupce dokud není lg ────────
# Na tabletu (md = 768px) jsou 3 ceníkové karty příliš úzké (~224px každá)
# Řešení: grid jde do 3 sloupců až od lg (1024px), ne od md (768px)

if [ -f "src/pages/cenik.astro" ]; then
  sed -i 's/grid grid-cols-1 md:grid-cols-3 gap-6 lg:gap-8/grid grid-cols-1 lg:grid-cols-3 gap-6 lg:gap-8/g' "src/pages/cenik.astro"
  echo "  ✓ cenik.astro – pricing grid → lg:grid-cols-3"
fi

# ── 3. DIVIDER – přidej md mezikrok ────────────────────────────────────────
# py-12 lg:py-16  →  py-12 md:py-14 lg:py-16

if [ -f "src/components/Divider.astro" ]; then
  sed -i 's/py-12 lg:py-16 2xl:py-24/py-12 md:py-14 lg:py-16 2xl:py-24/g' "src/components/Divider.astro"
  echo "  ✓ Divider.astro – přidán md:py-14"
fi

# ── 4. FOOTER – vnější wrapper ─────────────────────────────────────────────
if [ -f "src/components/Footer.astro" ]; then
  sed -i 's/px-4 sm:px-6 pb-4 sm:pb-6/px-4 sm:px-6 md:px-10 pb-4 sm:pb-6 md:pb-8/g' "src/components/Footer.astro"
  echo "  ✓ Footer.astro"
fi

# ── 5. HERO SEKCE – přidej md mezikrok pro vertikální padding ─────────────
# Týká se všech hero sekcí na stránkách (cenik, portfolio, o-mne)
for PAGE in "src/pages/cenik.astro" "src/pages/portfolio.astro" "src/pages/o-mne.astro"; do
  if [ -f "$PAGE" ]; then
    sed -i 's/pt-24 pb-16 lg:pt-32 lg:pb-24/pt-24 md:pt-28 pb-16 md:pb-20 lg:pt-32 lg:pb-24/g' "$PAGE"
  fi
done

# Spodní CTA sekce na stránkách
for PAGE in "src/pages/cenik.astro" "src/pages/portfolio.astro" "src/pages/o-mne.astro" "src/pages/index.astro"; do
  if [ -f "$PAGE" ]; then
    sed -i 's/pb-16 lg:pb-24/pb-16 md:pb-20 lg:pb-24/g' "$PAGE"
  fi
done

echo ""
echo "✅ Hotovo! Změny:"
echo "   • px padding na tabletech: px-6 → px-6 sm:px-8 md:px-12"
echo "   • Ceníkový grid: 3 sloupce od lg (1024px), ne md (768px)"
echo "   • Divider: přidán md:py-14 mezikrok"
echo "   • Footer: přidán md:px-10"
echo "   • Hero/CTA sekce: přidány md: mezikroky pro vertikální padding"
echo ""
echo "Spusť npm run dev a zkontroluj na tabletech."
