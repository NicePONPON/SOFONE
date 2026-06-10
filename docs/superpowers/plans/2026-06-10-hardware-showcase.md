# Hardware Showcase Section Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a Hardware Showcase section (autopos ONE + XELF II) between the Autopos and CentrDX sections of the SOFONE landing page, with a feature+sidebar layout and an inline fan-out interaction for XELF II.

**Architecture:** A single `<section id="hardware">` with two swappable feature panels and two sidebar thumbnail tiles. A small vanilla-JS handler toggles the active panel; XELF II's photo toggles an `.is-expanded` class that fans out 3 satellite images via CSS transforms. All copy flows through the existing `data-i18n` / `applyTranslations` i18n system across 4 languages.

**Tech Stack:** Static HTML + CSS (custom properties already defined in `style.css`) + vanilla JS. No build step, no test framework — verification is by serving locally and viewing in a browser.

**Verification note:** This repo has no automated tests. Each task verifies by running a local server (`python3 -m http.server 8000` from `~/SOFONE`) and viewing `http://localhost:8000`. Keep one server running in the background across tasks.

**Design tokens available** (from `style.css :root`): `--c-bg #0d1f2d`, `--c-surface #122030`, `--c-surface-2 #192e40`, `--c-border`, `--c-accent #6ACCAC`, `--c-muted`, `--c-text`; radii `--r-sm 6 / --r-md 12 / --r-lg 20`; `--max-w 1060`. Existing reusable classes: `.section-inner`, `.section-eyebrow`, `.section-h2`, `.reveal`/`.is-visible`, `.btn .btn--primary`.

---

### Task 1: Add the section HTML (zh-TW inline copy as default/fallback)

**Files:**
- Modify: `index.html` — insert after the Autopos section's closing `</section>` (currently line 455, immediately before the `<!-- ── 3. CentrDX Section -->` comment on line 457).

- [ ] **Step 1: Insert the section markup**

Insert this block between line 455 (`  </section>`) and line 457 (`  <!-- ── 3. CentrDX Section ... -->`):

