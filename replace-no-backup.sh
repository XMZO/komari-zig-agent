#!/bin/sh
set -eu

UPSTREAM_REPLACE_URL="${KOMARI_UPSTREAM_REPLACE_URL:-https://raw.githubusercontent.com/luodaoyi/komari-zig-agent/main/replace.sh}"

tmp_script=""
tmp_log=""

log() { printf '%s\n' "$*"; }
err() { printf 'ERROR: %s\n' "$*" >&2; }

cleanup() {
  if [ -n "$tmp_script" ] && [ -f "$tmp_script" ]; then rm -f "$tmp_script"; fi
  if [ -n "$tmp_log" ] && [ -f "$tmp_log" ]; then rm -f "$tmp_log"; fi
}
trap cleanup EXIT HUP INT TERM

download_script() {
  out="$1"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$UPSTREAM_REPLACE_URL" -o "$out"
    return
  fi
  if command -v wget >/dev/null 2>&1; then
    wget -qO "$out" "$UPSTREAM_REPLACE_URL"
    return
  fi
  err "curl or wget is required"
  exit 1
}

if [ "$(id -u)" != "0" ]; then
  err "please run as root"
  exit 1
fi

tmp_script="$(mktemp /tmp/komari-replace.XXXXXX)"
tmp_log="$(mktemp /tmp/komari-replace-log.XXXXXX)"

download_script "$tmp_script"
chmod 0700 "$tmp_script"

set +e
sh "$tmp_script" "$@" >"$tmp_log" 2>&1
status=$?
set -e

cat "$tmp_log"

if [ "$status" -ne 0 ]; then
  exit "$status"
fi

sed -n 's/^backup: //p' "$tmp_log" | while IFS= read -r backup; do
  if [ -n "$backup" ] && [ -f "$backup" ]; then
    rm -f "$backup"
    log "removed backup: $backup"
  fi
done
