# autopos 全場景解決方案 — Interactive Solution Map — Design

**Date:** 2026-07-07
**Status:** Approved (prototype validated)
**Prototype:** https://claude.ai/code/artifact/bbc09287-d409-4663-9e06-00db23a12fb6

## Goal

Bring the logic and content of the comprehensive `2026 autopos介紹(Chris)` deck (31 slides,
~20 feature modules) into the live SOFONE site, without ballooning the landing page. The deck's
spine is slide 4 — the 全場景解決方案 architecture map (前台管理 門市 → 一鍵派發設定 →
中台管理 autopos Cloud → IMSDOM). We turn that map into a **single interactive centerpiece**
inside the existing Autopos section: a clickable diagram where each of the 20 module nodes
expands to reveal that module's headline, value bullets, a hero stat, and a real product image
pulled from the deck.

This lets the website carry the full autopos product tour that today only exists as a PDF.

## Source material

- **Deck (content):** `~/Library/Mobile Documents/com~apple~CloudDocs/SOFONE/公司基本資料/軟體資料/autopos/2026 autopos介紹(Chris).pdf` (31 pages).
- **Deck (assets, higher-res):** the sibling `.key` file is a zip; `Data/` holds full-resolution
  original PNGs. Prefer these where identifiable; fall back to per-slide PDF extraction
  (`pdfimages`) otherwise. `poppler` + `cwebp` are installed locally.
- All zh-TW copy in this spec is transcribed from the deck.

## Decisions (locked)

| Axis | Decision |
|------|----------|
| **Form** | Interactive solution map, inside the current Autopos section (no new page). |
| **Visual** | "Light inset" — a white spotlight band holding the autopos-purple map (mirrors slide 4), embedded in the dark navy section. |
| **Panel visual** | Real deck images extracted → WebP, paired with rebuilt translatable text. |
| **Placement** | Map **replaces** the existing 3-col solution table (`.ap-solution` / `.ap-sol-table`). chaos→unified stays as intro; globe stays as the global-reach closer. |
| **Node depth** | All 20 nodes get a full detail panel (前台 10 + 中台 6 + IMSDOM 4). |
| **i18n** | zh-TW built first; en/ja/vi in a follow-up pass. Keys exist in all 4 packs from day one. |
| **Panel placement (from prototype)** | Docked panel below the map, inside the same white band (not a modal). Confirmed via prototype. |

## Placement & DOM change

Inside `<section class="autopos-section" id="autopos">` (index.html), the block
`<div class="ap-solution reveal">…<table class="ap-sol-table">…` (currently ~line 262) is
**removed in full** and replaced by the new map component. Everything else in the section
(chaos→unified intro above it; strategic-value + globe below it) is untouched.

**Cleanup that ships with the replacement:**
- Remove the `.ap-sol-*` CSS rules that become dead (`.ap-solution`, `.ap-sol-h3`,
  `.ap-sol-table-wrap`, `.ap-sol-table`, `.ap-sol-dim/desc/val/icon`).
- Remove the now-orphaned i18n keys `autopos.sol.h3` and `autopos.sol.r1..r4.{dim,sol,val}`
  from all 4 language packs.

## The map component

A white rounded band (`.solmap-band`) set into the dark section, with a faint world-map
watermark. CSS grid: `[前台 col] [connectors] [中台 col]`.

- **前台管理 · 門市** card — autopos wordmark; a 2-col grid of 10 node pills:
  收銀點餐 · 自助點餐 · 手機點餐 · 會員行銷 · 取餐叫號 · 行動報表 · 電視菜單 · 外送整合 · 電子發票 · 多元支付
- **Connectors** — two chevron bars between the cards: `一鍵派發設定` (→ top) and
  `資料自動上傳` (← bottom).
- **中台管理 · autopos Cloud · 資訊總部指揮中心** card — a 3-col grid of 6 node pills:
  門店中心 · 商品中心 · 會員管理 · 訂單中心 · 行銷中心 · 權限管理;
  with a nested dark-purple **IMSDOM · 人員總部指揮中心（增值方案）** sub-band holding 4 nodes:
  招商簽約 · 開店籌建 · 培訓考核 · 巡店稽核.
- Each node is a `<button>` (icon + label), keyboard-focusable. All 20 are interactive.

## Interaction & panel

- Clicking a node sets it active (purple fill) and opens the detail panel docked directly
  below the map inside the band; the panel `scrollIntoView({block:'nearest'})`.
- Only one panel open at a time; clicking another node swaps content in place.
- Close via a `×` button or `Esc`; closing clears the active node and restores the
  "點任一模組展開細節" hint.