```html

  <!-- ── Hardware Showcase Section ─────────────────────────── -->
  <section class="hw-section" id="hardware">
    <div class="section-inner">
      <p class="section-eyebrow reveal" data-i18n="hardware.eyebrow">硬體設備 · 軟硬整合一站交付</p>
      <h2 class="section-h2 reveal" data-i18n="hardware.h2">為餐飲現場而生的耐用終端。</h2>

      <div class="hw-showcase reveal">
        <!-- Feature panels -->
        <div class="hw-feature">

          <!-- autopos ONE -->
          <div class="hw-panel is-active" data-hw="apone">
            <div class="hw-photo">
              <img src="assets/demo/webp/autoposone_demo_01.webp" alt="autopos ONE 智慧收銀機" loading="lazy">
            </div>
            <div class="hw-info">
              <h3 class="hw-name" data-i18n="hardware.apone.name">autopos ONE 智慧收銀機</h3>
              <p class="hw-tagline" data-i18n="hardware.apone.tagline">主流 x86 效能，餐飲現場耐用之選</p>
              <ul class="hw-specs">
                <li data-i18n-html="hardware.apone.spec1"><b>主流 x86 效能 × Windows 系統</b> — Intel N95 處理器搭配 8G 記憶體 + 128G SSD、Win 10/11，軟體相容性高，收銀、會員、線上單多視窗同時跑也不卡頓，不必擔心 Android POS 的擴充與相容限制。</li>
                <li data-i18n-html="hardware.apone.spec2"><b>15.6 吋 Full HD IPS 多點觸控</b> — 1920×1080 IPS 面板 + G+G 多點觸控電容螢幕，字大清晰、廣視角、觸控靈敏，店員零學習門檻、尖峰時段點得快。</li>
                <li data-i18n-html="hardware.apone.spec3"><b>雙頻 WiFi + Gigabit + 藍牙 5.3 完整連網</b> — 2.4G/5G 雙頻 WiFi、10/100/1000M 有線網路、BT5.3 三路齊備，連線穩定、可有線無線互備，藍牙周邊一次配對到位。</li>
                <li data-i18n-html="hardware.apone.spec4"><b>豐富外接介面，一台串起全部周邊</b> — HDMI×1、COM×2、USB2.0×2、USB3.0×2、RJ45、音源孔，客顯、出單機、錢箱、掃碼槍、刷卡機一次接齊，不必外掛轉接器。</li>
                <li data-i18n-html="hardware.apone.spec5"><b>商用級耐用機構</b> — 金屬＋塑鋼機身、3W 喇叭、12V/4A 供電、工作溫度 −10~45℃、通過 CCC 認證，耐得住餐飲油煙與長時間營業；機身僅 363×321×191mm，占桌面小。</li>
              </ul>
              <a href="#contact" class="btn btn--primary hw-cta" data-i18n="hardware.cta">預約諮詢</a>
            </div>
          </div>

          <!-- XELF II -->
          <div class="hw-panel" data-hw="xelf">
            <div class="hw-photo hw-photo--xelf" id="xelfFan" role="button" tabindex="0" aria-label="展開 XELF II 更多視角">
              <img src="assets/XELFII-4.png" alt="XELF II 視角" class="hw-xelf-sat hw-xelf-sat--1" loading="lazy">
              <img src="assets/XELFII-5.png" alt="XELF II 視角" class="hw-xelf-sat hw-xelf-sat--2" loading="lazy">
              <img src="assets/XELFII-7.png" alt="XELF II 視角" class="hw-xelf-sat hw-xelf-sat--3" loading="lazy">
              <img src="assets/XELFII-3.png" alt="XELF II 自助點餐機" class="hw-xelf-main" loading="lazy">
              <span class="hw-xelf-hint" data-i18n="hardware.xelf.hint">點擊展開更多視角</span>
            </div>
            <div class="hw-info">
              <h3 class="hw-name" data-i18n="hardware.xelf.name">XELF II 自助點餐機（FEC）</h3>
              <p class="hw-tagline" data-i18n="hardware.xelf.tagline">模組化自助點餐，小店到大廳全對應</p>
              <ul class="hw-specs">
                <li data-i18n-html="hardware.xelf.spec1"><b>15.6" / 22" 雙尺寸 + 橫直向自由配置</b> — 同一產品線同時支援 15.6 吋與 22 吋面板，可橫向或直向安裝，小店到大店、窄入口到寬廳都能對應。</li>
                <li data-i18n-html="hardware.xelf.spec2"><b>掃碼 + 出單 + 金流模組整合一機</b> — 內建條碼掃描（Henex H22／Newland FM6080），支援主流出單機（EPSON M30 II/III、Seiko RP-D10）與刷卡金流端（Verifone、PAX、Ingenico），點餐到付款一機完成，刷卡模組現成可接。</li>
                <li data-i18n-html="hardware.xelf.spec3"><b>壓鑄鋁機身 + 商用耐用設計</b> — 鋁壓鑄＋塑鋼結構、2×2W 喇叭，通過 FCC／CE Class B 認證，適合公共場域天天被按、耐撞耐用。</li>
                <li data-i18n-html="hardware.xelf.spec4"><b>選配擴充彈性極大</b> — MSR／指紋／NFC、LED 燈條＋鏡頭二合一、發票印表機、載具/護照掃描、取票/發卡、紙鈔辨識、ADA 無障礙鍵盤等，可從餐飲自助點餐延伸到零售、報到、旅宿。</li>
                <li data-i18n-html="hardware.xelf.spec5"><b>桌上型 / 落地型雙形態</b> — 落地型 1550×500×500mm（43kg）入口吸睛、桌上型 792×378×364mm（29kg）省櫃檯空間，依場域選型，單機即可獨立運作。</li>
              </ul>
              <a href="#contact" class="btn btn--primary hw-cta" data-i18n="hardware.cta">預約諮詢</a>
            </div>
          </div>

        </div>

        <!-- Sidebar thumbnails -->
        <div class="hw-thumbs">
          <button class="hw-thumb is-active" data-hw="apone" type="button">
            <img src="assets/demo/webp/autoposone_demo_01.webp" alt="" loading="lazy">
            <span data-i18n="hardware.apone.name">autopos ONE 智慧收銀機</span>
          </button>
          <button class="hw-thumb" data-hw="xelf" type="button">
            <img src="assets/XELFII-3.png" alt="" loading="lazy">
            <span data-i18n="hardware.xelf.name">XELF II 自助點餐機（FEC）</span>
          </button>
        </div>
      </div>
    </div>
  </section>
```

- [ ] **Step 2: Verify the section renders**

Start a server (once, reuse for later tasks): `cd ~/SOFONE && python3 -m http.server 8000`
Open `http://localhost:8000#hardware`.
Expected: The new section appears between Autopos and CentrDX. Unstyled, both panels' content visible (no CSS yet), the autopos ONE image and XELF II images all show. No console errors.

