# Project: New Order — HL2RP

Servidor de Garry's Mod de **Half-Life 2 Roleplay serio**, construido sobre el framework
[Helix](https://github.com/NebulousCloud/helix) e inspirado en el estilo de juego de
Project: Synapse: inmersión estricta, sin physgun para jugadores, Unión con jerarquía y
economía basada en raciones.

> **No hay código de Synapse en este repositorio.** Synapse es un servidor cerrado con
> código propio. Este repositorio es un schema propio que imita su *estilo*, no su contenido.
> No copies addons, modelos ni código de otros servidores sin licencia.

## Qué incluye

| Área | Contenido |
| --- | --- |
| **Facciones** | Ciudadano (por defecto), UTC, Protección Civil, Overwatch Transhumana, Administración Civil. Todas salvo Ciudadano requieren whitelist. |
| **Protección Civil** | Nombres automáticos `C24.MPF-RANGO.12345` y rangos `RCT → 05 … 01 → OfC → EpU → DvL → SeC`. |
| **Identidad** | Tarjeta CID generada al crear el personaje; puntos de lealtad por personaje. |
| **Raciones** | Dispensadores vinculados a la CID con espera configurable; raciones de lealtad para la UTC y los ciudadanos leales. |
| **Código de la ciudad** | Verde, amarillo, rojo y negro, con aviso global y un indicador en el HUD. |
| **Comunicaciones** | `/R` radio de la Unión, `/Dispatch`, `/Broadcast` (Administración), `/Request` (con dispositivo de solicitud). |
| **Unión** | Marcadores de biseñal en el HUD, aviso de pérdida de biseñal, frases de voz, armadura por facción. |
| **Objetos** | CID, bridas (atar/desatar con `E`), raciones, consumibles, armas y munición de HL2. |

## Estructura

```
gamemodes/neworder/          Schema de Helix (se enlaza en garrysmod/gamemodes)
  gamemode/                  Deriva de Helix
  schema/
    factions/                Facciones
    items/                   Objetos (base/, consumables/, rations/, weapons/, ammo/)
    plugins/                 Raciones, código de la ciudad, voces
    sh_schema.lua            Rangos, nombres, utilidades
    sh_chatclasses.lua       Radio, dispatch, broadcast, request
    sh_commands.lua          Rangos y lealtad
server/
  install.sh                 Instala GMod dedicado + Helix + CS:S y enlaza todo
  start.sh                   Arranca srcds con las variables de .env
  cfg/server.cfg             Configuración del servidor
```

## Instalación (Linux)

1. Instala `steamcmd` y `git`.
2. `cp .env.example .env` y rellena al menos `GSLT` y `RCON_PASSWORD`.
3. `./server/install.sh` — descarga GMod dedicado, Helix y CS:S en `srv/` (ignorado por git).
4. `./server/start.sh`
5. Helix no trae mod de administración. Instala uno (ULX, SAM…) para gestionar rangos de
   staff de forma persistente. Para una primera prueba, desde la consola del servidor:
   `lua_run Entity(1):SetUserGroup("superadmin")` (no persiste entre reinicios).

### Mapa y contenido

`MAP` viene en `gm_construct` para poder probar sin descargas. Para jugar de verdad:
crea una colección del Workshop con un mapa de ciudad (City 8, City 17, Industrial 17…) y
el contenido que necesite, pon su ID en `WORKSHOP_COLLECTION` y el nombre del mapa en `MAP`.

## Comandos principales

| Comando | Quién | Qué hace |
| --- | --- | --- |
| `/PlyWhitelist <jugador> <facción>` | Admin (Helix) | Da acceso a una facción. |
| `/CharSetRank <personaje> <rango>` | DvL+, Administración, admins | Cambia el rango de una unidad. No puedes ascender a tu rango o por encima. |
| `/CharAddLoyalty <personaje> <n>` | Unión, Administración, admins | Suma o resta lealtad (máximo `loyaltyStep` por vez si no eres admin). |
| `/CharCheckLoyalty <personaje>` | Unión, Administración, admins | Consulta la lealtad. |
| `/SetCityCode <1-4>` | DvL+, Administración, admins | Cambia el código de la ciudad. |
| `/DispenserToggle` | Unión, Administración, admins | Activa o desactiva el dispensador que miras. |
| `/R`, `/Dispatch`, `/Broadcast`, `/Request` | Según facción | Canales de comunicación. |

Los dispensadores se colocan desde el menú Q → Entidades → *Helix - New Order* y se
guardan solos.

### Flags de Helix

Los jugadores **no** reciben physgun ni toolgun. Se dan por flags:
`/CharGiveFlag <personaje> pet` (`p` physgun, `e` props, `t` toolgun).

## Configuración del schema

Desde el menú de Helix (pestaña Config → *New Order*): `cityName`, `rationInterval`,
`loyalRationThreshold`, `loyaltyStep`.

## Próximos pasos sugeridos

- Puertas de la Unión y bloques de vivienda (plugin `doors` de Helix).
- Registro e inventario de cacheos, terminales de la Unión, vendedores de la UTC.
- Base de datos MySQL (`gamemodes/helix/helix.yml`) cuando haya más de un servidor.
