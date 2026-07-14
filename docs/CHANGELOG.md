# Changelog

Session work on the SOFONE landing page (sofone.vercel.app). All changes are live in production via push-to-`main` auto-deploy.

---

## 2026-07-14 — autopos section redesign (deck theme)

Full redesign of the autopos section + hardware presentation to match the `2026 autopos 門店數位化解決方案簡報` deck.

### Design system
- Light theme: `#FFFFFC` background across all sections (no gradients); indigo `#4632C6` structural accent, teal `#2BB89A` positive stats, normal text `#5E5E5E`.
- Two-tone headings (dark body + `.hl` indigo emphasis); **Taipei Sans TC Beta** font (subset woff2 in `assets/fonts/`).

### Content
- **Credibility proof strip** under the hero (stats + named clients).
- **現有架構 → AUTOPOS 統一中控** comparison: country tags filled solid + white text for visibility.
- **GLOBAL 全球化支援** umbrella section (below the dashboard) combining multilingual UI (雙語無痛切換), in-country compliance (彈性稅率/海外電子發票/小票稅率明細 + 越南·馬來西亞·新加坡 已上線 in purple), and delivery+payment integrations. i18n in all 4 languages.

### Solution dashboard (solmap)
- `assets/demo_slide/` module screenshots in the expand panel.
- Panel layouts: 50/50 photo-left + one-line points; 外送整合 = wide full-width photo (no points); 多元支付 + IMSDOM 4 = no photo, points in one row; frames hug each image's true aspect ratio.
- Column titles use the autopos logo. Connector arrows = single `clip-path` shape with travelling-pulse flow animation; **vertical (down/up) on mobile** where columns stack.

### Hardware catalogue
- The 3 machines (autopos ONE / XELF II / KS-1000) folded into a click-to-expand catalogue with dashboard-style panels; panels keep the original interactive viewers (autopos ONE 360° spin, XELF II frameless assemble, KS-1000 drag-scrub) + key specs + CTA. XELF II card uses `XELFII-2.webp`.

### Logos & mobile
- `autopos-logo.png` (black wordmark) for section header, dashboard titles, CentrDX growth 未來 cup; CentrDX product logo → `centrdx-logo.png` (hexagon), all langs.
- Mobile bottom nav: dark-grey `#2d2d2d` bar, pure-white labels (active = light indigo); removed ⚡ from 閃電下單 nav label.
- CentrDX headline uses spaced hyphen (`極簡出餐 - 三件事`).

---

## 2026-06-24 — Hardware spec unification, mobile polish & fixes

### Unified spec format across all hardware blocks
- **autopos ONE, XELF II and KS-1000 now share one icon-grid spec style** (`.ks-specs-grid` / `.ks-spec*`): small icon + label + 1–2 line value. (`0b358d2`)
  - autopos ONE: 11 tiles (OS / 螢幕 / 觸控 / 處理器 / 記憶體 / 儲存 / 連網 / I/O / 工作溫度 / 尺寸 / 第二螢幕), from the POS-X6 spec sheet.
  - XELF II: 7 tiles (螢幕 / 配置 / 整合 / 機身 / 擴充 / 形態 / 認證).
  - KS-1000: dropped the 14-row detail table — icon grid only.
  - Replaced the old paragraph bullets; new `apone.spec.*` / `xelf.spec.*` i18n keys in all 4 languages, removed `hardware.*.spec*` and `ks.row.*`.
- **Compacted KS-1000 spec values to 1–2 lines** so its grid matches the others. (`4722fa0`)
  - OS → `Windows · Ubuntu · Android`; CPU → `ARM～14 代 i7（三階可選）`; 觸控 → `多點觸控電容`; 支付 → `現金收付＋多元電子支付`; 尺寸 → `337×380×630 / 731mm`.
  - Note: dropped OS versions, CPU mid-tier (N150), and per-size dimensions for brevity.
- **Added a 預約 Demo CTA under autopos ONE** (it was the only block without one); links to `#contact`. (`2b7ffed`)
- **Added autopos ONE second-display spec** — 10" 1280×800 **non-touch** customer display (specify at purchase, no retrofit), all 4 languages. (`d65f247`)

### Mobile & layout polish
- **2 spec tiles per row on mobile** (was single column once values became terse). (`3c32e71`, earlier `c7a6858` / `d8ab457`)
- **`(...)`/`（...）` qualifiers wrap to their own line** in every spec tile (e.g. `DDR4 8G` / `（最大 16G）`), via a pass in `applyTranslations` + `.spec-paren`. Works in all 4 languages. (`71377eb`)

### Fixes
- **Mobile bottom nav stayed fixed on scroll.** `<body>` had `overflow-x: hidden`, which on mobile makes the body a scroll container and breaks `position: fixed` (nav drifted to mid-screen). Switched to `overflow-x: clip`. (`cf9c6c2`)

---

## 2026-06-23 — KS-1000 showcase block

- **Added the KS-1000「全場域整合智助機」hardware block** inside `#hardware`, after XELF II (Traditional Chinese). (`ed26586`)
  - Autopos-ONE-style scrub viewer cycling 7 product photos (KS-1000-1,2,3,5,6,7,8); the viewer JS was generalized to drive both viewers.
  - Spec icon grid, 搭配 autopos pairing + metric chips, 空間效益 comparison (KS-1000-4), 預約 Demo CTA.
  - Status copy = 即將上市 / 開放預約導入 (mass production expected 2026/12).
  - Viewer photos trimmed to content; comparison image de-framed and re-exported (FEC branding removed).
- **Translated the KS-1000 block to EN / JA / VI** — 61 `ks.*` keys × 4 packs; Taiwan payment terms localized (悠遊卡/一卡通 → EasyCard/iPASS, 街口/全支付 → JKOPAY/PXPay, 健保卡 → NHI / BHYT). (`ae539de`)

---

## 2026-06-22 — Nubis removal

- **Removed the Nubis & Nubis Cast section entirely** — HTML section, mobile-nav link, JSON-LD product entry + org description, all `nubis.*` / `nav.nubis` i18n keys (4 langs), dead `.nubis-*` / `.hotspot*` CSS and JS, 4 orphaned image assets, and the docs audit table. Hero waitress tooltip rewritten to IMSDOM-only. (`a492d21`)

---

## i18n status

The TRANSLATIONS object stays key-consistent across all 4 languages (`zh-TW` / `en` / `ja` / `vi`); every `data-i18n` key resolves in every language. See [i18n-translations.md](i18n-translations.md) for the per-section key audit. Current total: **256 keys × 4**.
