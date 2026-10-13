# doom.library

中文: `README.md`

> ## ⚠️ Beta stage notice (please read this part first)
>
> This pack is currently in the **mid-development (Beta) stage**: interfaces and data formats **may still change**, and the data structures, function names and storage layouts already written **are not guaranteed to be backward compatible**.
>
> - This document records the **current development state**; **its content is for reference only** and is not a stability commitment.
> - Before using it in a real map / server, **back up your save first**, and confirm it by testing in your own environment.
> - After upgrading this pack's version, run it once in a test world before putting it into a live save.
>
> If all you want is "take it and play, no fuss", you had better wait until it leaves Beta.

---

## Table of contents

- [1. What is this?](#1-what-is-this)
- [2. What does installing it get you? Who needs it?](#2-what-does-installing-it-get-you-who-needs-it)
- [3. What is its relationship to doom.consumable?](#3-what-is-its-relationship-to-doomconsumable)
- [4. Installation steps](#4-installation-steps)
- [5. Five-minute quick start](#5-five-minute-quick-start)
- [6. Usage caveats](#6-usage-caveats)
- [7. Technical reference](#7-technical-reference)
  - [7.1 Architecture](#71-architecture)
  - [7.2 API: player data](#72-api-player-data)
  - [7.3 API: utility functions](#73-api-utility-functions)
  - [7.4 Predicate list (37)](#74-predicate-list-37)
  - [7.5 Function tags](#75-function-tags)
  - [7.6 Known limitations (design trade-offs — read before use)](#76-known-limitations-design-trade-offs--read-before-use)
- [8. Tests and self-checks](#8-tests-and-self-checks)
- [9. Current users](#9-current-users)

---

## 1. What is this?

**In one sentence: this is a "player data warehouse" for other datapacks — it has no gameplay of its own.**

A Minecraft datapack that wants to "remember something" about a player — how many times someone
has taken a potion, what is in their inventory, when they last opened a chest — has to find
somewhere to store it. Vanilla scoreboards can only store numbers; they cannot store items,
coordinates or complex structures. And scribbling directly into storage means several packs
fight over the same space.

`doom.library` exists to solve that:

- It **automatically assigns each player a number**, and from then on you refer to that number to store and read data;
- It provides a **unified read/write interface** — you just "read it out" and "write it back", while it handles the dirty work of persistence, queueing and conflicts;
- It also throws in a small set of **common check utilities** (for example "is this player sneaking", "does the main-hand item have custom data").

So: **it produces no gameplay; it produces "the foundation others build gameplay on".**

> If you are not a datapack author and just want to install something fun to play with, then what
> you are looking for are the packs that **use** it (such as `doom.consumable`), not this one.
> Install it on its own and nothing in the game changes.

---

## 2. What does installing it get you? Who needs it?

| Who you are | Do you need it | Why |
|---|---|---|
| Regular player / just wants gameplay | No need to install it separately | It has no gameplay. The gameplay pack you install brings it along automatically. |
| Map author (making modpacks, making maps) | **Depends** | If the `doom.*` series pack you use reports a "missing dependency", then you have to install it. |
| Datapack author (writing mcfunction) | **Very likely yes** | It saves you the work of writing your own "player data storage" layer. |
| Someone who wants to modify a pack in the doom series | Yes | Other packs' data all sits here; reading it is how you understand what they stored. |

**The specific pain point it solves**: vanilla datapacks have no ready-made facility for
"persisting an arbitrary structure per player". Scoreboards can only hold integers, storage is
global and does not follow the player around, and several packs sharing one storage very easily
overwrite each other. This pack wraps that layer up with a "player → number → data tree" mapping.

---

## 3. What is its relationship to doom.consumable?

`doom.consumable` is the "unified item-usage framework" (consuming / placing / dropping / fishing / shooting / throwing).
It is this pack's **heavy user**:

```
doom.consumable  (gameplay layer: how items are used)
      │  needs to store "this player's item state"
      ▼
doom.library     (foundation: where player data is stored, and how)
```

Concretely, `doom.consumable` calls this pack's
`api/ensure` (make sure the player has a number), `api/read` (read data), `api/cache` / `api/cache_get` (write and read cache entries),
and `api/open` (open in one step) interfaces.

**So: if you want to use `doom.consumable`, you must install `doom.library` as well.** The reverse does not hold — this pack can be installed on its own (it just has no gameplay that way).

---

## 4. Installation steps

A datapack is just a bunch of folders: **drop it in the right place** and you are done. No third-party loader is needed.

**Client (single-player save)**

1. Open your save folder:
   `%appdata%\.minecraft\saves\<your save name>\`
2. Inside it, find (or create, if missing) a folder named `datapacks`;
3. **Copy the whole `doom.library` folder in**, so it ends up looking like this:
   ```
   saves\<save name>\datapacks\doom.library\pack.mcmeta
   saves\<save name>\datapacks\doom.library\data\...
   ```
   ⚠️ Note that `pack.mcmeta` sits directly under `doom.library` — **do not nest another folder of the same name inside**.
4. Back in the game, run `/reload`; if you had already entered the save, exiting and re-entering is recommended.

**Server**

1. Copy the `doom.library` folder into the server's `<server directory>\world\datapacks\`;
2. Run `reload` from the console.

**Should you install anything else at the same time?**

- If you just want some gameplay pack to run → install **that pack** and **the dependencies it declares**. Taking `doom.consumable` as an example: `doom.library` is mandatory.
- Installing `doom.test` (the series' self-check suite) alongside is recommended, as it makes troubleshooting easier.

**Version requirement**: this pack declares support for `pack_format` **48 – 82**, and the current `pack_format` is **81** (read from `pack.mcmeta`).
If your game version reports "datapack version incompatible" when loading, that means your game is outside that range.
(The repo's older docs noted "1.21.6 = 80", which you can use as a conversion reference.)

---

## 5. Five-minute quick start

The three snippets below are the **most commonly used** actions. It does not matter if you do not
follow the syntax; copy them and tweak them first.

### ① Open a player's data

```mcfunction
# Assign a number to every player and read their data out
execute as @a run function doom.library:api/open
```

After it runs, the player data is in `storage doom.library:io output[-1].data`.
(`api/open` = `api/ensure` + `api/read` done in one step; using it is recommended.)

### ② Write a cache entry

A "cache entry" is a chunk of timestamped data hung on a player; it is suited to storing "what it looked like last time".

```mcfunction
# api/ensure or api/open must have run first, otherwise _.idx has no value
data modify storage doom.library:ctx _.cache_key set value "inventory"
data modify storage doom.library:ctx _.cache_data set value {}
data modify storage doom.library:ctx _.cache_data.Inventory set from entity @s Inventory
function doom.library:api/cache with storage doom.library:ctx _

# Clean up the parameters when done (good habit)
data remove storage doom.library:ctx _.cache_key
data remove storage doom.library:ctx _.cache_data
```

### ③ Read a cache entry

```mcfunction
data modify storage doom.library:ctx _.cache_key set value "inventory"
function doom.library:api/cache_get with storage doom.library:ctx _
# The result is in storage doom.library:ctx cache_result
```

**Note**: `cache_get` does **not** need `api/read` first; it reads the data directly and is the mirror operation of `api/cache`.

> **Why does the function name keep getting followed by `with storage doom.library:ctx _`?**
> Because the lines starting with `$` are "macros" — their parameters have to be passed in from elsewhere. This pack's convention is:
> **parameters go under `_` in `storage doom.library:ctx`**.
> And macros have a hard rule: **if one parameter is missing, the whole call is silently abandoned** (no error, nothing happens).
> So always set every parameter you need before calling.

---

## 6. Usage caveats

The four things beginners trip over most; remember these first:

1. **`api/write` and `api/update` do not take effect immediately.** They only push the write into a queue,
   and the server processes only **one** entry per tick. `api/cache` and `api/reset`, by contrast, are **immediate direct writes**.
   Do **not** mix the two kinds of write for the same player at the same moment — a whole-object replacement still
   sitting in the queue will overwrite the later direct write.
2. **`output` has only one slot.** Every `api/read` overwrites it wholesale. Use the result right away;
   do not "read once, then use it a while later".
3. **The index is never reclaimed.** After a player quits, their data stays in storage. When cleanup is needed,
   the caller calls `api/reset` themselves.
4. **The return value of the effect functions is a global fake score** (`#lib_result lib.var`).
   When calling them for players one by one in a loop, the next player overwrites the previous player's result —
   **you must read it out within the same call**.

---

## 7. Technical reference

> What follows is the complete material for datapack authors. All values and names **take the actual files
> in the repo as authoritative** (`pack.mcmeta`, `data/doom.library/function/`, `data/doom.library/predicate/`, `data/doom.library/tags/`).

### 7.1 Architecture

| Resource | Purpose |
|---|---|
| Scoreboard `lib.var` | Internal temporary computation for the library (`#lib_t` / `#lib_b` / `#lib_result` / `#lib_exists` / `#lib_amp` / `#lib_dur` / `#256` / `#0`…) |
| Scoreboard `lib.idx` | **Player → index** binding (`@s lib.idx`, assigned by `api/ensure`; the global counter `#lib_idx` only ever grows) |
| `storage doom.library:io` | `{players:{index:{},data:{}}, input:[], output:[], stack:[]}` |
| `storage doom.library:ctx` | Caller context; keys prefixed with `_` = macro function parameters (`_.idx` / `_.cache_key` / `_.cache_data` / `_.data`) |
| `storage doom.library:const` | Constant table (`hex_chars`, 256 entries, used as a lookup table for UUID conversion) |
| `storage doom.library:test` | Temporary lists used by the self-check functions (`test/check`, `test/validate`) |

**Entry points** (read from `data/minecraft/tags/function/`):

- `#minecraft:load` → `doom.library:__load__` (creates the two scoreboards `lib.var` / `lib.idx`, fills the `hex_chars` constant table, initializes the four fields of `io`)
- `#minecraft:tick` → `doom.library:tick/tick` → `doom.library:io/cycle` (processes one queued write per tick)

**Data shape**: `players.data.<idx>` = that player's data tree;
`players.data.<idx>.CACHE.<key>` = `{data:…, timestamp:<gametime>}` (written by `api/cache`).

**Macro calling convention**: all `api/*` macro functions are called with
`function doom.library:api/<name> with storage doom.library:ctx _`, with the parameters written under the `_` key of `ctx`.
Macros expand as a whole batch at call time — a missing parameter ⇒ **the entire call is silently abandoned**, so always write every parameter before calling.

### 7.2 API: player data

| Function | Macro | Parameters (under ctx `_`) | Output |
|---|---|---|---|
| `api/ensure` | No | none (needs `@s`) | Assigns `lib.idx` to `@s`; writes `_.idx` into ctx; also fills in any missing fields of `io` |
| `api/open` | No | none (needs `@s`) | = `api/ensure` + `api/read`; the data lands in `io output[-1].data` |
| `api/read` | Yes | `idx` | `io output[-1].data` = the player data (valid until the next read) |
| `api/write` | Yes | `idx`, `data` | Enqueues into `input`, **replacing** the player data wholesale (one lands per tick) |
| `api/update` | Yes | `idx`, `data` | Enqueues into `input` with `mode:"merge"`, **merging** into the player data (one lands per tick) |
| `api/reset` | Yes | `idx` | Immediately clears that player's data (direct write, bypasses the queue) |
| `api/cache` | Yes | `idx`, `cache_key`, `cache_data` | Immediately writes `players.data.<idx>.CACHE.<key>` = `{data, timestamp}` (direct write, bypasses the queue) |
| `api/cache_get` | Yes | `idx`, `cache_key` | `ctx cache_result` = the contents of `CACHE.<key>.data` (if the entry does not exist, `cache_result` does not exist; does not depend on a prior `read`) |
| `api/cache_clear` | Yes | `idx`, `cache_key` | Deletes the whole `CACHE.<key>` entry (with an existence guard; skips quietly when the entry is missing) |

Queue processing detail: `io/cycle` uses **pop-then-process** — it moves the head entry away first, then performs the write.
That way, even if a bad entry gets into the queue, it is merely "eaten and skipped" and never permanently jams the queue.

### 7.3 API: utility functions

| Function | Description |
|---|---|
| `api/uuid_hex` | Converts `@s`'s UUID into a 36-character hex string (`8-4-4-4-12`); the result lands in `storage doom.library:ctx uuid`. Internally it goes through two levels of macros, `api/hex/join` → `api/hex/join2`, to do the table lookup and string assembly. |
| `effect/has_effect` | Macro parameter `$(effect)`; optional ctx `min_amplifier` / `min_duration`; result in `#lib_result lib.var` (1 / 0) |
| `effect/get_amplifier` | Macro parameter `$(effect)`; result in `#lib_result lib.var` (-1 when the effect is absent) |
| `effect/get_duration` | Macro parameter `$(effect)`; result in `#lib_result lib.var` (-1 when the effect is absent) |
| `test/check` | Diagnoses and prints which predicates the current player matches, one by one |
| `test/validate` | Validates the whole predicate list in bulk (prints the list length) |
| `test/list` | Prints the predicate reference list (with Chinese glosses, see 7.4) |
| `test/probe_uuid` | Probe: prints the real UUID along with `ctx.uuid` / `ctx.hex`, used to pin down the output path of `api/uuid_hex` |
| `test/uuid_test` | Test cases for UUID conversion |
| `test/cache_api` | The four self-checks of `api/cache` / `api/cache_get` / `api/cache_clear` (READ / CLEAR / STALE / PARAMS) |

> `api/hex/join` and `api/hex/join2` are the internal implementation of `api/uuid_hex` and are generally not called directly.

### 7.4 Predicate list (37)

There are **37** predicate files in total, spread under `data/doom.library/predicate/`:
14 under `effect/*`, 17 under `player/*`, 2 under `entity/*`, 4 under `item/*`.

**effect/ (14)**: `has_strength` Strength · `has_strength_2` Strength II+ · `has_speed` Speed ·
`has_speed_2` Speed II+ · `has_resistance` Resistance · `has_fire_resistance` Fire Resistance ·
`has_water_breathing` Water Breathing · `has_night_vision` Night Vision · `has_regeneration` Regeneration ·
`has_absorption` Absorption · `has_haste` Haste · `has_levitation` Levitation · `has_slow_falling` Slow Falling ·
`has_jump_boost` Jump Boost

**player/ (17)**: `gamemode_survival` / `gamemode_creative` / `gamemode_adventure` / `gamemode_spectator`
the four game modes · `is_sneaking` sneaking · `is_sprinting` sprinting · `is_swimming` swimming · `is_on_ground` on the ground ·
`is_burning` burning · `has_vehicle` riding · `is_in_overworld` / `is_in_nether` / `is_in_end` the three dimensions ·
`input_jump` / `input_sneak` / `input_sprint` the three key inputs · `xp_high` XP ≥30 levels

**entity/ (2)**: `is_player` is a player · `is_undead` is undead

**item/ (4)**: `has_custom_data` main hand has `custom_data` · `has_armor_head` head slot has an item ·
`has_armor_chest` chest slot has an item · `has_armor_feet` feet slot has an item

> The most authoritative list is in the function `doom.library:test/list` (run
> `/function doom.library:test/list` in game to see the complete list with Chinese glosses).

### 7.5 Function tags

| Tag | Content | Description |
|---|---|---|
| `#doom.library:read` | `doom.library:api/read` | Legacy interface |
| `#doom.library:write` | `doom.library:api/write` | Legacy interface |
| `#doom.library:data_read` | `doom.library:api/read` | Same content as `read` |
| `#doom.library:data_write` | `doom.library:api/write` | Same content as `write` |

> These four tags are pairwise identical in content, **no pack in this repo references them**, and they are kept as legacy interfaces.
> New code should call the functions directly and not depend on these tags.

### 7.6 Known limitations (design trade-offs — read before use)

1. **Two-track write path**: `api/write` / `api/update` go through the `input` queue (only **one** lands per tick);
   `api/cache` / `api/reset` are direct writes. If a whole-object replacement is still sitting in the same player's
   queue, the later direct cache write gets overwritten by it — do not mix the two kinds of write for the same player in the same tick.
2. **Single `output` slot**: every `api/read` overwrites it wholesale; consume the result as soon as you have read it, and do not use it across the next read.
3. **The effect functions use a global fake score** (`#lib_result lib.var`): in a per-player loop the result is overwritten by the next player,
   so it must be read out within the same call.
4. **The index is never reclaimed**: after a player quits, `players.data.<idx>` is kept forever (storage is not cleaned automatically);
   when cleanup is needed the caller calls `api/reset` themselves.
5. **Redundant tags**: the four tags `tags/function/read|write|data_read|data_write` are pairwise identical in content,
   are referenced by no pack at present, and are kept as legacy interfaces.
6. **Dropping one queue entry vs deadlocking**: `io/cycle` chooses "pop then process"; the cost is that a failure mid-processing makes that write
   get **lost** — this is a deliberate trade-off, and far better than the old version where "a bad entry permanently jams the whole queue".

---

## 8. Tests and self-checks

Run the following commands in game to check things yourself (`@s` must be a player):

| Command | Effect |
|---|---|
| `/function doom.library:test/list` | Prints the whole predicate list with Chinese glosses |
| `/function doom.library:test/check` | Diagnoses one by one: which predicates the current player matches |
| `/function doom.library:test/validate` | Validates the predicate list in bulk (prints the list length) |
| `/function doom.library:test/probe_uuid` | Prints the real UUID along with `ctx.uuid` / `ctx.hex`, to pin down the output of the UUID conversion |
| `/function doom.library:test/cache_api` | Cache API self-check; expect four green lines: `READ OK` / `CLEAR OK` / `STALE OK` / `PARAMS OK` |

> ⚠️ `test/cache_api` **really does write and then delete** a cache entry named `selftest`,
> so use it in a test environment and do not casually run it in a live save.

The complete cross-pack regression suite lives in `doom.test` (it includes this pack's `library_queue` and other cases).

---

## 9. Current users

- **`doom.consumable`** — heavy user: `api/ensure` / `api/read` / `api/cache` / `api/open` and so on
- **`doom.test`** — library self-checks and the `doom.consumable` suite

---

<sub>This file is maintained by the repo. If a value disagrees with in-game behaviour, take `pack.mcmeta` and the actual files under `data/` as authoritative.</sub>
