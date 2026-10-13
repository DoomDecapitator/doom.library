# Changelog · doom.library

中文: `CHANGELOG.md`

> **Scope**: namespace `doom.library` (the shared storage layer that provides "per-player data persistence" for other `doom.*` packs).
> `pack_format` 81, `supported_formats` 48–82, with `min_format` / `max_format` written out explicitly (mandatory fields since 1.21.11).
> Depended on by `doom.consumable` (heavy user) and `doom.test`.

---

## 2026-10-13 · v0.1.0-beta.2 — added the offline static gate

### 🟢 New `.github/` offline static gate (CI)

Three Node scripts plus one GitHub Actions workflow, under 2s locally, no Minecraft needed:

| Script | What it checks |
|---|---|
| `check_leak.mjs` | Leak scan (local absolute paths / development-artifact markers) + repo top-level whitelist |
| `check_pack.mjs` | Every `.json` parses + every `.mcfunction` is line-level legal + function reference closure |
| `check_dist.mjs` | The `dist/` zip is **byte-for-byte identical** to the working tree + sha256 matches `SHA256SUMS.txt` + the manifest covers everything |

The gate rules are calibrated against **real-machine measurements** (not copied from a template):

- `~-N` / `~-0.5` are **legal**; only `~+N` is rejected by Brigadier (`Expected double`) ⇒ the rule narrows to `/~\+\d/`
- The **leading indentation** of a `\` line continuation is formatting and legal (`test/check.mcfunction` / `test/validate.mcfunction`
  use `\` continuations to write multi-line JSON arrays) ⇒ the two-space rule now tests `line.trim()`
- `#$(tag)` is a macro tag selector, not an end-of-line comment ⇒ the `#`-stripping character class gains `$`

### 📌 First release (v0.1.0-beta.1, 2026-10-13)

This library had no public source before; it was released together with the open-sourcing of `doom.consumable`.
