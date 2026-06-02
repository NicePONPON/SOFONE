# autopos ONE Hardware Showcase Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an autopos ONE hardware showcase block inside the existing Autopos section — a 360° drag-to-spin viewer (12 frames) followed by a 6-card feature grid — with full 4-language i18n support.

**Architecture:** Three files touched — `index.html` gets new HTML + i18n strings + inline JS; `style.css` gets new `.ap-one-*` CSS. No new files, no dependencies. The viewer uses vanilla JS drag/touch handlers to cycle through 12 preloaded `<img>` tags.

**Tech Stack:** Vanilla HTML5, CSS3 (CSS Grid), vanilla JS — consistent with the rest of the project.

---

## File Map

| File | What changes |
|------|-------------|
| `index.html` | (1) Add `apone.*` keys to all 4 TRANSLATIONS packs; (2) Insert `.ap-one` HTML block after line 421; (3) Add 360° viewer JS after existing handlers |
| `style.css` | Add `.ap-one-*` CSS rules at the end of the file |

---

## Task 1: Add i18n strings to all 4 language packs

**Files:**
- Modify: `index.html` (4 locations — one per language pack)

The TRANSLATIONS object has 4 packs. In each pack, add the new `apone.*` keys **after** the `autopos.int.payment` line and **before** the `nubis.eyebrow` line.

- [ ] **Step 1: Add strings to `'zh-TW'` pack (after line 1007)**

Find this exact string in `index.html`:
```
        'autopos.int.delivery': '合作外送平台', 'autopos.int.payment': '支援支付方式',
        'nubis.eyebrow': 'Nubis · IoT UEM 全球控制塔',
```

Replace with:
```
        'autopos.int.delivery': '合作外送平台', 'autopos.int.payment': '支援支付方式',
        'apone.eyebrow': 'autopos ONE · 專業級 POS 終端',
        'apone.h3': '旗艦工業設計，與 autopos 雲端完美整合。',
        'apone.viewer.hint': '拖曳旋轉',
        'apone.features.label': '每一處細節，都是工程師的堅持。',
        'apone.feat.a1.title': '無段式角度調整',
        'apone.feat.a1.desc': '螢幕最大仰角 45°，無段微調，適應每種收銀場景。',
        'apone.feat.f1.title': '全接口底座',
        'apone.feat.f1.desc': '底座整合所有連接埠，保持桌面整潔，快速部署。',
        'apone.feat.f2.title': '精工電源鍵',
        'apone.feat.f2.desc': '仿精品設計語言，單鍵操作，質感升級。',
        'apone.feat.f3.title': '隱藏式喇叭',
        'apone.feat.f3.desc': '音源內嵌螢幕背板，外觀零破綻。',
        'apone.feat.f4.title': '主動導流散熱',
        'apone.feat.f4.desc': '氣流通道設計，IP65 等級，抵禦餐飲高溫油煙環境。',
        'apone.feat.f5.title': '散熱結構細節',
        'apone.feat.f5.desc': '精密鰭片排列，確保長時間穩定運行。',
        'nubis.eyebrow': 'Nubis · IoT UEM 全球控制塔',
```

- [ ] **Step 2: Add strings to `'en'` pack (after line 1159)**

Find this exact string in `index.html`:
```
        'autopos.int.delivery': 'Delivery Partners', 'autopos.int.payment': 'Supported Payment Methods',
        'nubis.eyebrow': 'Nubis · IoT UEM Global Control Tower',
```

Replace with:
```
        'autopos.int.delivery': 'Delivery Partners', 'autopos.int.payment': 'Supported Payment Methods',
        'apone.eyebrow': 'autopos ONE · Professional POS Terminal',
        'apone.h3': 'Flagship industrial design, seamlessly integrated with autopos Cloud.',
        'apone.viewer.hint': 'Drag to rotate',
        'apone.features.label': 'Every detail, engineered with purpose.',
        'apone.feat.a1.title': 'Stepless Angle Adjustment',
        'apone.feat.a1.desc': 'Up to 45° tilt with stepless adjustment — fits every checkout setup.',
        'apone.feat.f1.title': 'All-Port Base',
        'apone.feat.f1.desc': 'All ports consolidated at the base — clean desk, fast deployment.',
        'apone.feat.f2.title': 'Precision Power Button',
        'apone.feat.f2.desc': 'Boutique-grade design language. One button, elevated feel.',
        'apone.feat.f3.title': 'Hidden Speaker',
        'apone.feat.f3.desc': 'Speaker embedded behind the screen — seamless exterior.',
        'apone.feat.f4.title': 'Active Airflow Cooling',
        'apone.feat.f4.desc': 'Engineered airflow channels, IP65-rated, built for F&B heat and grease.',
        'apone.feat.f5.title': 'Thermal Structure Detail',
        'apone.feat.f5.desc': 'Precision fin array for sustained stable operation under continuous load.',
        'nubis.eyebrow': 'Nubis · IoT UEM Global Control Tower',
```

