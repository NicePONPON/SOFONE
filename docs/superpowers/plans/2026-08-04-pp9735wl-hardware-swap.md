# FEC PP-9735WL Hardware Swap Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the cancelled autopos ONE with the FEC PP-9735WL across the SOFONE landing page, removing every stale autopos ONE asset, spec value, and i18n key.

**Architecture:** SOFONE is a single-file static site — `index.html` holds markup, all four i18n language packs, and all JavaScript inline; `style.css` holds styles. No build step, no test framework. Verification is therefore done with `grep`/Node assertion scripts run against the source, plus a local HTTP server for visual checks. Deploy is `git push origin main` → Vercel auto-builds.

**Tech Stack:** Static HTML/CSS/vanilla JS, `cwebp` for image conversion, `pyftsubset` (fonttools, in a scratchpad venv) for font subsetting, Node for verification scripts.

## Global Constraints

- Product name is exactly **`FEC PP-9735WL`** — never `PP-9735W`, `PP-9735L`, or `PP-9735WL` without the `FEC` prefix in user-visible name fields.
- Second display model is exactly **`XM-3010W`** — never `XM-1010W`.
- Branding is **straight vendor hardware**. No "autopos ONE" wording, no autopos-cloud tie-in copy.
- All four language packs (`zh-TW`, `en`, `ja`, `vi`) must end with **identical key sets**. Key namespace is `pp97.*` (renamed from `apone.*`).
- RAM / storage / OS are SOFONE's configured build (**DDR4 8GB, M.2 SSD 128GB, Windows 11 IoT Enterprise**), not FEC's base SKU.
- XM-3010W panel resolution is **deliberately omitted** — not published by FEC. Do not invent one.
- Served asset paths must not contain `+`. Use `assets/pp9735/`.
- Do not deploy (`git push`) until Task 9 explicitly authorises it.

**Scratchpad for temp files:** `/private/tmp/claude-501/-Users-chi-yuliao/5ee21671-f88b-45f2-ade0-106ba73dcb1f/scratchpad`

---

### Task 1: Convert product photos to WebP

**Files:**
- Read: `assets/PP-9735WL+XM-3010W/PP-9735L_{01,02,03,04,05}.png`
- Create: `assets/pp9735/pp9735-{1,2,3,4,5}.webp`

**Interfaces:**
- Produces: five WebP files at `assets/pp9735/pp9735-N.webp`, where the index N maps to slider position N−1 in the rotation order defined below. Tasks 2 and 4 reference these exact paths.

**Rotation order** (source → output; this ordering is what makes dragging read as rotation):

| Output | Source | Angle |
|---|---|---|
| `pp9735-1.webp` | `PP-9735L_01.png` | front |
| `pp9735-2.webp` | `PP-9735L_03.png` | ¾ front |
| `pp9735-3.webp` | `PP-9735L_05.png` | side profile |
| `pp9735-4.webp` | `PP-9735L_04.png` | ¾ rear |
| `pp9735-5.webp` | `PP-9735L_02.png` | rear |

- [ ] **Step 1: Confirm the source files exist and are 1000×1000**

```bash
cd ~/SOFONE
for f in 01 02 03 04 05; do
  sips -g pixelWidth -g pixelHeight "assets/PP-9735WL+XM-3010W/PP-9735L_${f}.png" | tail -2
done
```

Expected: each reports `pixelWidth: 1000` and `pixelHeight: 1000`.

- [ ] **Step 2: Convert to WebP at 800px with alpha preserved**

The source PNGs have transparent backgrounds (the product floats on white). `-q 82` matches the quality used for the existing KS-1000/XELF assets; `-alpha_q 100` avoids halos on the transparent edge.

```bash
cd ~/SOFONE
mkdir -p assets/pp9735
convert_one() {  # $1 = source suffix, $2 = output index
  cwebp -q 82 -alpha_q 100 -resize 800 0 \
    "assets/PP-9735WL+XM-3010W/PP-9735L_$1.png" \
    -o "assets/pp9735/pp9735-$2.webp"
}
convert_one 01 1
convert_one 03 2
convert_one 05 3
convert_one 04 4
convert_one 02 5
```

- [ ] **Step 3: Verify output size and dimensions**

```bash
cd ~/SOFONE && ls -la assets/pp9735/ && \
  for i in 1 2 3 4 5; do cwebp -version >/dev/null; \
  sips -g pixelWidth "assets/pp9735/pp9735-$i.webp" | tail -1; done
```

Expected: five files present, each **under 120 KB** (sources are 293–730 KB PNG), each `pixelWidth: 800`.

If any file exceeds 120 KB, re-run that one at `-q 75`.

- [ ] **Step 4: Commit**

```bash
cd ~/SOFONE
git add assets/pp9735/
git commit -m "Add FEC PP-9735WL product photos (WebP, 800px)"
```

---

### Task 2: Swap the markup — hero, lineup card, viewer

**Files:**
- Modify: `index.html:166` (hero device image)
- Modify: `index.html:456-463` (catalogue id + lineup card)
- Modify: `index.html:483-504` (viewer frames + slider)