- [ ] **Step 3: Commit**

```bash
cd ~/SOFONE
git add index.html
git commit -m "feat(hardware): add hardware showcase section markup"
```

---

### Task 2: Add the section CSS

**Files:**
- Modify: `style.css` — append a new block at the end of the file (after the existing `.ap-one*` rules). Keep all hardware rules together.

- [ ] **Step 1: Append the hardware showcase styles**

Add to the end of `style.css`:

```css

/* ── Hardware Showcase Section ──────────────────────────── */
.hw-section { background: var(--c-bg); }

.hw-showcase {
  display: grid;
  grid-template-columns: 1fr 260px;
  gap: 28px;
  margin-top: 40px;
  align-items: start;
}

/* Feature panels: only the active one shows */
.hw-feature { position: relative; }
.hw-panel { display: none; }
.hw-panel.is-active {
  display: grid;
  grid-template-columns: minmax(0, 1.1fr) minmax(0, 1fr);
  gap: 32px;
  align-items: center;
}

.hw-photo {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: var(--r-lg);
  padding: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 360px;
}
.hw-photo img { max-width: 100%; max-height: 380px; object-fit: contain; }

.hw-name {
  font-size: 1.5rem;
  font-weight: 700;
  color: var(--c-text);
  margin: 0 0 6px;
}
.hw-tagline {
  color: var(--c-accent);
  font-weight: 600;
  margin: 0 0 18px;
}
.hw-specs {
  list-style: none;
  padding: 0;
  margin: 0 0 24px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.hw-specs li {
  position: relative;
  padding-left: 20px;
  color: var(--c-muted);
  font-size: 0.92rem;
  line-height: 1.6;
}
.hw-specs li::before {
  content: "";
  position: absolute;
  left: 0;
  top: 9px;
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: var(--c-accent);
}
.hw-specs li b { color: var(--c-text); font-weight: 700; }

.hw-cta { display: inline-flex; }

/* Sidebar thumbnails */
.hw-thumbs {
  display: flex;
  flex-direction: column;
  gap: 14px;
}
.hw-thumb {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: var(--r-md);
  cursor: pointer;
  text-align: left;
  color: var(--c-muted);
  font: inherit;
  font-size: 0.9rem;
  font-weight: 600;
  transition: border-color .2s, background .2s, color .2s;
}
.hw-thumb img {
  width: 52px;
  height: 52px;
  object-fit: contain;
  flex-shrink: 0;
}
.hw-thumb:hover { border-color: var(--c-accent); }
.hw-thumb.is-active {
  border-color: var(--c-accent);
  background: var(--c-accent-bg);
  color: var(--c-text);
}

/* XELF II fan-out */
.hw-photo--xelf { position: relative; cursor: pointer; overflow: visible; }
.hw-xelf-main {
  position: relative;
  z-index: 3;
  transition: transform .35s ease;
}
.hw-xelf-sat {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 42%;
  max-height: 200px;
  object-fit: contain;
  z-index: 2;
  opacity: 0;
  transform: translate(-50%, -50%) scale(0.5);
  transition: transform .4s cubic-bezier(.2,.7,.3,1), opacity .35s ease;
  pointer-events: none;
}
.hw-photo--xelf.is-expanded .hw-xelf-main { transform: scale(0.82); }
.hw-photo--xelf.is-expanded .hw-xelf-sat { opacity: 1; }
.hw-photo--xelf.is-expanded .hw-xelf-sat--1 {
  transform: translate(-118%, -62%) scale(0.92);
  transition-delay: .02s;
}
.hw-photo--xelf.is-expanded .hw-xelf-sat--2 {
  transform: translate(18%, -62%) scale(0.92);
  transition-delay: .08s;
}
.hw-photo--xelf.is-expanded .hw-xelf-sat--3 {
  transform: translate(-50%, 30%) scale(0.92);
  transition-delay: .14s;
}

.hw-xelf-hint {
  position: absolute;
  bottom: 12px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 4;
  font-size: 0.78rem;
  color: var(--c-muted);
  background: rgba(13, 31, 45, 0.7);
  padding: 4px 12px;
  border-radius: var(--r-sm);
  pointer-events: none;
  transition: opacity .25s;
}
.hw-photo--xelf.is-expanded .hw-xelf-hint { opacity: 0; }

/* Responsive */
@media (max-width: 860px) {
  .hw-showcase { grid-template-columns: 1fr; }
  .hw-panel.is-active { grid-template-columns: 1fr; gap: 20px; }
  .hw-thumbs {
    flex-direction: row;
    order: -1;
    overflow-x: auto;
  }
  .hw-thumb { flex: 1 0 auto; }
}
```