- [ ] **Step 3: Add strings to `'ja'` pack (after line 1311)**

Find this exact string in `index.html`:
```
        'autopos.int.delivery': '提携デリバリープラットフォーム', 'autopos.int.payment': '対応決済方法',
        'nubis.eyebrow': 'Nubis · IoT UEM グローバルコントロールタワー',
```

Replace with:
```
        'autopos.int.delivery': '提携デリバリープラットフォーム', 'autopos.int.payment': '対応決済方法',
        'apone.eyebrow': 'autopos ONE · プロ仕様 POS 端末',
        'apone.h3': 'フラッグシップの工業デザイン、autopos クラウドと完全統合。',
        'apone.viewer.hint': 'ドラッグで回転',
        'apone.features.label': 'すべての細部に、エンジニアのこだわりが宿る。',
        'apone.feat.a1.title': '無段階角度調整',
        'apone.feat.a1.desc': '最大45°の無段階チルト。あらゆるレジ環境に対応。',
        'apone.feat.f1.title': '全ポートベース',
        'apone.feat.f1.desc': 'すべての接続ポートをベースに統合。デスクをすっきり保ちます。',
        'apone.feat.f2.title': '精密電源ボタン',
        'apone.feat.f2.desc': 'プレミアムデザイン言語。ワンボタン操作で質感向上。',
        'apone.feat.f3.title': '隠しスピーカー',
        'apone.feat.f3.desc': 'スクリーン背面に内蔵。外観に一切の突起なし。',
        'apone.feat.f4.title': 'アクティブ導流冷却',
        'apone.feat.f4.desc': '気流チャネル設計、IP65等級。飲食業の高熱・油煙環境に対応。',
        'apone.feat.f5.title': '放熱構造の詳細',
        'apone.feat.f5.desc': '精密フィン配列により、連続負荷下でも安定動作を維持。',
        'nubis.eyebrow': 'Nubis · IoT UEM グローバルコントロールタワー',
```

- [ ] **Step 4: Add strings to `'vi'` pack (after line 1463)**

Find this exact string in `index.html`:
```
        'autopos.int.delivery': 'Đối tác giao hàng', 'autopos.int.payment': 'Phương thức thanh toán hỗ trợ',
        'nubis.eyebrow': 'Nubis · Tháp kiểm soát IoT UEM toàn cầu',
```

Replace with:
```
        'autopos.int.delivery': 'Đối tác giao hàng', 'autopos.int.payment': 'Phương thức thanh toán hỗ trợ',
        'apone.eyebrow': 'autopos ONE · Thiết bị POS chuyên nghiệp',
        'apone.h3': 'Thiết kế công nghiệp hàng đầu, tích hợp hoàn hảo với autopos Cloud.',
        'apone.viewer.hint': 'Kéo để xoay',
        'apone.features.label': 'Từng chi tiết nhỏ, đều là sự kiên trì của kỹ sư.',
        'apone.feat.a1.title': 'Điều chỉnh góc vô cấp',
        'apone.feat.a1.desc': 'Nghiêng tối đa 45°, điều chỉnh vô cấp, phù hợp mọi quầy thu ngân.',
        'apone.feat.f1.title': 'Đế đầy đủ cổng kết nối',
        'apone.feat.f1.desc': 'Tất cả cổng kết nối tích hợp vào đế, bàn gọn gàng, triển khai nhanh.',
        'apone.feat.f2.title': 'Nút nguồn tinh xảo',
        'apone.feat.f2.desc': 'Ngôn ngữ thiết kế cao cấp, một nút thao tác, nâng tầm cảm giác.',
        'apone.feat.f3.title': 'Loa ẩn',
        'apone.feat.f3.desc': 'Loa tích hợp sau màn hình, ngoại quan không tì vết.',
        'apone.feat.f4.title': 'Tản nhiệt luồng khí chủ động',
        'apone.feat.f4.desc': 'Kênh dẫn khí thiết kế, chuẩn IP65, chống nhiệt và dầu mỡ nhà bếp.',
        'apone.feat.f5.title': 'Chi tiết cấu trúc tản nhiệt',
        'apone.feat.f5.desc': 'Cánh tản nhiệt chính xác, đảm bảo vận hành ổn định liên tục.',
        'nubis.eyebrow': 'Nubis · Tháp kiểm soát IoT UEM toàn cầu',
```