**Interfaces:**
- Consumes: `assets/pp9735/pp9735-{1..5}.webp` from Task 1.
- Produces: `data-vis="pp97"` on the visual container and `data-machine="pp97"` on the lineup button — Task 3's `HW` object key must match this string exactly.

- [ ] **Step 1: Write the failing verification script**

Create `/private/tmp/claude-501/-Users-chi-yuliao/5ee21671-f88b-45f2-ade0-106ba73dcb1f/scratchpad/check-markup.js`:

```js
const fs = require('fs');
const html = fs.readFileSync(process.argv[2] || 'index.html', 'utf8');
const fail = [];

// Hero device must use the new photo
if (!html.includes('src="assets/pp9735/pp9735-1.webp" alt="FEC PP-9735WL"'))
  fail.push('hero/lineup: pp9735-1.webp not wired');

// Lineup card renamed
if (!html.includes('data-machine="pp97"')) fail.push('lineup: data-machine not pp97');
if (!html.includes('>FEC PP-9735WL<')) fail.push('lineup: visible name not "FEC PP-9735WL"');
if (!html.includes('data-i18n="hw.lineup.pp97.d"')) fail.push('lineup: desc key not renamed');

// Catalogue id renamed
if (!html.includes('class="hw-catalogue" id="hardware-catalogue"'))
  fail.push('catalogue: id not renamed to hardware-catalogue');

// Viewer: exactly 5 frames, slider max=4
if (!html.includes('data-vis="pp97"')) fail.push('viewer: data-vis not pp97');
const frames = (html.match(/assets\/pp9735\/pp9735-[1-5]\.webp/g) || []).length;
if (frames < 5) fail.push(`viewer: expected >=5 frame refs, found ${frames}`);
if (!html.includes('class="ap-one-slider" min="0" max="4"'))
  fail.push('viewer: slider max is not 4');

// No stale autopos ONE traces in markup
if (/autoposone_demo/.test(html)) fail.push('stale: autoposone_demo_* still referenced');
if (/autopos ONE/.test(html)) fail.push('stale: "autopos ONE" text still present');

if (fail.length) { console.error('FAIL:\n - ' + fail.join('\n - ')); process.exit(1); }
console.log('PASS: markup checks');
```

- [ ] **Step 2: Run it to confirm it fails**

```bash
cd ~/SOFONE && node /private/tmp/claude-501/-Users-chi-yuliao/5ee21671-f88b-45f2-ade0-106ba73dcb1f/scratchpad/check-markup.js
```

Expected: `FAIL:` listing every check (nothing has been changed yet).

- [ ] **Step 3: Swap the hero device image**

Replace at `index.html:166`:

```html
          <img loading="lazy" src="assets/demo/webp/autoposone_demo_01.webp" alt="autopos POS" class="device-img" draggable="false">
```

with:

```html
          <img loading="lazy" src="assets/pp9735/pp9735-1.webp" alt="FEC PP-9735WL" class="device-img" draggable="false">
```

- [ ] **Step 4: Fix the stale section comment**

At `index.html:451`, replace:

```html
      <!-- Hardware showcase heading (moved above autopos ONE) -->
```

with:

```html
      <!-- Hardware showcase heading -->
```

- [ ] **Step 5: Rename the catalogue id and rewrite the lineup card**

Replace:

```html
      <div class="hw-catalogue" id="apone">
        <div class="hw-lineup reveal">
          <button type="button" class="hw-lc" data-machine="apone">
            <span class="hw-lc-img"><img src="assets/demo/webp/autoposone_demo_01.webp" alt="autopos ONE" loading="lazy"></span>
            <span class="hw-lc-name">autopos ONE</span>
            <span class="hw-lc-desc" data-i18n="hw.lineup.one.d">專業級 POS 終端</span>
```

with:

```html
      <div class="hw-catalogue" id="hardware-catalogue">
        <div class="hw-lineup reveal">
          <button type="button" class="hw-lc" data-machine="pp97">
            <span class="hw-lc-img"><img src="assets/pp9735/pp9735-1.webp" alt="FEC PP-9735WL" loading="lazy"></span>
            <span class="hw-lc-name">FEC PP-9735WL</span>
            <span class="hw-lc-desc" data-i18n="hw.lineup.pp97.d">專業級 POS 終端</span>
```

- [ ] **Step 6: Replace the 12-frame viewer with 5 frames**

Replace the whole block from `<!-- autopos ONE — 360° rolling frames -->` down to and including the `</div>` that closes `.ap-one-scrub` (currently lines 482–504) with:

```html
              <!-- FEC PP-9735WL — multi-angle rolling frames -->
              <div class="hwc-vis" data-vis="pp97">
                <div class="ap-one hwc-ap">
                  <div class="ap-one-viewer-ring">
                    <div class="ap-one-viewer" role="img" aria-label="FEC PP-9735WL 多視角展示">
                      <img loading="lazy" class="ap-one-frame is-active" src="assets/pp9735/pp9735-1.webp" alt="FEC PP-9735WL 正面" draggable="false">
                      <img class="ap-one-frame" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" data-src="assets/pp9735/pp9735-2.webp" loading="lazy" alt="FEC PP-9735WL 前四分之三角度" draggable="false">
                      <img class="ap-one-frame" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" data-src="assets/pp9735/pp9735-3.webp" loading="lazy" alt="FEC PP-9735WL 側面" draggable="false">
                      <img class="ap-one-frame" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" data-src="assets/pp9735/pp9735-4.webp" loading="lazy" alt="FEC PP-9735WL 後四分之三角度" draggable="false">
                      <img class="ap-one-frame" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" data-src="assets/pp9735/pp9735-5.webp" loading="lazy" alt="FEC PP-9735WL 背面" draggable="false">
                    </div>
                  </div>
                  <div class="ap-one-scrub">
                    <input type="range" class="ap-one-slider" min="0" max="4" step="1" value="0" aria-label="拖曳檢視 FEC PP-9735WL 各視角">
                    <span class="ap-one-scrub-hint" data-i18n="pp97.viewer.hint">拖曳旋轉檢視</span>
                  </div>
```

**Note:** the first frame keeps a real `src` (it is the visible default); frames 2–5 keep the 1×1 GIF placeholder + `data-src`, which the existing `loadAllFrames()` swaps in on first interaction. Do not change that pattern.

- [ ] **Step 7: Run the verification script**

```bash
cd ~/SOFONE && node /private/tmp/claude-501/-Users-chi-yuliao/5ee21671-f88b-45f2-ade0-106ba73dcb1f/scratchpad/check-markup.js
```

Expected: `PASS: markup checks`

- [ ] **Step 8: Commit**

```bash
cd ~/SOFONE
git add index.html
git commit -m "Swap hero, lineup card and viewer to FEC PP-9735WL (5 angles)"
```

---

### Task 3: Update the JavaScript — drop frame config, rewrite catalogue entry

**Files:**
- Modify: `index.html:2119-2152` (delete `AP_ONE_FRAME_CONFIG` and its consumer block)
- Modify: `index.html:2516-2518` (`HW.apone` → `HW.pp97`)

**Interfaces:**
- Consumes: `data-machine="pp97"` / `data-vis="pp97"` from Task 2.
- Produces: i18n key references `pp97.eyebrow`, `pp97.h3`, and seven `pp97.spec.*.{label,val}` pairs — Tasks 4 and 5 must define exactly these keys.

**Critical:** `AP_ONE_FRAME_CONFIG` is read at line 2146 inside `initApOneViewer()`. Deleting the array **without** also deleting that consumer block throws `ReferenceError` and breaks all three viewers. Both edits are mandatory and must land together.

- [ ] **Step 1: Write the failing verification script**

Create `.../scratchpad/check-js.js`:

```js
const fs = require('fs');
const html = fs.readFileSync(process.argv[2] || 'index.html', 'utf8');
const fail = [];

if (/AP_ONE_FRAME_CONFIG/.test(html)) fail.push('AP_ONE_FRAME_CONFIG still present');
if (/HW\s*=\s*\{[\s\S]{0,80}apone:/.test(html)) fail.push('HW.apone key still present');
if (!/pp97:\s*\{\s*img:'assets\/pp9735\/pp9735-1\.webp'/.test(html))
  fail.push('HW.pp97 entry missing or wrong img');

const specKeys = ['os','screen','cpu','ram','storage','net','disp2'];
for (const k of specKeys) {
  if (!html.includes(`['pp97.spec.${k}.label','pp97.spec.${k}.val']`))
    fail.push(`HW.pp97 specs missing ${k}`);
}
if (/apone\./.test(html)) fail.push('stale apone.* key reference remains');

if (fail.length) { console.error('FAIL:\n - ' + fail.join('\n - ')); process.exit(1); }
console.log('PASS: js checks');
```

- [ ] **Step 2: Run it to confirm it fails**

```bash
cd ~/SOFONE && node /private/tmp/claude-501/-Users-chi-yuliao/5ee21671-f88b-45f2-ade0-106ba73dcb1f/scratchpad/check-js.js
```

Expected: `FAIL:` listing `AP_ONE_FRAME_CONFIG still present`, `HW.apone key still present`, and the missing `pp97` entries.

- [ ] **Step 3: Delete the frame-config array**

Delete lines 2119–2134 entirely — the `/* ── autopos ONE 360° Viewer ── */` comment, the whole `var AP_ONE_FRAME_CONFIG = [ ... ];` array, and the blank line after it.

- [ ] **Step 4: Delete the consumer block and fix the stale comment**

Replace:

```js
    /* Drives every .ap-one-viewer-ring: drag the scrub bar (or swipe) to switch frames.
       The calibrated per-frame transforms apply only to the 12-frame autopos ONE viewer;
       other viewers (e.g. KS-1000, 3 frames) simply cross-fade. */
    function initApOneViewer(ring) {
      var viewer      = ring.querySelector('.ap-one-viewer');
      var frames      = viewer.querySelectorAll('.ap-one-frame');
      var slider      = (ring.closest('.ap-one') || document).querySelector('.ap-one-slider');
      var total       = frames.length;
      var current     = 0;
      var touchStartX = 0;

      if (total === AP_ONE_FRAME_CONFIG.length) {
        for (var i = 0; i < total; i++) {
          var c = AP_ONE_FRAME_CONFIG[i];
          frames[i].style.transformOrigin = 'center center';
          frames[i].style.transform = 'translate(' + c.x + '%, ' + c.y + '%) scale(' + c.scale + ')';
        }
      }
```

with:

```js
    /* Drives every .ap-one-viewer-ring: drag the scrub bar (or swipe) to switch frames.
       All viewers (PP-9735WL 5 frames, KS-1000 7 frames) simply cross-fade. */
    function initApOneViewer(ring) {
      var viewer      = ring.querySelector('.ap-one-viewer');
      var frames      = viewer.querySelectorAll('.ap-one-frame');
      var slider      = (ring.closest('.ap-one') || document).querySelector('.ap-one-slider');
      var total       = frames.length;
      var current     = 0;
      var touchStartX = 0;
```

- [ ] **Step 5: Rewrite the catalogue data entry**

Replace:

```js
      apone: { img:'assets/demo/webp/autoposone_demo_01.webp', eyebrow:'apone.eyebrow', title:'apone.h3', titleHtml:true,
        specs:[['apone.spec.os.label','apone.spec.os.val'],['apone.spec.screen.label','apone.spec.screen.val'],['apone.spec.cpu.label','apone.spec.cpu.val'],['apone.spec.touch.label','apone.spec.touch.val'],['apone.spec.storage.label','apone.spec.storage.val'],['apone.spec.net.label','apone.spec.net.val']],
        cta:'hardware.cta', href:'mailto:chris.chen@sofone.ai', mail:true },
```

with:

```js
      pp97: { img:'assets/pp9735/pp9735-1.webp', eyebrow:'pp97.eyebrow', title:'pp97.h3', titleHtml:true,
        specs:[['pp97.spec.os.label','pp97.spec.os.val'],['pp97.spec.screen.label','pp97.spec.screen.val'],['pp97.spec.cpu.label','pp97.spec.cpu.val'],['pp97.spec.ram.label','pp97.spec.ram.val'],['pp97.spec.storage.label','pp97.spec.storage.val'],['pp97.spec.net.label','pp97.spec.net.val'],['pp97.spec.disp2.label','pp97.spec.disp2.val']],
        cta:'hardware.cta', href:'mailto:chris.chen@sofone.ai', mail:true },
```

- [ ] **Step 6: Run the verification script**

```bash
cd ~/SOFONE && node /private/tmp/claude-501/-Users-chi-yuliao/5ee21671-f88b-45f2-ade0-106ba73dcb1f/scratchpad/check-js.js
```

Expected: `PASS: js checks`

- [ ] **Step 7: Commit**

```bash
cd ~/SOFONE
git add index.html
git commit -m "Drop AP_ONE_FRAME_CONFIG; point hardware catalogue at PP-9735WL"
```

---

### Task 4: Rewrite the zh-TW language pack

**Files:**
- Modify: `index.html` — zh-TW block, currently lines 1128, 1132-1133, 1149-1159, 1191-1204

**Interfaces:**
- Consumes: the seven `pp97.spec.*` key names and `pp97.eyebrow` / `pp97.h3` from Task 3, plus `pp97.viewer.hint` and `hw.lineup.pp97.d` from Task 2.
- Produces: the canonical key set that Task 5 replicates into `en`, `ja`, and `vi`.

- [ ] **Step 1: Rename the lineup description key**

At line 1128, change only the first key (`hw.lineup.one.d` → `hw.lineup.pp97.d`); leave the rest of the line untouched:

```js
        'hw.lineup.pp97.d': '專業級 POS 終端', 'hw.lineup.xelf.d': '模組化自助點餐終端', 'hw.lineup.ks.d': '整合式自助服務機', 'hw.lineup.more': '查看詳情 →',
```

- [ ] **Step 2: Delete the two dead `hardware.apone.*` keys**

Delete lines 1132–1133 entirely:

```js
        'hardware.apone.name': 'autopos ONE 智慧收銀機',
        'hardware.apone.tagline': '主流 x86 效能，餐飲現場耐用之選',
```

- [ ] **Step 3: Replace the 11-line spec run with 7 lines**

Replace all of lines 1149–1159 (from `'apone.spec.os.label'` through `'apone.spec.disp2.val'`) with:

