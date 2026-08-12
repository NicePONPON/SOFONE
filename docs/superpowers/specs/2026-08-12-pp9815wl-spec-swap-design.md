# Replace FEC PP-9735WL with FEC PP-9815WL

**Date:** 2026-08-12
**Status:** Implemented and deployed (`51e5c01`, `936119b`)

## Context

The POS terminal in the hardware catalogue changes from the **FEC PP-9735WL** to the
**FEC PP-9815WL**. This supersedes the 2026-08-04 swap
([`2026-08-04-pp9735wl-hardware-swap-design.md`](./2026-08-04-pp9735wl-hardware-swap-design.md)),
which had itself replaced the cancelled autopos ONE.

Unlike that swap, this one is **specification-only**. The client confirmed the existing
product photography is reused as-is, so no assets, no viewer frames, and no layout change.

## Model identity

The client's part number `PP-9815WL` corresponds to FEC's catalogue **`PP-9815W`** —
the 15.6" Full HD variant. FEC lists three siblings on one page; do not confuse them:

| FEC model | Panel |
|---|---|
| PP-9815 | 15" XGA (1024×768) |
| **PP-9815W** | **15.6" Full HD (1920×1080)** ← this one |
| PP-9812W | 21.5" Full HD (1920×1080) |

Vendor page: https://www.fecpos.com/tw/product-PP-9815.html

The `WL` suffix follows the same convention as the outgoing PP-9735WL: it appears in
FEC's XPPC Fanless family listing, and denotes the wireless variant. Write the model
string as **`FEC PP-9815WL`** everywhere — never `PP-9815`, `PP-9815W`, or `PP-9815L`.

## Source of truth for specs

FEC's published spec table, **overridden by SOFONE's configured build and by three
explicit client decisions** recorded below. Where the two disagree, the client wins.

## Spec changes

| Row | PP-9735WL (was) | PP-9815WL (now) |
|---|---|---|
| 作業系統 | Windows 11 IoT Enterprise | **Windows 11 IoT** |
| 螢幕 | 15.6" 1920×1080 全平面電容觸控 | **15.6" 1920×1080 電容觸控** |
| 處理器 | Intel J6412 / N150（選配） | **Intel N150** |
| 記憶體 | DDR4 8GB（最大 32GB） | **DDR5 8GB/16GB** |
| 儲存 | M.2 SSD 128GB | *(unchanged)* |
| 連網 | Gigabit LAN・WiFi 802.11ac・BT | **Gigabit LAN・Wi-Fi 6E・藍牙 5.2** |
| 第二螢幕（選配） | XM-3010W 10.1" | *(unchanged)* |

Headline changed to match the screen row:
「無風扇工業設計，**15.6" 電容觸控主機**。」 (was 「…15.6" 全平面觸控主機。」)

## Client decisions — do not "correct" these back from the vendor page

These four points are where the shipped copy deliberately diverges from FEC's page.
Each was raised and decided explicitly. A future maintainer diffing the site against
fecpos.com will find all four and be tempted to "fix" them. Don't.

1. **「全平面」 / True-Flat dropped.** FEC uses that wording on the PP-9735 page but
   **not** on the PP-9815 page. Rather than carry an unverified claim across, it was
   removed from both the screen row and the headline. Same principle already applied
   to the XM-3010W resolution, which FEC does not publish and the site does not invent.