- [ ] **Step 5: Verify translations load correctly**

Start the dev server: `bash /Users/chi-yuliao/secpos-bd/serve.sh`

Open http://localhost:8080, switch the language picker through all 4 languages. The page should not throw JS errors in the console. The new keys won't be visible yet (HTML not added), but no errors means the TRANSLATIONS object is valid JSON-like syntax.

- [ ] **Step 6: Commit**

```bash
git add index.html
git commit -m "feat: add apone i18n strings to all 4 language packs"
```

---

## Task 2: Add the HTML block

**Files:**
- Modify: `index.html` (insert after line 421, inside `.autopos-section > .section-inner`)

- [ ] **Step 1: Insert the HTML block**

Find this exact string in `index.html` (the closing tag of the `.ap-strategy` block):
```
      </div>

    </div>
  </section>

  <!-- ── 4. Nubis Section
```

Replace with:
```
      </div>

      <!-- Block 4: autopos ONE Hardware Showcase -->
      <div class="ap-one reveal">
        <p class="ap-one-eyebrow" data-i18n="apone.eyebrow">autopos ONE · 專業級 POS 終端</p>
        <h3 class="ap-one-h3" data-i18n="apone.h3">旗艦工業設計，與 autopos 雲端完美整合。</h3>

        <!-- 360° Viewer -->
        <div class="ap-one-viewer" role="img" aria-label="autopos ONE 360° 全視角展示">
          <img class="ap-one-frame" src="assets/demo/autoposone_demo_01.png" alt="autopos ONE 視角 1" draggable="false">
          <img class="ap-one-frame ap-one-frame--hidden" src="assets/demo/autoposone_demo_02.png" alt="autopos ONE 視角 2" draggable="false">
          <img class="ap-one-frame ap-one-frame--hidden" src="assets/demo/autoposone_demo_03.png" alt="autopos ONE 視角 3" draggable="false">
          <img class="ap-one-frame ap-one-frame--hidden" src="assets/demo/autoposone_demo_04.png" alt="autopos ONE 視角 4" draggable="false">
          <img class="ap-one-frame ap-one-frame--hidden" src="assets/demo/autoposone_demo_05.png" alt="autopos ONE 視角 5" draggable="false">
          <img class="ap-one-frame ap-one-frame--hidden" src="assets/demo/autoposone_demo_06.png" alt="autopos ONE 視角 6" draggable="false">
          <img class="ap-one-frame ap-one-frame--hidden" src="assets/demo/autoposone_demo_07.png" alt="autopos ONE 視角 7" draggable="false">
          <img class="ap-one-frame ap-one-frame--hidden" src="assets/demo/autoposone_demo_08.png" alt="autopos ONE 視角 8" draggable="false">
          <img class="ap-one-frame ap-one-frame--hidden" src="assets/demo/autoposone_demo_09.png" alt="autopos ONE 視角 9" draggable="false">
          <img class="ap-one-frame ap-one-frame--hidden" src="assets/demo/autoposone_demo_10.png" alt="autopos ONE 視角 10" draggable="false">
          <img class="ap-one-frame ap-one-frame--hidden" src="assets/demo/autoposone_demo_11.png" alt="autopos ONE 視角 11" draggable="false">
          <img class="ap-one-frame ap-one-frame--hidden" src="assets/demo/autoposone_demo_12.png" alt="autopos ONE 視角 12" draggable="false">
          <div class="ap-one-drag-hint" aria-hidden="true">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
              <path d="M8 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h3"/><path d="M16 3h3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-3"/>
              <line x1="12" y1="8" x2="12" y2="16"/><polyline points="9 11 12 8 15 11"/>
            </svg>
            <span data-i18n="apone.viewer.hint">拖曳旋轉</span>
          </div>
        </div>

        <!-- Feature Grid -->
        <div class="ap-one-features">
          <p class="ap-one-features-label" data-i18n="apone.features.label">每一處細節，都是工程師的堅持。</p>
          <div class="ap-one-row-1">
            <div class="ap-one-feat ap-one-feat--hero">
              <img src="assets/demo/autoposone_demo_A1.png" alt="無段式角度調整" class="ap-one-feat-img">
              <div class="ap-one-feat-body">
                <p class="ap-one-feat-title" data-i18n="apone.feat.a1.title">無段式角度調整</p>
                <p class="ap-one-feat-desc" data-i18n="apone.feat.a1.desc">螢幕最大仰角 45°，無段微調，適應每種收銀場景。</p>
              </div>
            </div>
            <div class="ap-one-feat">
              <img src="assets/demo/autoposone_demo_F1.png" alt="全接口底座" class="ap-one-feat-img">
              <p class="ap-one-feat-title" data-i18n="apone.feat.f1.title">全接口底座</p>
              <p class="ap-one-feat-desc" data-i18n="apone.feat.f1.desc">底座整合所有連接埠，保持桌面整潔，快速部署。</p>
            </div>
          </div>
          <div class="ap-one-row-2">
            <div class="ap-one-feat">
              <img src="assets/demo/autoposone_demo_F2.png" alt="精工電源鍵" class="ap-one-feat-img">
              <p class="ap-one-feat-title" data-i18n="apone.feat.f2.title">精工電源鍵</p>
              <p class="ap-one-feat-desc" data-i18n="apone.feat.f2.desc">仿精品設計語言，單鍵操作，質感升級。</p>
            </div>
            <div class="ap-one-feat">
              <img src="assets/demo/autoposone_demo_F3.png" alt="隱藏式喇叭" class="ap-one-feat-img">
              <p class="ap-one-feat-title" data-i18n="apone.feat.f3.title">隱藏式喇叭</p>
              <p class="ap-one-feat-desc" data-i18n="apone.feat.f3.desc">音源內嵌螢幕背板，外觀零破綻。</p>
            </div>
            <div class="ap-one-feat">
              <img src="assets/demo/autoposone_demo_F4.png" alt="主動導流散熱" class="ap-one-feat-img">
              <p class="ap-one-feat-title" data-i18n="apone.feat.f4.title">主動導流散熱</p>
              <p class="ap-one-feat-desc" data-i18n="apone.feat.f4.desc">氣流通道設計，IP65 等級，抵禦餐飲高溫油煙環境。</p>
            </div>
            <div class="ap-one-feat">
              <img src="assets/demo/autoposone_demo_F5.png" alt="散熱結構細節" class="ap-one-feat-img">
              <p class="ap-one-feat-title" data-i18n="apone.feat.f5.title">散熱結構細節</p>
              <p class="ap-one-feat-desc" data-i18n="apone.feat.f5.desc">精密鰭片排列，確保長時間穩定運行。</p>
            </div>
          </div>
        </div>
      </div>

    </div>
  </section>

  <!-- ── 4. Nubis Section
```