```js
        'pp97.spec.os.label': '作業系統', 'pp97.spec.os.val': 'Windows 11 IoT Enterprise',
        'pp97.spec.screen.label': '螢幕', 'pp97.spec.screen.val': '15.6" 1920×1080 全平面電容觸控',
        'pp97.spec.cpu.label': '處理器', 'pp97.spec.cpu.val': 'Intel Celeron J6412 2.6GHz',
        'pp97.spec.ram.label': '記憶體', 'pp97.spec.ram.val': 'DDR4 8GB（最大 32GB）',
        'pp97.spec.storage.label': '儲存', 'pp97.spec.storage.val': 'M.2 SSD 128GB',
        'pp97.spec.net.label': '連網', 'pp97.spec.net.val': 'Gigabit LAN・WiFi 802.11ac・BT',
        'pp97.spec.disp2.label': '第二螢幕（選配）', 'pp97.spec.disp2.val': 'XM-3010W 10.1"',
```

This drops `touch` (folded into the screen line), `io`, `temp`, and `size`.

- [ ] **Step 4: Replace the 14-line copy run with 3 lines**

Replace all of lines 1191–1204 (from `'apone.eyebrow'` through `'apone.feat.f4.desc'`) with:

```js
        'pp97.eyebrow': 'FEC PP-9735WL · 專業級 POS 終端',
        'pp97.h3': '無風扇工業設計，<span class="hl">15.6" 全平面觸控主機</span>。',
        'pp97.viewer.hint': '拖曳旋轉檢視',
```

This deletes `apone.features.label` and all ten `apone.feat.*` keys.

- [ ] **Step 5: Verify no `apone` remains in the zh-TW block**

```bash
cd ~/SOFONE && sed -n '1100,1250p' index.html | grep -n "apone" && echo "STILL PRESENT" || echo "PASS: zh-TW clean"
```

Expected: `PASS: zh-TW clean`

- [ ] **Step 6: Commit**

```bash
cd ~/SOFONE
git add index.html
git commit -m "i18n(zh-TW): replace autopos ONE keys with PP-9735WL specs"
```

---

### Task 5: Rewrite the en / ja / vi language packs

**Files:**
- Modify: `index.html` — `en` block (lines 1352, 1356-1357, 1373-1383, 1415-1428)
- Modify: `index.html` — `ja` block (lines 1576, 1580-1581, 1597-1607, 1639-1652)
- Modify: `index.html` — `vi` block (lines 1800, 1804-1805, 1821-1831, 1863-1876)

**Interfaces:**
- Consumes: the canonical key set established in Task 4. Key names must match character-for-character.

**Line numbers above are pre-edit.** Task 4 removed 15 lines from the zh-TW block, so every line number here has shifted upward. Locate each run by its content (`'apone.spec.os.label'` etc.), not by line number. Apply the same four edits as Task 4 to each language, in the order en → ja → vi.

- [ ] **Step 1: Apply all four edits to the `en` block**

Rename `'hw.lineup.one.d': 'Pro-grade POS terminal'` → `'hw.lineup.pp97.d': 'Pro-grade POS terminal'`.

Delete `'hardware.apone.name'` and `'hardware.apone.tagline'`.

Replace the 11-line spec run with:

```js
        'pp97.spec.os.label': 'Operating System', 'pp97.spec.os.val': 'Windows 11 IoT Enterprise',
        'pp97.spec.screen.label': 'Display', 'pp97.spec.screen.val': '15.6" 1920×1080 True-Flat PCAP touch',
        'pp97.spec.cpu.label': 'Processor', 'pp97.spec.cpu.val': 'Intel Celeron J6412 2.6GHz',
        'pp97.spec.ram.label': 'Memory', 'pp97.spec.ram.val': 'DDR4 8GB (max 32GB)',
        'pp97.spec.storage.label': 'Storage', 'pp97.spec.storage.val': 'M.2 SSD 128GB',
        'pp97.spec.net.label': 'Connectivity', 'pp97.spec.net.val': 'Gigabit LAN · WiFi 802.11ac · BT',
        'pp97.spec.disp2.label': 'Second display (opt.)', 'pp97.spec.disp2.val': 'XM-3010W 10.1"',
```

Replace the 14-line copy run with:

```js
        'pp97.eyebrow': 'FEC PP-9735WL · Professional POS Terminal',
        'pp97.h3': 'Fanless industrial design, <span class="hl">15.6" True-Flat touch terminal.</span>',
        'pp97.viewer.hint': 'Drag to rotate',
```

- [ ] **Step 2: Apply all four edits to the `ja` block**

Rename `'hw.lineup.one.d': 'プロ仕様 POS 端末'` → `'hw.lineup.pp97.d': 'プロ仕様 POS 端末'`.

Delete `'hardware.apone.name'` and `'hardware.apone.tagline'`.

Replace the 11-line spec run with:

```js
        'pp97.spec.os.label': 'OS', 'pp97.spec.os.val': 'Windows 11 IoT Enterprise',
        'pp97.spec.screen.label': 'ディスプレイ', 'pp97.spec.screen.val': '15.6" 1920×1080 フルフラット静電容量タッチ',
        'pp97.spec.cpu.label': 'プロセッサー', 'pp97.spec.cpu.val': 'Intel Celeron J6412 2.6GHz',
        'pp97.spec.ram.label': 'メモリ', 'pp97.spec.ram.val': 'DDR4 8GB（最大 32GB）',
        'pp97.spec.storage.label': 'ストレージ', 'pp97.spec.storage.val': 'M.2 SSD 128GB',
        'pp97.spec.net.label': '通信', 'pp97.spec.net.val': 'Gigabit LAN・WiFi 802.11ac・BT',
        'pp97.spec.disp2.label': 'セカンド画面（オプション）', 'pp97.spec.disp2.val': 'XM-3010W 10.1"',
```

