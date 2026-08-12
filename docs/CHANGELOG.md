# Changelog

Session work on the SOFONE landing page (sofone.vercel.app). All changes are live in production via push-to-`main` auto-deploy.

---

## 2026-08-12 — POS terminal swapped to FEC PP-9815WL

Specification-only swap of the first machine in the hardware catalogue, from **FEC PP-9735WL** to **FEC PP-9815WL** (= FEC's catalogue `PP-9815W`, the 15.6" FHD variant). Photos, viewer, layout and CSS all unchanged.

- Model string updated in 18 places: hero alt, lineup card, all 6 viewer frame alts, viewer aria-labels, the eyebrow in 4 language packs, 2 code comments.
- Specs (all 4 languages): 處理器 → `Intel N150`; 記憶體 → `DDR5 8GB/16GB`; 連網 → `Gigabit LAN・Wi-Fi 6E・藍牙 5.2`; 螢幕 dropped 「全平面」; 作業系統 shortened to `Windows 11 IoT`.
- **無風扇 kept** (PP-9815W is in FEC's XPPC Fanless family); **「全平面」/True-Flat dropped** (FEC doesn't use that wording for the 9815); **no capacity ceilings** and **base CPU only** — all three per client decision, deliberately diverging from FEC's page.
- Webfonts re-subset with `--no-hinting` for the new glyphs (藍牙静電容量).
- Naming debt accepted: photos stay at `assets/pp9735/*` and the i18n namespace stays `pp97.*`, since the photography was reused.

Spec: [`2026-08-12-pp9815wl-spec-swap-design.md`](./superpowers/specs/2026-08-12-pp9815wl-spec-swap-design.md). Commits `51e5c01`, `936119b`.

---

## 2026-08-04 — autopos ONE cancelled, replaced by FEC PP-9735WL

_Logged retroactively on 2026-08-12 — this entry was missed at the time._

- autopos ONE removed from the catalogue; replaced by **FEC PP-9735WL** + optional **XM-3010W** 10.1" second display.
- i18n namespace `apone.*` → `pp97.*`; `HW` key / `data-machine` / `data-vis` → `pp97`; `.hw-catalogue` id `apone` → `hardware-catalogue` (old `#apone` deep links no longer scroll). 21 dead keys per language deleted.
- New 6-frame viewer (`assets/pp9735/`), dual-screen shot first, slider `max="5"`.
- `AP_ONE_FRAME_CONFIG` deleted along with its length-guard consumer — the array was read inside `initApOneViewer()`, which drives **all three** hardware viewers, so removing one without the other throws at load.
- 19 orphaned files removed (`autoposone_demo_*`, `dev-360.html`, `dev-power.html`).
- Webfonts re-subset; the shipped subsets were found to have been **already stale for weeks**, silently falling back to a system font for 專拠沈符續背融西談越馬 and others.

Spec: [`2026-08-04-pp9735wl-hardware-swap-design.md`](./superpowers/specs/2026-08-04-pp9735wl-hardware-swap-design.md).

---

## 2026-07-16 — SERVICE + IMSDOM lifecycle, logos, performance

### New content (deck p29/p30)
- **SERVICE 服務保障 section** (before IMSDOM): 5-step onboarding flow (需求訪談 → 方案規劃 → 系統設定/硬體配置 → 教育訓練 → 上線輔導) + indigo guarantee band (安裝僅需1小時 / 業培一體SOP / 上線後不斷線).
- **IMSDOM franchise lifecycle flow** added above the existing feature grid: 招商加盟 → 開店流程 → 營運SOP → 培訓考核 → 巡店稽核 + IMSDOM band with 4 pills.
- Shared `.proc-flow` component (teal steps + chevrons, indigo band); responsive (stacks with down-chevrons on mobile); i18n × 4.

### Logos & graphics
- CentrDX growth cups now show both logos (現在 = CentrDX hexagon + 閃電下單; 未來 = autopos logo); CentrDX product logo → `centrdx-logo.png` (all langs); favicon → `autopos Logo Icon.png` (+ apple-touch-icon).
- Architecture comparison (現有架構 → 統一中控): country tags filled solid + white text.
- Dashboard connector arrows rebuilt as single `clip-path` shapes with flow-pulse animation; **vertical (down/up) on mobile**.
- 已上線 pills fixed to purple (redeclared `--ap` tokens on `.ap-global`).

### Mobile
- Bottom nav: dark-grey `#2d2d2d` bar, pure-white labels; removed ⚡ from 閃電下單.

### Performance (lighter, faster load)
- Loaded PNG screenshots → **resized WebP** (demo_slide + KS-1000 viewer): ~11.6MB → ~628KB (~18×).
- Removed ~**221MB** of unused original images (`assets/demo/*.png` sources, `KS-1000-4.png`, superseded PNGs); working `assets/` folder ~227MB → 5.8MB.
- **Deferred the lottie-player CDN script** (was render-blocking in `<head>`).
- **Lazy-loaded** all below-the-fold images (only 4 hero images stay eager).
- Dropped the unused **Light (300) font weight** + file.

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