2. **無風扇 (fanless) kept.** Not stated on the product page itself, but PP-9815 and
   PP-9815W are both listed under FEC's **XPPC Fanless** family
   (https://www.fecpos.com/XPPC-Fanless.html), so the claim is supported.

3. **Processor is base-only: `Intel N150`.** FEC prints
   「Intel Processor TwinLake N150 / i3-N35501」. That trailing `01` is a typo on FEC's
   page — the real Intel part is **i3-N355**. Rather than publish a corrected guess,
   the client chose to list only the base CPU and drop the optional upgrade entirely.

4. **No capacity ceilings.** FEC lists "up to 16 GB" RAM and "up to 512 GB" storage.
   The client rejected 「最大 …」 phrasing: RAM reads as the two offered sizes
   slash-separated (`DDR5 8GB/16GB`), storage stays a plain `M.2 SSD 128GB`.

Additionally, **wireless is standard** on this model — FEC's own 9815 page lists
Wi-Fi 6E and Bluetooth 5.2 as standard, so unlike the 9735 there is no "(Optional)"
footnote to argue with.

## Deliberately unchanged

- **All product photography.** Still `assets/pp9735/pp9735-{01,02,03,04,05,11}.webp`,
  still the 6-frame viewer in order `11 → 01 → 02 → 03 → 04 → 05` with the dual-screen
  shot leading, slider `max="5"`. The photos depict the PP-9735WL; the client accepted
  this ("the photo can be remained the same").
- **The XM-3010W second-display row.** FEC's 9815 page lists no XM-series accessory —
  the pairing is a SOFONE offering, and the client confirmed it still applies. This is
  also why viewer frame 11 (the dual-screen shot) stays as the lead image.
- **Storage, screen size/resolution, panel type, the 7-row panel shape, layout, CSS.**

## Naming debt (accepted, not paid down)

Because the photos were retained, the following still say `9735` / `pp97` while
describing a PP-9815WL:

- asset paths `assets/pp9735/pp9735-*.webp`
- i18n namespace `pp97.*`
- `HW` object key, `data-machine`, `data-vis` — all `pp97`

None of it is user-visible. A rename to `pp98.*` was offered and not taken up. This is
the same category of legacy naming as the live-but-misnamed `.ap-one*` CSS classes and
`initApOneViewer()`, which drive all three hardware viewers and must not be renamed.

## Scope of change

| Location | Change |
|---|---|
| `index.html:166` | Hero `.device-img` alt → `FEC PP-9815WL` |
| `index.html:459-460` | Lineup card alt + `hw-lc-name` → `FEC PP-9815WL` |
| `index.html:482-496` | Viewer comment, `role="img"` aria-label, 6 frame alts, slider aria-label |
| `index.html:2046, 2101` | Two code comments referencing the model |
| i18n ×4 langs | `pp97.eyebrow`, `pp97.h3`, and 5 of 7 `pp97.spec.*.val` |

18 occurrences of the literal `PP-9735WL` were replaced. Asset paths use lowercase
`pp9735` and were intentionally left alone.

No CSS change. No change to `HW.pp97`'s spec-row list — the same 7 rows, same order.

## Verification performed

- All 24 initial + 6 follow-up + 4 OS replacements asserted to match **exactly once**
  (or an expected count) before writing — a miscount aborts the script rather than
  silently half-applying.
- All inline `<script>` blocks parsed; JSON-LD parsed as JSON.
  *(Note: parsing the JSON-LD block as JS produces a spurious "Unexpected token ':'" —
  it is data, not code.)*
- Headless Chrome DOM dump confirmed the lineup card renders `FEC PP-9815WL`.
- The real `TRANSLATIONS` object was evaluated against the real `HW.pp97` spec list to
  render all 7 rows in all 4 languages — zero missing keys. The spec panel is
  click-rendered, so a static DOM dump alone would not have caught a broken key.
- Post-deploy: live site polled for 18 × `PP-9815WL` / 0 × `PP-9735WL`, all five changed
  spec values present in all four packs, both webfonts serving 200 at their new sizes.

## Font subsetting

The first commit added new CJK glyphs (`藍`, `牙`, `静`, `量`), so both webfonts were
re-subset with `--no-hinting` per the standing trap — 159,572 / 162,572 bytes, table set
verified free of `cvt `/`fpgm`/`prep`, and the new glyphs confirmed present in `cmap`.

The two follow-up commits **only removed** characters, so no re-subset was needed: a
stale subset causes a silent system-font fallback only when text gains glyphs the subset
lacks. Extra unused glyphs are harmless.