Replace the 14-line copy run with:

```js
        'pp97.eyebrow': 'FEC PP-9735WL · プロ仕様 POS 端末',
        'pp97.h3': 'ファンレス工業デザイン、<span class="hl">15.6インチ フルフラットタッチ端末。</span>',
        'pp97.viewer.hint': 'ドラッグで回転',
```

**Watch out:** the `ja` I/O line (`'apone.spec.io.label': 'I/O', 'apone.spec.io.val': 'HDMI・COM×2・USB×4・RJ45',`) is byte-identical to the zh-TW one. Because Task 4 already removed the zh-TW copy, it is now unique — but if editing out of order, include an adjacent line for disambiguation.

- [ ] **Step 3: Apply all four edits to the `vi` block**

Rename `'hw.lineup.one.d': 'Máy POS chuyên nghiệp'` → `'hw.lineup.pp97.d': 'Máy POS chuyên nghiệp'`.

Delete `'hardware.apone.name'` and `'hardware.apone.tagline'`.

Replace the 11-line spec run with:

```js
        'pp97.spec.os.label': 'Hệ điều hành', 'pp97.spec.os.val': 'Windows 11 IoT Enterprise',
        'pp97.spec.screen.label': 'Màn hình', 'pp97.spec.screen.val': '15.6" 1920×1080 cảm ứng phẳng điện dung',
        'pp97.spec.cpu.label': 'Bộ xử lý', 'pp97.spec.cpu.val': 'Intel Celeron J6412 2.6GHz',
        'pp97.spec.ram.label': 'Bộ nhớ', 'pp97.spec.ram.val': 'DDR4 8GB (tối đa 32GB)',
        'pp97.spec.storage.label': 'Lưu trữ', 'pp97.spec.storage.val': 'M.2 SSD 128GB',
        'pp97.spec.net.label': 'Kết nối', 'pp97.spec.net.val': 'Gigabit LAN · WiFi 802.11ac · BT',
        'pp97.spec.disp2.label': 'Màn hình phụ (tùy chọn)', 'pp97.spec.disp2.val': 'XM-3010W 10.1"',
```

Replace the 14-line copy run with:

```js
        'pp97.eyebrow': 'FEC PP-9735WL · Thiết bị POS chuyên nghiệp',
        'pp97.h3': 'Thiết kế công nghiệp không quạt, <span class="hl">máy cảm ứng phẳng 15.6".</span>',
        'pp97.viewer.hint': 'Kéo để xoay',
```

- [ ] **Step 4: Write the key-parity verification script**

Create `.../scratchpad/check-i18n.js`:

```js
const fs = require('fs');
const html = fs.readFileSync(process.argv[2] || 'index.html', 'utf8');
const fail = [];

if (/apone/.test(html)) {
  const hits = html.split('\n').map((l, i) => [i + 1, l])
    .filter(([, l]) => l.includes('apone'));
  fail.push('stale "apone" at lines: ' + hits.map(([n]) => n).join(', '));
}

// Extract each language pack and compare key sets
const langs = ['zh-TW', 'en', 'ja', 'vi'];
const sets = {};
for (const lang of langs) {
  const re = new RegExp(`'${lang}'\\s*:\\s*\\{`);
  const m = html.match(re);
  if (!m) { fail.push(`language pack ${lang} not found`); continue; }
  const start = m.index;
  const next = langs.map(l => html.indexOf(`'${l}':`, start + 5))
    .filter(i => i > start).sort((a, b) => a - b)[0] || html.length;
  const body = html.slice(start, next);
  sets[lang] = new Set([...body.matchAll(/'([a-zA-Z0-9_.]+)'\s*:/g)].map(x => x[1]));
}
const base = sets['zh-TW'];
for (const lang of langs.slice(1)) {
  if (!sets[lang]) continue;
  const missing = [...base].filter(k => !sets[lang].has(k));
  const extra   = [...sets[lang]].filter(k => !base.has(k));
  if (missing.length) fail.push(`${lang} missing: ${missing.join(', ')}`);
  if (extra.length)   fail.push(`${lang} extra: ${extra.join(', ')}`);
}

const required = ['pp97.eyebrow', 'pp97.h3', 'pp97.viewer.hint', 'hw.lineup.pp97.d',
  ...['os','screen','cpu','ram','storage','net','disp2']
      .flatMap(k => [`pp97.spec.${k}.label`, `pp97.spec.${k}.val`])];
for (const k of required) if (base && !base.has(k)) fail.push(`zh-TW missing ${k}`);

if (fail.length) { console.error('FAIL:\n - ' + fail.join('\n - ')); process.exit(1); }
console.log(`PASS: i18n — ${base.size} keys × ${langs.length} langs, all in sync`);
```

- [ ] **Step 5: Run it**

```bash
cd ~/SOFONE && node /private/tmp/claude-501/-Users-chi-yuliao/5ee21671-f88b-45f2-ade0-106ba73dcb1f/scratchpad/check-i18n.js
```

Expected: `PASS: i18n — <N> keys × 4 langs, all in sync`

If it reports missing/extra keys, fix the offending language pack before continuing. Do not proceed with an unbalanced key set.

- [ ] **Step 6: Commit**

```bash
cd ~/SOFONE
git add index.html
git commit -m "i18n(en/ja/vi): replace autopos ONE keys with PP-9735WL specs"
```

---

### Task 6: Delete orphaned autopos ONE assets

**Files:**
- Delete: `assets/demo/webp/autoposone_demo_{01..12,A1,F1,F2,F3,F4}.webp` (17 files)
- Modify: `dev-360.html` (2 stale references)

- [ ] **Step 1: Confirm nothing in the shipped site references them**

```bash
cd ~/SOFONE && grep -rn "autoposone_demo" --include='*.html' --include='*.css' . | grep -v '^\./dev-'
```

Expected: **no output**. If anything matches, stop — Task 2 or 3 is incomplete.

- [ ] **Step 2: Delete the files**

```bash
cd ~/SOFONE
git rm -q assets/demo/webp/autoposone_demo_*.webp
ls assets/demo/webp/ 2>/dev/null || echo "(directory now empty/removed)"
```

- [ ] **Step 3: Retire the stale dev tool**

`dev-360.html` is the calibration tool for the 12-frame `AP_ONE_FRAME_CONFIG`, which Task 3 deleted. The tool now has no purpose and points at deleted images. Delete it:

```bash
cd ~/SOFONE && git rm -q dev-360.html
```

- [ ] **Step 4: Verify no dangling references anywhere**

```bash
cd ~/SOFONE && grep -rn "autoposone\|dev-360" --include='*.html' --include='*.css' --include='*.md' . \
  | grep -v '^\./docs/superpowers/' || echo "PASS: no dangling references"
```

Expected: `PASS: no dangling references` (spec/plan docs under `docs/superpowers/` legitimately mention the old names as history).

- [ ] **Step 5: Commit**

```bash
cd ~/SOFONE
git commit -q -m "Remove orphaned autopos ONE images and dev-360 calibration tool"
git log --oneline -1
```

---

### Task 7: Verify font glyph coverage

**Files:**
- Possibly modify: `assets/fonts/TaipeiSansTCBeta-{Regular,Bold}.woff2`

The webfonts are **subsets** containing only the glyphs the page used at subsetting time. New copy introduced in Tasks 4–5 (`無風扇`, `全平面觸控主機`, `檢視`, and the katakana in the `ja` pack) may include glyphs that are not in the subset — those would silently fall back to a system font.

- [ ] **Step 1: Check whether any page glyph is missing from the subset**

```bash
cd ~/SOFONE
export SCRATCH=/private/tmp/claude-501/-Users-chi-yuliao/5ee21671-f88b-45f2-ade0-106ba73dcb1f/scratchpad
python3 -m venv "$SCRATCH/fontvenv"
"$SCRATCH/fontvenv/bin/pip" -q install fonttools brotli

# Every unique character in index.html — matches how the subset was originally built
node -e '
  const fs = require("fs");
  const t = fs.readFileSync("index.html", "utf8");
  fs.writeFileSync(process.env.SCRATCH + "/pagetext.txt", [...new Set(t)].join(""));
'

"$SCRATCH/fontvenv/bin/python" - <<'PY'
import os
from fontTools.ttLib import TTFont
scratch = os.environ.get('SCRATCH', '.')
chars = set(open(os.path.join(scratch, 'pagetext.txt'), encoding='utf-8').read())
for name in ('Regular', 'Bold'):
    f = TTFont(f'assets/fonts/TaipeiSansTCBeta-{name}.woff2')
    have = set()
    for table in f['cmap'].tables:
        have |= {chr(c) for c in table.cmap}
    missing = {c for c in chars if c.strip() and c not in have and ord(c) > 0x20}
    print(f'{name}: {len(missing)} missing', ''.join(sorted(missing))[:200])
PY
```

Expected: ideally `Regular: 0 missing` and `Bold: 0 missing`.

- [ ] **Step 2: Re-subset only if Step 1 reported missing glyphs**

Skip this step entirely if both reported `0 missing`.

```bash
cd ~/SOFONE
export SCRATCH=/private/tmp/claude-501/-Users-chi-yuliao/5ee21671-f88b-45f2-ade0-106ba73dcb1f/scratchpad
for W in Regular Bold; do
  "$SCRATCH/fontvenv/bin/pyftsubset" ~/Library/Fonts/TaipeiSansTCBeta-$W.ttf \
    --text-file="$SCRATCH/pagetext.txt" \
    --flavor=woff2 \
    --output-file=assets/fonts/TaipeiSansTCBeta-$W.woff2
done
ls -la assets/fonts/
```

Expected: both files regenerate at roughly 150 KB (the current size). A wildly larger file means the text file picked up markup noise — inspect `pagetext.txt` before committing.

- [ ] **Step 3: Re-run the coverage check**

Re-run the Step 1 python block. Expected: `0 missing` for both weights.

- [ ] **Step 4: Commit (only if fonts changed)**

```bash
cd ~/SOFONE
git diff --quiet assets/fonts/ && echo "fonts unchanged, nothing to commit" || {
  git add assets/fonts/
  git commit -m "Re-subset webfonts to cover new PP-9735WL copy"
}
```

---

### Task 8: Local visual verification

**Files:** none modified — this is a review gate.

- [ ] **Step 1: Run every verification script against the final file**

```bash
cd ~/SOFONE
S=/private/tmp/claude-501/-Users-chi-yuliao/5ee21671-f88b-45f2-ade0-106ba73dcb1f/scratchpad
node $S/check-markup.js && node $S/check-js.js && node $S/check-i18n.js
```

Expected: three `PASS` lines.

- [ ] **Step 2: Start the dev server in the background**

`serve.sh` blocks, so run it detached or it will hang the step:

```bash
cd ~/SOFONE && bash serve.sh
```

Run this with `run_in_background: true`. Serves on `http://localhost:8080`.
Wait ~2s before the next step, and stop the server once Task 8 is complete.

- [ ] **Step 3: Confirm every new asset resolves**

```bash
for i in 1 2 3 4 5; do
  printf "pp9735-%s: " "$i"
  curl -s -o /dev/null -w "%{http_code}\n" "http://localhost:8080/assets/pp9735/pp9735-$i.webp"
done
printf "deleted frame (expect 404): "
curl -s -o /dev/null -w "%{http_code}\n" "http://localhost:8080/assets/demo/webp/autoposone_demo_01.webp"
```

Expected: five `200`s, then `404`.

- [ ] **Step 4: Check for JS errors and confirm the panel renders**

Open `http://localhost:8080` and confirm, **in the browser console and UI**:

1. **Zero console errors** — specifically no `ReferenceError: AP_ONE_FRAME_CONFIG is not defined`. If this appears, Task 3 Step 4 was not applied.
2. The lineup shows **FEC PP-9735WL** as the first card with the front-view thumbnail.
3. Clicking it opens the panel showing **7 spec rows** ending in `第二螢幕（選配） XM-3010W 10.1"`.
4. Dragging the slider steps through all 5 angles with **no blank frames** — frames 2–5 load on first interaction.
5. **XELF II and KS-1000 still work** — their viewers share `initApOneViewer()`, so a Task 3 mistake breaks them too.
6. Switching language to EN / 日本語 / Tiếng Việt updates the eyebrow, heading, and all 7 spec rows with **no raw key strings** (e.g. a literal `pp97.spec.ram.label`) visible.

- [ ] **Step 5: Report findings and stop for user review**

Summarise results. **Do not push.** Wait for explicit approval before Task 9.

---

### Task 9: Deploy

**Files:** none modified.

**Do not start this task until the user has approved Task 8's results.**

- [ ] **Step 1: Confirm the working tree is clean and review the full diff**

```bash
cd ~/SOFONE && git status --short && git log --oneline origin/main..HEAD
```

Expected: clean tree, and the commits from Tasks 1–7 listed.

- [ ] **Step 2: Push to deploy**

```bash
cd ~/SOFONE && git push origin main
```

Vercel auto-builds; live in ~20–40s. There is no CLI step — `vercel` is not installed and the project is not linked locally.

- [ ] **Step 3: Verify production**

```bash
sleep 45
for i in 1 2 3 4 5; do
  printf "pp9735-%s: " "$i"
  curl -s -o /dev/null -w "%{http_code}\n" "https://sofone.vercel.app/assets/pp9735/pp9735-$i.webp"
done
printf "PP-9735WL in markup: "
curl -s https://sofone.vercel.app/ | grep -c "FEC PP-9735WL"
printf "stale autopos ONE refs (expect 0): "
curl -s https://sofone.vercel.app/ | grep -c "autoposone_demo" || true
```

Expected: five `200`s, a non-zero count for `FEC PP-9735WL`, and `0` stale references.

---

## Notes for the implementer

- **`index.html` is ~2900 lines** holding markup, four i18n packs, and all JS. Use string-anchored edits, not line numbers — every task shifts the lines below it.
- **All three hardware viewers share `initApOneViewer()`.** Any change there must be checked against XELF II and KS-1000, not just PP-9735WL.
- **`PP-9735L_11.png`** (the dual-screen / XM-3010W shot) is intentionally left unconverted and unused. Do not add it to the viewer — it breaks the rotation illusion.
- **The source folder `assets/PP-9735WL+XM-3010W/`** stays untracked and is not deployed. Only `assets/pp9735/*.webp` ships.
