# autopos ONE Hardware Showcase — Design Spec

**Date:** 2026-06-02  
**Project:** SOFONE landing page  
**Section:** autopos ONE block (4th block inside `.autopos-section`)

---

## Overview

Add a hardware showcase block for the **autopos ONE** POS machine inside the existing Autopos section. The block sits after the current "Strategic Value + Globe" block and before the section closes. It consists of two visually separated zones:

1. A full-width **360° interactive viewer** (drag to spin)
2. A **feature highlights grid** separated by generous spacing and a sub-heading

---

## Placement

Insert as the 4th block inside `.autopos-section > .section-inner`, directly after the `.ap-strategy` div and before the section CTA `</div></section>`.

Page flow after change:
```
Hero → CentrDX → autopos (SaaS: pain point + solution table + bilingual UI + autopos ONE hardware + globe/CTA) → Nubis → IMSDOM → Partners
```

---

## HTML Structure

```
.ap-one                          ← outer wrapper, reveal class
  .ap-one-header                 ← eyebrow + heading
  .ap-one-viewer                 ← 360° viewer zone
    .ap-one-viewer-frame         ← img display area (12 preloaded imgs, only current visible)
    .ap-one-drag-hint            ← "⟳ 拖曳旋轉" label, fades on first interaction
  .ap-one-features               ← feature grid zone
    .ap-one-features-label       ← sub-heading "每一處細節，都是工程師的堅持。"
    .ap-one-feat-grid            ← CSS grid container
      .ap-one-feat--hero (A1)    ← wide featured card (col-span 1.5fr)
      .ap-one-feat (F1)          ← standard card
      .ap-one-feat (F2–F5)       ← 4-col row
```

---

## 360° Viewer

**Photos:** `assets/demo/autoposone_demo_01.png` → `autoposone_demo_12.png` (12 frames)

**Interaction:**
- Desktop: `mousedown` + `mousemove` → track cumulative X delta → derive frame index
- Mobile: `touchstart` + `touchmove` → same logic
- Frame formula: `index = ((Math.round(totalDeltaX / 20)) % 12 + 12) % 12`
- Sensitivity: 20px per frame
- Loop: infinite in both directions
- All 12 images are preloaded into hidden `<img>` tags on page load; only the active frame is `display:block`
- Drag hint (icon + i18n label) fades out (`opacity:0`, `pointer-events:none`) after the first `mousemove`/`touchmove` event on the viewer

**Aspect ratio:** The viewer container uses `aspect-ratio: 16/9` on desktop, `aspect-ratio: 4/3` on mobile. Images use `object-fit: contain`.

---

## Feature Grid

**Separation from viewer:** `margin-top: 56px` on `.ap-one-features` (desktop), `40px` on mobile.

**Sub-heading** (`.ap-one-features-label`): eyebrow-style small text above the grid.

### Grid layout (desktop ≥768px)

**Row 1:** 2 columns — `1.5fr 1fr`
- A1 (`.ap-one-feat--hero`): wider card, image left + title + description text right
- F1: standard square card, image top + label bottom

**Row 2:** 4 equal columns
- F2, F3, F4, F5: standard square cards

### Grid layout (mobile <768px)

- Row 1: A1 full-width; F1 full-width below it
- Row 2: 2×2 grid (F2 F3 / F4 F5)

### Feature card content

| ID | Photo | zh-TW title | zh-TW desc |
|----|-------|-------------|------------|
| A1 | autoposone_demo_A1.png | 無段式角度調整 | 螢幕最大仰角 45°，無段微調，適應每種收銀場景。 |
| F1 | autoposone_demo_F1.png | 全接口底座 | 底座整合所有連接埠，保持桌面整潔，快速部署。 |
| F2 | autoposone_demo_F2.png | 精工電源鍵 | 仿精品設計語言，單鍵操作，質感升級。 |
| F3 | autoposone_demo_F3.png | 隱藏式喇叭 | 音源內嵌螢幕背板，外觀零破綻。 |
| F4 | autoposone_demo_F4.png | 主動導流散熱 | 氣流通道設計，IP65 等級，抵禦餐飲高溫油煙環境。 |
| F5 | autoposone_demo_F5.png | 散熱結構細節 | 精密鰭片排列，確保長時間穩定運行。 |

---

## i18n Strings

All new strings added to the existing `TRANSLATIONS` object in `index.html` for all 4 language packs: `zh-TW`, `EN`, `JA`, `VI`.

