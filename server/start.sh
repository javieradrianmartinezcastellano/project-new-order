#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
[ -f "$ROOT/.env" ] && set -a && . "$ROOT/.env" && set +a

GMOD_DIR="${GMOD_DIR:-$ROOT/srv/gmod}"
case "$GMOD_DIR" in /*) ;; *) GMOD_DIR="$ROOT/$GMOD_DIR" ;; esac

args=(
	-game garrysmod
	-console
	-port "${PORT:-27015}"
	+maxplayers "${MAXPLAYERS:-64}"
	+gamemode neworder
	+map "${MAP:-gm_construct}"
)

[ -n "${WORKSHOP_COLLECTION:-}" ] && args+=(+host_workshop_collection "$WORKSHOP_COLLECTION")
[ -n "${GSLT:-}" ] && args+=(+sv_setsteamaccount "$GSLT")
[ -n "${RCON_PASSWORD:-}" ] && args+=(+rcon_password "$RCON_PASSWORD")

exec "$GMOD_DIR/srcds_run" "${args[@]}"
