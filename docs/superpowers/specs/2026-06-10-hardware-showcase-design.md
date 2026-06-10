# Hardware Showcase Section — Design

**Date:** 2026-06-10
**Project:** SOFONE landing page (`~/SOFONE`, repo `NicePONPON/SOFONE`)
**Status:** Approved design — pending spec review

## Goal

Add a Hardware Showcase section to the landing page that presents the 2 hardware
models that pair with the Autopos software ecosystem: **autopos ONE** (smart POS
terminal) and **XELF II** (FEC self-order kiosk). The section gives B2B buyers a
clean way to browse hardware and request a quote.

> Scope decision (2026-06-10): KIOSK and Table Kiosk dropped from this section.
> Only autopos ONE and XELF II are shown.

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
│         LARGE FEATURED PHOTO                   │ ▢ XELF II     │
│         (selected hardware)                    │               │
│  Name · Tagline                               │               │
│  • spec 1                                      │               │
│  • spec 2 …                                    │               │
│  [ Request a quote → ]                         │               │
└──────────────────────────────────────────────┴───────────────┘
```

- **Left (~65%):** featured photo + name + tagline + spec bullets (bold lead-in +
  description) + CTA button linking to `#contact`.
- **Right (~35%):** vertical list of 2 thumbnail tiles. Clicking a tile sets it
  active and swaps the featured panel. **autopos ONE selected by default.**
- **Mobile:** sidebar collapses to a horizontal scrollable row of thumbnails
  above the featured panel (single column).

## Per-hardware behavior

| Model | Featured image | Special behavior |
|-------|---------------|------------------|
| autopos ONE | `assets/demo/webp/autoposone_demo_01.webp` (single representative frame — **not** the full 360° viewer, which already lives in the Autopos section above) | none |
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
- Per model `<m>` ∈ {`apone`, `xelf`}:
  - `hardware.<m>.name`
  - `hardware.<m>.tagline`
  - `hardware.<m>.spec1` … `hardware.<m>.spec5` (each = `<b>headline</b> — description`)

Markup uses existing `data-i18n` attributes (use `data-i18n-html` for the bold
lead-in spec bullets); `applyTranslations(lang)` already handles the rest — no JS
changes needed for translation. EN/JA/VI to be translated from the zh-TW source
below during implementation.

### Real copy (zh-TW source — final)

**autopos ONE 智慧收銀機** — tagline: 主流 x86 效能，餐飲現場耐用之選

1. **主流 x86 效能 × Windows 系統** — Intel N95 處理器搭配 8G 記憶體 + 128G SSD、Win 10/11，軟體相容性高，收銀、會員、線上單多視窗同時跑也不卡頓，不必擔心 Android POS 的擴充與相容限制。
2. **15.6 吋 Full HD IPS 多點觸控** — 1920×1080 IPS 面板 + G+G 多點觸控電容螢幕，字大清晰、廣視角、觸控靈敏，店員零學習門檻、尖峰時段點得快。
3. **雙頻 WiFi + Gigabit + 藍牙 5.3 完整連網** — 2.4G/5G 雙頻 WiFi、10/100/1000M 有線網路、BT5.3 三路齊備，連線穩定、可有線無線互備，藍牙周邊一次配對到位。
4. **豐富外接介面，一台串起全部周邊** — HDMI×1、COM×2、USB2.0×2、USB3.0×2、RJ45、音源孔，客顯、出單機、錢箱、掃碼槍、刷卡機一次接齊，不必外掛轉接器。
5. **商用級耐用機構** — 金屬＋塑鋼機身、3W 喇叭、12V/4A 供電、工作溫度 −10~45℃、通過 CCC 認證，耐得住餐飲油煙與長時間營業；機身僅 363×321×191mm，占桌面小。

**XELF II 自助點餐機（FEC）** — tagline: 模組化自助點餐，小店到大廳全對應

1. **15.6" / 22" 雙尺寸 + 橫直向自由配置** — 同一產品線同時支援 15.6 吋與 22 吋面板，可橫向或直向安裝，小店到大店、窄入口到寬廳都能對應。
2. **掃碼 + 出單 + 金流模組整合一機** — 內建條碼掃描（Henex H22／Newland FM6080），支援主流出單機（EPSON M30 II/III、Seiko RP-D10）與刷卡金流端（Verifone、PAX、Ingenico），點餐到付款一機完成，刷卡模組現成可接。
3. **壓鑄鋁機身 + 商用耐用設計** — 鋁壓鑄＋塑鋼結構、2×2W 喇叭，通過 FCC／CE Class B 認證，適合公共場域天天被按、耐撞耐用。
4. **選配擴充彈性極大** — MSR／指紋／NFC、LED 燈條＋鏡頭二合一、發票印表機、載具/護照掃描、取票/發卡、紙鈔辨識、ADA 無障礙鍵盤等，可從餐飲自助點餐延伸到零售、報到、旅宿。
5. **桌上型 / 落地型雙形態** — 落地型 1550×500×500mm（43kg）入口吸睛、桌上型 792×378×364mm（29kg）省櫃檯空間，依場域選型，單機即可獨立運作。

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

- KIOSK and Table Kiosk are **not** included in this section (scope decision).
- EN/JA/VI translations to be produced during implementation from the zh-TW
  source above.
- No 360° viewer duplication for autopos ONE — single representative frame only.
- Spec bullets are detailed (5 per model); consider whether all 5 show by default
  or the panel scrolls. Default: show all 5 as a styled list.