- [ ] **Step 2: Verify HTML renders without errors**

In the running browser at http://localhost:8080, scroll to the Autopos section. You should see:
- Eyebrow text: "autopos ONE · 專業級 POS 終端"
- Heading text visible
- First 360° viewer image visible (unstyled for now — that's fine)
- All 6 feature photos visible (unstyled)
- No broken image icons (if any appear, double-check the `assets/demo/` paths)

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "feat: add autopos ONE HTML block to Autopos section"
```

---

## Task 3: Add CSS — viewer zone

**Files:**
- Modify: `style.css` (append at end of file)

- [ ] **Step 1: Append viewer CSS to style.css**

Add at the very end of `style.css`:

```css
/* ── autopos ONE Hardware Showcase ─────────────────────── */

.ap-one {
  margin-top: 72px;
  padding-top: 56px;
  border-top: 1px solid var(--c-border);
}

.ap-one-eyebrow {
  font-size: 12px;
  font-weight: 600;
  letter-spacing: .1em;
  text-transform: uppercase;
  color: var(--c-accent);
  margin-bottom: 10px;
}

.ap-one-h3 {
  font-size: clamp(1.15rem, 2.2vw, 1.55rem);
  font-weight: 700;
  color: var(--c-white);
  line-height: 1.35;
  margin-bottom: 36px;
  max-width: 640px;
}

/* 360° Viewer */
.ap-one-viewer {
  position: relative;
  width: 100%;
  aspect-ratio: 16 / 9;
  background: var(--c-surface);
  border-radius: var(--r-lg);
  overflow: hidden;
  cursor: grab;
  user-select: none;
  -webkit-user-select: none;
  border: 1px solid var(--c-border);
}

.ap-one-viewer:active {
  cursor: grabbing;
}

.ap-one-frame {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: contain;
  object-position: center;
  pointer-events: none;
}

.ap-one-frame--hidden {
  display: none;
}

.ap-one-drag-hint {
  position: absolute;
  bottom: 16px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 7px 14px;
  background: rgba(13, 31, 45, 0.72);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  border: 1px solid var(--c-border);
  border-radius: 999px;
  color: var(--c-accent);
  font-size: 12px;
  font-weight: 500;
  pointer-events: none;
  transition: opacity .4s ease;
}

.ap-one-drag-hint.is-hidden {
  opacity: 0;
}

@media (max-width: 767px) {
  .ap-one-viewer {
    aspect-ratio: 4 / 3;
    border-radius: var(--r-md);
  }
}
```

- [ ] **Step 2: Verify viewer styling in browser**

Scroll to the autopos ONE block. The viewer should now be:
- A dark rounded rectangle with `aspect-ratio: 16/9`
- The first machine photo filling it (object-fit: contain, centered)
- The drag hint pill visible at the bottom center
- Cursor changes to `grab` on hover

- [ ] **Step 3: Commit**

```bash
git add style.css
git commit -m "feat: add CSS for autopos ONE 360 viewer"
```

---

## Task 4: Add CSS — feature grid

**Files:**
- Modify: `style.css` (append after Task 3's CSS)

- [ ] **Step 1: Append feature grid CSS to style.css**

Add immediately after the viewer CSS added in Task 3:

```css
/* Feature Grid */
.ap-one-features {
  margin-top: 56px;
}

.ap-one-features-label {
  font-size: 13px;
  font-weight: 600;
  color: var(--c-muted);
  margin-bottom: 20px;
  letter-spacing: .02em;
}

.ap-one-row-1 {
  display: grid;
  grid-template-columns: 3fr 2fr;
  gap: 16px;
  margin-bottom: 16px;
}

.ap-one-row-2 {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}

.ap-one-feat {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: var(--r-lg);
  overflow: hidden;
  transition: border-color .2s ease;
}

.ap-one-feat:hover {
  border-color: rgba(106, 204, 172, 0.4);
}

.ap-one-feat-img {
  width: 100%;
  aspect-ratio: 4 / 3;
  object-fit: cover;
  object-position: center;
  display: block;
}

.ap-one-feat--hero {
  display: flex;
  flex-direction: row;
  align-items: stretch;
}

.ap-one-feat--hero .ap-one-feat-img {
  width: 55%;
  flex-shrink: 0;
  aspect-ratio: auto;
  height: 100%;
  object-fit: cover;
}

.ap-one-feat-body {
  padding: 20px 22px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 10px;
}

.ap-one-feat-title {
  font-size: 14px;
  font-weight: 700;
  color: var(--c-accent);
  line-height: 1.3;
}

.ap-one-feat-desc {
  font-size: 12px;
  color: var(--c-muted);
  line-height: 1.6;
  padding: 10px 14px 14px;
}

/* For standard (non-hero) cards, title sits below image */
.ap-one-feat:not(.ap-one-feat--hero) .ap-one-feat-title {
  padding: 12px 14px 0;
  font-size: 13px;
}

/* Mobile */
@media (max-width: 767px) {
  .ap-one-row-1 {
    grid-template-columns: 1fr;
  }

  .ap-one-feat--hero {
    flex-direction: column;
  }

  .ap-one-feat--hero .ap-one-feat-img {
    width: 100%;
    height: auto;
    aspect-ratio: 16 / 9;
  }

  .ap-one-row-2 {
    grid-template-columns: repeat(2, 1fr);
  }
}
```

- [ ] **Step 2: Verify feature grid in browser**

Scroll to the feature section. Check:
- Row 1: A1 (wider, horizontal image+text layout) beside F1 (square card)
- Row 2: F2–F5 in 4 equal columns
- Generous gap between the 360° viewer and the "每一處細節" label
- On mobile (resize browser to < 768px): Row 1 stacks, Row 2 becomes 2×2

- [ ] **Step 3: Commit**

```bash
git add style.css
git commit -m "feat: add CSS for autopos ONE feature grid"
```

---

## Task 5: Add 360° viewer JavaScript

**Files:**
- Modify: `index.html` (add JS block inside the existing `<script>` tag, after the last handler)

- [ ] **Step 1: Find the insertion point in the script block**

Find this comment near the bottom of the `<script>` block (around line 1638):
```javascript
    /* ── Contact section reveal ────────────────────────────── */
```

Insert the following block **before** that comment:

```javascript
    /* ── autopos ONE 360° Viewer ──────────────────────────── */
    (function () {
      var viewer = document.querySelector('.ap-one-viewer');
      if (!viewer) return;

      var frames  = viewer.querySelectorAll('.ap-one-frame');
      var hint    = viewer.querySelector('.ap-one-drag-hint');
      var total   = frames.length; /* 12 */
      var current = 0;
      var dragging = false;
      var startX   = 0;
      var baseIdx  = 0;

      function showFrame(idx) {
        frames[current].classList.add('ap-one-frame--hidden');
        current = ((idx % total) + total) % total;
        frames[current].classList.remove('ap-one-frame--hidden');
      }

      function onStart(x) {
        dragging = true;
        startX   = x;
        baseIdx  = current;
      }

      function onMove(x) {
        if (!dragging) return;
        if (hint && !hint.classList.contains('is-hidden')) {
          hint.classList.add('is-hidden');
        }
        var delta    = x - startX;
        var newIdx   = baseIdx - Math.round(delta / 20);
        showFrame(newIdx);
      }

      function onEnd() { dragging = false; }

      viewer.addEventListener('mousedown',  function (e) { e.preventDefault(); onStart(e.clientX); });
      document.addEventListener('mousemove', function (e) { if (dragging) onMove(e.clientX); });
      document.addEventListener('mouseup',   onEnd);

      viewer.addEventListener('touchstart', function (e) { onStart(e.touches[0].clientX); }, { passive: true });
      viewer.addEventListener('touchmove',  function (e) { e.preventDefault(); onMove(e.touches[0].clientX); }, { passive: false });
      viewer.addEventListener('touchend',   onEnd);
    }());
```

- [ ] **Step 2: Verify drag interaction in browser**

Scroll to the 360° viewer. Test:
1. Click and drag left → machine rotates clockwise through frames
2. Click and drag right → machine rotates counter-clockwise
3. After first drag, the "拖曳旋轉" pill fades out (`is-hidden` class applied)
4. On mobile (or using browser devtools mobile emulation): touch-drag works the same way
5. Dragging past frame 12 wraps back to frame 1 (infinite loop)
6. No console errors

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "feat: add 360 drag-to-spin JS for autopos ONE viewer"
```

---

## Task 6: Final QA pass

**Files:** None — verification only.

- [ ] **Step 1: Full language switch test**

At http://localhost:8080, click through all 4 language buttons (TW / EN / JP / VI). For each language verify:
- Eyebrow, heading, drag hint, and features label update correctly
- All 6 feature card titles and descriptions update (A1, F1–F5)
- No `[object Object]` or blank text appears

- [ ] **Step 2: Scroll reveal test**

Reload the page. Scroll slowly down to the autopos ONE block. The `.ap-one` div should fade/slide in via the existing `reveal` → `is-visible` IntersectionObserver. If it doesn't animate in, confirm the `reveal` class is on `.ap-one` in the HTML.

- [ ] **Step 3: Responsive check**

In browser devtools, test at these breakpoints:
- 1280px: Row 1 = wide A1 + F1; Row 2 = 4 cols
- 768px: same as desktop (breakpoint is <767px)
- 390px (iPhone): Row 1 = A1 stacked above F1; Row 2 = 2×2; viewer aspect-ratio 4/3

- [ ] **Step 4: Final commit**

```bash
git add index.html style.css
git commit -m "feat: complete autopos ONE hardware showcase section"
```
