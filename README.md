# 碩豐 SOFONE — Landing Page

B2B landing page for SOFONE (碩豐數位科技), a System Integration & POS company.

## Project Structure

```
secpos-bd/
├── index.html          # Main landing page
├── style.css           # All styles
├── dev.html            # Dev dashboard for adjusting device positions
├── serve.sh            # Local dev server script
└── assets/
    ├── sofone-logo.png
    ├── Cafe Background.png   # Isometric café map (2544×1648)
    ├── KIOSK.png             # CentrDX kiosk overlay
    ├── POS.png               # Autopos POS overlay
    ├── Printer.png           # Nubis printer overlay
    ├── QR Code.png           # CentrDX QR ordering overlay
    └── Waitress.gif          # IMSDOM waitress character overlay
```

## Local Development

```bash
bash serve.sh
```

| URL | Description |
|-----|-------------|
| http://localhost:8080 | Main landing page |
| http://localhost:8080/dev.html | Dev dashboard |

## Dev Dashboard

Visual tool for adjusting device overlay positions on the café map in real time.

**Keyboard shortcuts:**

| Key | Action |
|-----|--------|
| `P` | Toggle control panel |
| `R` | Reload preview |
| `C` | Copy CSS variables |
| `⌫` | Reset all positions to defaults |

## Device Overlay Positions

All positions are `%` values relative to `.map-stage` dimensions, defined as CSS variables in `:root`:

```css
--dev-kiosk-top / left / w       /* CentrDX Kiosk */
--dev-pos-top / left / w         /* Autopos POS */
--dev-printer-top / left / w     /* Nubis Printer */
--dev-qr-top / left / w          /* CentrDX QR Code */
--dev-waitress-top / left / w    /* IMSDOM Waitress */
```

## Sections

1. **Hero** — Two-column layout: brand copy (left) + interactive isometric café map (right)
2. **CentrDX** — Self-service kiosk solution, before/after comparison
3. **Autopos** — Enterprise POS, country tabs
4. **Nubis** — IoT monitoring, hotspot map
5. **IMSDOM** — Digital operations & staff management, accordion
6. **Partners / Contact**