| Key | zh-TW | EN | JA | VI |
|-----|-------|----|----|-----|
| `apone.eyebrow` | autopos ONE · 專業級 POS 終端 | autopos ONE · Professional POS Terminal | autopos ONE · プロ仕様 POS 端末 | autopos ONE · Thiết bị POS chuyên nghiệp |
| `apone.h3` | 旗艦工業設計，與 autopos 雲端完美整合。 | Flagship industrial design, seamlessly integrated with autopos Cloud. | フラッグシップの工業デザイン、autopos クラウドと完全統合。 | Thiết kế công nghiệp hàng đầu, tích hợp hoàn hảo với autopos Cloud. |
| `apone.viewer.hint` | 拖曳旋轉 | Drag to rotate | ドラッグで回転 | Kéo để xoay |
| `apone.features.label` | 每一處細節，都是工程師的堅持。 | Every detail, engineered with purpose. | すべての細部に、エンジニアのこだわりが宿る。 | Từng chi tiết nhỏ, đều là sự kiên trì của kỹ sư. |
| `apone.feat.a1.title` | 無段式角度調整 | Stepless Angle Adjustment | 無段階角度調整 | Điều chỉnh góc vô cấp |
| `apone.feat.a1.desc` | 螢幕最大仰角 45°，無段微調，適應每種收銀場景。 | Up to 45° tilt with stepless adjustment — fits every checkout setup. | 最大45°の無段階チルト。あらゆるレジ環境に対応。 | Nghiêng tối đa 45°, điều chỉnh vô cấp, phù hợp mọi quầy thu ngân. |
| `apone.feat.f1.title` | 全接口底座 | All-Port Base | 全ポートベース | Đế đầy đủ cổng kết nối |
| `apone.feat.f1.desc` | 底座整合所有連接埠，保持桌面整潔，快速部署。 | All ports consolidated at the base — clean desk, fast deployment. | すべての接続ポートをベースに統合。デスクをすっきり保ちます。 | Tất cả cổng kết nối tích hợp vào đế, bàn gọn gàng, triển khai nhanh. |
| `apone.feat.f2.title` | 精工電源鍵 | Precision Power Button | 精密電源ボタン | Nút nguồn tinh xảo |
| `apone.feat.f2.desc` | 仿精品設計語言，單鍵操作，質感升級。 | Boutique-grade design language. One button, elevated feel. | プレミアムデザイン言語。ワンボタン操作で質感向上。 | Ngôn ngữ thiết kế cao cấp, một nút thao tác, nâng tầm cảm giác. |
| `apone.feat.f3.title` | 隱藏式喇叭 | Hidden Speaker | 隠しスピーカー | Loa ẩn |
| `apone.feat.f3.desc` | 音源內嵌螢幕背板，外觀零破綻。 | Speaker embedded behind the screen — seamless exterior. | スクリーン背面に内蔵。外観に一切の突起なし。 | Loa tích hợp sau màn hình, ngoại quan không tì vết. |
| `apone.feat.f4.title` | 主動導流散熱 | Active Airflow Cooling | アクティブ導流冷却 | Tản nhiệt luồng khí chủ động |
| `apone.feat.f4.desc` | 氣流通道設計，IP65 等級，抵禦餐飲高溫油煙環境。 | Engineered airflow channels, IP65-rated, built for F&B heat and grease. | 気流チャネル設計、IP65等級。飲食業の高熱・油煙環境に対応。 | Kênh dẫn khí thiết kế, chuẩn IP65, chống nhiệt và dầu mỡ nhà bếp. |
| `apone.feat.f5.title` | 散熱結構細節 | Thermal Structure Detail | 放熱構造の詳細 | Chi tiết cấu trúc tản nhiệt |
| `apone.feat.f5.desc` | 精密鰭片排列，確保長時間穩定運行。 | Precision fin array for sustained stable operation under continuous load. | 精密フィン配列により、連続負荷下でも安定動作を維持。 | Cánh tản nhiệt chính xác, đảm bảo vận hành ổn định liên tục. |

---

## CSS Variables Used

All existing — no new variables needed:
- `--c-bg`, `--c-surface`, `--c-surface-2`, `--c-border`, `--c-accent` (#6ACCAC), `--c-text`, `--c-muted`
- `--r-lg` (20px), `--r-xl` (28px)

---

## Constraints

- No new JS libraries — vanilla JS only, inline in `<script>` block
- All new CSS in `style.css` using `.ap-one-*` namespace
- `data-i18n` / `data-i18n-html` on all text nodes
- `reveal` class on outer wrapper for scroll animation
- Must not break existing `applyTranslations()` function — just add keys to `TRANSLATIONS`
- `.gitignore` should include `.superpowers/`
