#!/usr/bin/env bash
# ─────────────────────────────────────────────
#  SOFONE local dev server
#  Usage:  bash serve.sh          (default port 8080)
#          bash serve.sh 3000     (custom port)
# ─────────────────────────────────────────────

PORT="${1:-8080}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_banner() {
  echo ""
  echo "  ┌──────────────────────────────────────────────┐"
  echo "  │   SOFONE Dev Server                          │"
  echo "  ├──────────────────────────────────────────────┤"
  echo "  │                                              │"
  printf "  │  Landing page:   http://localhost:%-5s       │\n" "$PORT"
  printf "  │  Dev dashboard:  http://localhost:%-5s       │\n" "$PORT/dev.html"
  echo "  │                                              │"
  echo "  │  Keyboard shortcuts (in dev.html):           │"
  echo "  │    P  — toggle control panel                 │"
  echo "  │    R  — reload preview                       │"
  echo "  │    C  — copy CSS variables                   │"
  echo "  │    ⌫  — reset positions to defaults          │"
  echo "  │                                              │"
  echo "  │  Press Ctrl+C to stop the server             │"
  echo "  └──────────────────────────────────────────────┘"
  echo ""
}

cd "$DIR" || exit 1
print_banner

# Try python3, then python2, then npx serve
if command -v python3 &>/dev/null; then
  python3 -m http.server "$PORT"
elif command -v python &>/dev/null; then
  python -m SimpleHTTPServer "$PORT"
elif command -v npx &>/dev/null; then
  npx --yes serve . -p "$PORT"
else
  echo "  ✗  No server found."
  echo "     Install Python 3 (recommended) or Node.js, then re-run."
  exit 1
fi