- `prefers-reduced-motion`: skip the rise animation.

**Panel content model (per node):**
`eyebrow` (category) · two-tone `headline` · one-line `subhead` · optional `hero stat`
(only where the deck states one) · 3–4 `icon bullets` (label + one line) · 1 `product image`.
Nodes whose deck story spans multiple slides (收銀點餐 = 樂高介面 + 彈性票據; 會員管理 = 3 slides)
merge their bullets into one panel.

## Data model & i18n scheme

Rendering is data-driven — adding a node = adding a data entry, no bespoke markup:

```js
const AUTOPOS_MODULES = {
  front: [ { id:'pos', icon:'cash', img:'pos', hasStat:true }, … ],   // 10
  mid:   [ { id:'shopctr', icon:'store', img:'shopctr' }, … ],        // 6
  ims:   [ { id:'recruit', icon:'hand', img:'recruit' }, … ]          // 4
};
```

- `icon` → a key into a small inline-SVG icon dictionary (Feather/Lucide style, matching the
  site's existing `stroke-width:1.6` convention).
- Text comes through the existing `data-i18n` machinery. Key scheme per node:
  `solmap.<id>.title` (may contain `<em>` → use `data-i18n-html`), `.sub`, `.stat`, `.statlabel`,
  `.b1t/.b1d … .b4t/.b4d`. Category eyebrows reuse three shared keys
  `solmap.cat.front/mid/ims`.
- Roughly **~160 new keys**, defined in all 4 packs. zh-TW filled first; en/ja/vi keys present
  but empty at first → the existing applyTranslations fallback keeps zh-TW showing (verify
  fallback behavior; if empty string blanks the node, seed en/ja/vi with the zh-TW value as a
  temporary fallback so no node renders blank).

## Canonical module content (zh-TW)

Authoritative copy, transcribed from the deck (same content proven in the prototype).
`stat` shown only where listed.

### 前台管理（門市）
| id | 節點 | headline | stat | bullets (title — desc) |
|----|------|----------|------|------------------------|
| pos | 收銀點餐 | 樂高式收銀介面 **上手快 好維護** | 80% 教育訓練成本降低 | 積木式版型／多型態收銀／彈性票據／廚房票據多語 |
| kiosk | 自助點餐 | Kiosk 自助點餐 **分流尖峰 解放人力** | 30% 尖峰排隊縮短 | 自助下單付款／多元收款／自動送單廚房／客單價提升 |
| mobile | 手機點餐 | 掃碼即點 **免下載 免等待** | — | 即掃即點／與現場一致／綁定會員閉環 |
| crm | 會員行銷 | 把會員 **變成回購與口碑** | — | 開發新客／提高客單價／老客回購 |
| call | 取餐叫號 | 取餐叫號 **尖峰也井然有序** | — | 自動叫號通知／廚房串接／看板同步 |
| report | 行動報表 | 隨時隨地 **掌握營運數據** | — | 即時掌握／主動預警／多維報表 |
| tv | 電視菜單 | 顧客第二屏 **選單金額看得清** | — | 10 吋客顯／金額同步／電視輪播／待機不浪費 |
| delivery | 外送整合 | 外送訂單 **自動進單免轉單** | — | 自動進單／免人工轉單／同步廚房／數據回歸總部 |
| invoice | 電子發票 | 結帳即開 **電子發票零負擔** | — | 結帳即開立／載具與歸戶／雲端管理 |
| pay | 多元支付 | 現金到行動支付 **一機收好收滿** | — | 一機收款／多元票證／對帳準確 |

### 中台管理（autopos Cloud）
| id | 節點 | headline | stat | bullets |
|----|------|----------|------|---------|
| shopctr | 門店中心 | 連鎖總部 **集團化統一管理** | — | 集團化管理／權限分層／全球數據接管 |
| goods | 商品中心 | 商品更動一次設定 **全通路同步** | — | 屬性彈性組合／全通路同步／批次匯入匯出 |
| member | 會員管理 | 任意組合 **精準分眾行銷** | 20/80 高價值會員創造 8 成利潤 | 多維度輪廓(9+7+13)／全通路推送／分眾精準／經營可預期 |
| order | 訂單中心 | 全通路訂單 **一個後台管理** | — | 全通路接單／查詢再利用／異常監控 |
| promo | 行銷中心 | 結帳當下 **順手再多賣一筆** | — | 自動套用／疊加可設限／即時折抵／自動上下架 |
| role | 權限管理 | 角色分層 **加盟直營各司其職** | — | 角色權限分層／加盟直營區隔／資料更安全 |

### IMSDOM（人員總部指揮中心 · 增值方案）
| id | 節點 | headline | bullets |
|----|------|----------|---------|
| recruit | 招商簽約 | 招商加盟 **標準化簽約** | 招商流程／合約管理／快速複製 |
| open | 開店籌建 | 開店籌建 **展店流程有 SOP** | 籌建任務／進度追蹤／經驗沉澱 |
| train | 培訓考核 | 培訓考核 **品質一致可複製** | 線上培訓／考核認證／品質一致 |
| audit | 巡店稽核 | 巡店稽核 **展店標準不走樣** | 巡店表單／問題追蹤／數據回報 |

(Full bullet descriptions live in the prototype's `M` data object; carried verbatim into i18n.)

## Asset pipeline

- Target: `assets/sol/webp/<id>.webp` — one image per node (20 total).
- Source priority: (1) full-res original from the `.key` `Data/` folder where the filename maps
  cleanly; (2) else `pdfimages -png` on the module's slide, pick the largest non-icon image and
  its `smask` for transparency; (3) crop from a 200-dpi rendered slide if neither is clean.
- Encode with `cwebp -q 78`, width ~320–480 depending on aspect. Keep each < ~40 KB.
- **Node → slide map** (for extraction): pos→6, kiosk→11, mobile→7, crm→14, call→8, report→15,
  tv→9, delivery→16, invoice→10, pay→17, shopctr→18, goods→19, member→20/21, order→22, promo→23,
  role→24, recruit/open/train/audit→30 (IMSDOM slide; may share one composite or crop regions).
  (Slide numbers to be confirmed during extraction; content is the source of truth.)
- **All images committed to git before pushing** — untracked assets 404 in prod (working dir is
  not what deploys).

## Visual system

Reuse the site's `:root` tokens (`--c-bg #0d1f2d`, `--c-accent #6ACCAC`, `--c-surface-2`, radii)
and add an autopos-purple sub-palette scoped to the map:

```css
--ap:#5646c9; --ap-ink:#372b8f; --ap-deep:#2c2170;
--ap-soft:#f1effc; --ap-border:#d9d3f4; --ap-slate:#3a3653; --ap-mut:#6f6a88;
```

- The white band is a deliberate single-purpose light surface; the purple is the one place
  autopos's own brand color enters the otherwise navy/teal site. Teal stays for site chrome.
- Icons follow the existing SVG convention (`fill=none stroke=currentColor stroke-width~1.6/1.7`,
  round caps/joins), colored `var(--ap)`.
- Typography: the site's existing font stack (CJK via system `PingFang TC` / `Noto Sans TC`).

## Mobile

Below ~820px the map collapses to a single stacked column grouped by 前台 / 中台 / IMSDOM;
the connectors rotate to horizontal dividers. Tapping a node expands its panel inline
(accordion) rather than a docked overlay. Bullets go single-column.

## Accessibility

- Nodes are real `<button>`s with visible `:focus-visible` outline; panel is a
  `role="region" aria-live="polite"`; `×` has an `aria-label`.
- `Esc` closes; focus returns to the last active node.
- Respect `prefers-reduced-motion`.

## Build phases

1. **Assets** — extract + optimize the 20 images into `assets/sol/webp/`.
2. **Static map** — build `.solmap-*` markup + CSS, replace `.ap-solution`, remove dead
   `.ap-sol-*` CSS + `autopos.sol.*` keys; responsive.
3. **Panels (zh-TW)** — `AUTOPOS_MODULES` data, render + interaction (click / Esc / mobile
   accordion), all 20 panels wired, i18n keys seeded in all 4 packs (zh-TW filled).
4. **Translations** — en / ja / vi copy in a follow-up commit.

Each phase is independently shippable; the section is never left broken between phases.

## Out of scope / follow-ups

- en/ja/vi copy (phase 4).
- Final per-module icon selection (prototype uses stand-ins).
- Native-speaker review of machine translations (matches KS-1000 precedent).
- Nubis orphaned-asset cleanup and OG-image wiring (tracked separately, not part of this work).

## Verification

- `bash serve.sh` → localhost:8080; click all 20 nodes, confirm each opens correct content +
  image; test Esc/close, keyboard focus, mobile width, language switch (zh-TW correct, others
  fall back without blanking).
- Confirm the removed 3-col table leaves no dead CSS/i18n/JS references (grep `ap-sol`,
  `autopos.sol.`).
- After deploy: `curl https://sofone.vercel.app/` for the new markup + `assets/sol/webp/*`.
