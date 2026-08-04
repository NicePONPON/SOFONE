# Replace autopos ONE with FEC PP-9735WL

**Date:** 2026-08-04
**Status:** Approved, pending implementation

## Context

autopos ONE has been cancelled from the SOFONE catalogue. It is replaced by the
**FEC PP-9735WL**, a 15.6" fanless True-Flat touch POS terminal, optionally paired
with the **XM-3010W** 10.1" second (customer-facing) display.

The hardware catalogue redesign (`5fa3f15`) already removed the autopos ONE feature
cards and the standalone spec grid, so the live surface is much smaller than the
i18n key count suggests: of 36 `apone.*` keys plus 2 `hardware.apone.*` keys,
only 15 are still rendered.

## Source of truth for specs

- FEC published spec: https://www.fecpos.com/tw/product-PP-9735W.html
- **Overridden by SOFONE's configured build:** RAM 8GB DDR4, storage 128GB M.2 SSD,
  OS Windows 11. These are the as-sold configuration, not FEC's base SKU
  (FEC lists 4GB standard / max 32GB, and a generic M.2 slot).

Every spec value currently on the site is wrong for this machine — the old tiles
describe autopos ONE (Intel N95, −10~45°C, 363×321×191mm) and must all be replaced.

## Scope of change

| Location | Change |
|---|---|
| `index.html:166` | Hero `.device-img` → PP-9735WL front view |
| `index.html:458-462` | Lineup card: thumbnail, `hw-lc-name` → `FEC PP-9735WL`, desc key |
| `index.html:483-505` | Viewer: 12 frames → 5; slider `max="12"` → `max="4"` |
| `index.html:2120-2135` | Delete `AP_ONE_FRAME_CONFIG` (12-frame calibration, no longer applicable; the length guard at :2146 already no-ops it) |
| `index.html:2516-2518` | `HW.apone` entry: img, eyebrow, title, spec list |
| i18n ×4 langs | Rename `apone.*` → `pp97.*`, delete 21 dead keys, rewrite all values |

`id="apone"` on `.hw-catalogue` is **renamed to `id="hardware-catalogue"`**, along
with the matching `data-machine` / `data-vis` attribute values (`apone` → `pp97`).
Verified that nothing in the repo links to `#apone`. This was originally spec'd as
"retain", changed on the user's instruction to clean out all autopos ONE traces.
Low residual risk: an external or printed link targeting `#apone` would no longer
scroll to the section (the page still loads normally).

## Visual: 5-angle drag-through

Reuses the existing `.ap-one-viewer` markup unchanged (the same reduced-frame
pattern KS-1000 already uses). Frames ordered so dragging reads as rotation:

| Slider position | Source file | Angle |
|---|---|---|
| 0 | `PP-9735L_01` | front |
| 1 | `PP-9735L_03` | ¾ front |
| 2 | `PP-9735L_05` | side profile |
| 3 | `PP-9735L_04` | ¾ rear |
| 4 | `PP-9735L_02` | rear |

`PP-9735L_11` (dual-screen / XM-3010W configuration) is **not** a viewer frame —
including it would break the rotation illusion. It stays available on disk, unused
for now.

## Specs displayed (7 tiles)

The panel previously showed 6 tiles and omitted 記憶體. Since RAM is part of the
configured build being advertised, 觸控 is folded into the screen line to make room,
and a 7th tile is added for the optional second display.

| Key | zh-TW label | Value |
|---|---|---|
| `pp97.spec.os` | 作業系統 | Windows 11 IoT Enterprise |
| `pp97.spec.screen` | 螢幕 | 15.6" 1920×1080 全平面電容觸控 |
| `pp97.spec.cpu` | 處理器 | Intel Celeron J6412 2.6GHz |
| `pp97.spec.ram` | 記憶體 | DDR4 8GB（最大 32GB） |
| `pp97.spec.storage` | 儲存 | M.2 SSD 128GB |
| `pp97.spec.net` | 連網 | Gigabit LAN・WiFi 802.11ac・BT |
| `pp97.spec.disp2` | 第二螢幕（選配） | XM-3010W 10.1" |

**Open item:** XM-3010W panel resolution is not published on FEC's page and is
therefore omitted rather than guessed. Add it if the figure is confirmed.

## Copy (zh-TW; translated to en / ja / vi)

- `pp97.eyebrow` — `FEC PP-9735WL · 專業級 POS 終端`
- `pp97.h3` — `無風扇工業設計，<span class="hl">15.6" 全平面觸控主機</span>。`
- `pp97.viewer.hint` — `拖曳旋轉檢視`
- `hw.lineup.pp97.d` — `專業級 POS 終端`

Branding is straight vendor hardware, matching how XELF II and KS-1000 are
presented. All "autopos ONE" wording is dropped; no autopos cloud tie-in copy.

## Keys deleted (21 per language, ×4 languages)

- `apone.features.label` (1)
- `apone.feat.{a1,f1,f2,f3,f4}.{title,desc}` (10)
- `apone.spec.{touch,io,temp,size}.{label,val}` (8)
- `hardware.apone.name`, `hardware.apone.tagline` (2)

All dead since `5fa3f15`. Note `apone.spec.ram` and `apone.spec.disp2` were also
dead but are **revived** as `pp97.spec.ram` / `pp97.spec.disp2` — see the spec
table above.

## Assets

- Source PNGs (293–730 KB) live in `assets/PP-9735WL+XM-3010W/` (folder renamed
  from `PP-9735L+XM-1010W` to correct both model numbers).
- Convert to resized WebP → `assets/pp9735/pp9735-1..5.webp`. The `+` in the source
  folder name is avoided in served URL paths.
- Delete the 17 orphaned `assets/demo/webp/autoposone_demo_*.webp` files, matching
  the cleanup precedent in `e47287a`.
- `dev-360.html` references the autopos ONE frames; it is a local scratch tool, not
  deployed. Verify before deleting frames and update or leave it stale deliberately.

## Verification

- All four language packs have identical key sets (no missing/orphan keys).
- No remaining `apone` / `autoposone` references in `index.html`.
- Viewer drags through 5 frames with no blank states.
- Font subset: new copy introduces no glyphs outside the existing subset — confirm,
  and re-run `pyftsubset` if it does (see `project_sofone_landing` notes).
- Live check after deploy: `curl` for the new asset paths returning 200.