- [ ] **Step 2: Verify styling**

Reload `http://localhost:8000#hardware`.
Expected: autopos ONE panel shows by default — large photo left, name/tagline/5 bullets/CTA right; sidebar shows 2 tiles with autopos ONE highlighted (accent border + tinted bg). On mobile width (<860px) the tiles become a horizontal row above the feature. XELF II panel is hidden. No layout overflow.

- [ ] **Step 3: Commit**

```bash
cd ~/SOFONE
git add style.css
git commit -m "feat(hardware): style showcase layout, thumbnails, XELF fan-out"
```

---

### Task 3: Add the JS (thumbnail switching + XELF II fan-out)

**Files:**
- Modify: `index.html` — add a script block. Place it just before the closing `</script>` region's end is messy; instead insert a new self-contained IIFE right after the Scroll Reveal block (after line ~1820, the `revealObserver` `.forEach` that ends at `});`). Any location inside the existing main `<script>` works since the DOM is already parsed at that point.

- [ ] **Step 1: Insert the hardware showcase script**

In `index.html`, immediately after the Scroll Reveal `document.querySelectorAll('.reveal').forEach(...)` block (ends ~line 1820), add:

```javascript

    /* ── Hardware Showcase ─────────────────────────────────── */
    (function() {
      var thumbs = document.querySelectorAll('.hw-thumb');
      var panels = document.querySelectorAll('.hw-panel');
      thumbs.forEach(function(thumb) {
        thumb.addEventListener('click', function() {
          var hw = thumb.getAttribute('data-hw');
          thumbs.forEach(function(t) { t.classList.toggle('is-active', t === thumb); });
          panels.forEach(function(p) {
            p.classList.toggle('is-active', p.getAttribute('data-hw') === hw);
          });
        });
      });

      var fan = document.getElementById('xelfFan');
      if (fan) {
        var toggleFan = function() { fan.classList.toggle('is-expanded'); };
        fan.addEventListener('click', toggleFan);
        fan.addEventListener('keydown', function(e) {
          if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); toggleFan(); }
        });
      }
    })();
```

- [ ] **Step 2: Verify interactions**

Reload `http://localhost:8000#hardware`.
Expected:
1. Clicking the "XELF II" thumbnail swaps the feature panel to XELF II (and highlights that tile; autopos ONE tile de-highlights).
2. Clicking the "autopos ONE" thumbnail swaps back.
3. With XELF II showing, clicking the main XELF II photo fans out the 3 satellite images (animated, staggered) and hides the hint; clicking again collapses them.
4. No console errors.

- [ ] **Step 3: Commit**

```bash
cd ~/SOFONE
git add index.html
git commit -m "feat(hardware): add panel switching and XELF fan-out interaction"
```

---

### Task 4: Add i18n keys to all 4 translation blocks + nav

**Files:**
- Modify: `index.html` — `TRANSLATIONS` object has 4 language blocks. The `zh-TW` block starts at line ~1082; each block contains an `'autopos.bil.jp': ...` line (zh-TW ~1183, en ~1352, ja ~1521, vi ~1690) — use those as anchors to insert each language's hardware keys nearby. Also add `nav.hardware` to each block's nav line and a nav link.

- [ ] **Step 1: Add the nav link**

After the mobile-nav autopos link (line ~109 `<a href="#autopos" ... >Autopos</a>`), add:

```html
    <a href="#hardware" class="mobile-nav-item" data-i18n="nav.hardware">硬體設備</a>
```

- [ ] **Step 2: Add zh-TW hardware keys**

In the `zh-TW` block, after the `'autopos.bil.en': ..., 'autopos.bil.dual': ..., 'autopos.bil.jp': '日本語 介面',` line (~1183), add:

