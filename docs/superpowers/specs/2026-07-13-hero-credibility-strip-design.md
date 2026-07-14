# Hero Credibility Strip — Design

Date: 2026-07-13
Status: Approved

## Purpose

The live site covers product breadth well but surfaces none of the trust/proof
layer from the latest autopos deck (`autopos（繁）_2026.06.18`). Named marquee
clients, team pedigree, order volume, and country footprint are absent. This
strip adds that proof directly under the hero — the single highest-ROI change
for a B2B chain-restaurant buyer.

## Placement

New full-width `<section class="proof-band">` inserted between the hero
(closes `index.html:210`) and the autopos section (`index.html:214`).

## Structure

Reuses existing `.section-inner` + `reveal` patterns and the site palette
(dark teal `--c-bg #0d1f2d`, accent `--c-accent #6ACCAC`). No new dependencies.

Four stat tiles in a row:

| # | Number (zh-TW) | Label (zh-TW) |
|---|----------------|----------------|
| 1 | 20+ | 年餐飲科技經驗 |
| 2 | 20+ | 國家佈局 |
| 3 | 數千萬 | 單日訂單處理量 |
| 4 | 百強 | 核心團隊來自全球 |

Client line below, centered:
`已服務 CoCo都可、50嵐、奈雪的茶、蜜雪冰城、幸運咖 等國際連鎖品牌`

## Responsive

4-across desktop; 2×2 on mobile (matches existing tile-row collapse).

## i18n

New keys added to all four language blocks (zh-TW / en / ja / vi), inserted
after each `hero.cta2`:

- `proof.stat1num` / `proof.stat1label` … `proof.stat4num` / `proof.stat4label`
- `proof.clients`

## Scope guard

Does NOT touch the existing 合作夥伴 logo wall (`section.partners`). Named
claims here + logo proof there are complementary.

## Data provenance

All figures sourced from the approved deck (p2, p4). User cleared named
clients, stats, and country footprint for public publication.
