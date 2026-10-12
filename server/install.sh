#!/usr/bin/env bash
# Instala Garry's Mod dedicado, Helix y (opcional) CS:S, y enlaza este schema.
# Requisitos: steamcmd en el PATH y git.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
[ -f "$ROOT/.env" ] && set -a && . "$ROOT/.env" && set +a

GMOD_DIR="${GMOD_DIR:-$ROOT/srv/gmod}"
case "$GMOD_DIR" in /*) ;; *) GMOD_DIR="$ROOT/$GMOD_DIR" ;; esac
HELIX_REF="${HELIX_REF:-master}"
MOUNT_CSS="${MOUNT_CSS:-1}"
CSS_DIR="$ROOT/srv/css"

command -v steamcmd >/dev/null || { echo "Falta steamcmd en el PATH." >&2; exit 1; }

echo "==> Instalando/actualizando Garry's Mod dedicado en $GMOD_DIR"
steamcmd +force_install_dir "$GMOD_DIR" +login anonymous +app_update 4020 validate +quit

GARRYSMOD="$GMOD_DIR/garrysmod"

echo "==> Helix ($HELIX_REF)"
if [ -d "$GARRYSMOD/gamemodes/helix/.git" ]; then
	git -C "$GARRYSMOD/gamemodes/helix" fetch --depth 1 origin "$HELIX_REF"
	git -C "$GARRYSMOD/gamemodes/helix" checkout -q FETCH_HEAD
else
	git clone --depth 1 --branch "$HELIX_REF" https://github.com/NebulousCloud/helix.git "$GARRYSMOD/gamemodes/helix"
fi

echo "==> Enlazando schema y configuración"
ln -sfn "$ROOT/gamemodes/neworder" "$GARRYSMOD/gamemodes/neworder"
ln -sf "$ROOT/server/cfg/server.cfg" "$GARRYSMOD/cfg/server.cfg"

if [ "$MOUNT_CSS" = "1" ]; then
	echo "==> Counter-Strike: Source dedicado (texturas para mapas rp_)"
	steamcmd +force_install_dir "$CSS_DIR" +login anonymous +app_update 232330 validate +quit
	cat > "$GARRYSMOD/cfg/mount.cfg" <<MOUNT
"mountcfg"
{
	"cstrike"	"$CSS_DIR/cstrike"
}
MOUNT
fi

echo "==> Listo. Arranca con server/start.sh"
