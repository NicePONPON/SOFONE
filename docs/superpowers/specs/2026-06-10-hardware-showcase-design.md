# Hardware Showcase Section — Design

**Date:** 2026-06-10
**Project:** SOFONE landing page (`~/SOFONE`, repo `NicePONPON/SOFONE`)
**Status:** Approved design — pending spec review

## Goal

Add a Hardware Showcase section to the landing page that presents the 4 hardware
models that pair with the Autopos software ecosystem: **autopos ONE, KIOSK,
Table Kiosk (with cash drawer), and XELF II**. The section gives B2B buyers a
clean way to browse hardware and request a quote.

## Placement

- New `<section class="hardware-section" id="hardware">` inserted **between the
  Autopos section (ends line ~455) and the CentrDX section (starts line ~458)**.
- Add a nav entry `nav.hardware` to:
  - the mobile nav (after `#autopos`, line ~109)
  - any desktop/main nav list
  - all 4 translation blocks (`zh-TW`, `en`, `ja`, `vi`)

## Layout (Feature + Sidebar Thumbnails)

```
┌──────────────────────────────────────────────┬───────────────┐
│                                               │ ▣ autopos ONE │  ← active
│         LARGE FEATURED PHOTO                   │ ▢ KIOSK       │
│         (selected hardware)                    │ ▢ Table Kiosk │
│                                               │ ▢ XELF II     │
│  Name · Tagline                               │               │
│  • spec 1   • spec 2                           │               │
│  • spec 3   • spec 4                           │               │
│  [ Request a quote → ]                         │               │
└──────────────────────────────────────────────┴───────────────┘
```

- **Left (~65%):** featured photo + name + tagline + 2–4 spec bullets + CTA
  button linking to `#contact`.
- **Right (~35%):** vertical list of 4 thumbnail tiles. Clicking a tile sets it
  active and swaps the featured panel. **autopos ONE selected by default.**
- **Mobile:** sidebar collapses to a horizontal scrollable row of thumbnails
  above the featured panel (single column).

## Per-hardware behavior

| Model | Featured image | Special behavior |
|-------|---------------|------------------|
| autopos ONE | `assets/demo/webp/autoposone_demo_01.webp` (single representative frame — **not** the full 360° viewer, which already lives in the Autopos section above) | none |
| KIOSK | `assets/KIOSK-1.png` | none (KIOSK-2/3 available as optional secondary thumbs — see open items) |
| Table Kiosk | `assets/White1.png` ⚠ **missing — must be added** | none (White2 secondary) |
| XELF II | `assets/XELFII-3.png` | **inline fan-out** |

### XELF II inline fan-out

- When XELF II is active, the featured image (XELFII-3) shows with a subtle
  "tap to expand" affordance.
- Clicking the main image **fans out XELFII-4, XELFII-5, XELFII-7**: they animate
  outward from the main image with a staggered scale + translate transition
  (~300ms, ~60ms stagger), settling into a row/arc around the main image.
- Clicking the main image again collapses them back.
- Implemented with a toggled CSS class (`.is-expanded`) on the XELF II panel; the
  satellite images use CSS transforms + transition. No JS animation library.

## Content & i18n

Each model gets keys added to all 4 `TRANSLATIONS` blocks:

- `hardware.eyebrow`, `hardware.h2` — section headers
- `hardware.cta` — shared CTA label ("Request a quote" / 預約諮詢 / 見積もり依頼 / Yêu cầu báo giá)
- Per model `<m>` ∈ {`apone`, `kiosk`, `table`, `xelf`}:
  - `hardware.<m>.name`
  - `hardware.<m>.tagline`
  - `hardware.<m>.spec1` … `hardware.<m>.spec4`

Markup uses existing `data-i18n` attributes; `applyTranslations(lang)` already
handles the rest — no JS changes needed for translation.

### Placeholder copy (DRAFT — user to correct real specs)

Chinese-first drafts, matching existing tone. **Specs are placeholders and must
be replaced with real hardware specs before launch.**

- **autopos ONE** — name: `autopos ONE`; tagline: 全能一體式收銀終端;
  specs: 工業級 IP65 防護 · 無段式角度調整 · 全接口底座 · 斷網不斷帳
- **KIOSK** — name: `KIOSK 自助點餐機`; tagline: 立式自助點餐，告別排隊;
  specs: 大尺寸觸控螢幕 · 整合會員與多支付 · 高峰分流 · 可客製外觀
- **Table Kiosk** — name: `桌上型 KIOSK（含現金）`; tagline: 桌面點餐結帳一體機;
  specs: 內建現金抽屜 · 精巧桌面尺寸 · 自助收款 · 適合小型門市
- **XELF II** — name: `XELF II`; tagline: 模組化彈性配置終端;
  specs: 多角度配置 · 模組化擴充 · 精工外型 · 彈性部署

## Implementation outline

1. HTML: new section markup (featured panel + 4 thumb tiles + XELF II satellites)
   inserted after line ~455.
2. CSS: `.hardware-section` styles in `style.css` following existing section
   conventions (`section-inner`, `section-eyebrow`, `section-h2`, `reveal`);
   thumbnail active state; XELF II fan-out transforms.
3. JS: small thumbnail-switch handler (toggle active tile + featured panel) and
   XELF II expand toggle. Plain vanilla, co-located with existing scripts.
4. i18n: add `hardware.*` keys to all 4 translation blocks + `nav.hardware`.
5. Nav: add `#hardware` link to mobile + main nav.

## Out of scope / open items

- **Real spec copy** for all 4 models (placeholders used until provided).
- **White1.png / White2.png** assets must be added to `assets/`.
- Whether KIOSK and Table Kiosk get multi-angle secondary thumbnails (KIOSK-2/3,
  White2) inside their featured panel, or just a single image. Default: single
  image for now; can extend later.
- No 360° viewer duplication for autopos ONE.