```javascript
        'nav.hardware': '硬體設備',
        'hardware.eyebrow': '硬體設備 · 軟硬整合一站交付',
        'hardware.h2': '為餐飲現場而生的耐用終端。',
        'hardware.cta': '預約諮詢',
        'hardware.xelf.hint': '點擊展開更多視角',
        'hardware.apone.name': 'autopos ONE 智慧收銀機',
        'hardware.apone.tagline': '主流 x86 效能，餐飲現場耐用之選',
        'hardware.apone.spec1': '<b>主流 x86 效能 × Windows 系統</b> — Intel N95 處理器搭配 8G 記憶體 + 128G SSD、Win 10/11，軟體相容性高，收銀、會員、線上單多視窗同時跑也不卡頓，不必擔心 Android POS 的擴充與相容限制。',
        'hardware.apone.spec2': '<b>15.6 吋 Full HD IPS 多點觸控</b> — 1920×1080 IPS 面板 + G+G 多點觸控電容螢幕，字大清晰、廣視角、觸控靈敏，店員零學習門檻、尖峰時段點得快。',
        'hardware.apone.spec3': '<b>雙頻 WiFi + Gigabit + 藍牙 5.3 完整連網</b> — 2.4G/5G 雙頻 WiFi、10/100/1000M 有線網路、BT5.3 三路齊備，連線穩定、可有線無線互備，藍牙周邊一次配對到位。',
        'hardware.apone.spec4': '<b>豐富外接介面，一台串起全部周邊</b> — HDMI×1、COM×2、USB2.0×2、USB3.0×2、RJ45、音源孔，客顯、出單機、錢箱、掃碼槍、刷卡機一次接齊，不必外掛轉接器。',
        'hardware.apone.spec5': '<b>商用級耐用機構</b> — 金屬＋塑鋼機身、3W 喇叭、12V/4A 供電、工作溫度 −10~45℃、通過 CCC 認證，耐得住餐飲油煙與長時間營業；機身僅 363×321×191mm，占桌面小。',
        'hardware.xelf.name': 'XELF II 自助點餐機（FEC）',
        'hardware.xelf.tagline': '模組化自助點餐，小店到大廳全對應',
        'hardware.xelf.spec1': '<b>15.6" / 22" 雙尺寸 + 橫直向自由配置</b> — 同一產品線同時支援 15.6 吋與 22 吋面板，可橫向或直向安裝，小店到大店、窄入口到寬廳都能對應。',
        'hardware.xelf.spec2': '<b>掃碼 + 出單 + 金流模組整合一機</b> — 內建條碼掃描（Henex H22／Newland FM6080），支援主流出單機（EPSON M30 II/III、Seiko RP-D10）與刷卡金流端（Verifone、PAX、Ingenico），點餐到付款一機完成，刷卡模組現成可接。',
        'hardware.xelf.spec3': '<b>壓鑄鋁機身 + 商用耐用設計</b> — 鋁壓鑄＋塑鋼結構、2×2W 喇叭，通過 FCC／CE Class B 認證，適合公共場域天天被按、耐撞耐用。',
        'hardware.xelf.spec4': '<b>選配擴充彈性極大</b> — MSR／指紋／NFC、LED 燈條＋鏡頭二合一、發票印表機、載具/護照掃描、取票/發卡、紙鈔辨識、ADA 無障礙鍵盤等，可從餐飲自助點餐延伸到零售、報到、旅宿。',
        'hardware.xelf.spec5': '<b>桌上型 / 落地型雙形態</b> — 落地型 1550×500×500mm（43kg）入口吸睛、桌上型 792×378×364mm（29kg）省櫃檯空間，依場域選型，單機即可獨立運作。',
```

- [ ] **Step 3: Add English hardware keys**

In the `en` block, after its `'autopos.bil.jp': 'Japanese UI',` line (~1352), add:

```javascript
        'nav.hardware': 'Hardware',
        'hardware.eyebrow': 'Hardware · One-stop software + hardware delivery',
        'hardware.h2': 'Durable terminals built for the F&B front line.',
        'hardware.cta': 'Request a quote',
        'hardware.xelf.hint': 'Tap to see more angles',
        'hardware.apone.name': 'autopos ONE Smart POS',
        'hardware.apone.tagline': 'Mainstream x86 power, built to last on the floor',
        'hardware.apone.spec1': '<b>Mainstream x86 power × Windows</b> — Intel N95 with 8GB RAM + 128GB SSD on Win 10/11. High software compatibility; run POS, membership and online orders in multiple windows without lag — none of the expansion or compatibility limits of Android POS.',
        'hardware.apone.spec2': '<b>15.6" Full HD IPS multi-touch</b> — 1920×1080 IPS panel with G+G capacitive multi-touch: large, crisp text, wide viewing angle and responsive touch. Zero learning curve for staff, fast ordering at peak hours.',
        'hardware.apone.spec3': '<b>Dual-band WiFi + Gigabit + Bluetooth 5.3</b> — 2.4G/5G dual-band WiFi, 10/100/1000M wired LAN and BT5.3 all included. Stable connectivity with wired/wireless failover, and one-pass pairing for Bluetooth peripherals.',
        'hardware.apone.spec4': '<b>Rich I/O — one unit links every peripheral</b> — HDMI×1, COM×2, USB2.0×2, USB3.0×2, RJ45 and audio jack connect customer display, printer, cash drawer, scanner and card reader at once, with no add-on adapters.',
        'hardware.apone.spec5': '<b>Commercial-grade durability</b> — metal + PC-ABS chassis, 3W speaker, 12V/4A power, −10~45℃ operating range and CCC certified — built for kitchen grease and long trading hours. Compact 363×321×191mm footprint.',
        'hardware.xelf.name': 'XELF II Self-Order Kiosk (FEC)',
        'hardware.xelf.tagline': 'Modular self-ordering — from small shops to large halls',
        'hardware.xelf.spec1': '<b>15.6" / 22" sizes + free portrait/landscape mount</b> — One product line supports both 15.6" and 22" panels, mounted landscape or portrait — fitting everything from small shops to large venues, narrow entries to wide halls.',
        'hardware.xelf.spec2': '<b>Scanning + printing + payment in one unit</b> — Built-in barcode scanning (Henex H22 / Newland FM6080), with support for mainstream printers (EPSON M30 II/III, Seiko RP-D10) and card-payment terminals (Verifone, PAX, Ingenico). Order to payment on one device; the card module is ready to connect.',
        'hardware.xelf.spec3': '<b>Die-cast aluminum body + commercial durability</b> — Die-cast aluminum + PC-ABS structure, 2×2W speakers, FCC / CE Class B certified — built for public spaces pressed daily, impact-resistant and durable.',
        'hardware.xelf.spec4': '<b>Huge optional expansion</b> — MSR / fingerprint / NFC, LED light bar + camera combo, invoice printer, carrier/passport scanning, ticket/card dispensing, banknote recognition, ADA accessible keypad and more — extending from F&B self-order to retail, check-in and hospitality.',
        'hardware.xelf.spec5': '<b>Floor-standing / countertop dual form</b> — Floor model 1550×500×500mm (43kg) draws attention at the entrance; countertop model 792×378×364mm (29kg) saves counter space. Choose by venue; each runs standalone.',
```

- [ ] **Step 4: Add Japanese hardware keys**

In the `ja` block, after its `'autopos.bil.jp': '日本語 画面',` line (~1521), add:

```javascript
        'nav.hardware': 'ハードウェア',
        'hardware.eyebrow': 'ハードウェア · ソフト＆ハード一括導入',
        'hardware.h2': '飲食の現場のために作られた、堅牢な端末。',
        'hardware.cta': '見積もり依頼',
        'hardware.xelf.hint': 'タップして他のアングルを表示',
        'hardware.apone.name': 'autopos ONE スマートPOS',
        'hardware.apone.tagline': '主流 x86 性能、現場で長く使える一台',
        'hardware.apone.spec1': '<b>主流 x86 性能 × Windows</b> — Intel N95 に 8GB メモリ + 128GB SSD、Win 10/11。ソフト互換性が高く、会計・会員・オンライン注文を複数ウィンドウで同時に動かしても重くならず、Android POS の拡張・互換の制約もありません。',
        'hardware.apone.spec2': '<b>15.6 インチ Full HD IPS マルチタッチ</b> — 1920×1080 IPS パネル + G+G 静電容量マルチタッチ。文字が大きく鮮明、広視野角でタッチも軽快。スタッフは学習不要、ピーク時も素早く操作できます。',
        'hardware.apone.spec3': '<b>デュアルバンド WiFi + Gigabit + Bluetooth 5.3</b> — 2.4G/5G デュアルバンド WiFi、10/100/1000M 有線 LAN、BT5.3 を完備。接続は安定し、有線・無線の相互バックアップが可能。Bluetooth 周辺機器も一度でペアリングできます。',
        'hardware.apone.spec4': '<b>豊富な外部端子、一台で全周辺機器を接続</b> — HDMI×1、COM×2、USB2.0×2、USB3.0×2、RJ45、音声端子を搭載。カスタマーディスプレイ、プリンター、キャッシュドロア、スキャナー、カードリーダーを変換アダプタなしで一括接続。',
        'hardware.apone.spec5': '<b>商用グレードの堅牢設計</b> — 金属＋PC-ABS 筐体、3W スピーカー、12V/4A 電源、動作温度 −10~45℃、CCC 認証取得。油煙や長時間営業にも耐え、筐体は 363×321×191mm とコンパクト。',
        'hardware.xelf.name': 'XELF II セルフオーダー端末（FEC）',
        'hardware.xelf.tagline': 'モジュール式セルフオーダー、小店から大ホールまで',
        'hardware.xelf.spec1': '<b>15.6" / 22" の2サイズ + 縦横自由設置</b> — 同一製品ラインで 15.6 インチと 22 インチに対応し、横・縦どちらでも設置可能。小型店から大型店、狭い入口から広いホールまで対応します。',
        'hardware.xelf.spec2': '<b>スキャン + 印刷 + 決済モジュールを一台に統合</b> — バーコードスキャン（Henex H22／Newland FM6080）を内蔵し、主流プリンター（EPSON M30 II/III、Seiko RP-D10）とカード決済端末（Verifone、PAX、Ingenico）に対応。注文から支払いまで一台で完結、決済モジュールもすぐ接続できます。',
        'hardware.xelf.spec3': '<b>ダイカストアルミ筐体 + 商用耐久設計</b> — アルミダイカスト＋PC-ABS 構造、2×2W スピーカー、FCC／CE Class B 認証。毎日操作される公共空間にも適し、衝撃に強く長持ちします。',
        'hardware.xelf.spec4': '<b>豊富な拡張オプション</b> — MSR／指紋／NFC、LED ライトバー＋カメラ一体型、レシートプリンター、キャリア/パスポート読取、発券/カード発行、紙幣識別、ADA バリアフリーキーパッドなど。飲食のセルフオーダーから小売・受付・宿泊まで拡張できます。',
        'hardware.xelf.spec5': '<b>卓上型 / 据置型の2形態</b> — 据置型 1550×500×500mm（43kg）は入口で目を引き、卓上型 792×378×364mm（29kg）はカウンターを節約。設置場所に合わせて選べ、一台で独立稼働します。',
```

- [ ] **Step 5: Add Vietnamese hardware keys**

In the `vi` block, after its `'autopos.bil.jp': 'Giao diện Tiếng Nhật',` line (~1690), add:

