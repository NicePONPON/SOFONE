# SOFONE — i18n / Translation Reference & Audit

_Last reviewed: 2026-06-11_

## Audit result ✅

All four languages are complete and consistent.

| Language | Code | Keys |
|----------|------|------|
| Traditional Chinese | `zh-TW` | 260 |
| English | `en` | 260 |
| Japanese | `ja` | 260 |
| Vietnamese | `vi` | 260 |

- **No missing keys, no extra keys** in any language (verified by diffing key sets against `zh-TW`).
- **No untranslated leftovers.** Three values are intentionally identical across languages and are correct, not bugs:
  - `hero.eyebrow` = `碩豐 SOFONE` — brand name (never translated).
  - `centrdx.growth.now` ja = `現在` — valid Japanese for "now".
  - `autopos.tabs.jp` ja = `日本` — literally "Japan" in Japanese.
- Recent additions (hardware showcase, XELF II, software→hardware bridge, quote-email subject/body) are translated and read naturally in EN/JA/VI.

## How the i18n system works

- Markup: elements carry `data-i18n="key"` (sets `textContent`) or `data-i18n-html="key"` (sets `innerHTML`, used where the value contains `<b>`/`<strong>`).
- `var TRANSLATIONS = { 'zh-TW': {...}, 'en': {...}, 'ja': {...}, 'vi': {...} }` in `index.html`.
- `applyTranslations(lang)` walks the DOM, applies values, and also updates `<title>`, meta description, OG/Twitter tags, the `<html lang>` attribute, the waitress Lottie color variant, and the quote-CTA `mailto:` (per-language subject/body).
- Selected language persists in `localStorage` (`sofone_lang`). Keys are lowercase except `zh-TW`.
- Apply guard is `if (T[key] !== undefined)`, so a missing key falls back to the inline (zh-TW) markup default rather than breaking.

## Keys by section (260 total)

| Prefix | Count | Area |
|--------|-------|------|
| `meta` | 3 | page title + descriptions |
| `nav` | 6 | nav links (incl. `nav.hardware`) |
| `hero` | 5 | hero eyebrow / headline / sub / CTAs |
| `device` | 10 | hero floor-map device tooltips |
| `autopos` | 51 | Autopos software section (pain / solution table / bilingual / strategy) |
| `apone` | 14 | autopos ONE 360° viewer + feature cards |
| `hardware` | 20 | hardware section header, bridge line, autopos ONE & XELF II specs, quote CTA + mail subject/body |
| `xelf` | 13 | XELF II block eyebrow/h3/features + 5 feature cards |
| `centrdx` | 59 | CentrDX section |
| `nubis` | 61 | Nubis section |
| `imsdom` | 16 | IMSDOM section |
| `partners` | 1 | partners heading |
| `contact` | 1 | contact heading |

## Editing / adding translations

1. Add the same key to **all four** language blocks in `index.html` (keep them in sync — that's what keeps the counts equal).
2. Use `data-i18n-html` (not `data-i18n`) if the value contains markup like `<b>`.
3. After editing, re-run the consistency check (parse `TRANSLATIONS`, diff each language's keys against `zh-TW`; expect zero missing/extra).
4. Brand name `autopos` is always lowercase; `SOFONE`/`碩豐 SOFONE` stays as-is across languages.