```javascript
        'nav.hardware': 'Phần cứng',
        'hardware.eyebrow': 'Phần cứng · Trọn gói phần mềm & phần cứng',
        'hardware.h2': 'Thiết bị bền bỉ, sinh ra cho tuyến đầu ngành F&B.',
        'hardware.cta': 'Yêu cầu báo giá',
        'hardware.xelf.hint': 'Chạm để xem thêm góc nhìn',
        'hardware.apone.name': 'autopos ONE Máy POS thông minh',
        'hardware.apone.tagline': 'Sức mạnh x86 phổ thông, bền bỉ tại hiện trường',
        'hardware.apone.spec1': '<b>Sức mạnh x86 phổ thông × Windows</b> — Intel N95 với 8GB RAM + 128GB SSD, Win 10/11. Tương thích phần mềm cao; chạy thu ngân, thành viên và đơn online nhiều cửa sổ cùng lúc không giật — không vướng giới hạn mở rộng và tương thích của POS Android.',
        'hardware.apone.spec2': '<b>Cảm ứng đa điểm IPS Full HD 15.6"</b> — Màn IPS 1920×1080 với cảm ứng điện dung đa điểm G+G: chữ to rõ, góc nhìn rộng, cảm ứng nhạy. Nhân viên không cần học, gọi món nhanh giờ cao điểm.',
        'hardware.apone.spec3': '<b>WiFi hai băng tần + Gigabit + Bluetooth 5.3</b> — WiFi hai băng tần 2.4G/5G, LAN có dây 10/100/1000M và BT5.3 đầy đủ. Kết nối ổn định, dự phòng có dây/không dây, ghép nối thiết bị Bluetooth trong một lần.',
        'hardware.apone.spec4': '<b>Cổng kết nối phong phú, một máy nối mọi thiết bị</b> — HDMI×1, COM×2, USB2.0×2, USB3.0×2, RJ45 và cổng âm thanh kết nối màn hình khách, máy in, ngăn kéo tiền, máy quét và máy quẹt thẻ cùng lúc, không cần bộ chuyển.',
        'hardware.apone.spec5': '<b>Kết cấu bền chuẩn thương mại</b> — Thân kim loại + PC-ABS, loa 3W, nguồn 12V/4A, nhiệt độ hoạt động −10~45℃, đạt chứng nhận CCC — chịu được dầu mỡ và kinh doanh dài giờ. Kích thước gọn 363×321×191mm.',
        'hardware.xelf.name': 'XELF II Kiosk tự gọi món (FEC)',
        'hardware.xelf.tagline': 'Tự gọi món dạng mô-đun — từ quán nhỏ đến sảnh lớn',
        'hardware.xelf.spec1': '<b>Hai cỡ 15.6" / 22" + lắp dọc/ngang tự do</b> — Cùng một dòng sản phẩm hỗ trợ cả màn 15.6" và 22", lắp ngang hoặc dọc — phù hợp từ quán nhỏ đến cửa hàng lớn, lối vào hẹp đến sảnh rộng.',
        'hardware.xelf.spec2': '<b>Quét mã + in + thanh toán tích hợp một máy</b> — Tích hợp quét mã vạch (Henex H22 / Newland FM6080), hỗ trợ máy in phổ biến (EPSON M30 II/III, Seiko RP-D10) và thiết bị thanh toán thẻ (Verifone, PAX, Ingenico). Từ gọi món đến thanh toán trên một máy; mô-đun thẻ sẵn sàng kết nối.',
        'hardware.xelf.spec3': '<b>Thân nhôm đúc + thiết kế bền thương mại</b> — Kết cấu nhôm đúc + PC-ABS, loa 2×2W, đạt chứng nhận FCC / CE Class B — phù hợp nơi công cộng bị bấm mỗi ngày, chống va đập và bền.',
        'hardware.xelf.spec4': '<b>Khả năng mở rộng tùy chọn cực lớn</b> — MSR / vân tay / NFC, thanh LED + camera hai trong một, máy in hóa đơn, quét thẻ/hộ chiếu, phát vé/thẻ, nhận diện tiền giấy, bàn phím tiếp cận ADA… mở rộng từ tự gọi món F&B sang bán lẻ, check-in và lưu trú.',
        'hardware.xelf.spec5': '<b>Hai dạng đứng sàn / để bàn</b> — Bản đứng sàn 1550×500×500mm (43kg) hút mắt ở lối vào; bản để bàn 792×378×364mm (29kg) tiết kiệm quầy. Chọn theo không gian; mỗi máy chạy độc lập.',
```

- [ ] **Step 6: Verify all languages**

Reload `http://localhost:8000`. Switch language to each of 中/EN/日/VI via the language picker.
Expected: The hardware section's eyebrow, h2, both product names/taglines, all 10 spec bullets (bold lead-in rendered), the CTA button, the XELF hint, and the `硬體設備`/`Hardware`/… nav link all change with the selected language. Bold lead-ins render (not literal `<b>` text). No missing-key fallbacks (no Chinese left over when EN is selected).

- [ ] **Step 7: Commit**

```bash
cd ~/SOFONE
git add index.html
git commit -m "feat(hardware): add i18n keys (zh-TW/en/ja/vi) and nav link"
```

---

### Task 5: Final review + deploy

**Files:** none (verification + deploy only)

- [ ] **Step 1: Full visual pass**

Reload `http://localhost:8000`. Confirm:
- Section sits between Autopos and CentrDX, background matches `--c-bg`.
- Reveal-on-scroll animates the eyebrow/h2/showcase.
- Panel switching + XELF fan-out work after a hard refresh.
- Responsive: narrow the window below 860px — thumbnails become a horizontal row, panels stack to single column.

- [ ] **Step 2: Stop the local server**

Stop the background `python3 -m http.server` process.

- [ ] **Step 3: Deploy to production (requires user confirmation)**

This is a production deploy — confirm with the user first, then:

```bash
cd ~/SOFONE
vercel --prod
```

Expected: deployment reaches READY; the live URL shows the new section. Note the deployment URL in the summary.

- [ ] **Step 4: Verify live**

Open the production URL, scroll to the hardware section, switch a language, and toggle the XELF fan-out to confirm parity with local.

---

## Open items (carry from spec)

- Real EN/JA/VI translations above are drafted from the zh-TW source; have a native reviewer proof them when convenient.
- KIOSK and Table Kiosk intentionally excluded from this section.
