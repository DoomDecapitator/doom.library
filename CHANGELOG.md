# 变更日志 · doom.library

> **口径**：namespace `doom.library`（给其他 `doom.*` 包提供「按玩家持久化数据」的公共存储层）。
> `pack_format` 81，`supported_formats` 48–82，并显式写出 `min_format` / `max_format`（1.21.11 起是强制字段）。
> 被 `doom.consumable`（重用户）与 `doom.test` 依赖。

---

## 2026-10-13 · v0.1.0-beta.2 —— 新增离线静态门

### 🟢 新增 `.github/` 离线静态门（CI）

三个 Node 脚本 + 一个 GitHub Actions workflow，本机 < 2s、不需要 Minecraft：

| 脚本 | 查什么 |
|---|---|
| `check_leak.mjs` | 泄漏扫描（本机绝对路径 / 开发物标识）+ 仓库顶层白名单 |
| `check_pack.mjs` | 每个 `.json` 可解析 + 每个 `.mcfunction` 行级合法性 + 函数引用闭包 |
| `check_dist.mjs` | `dist/` 的 zip 与工作树**逐字节一致** + sha256 与 `SHA256SUMS.txt` 一致 + 清单覆盖完整 |

门规则按**真机实测**校准（不是照抄范本）：

- `~-N` / `~-0.5` **合法**，只有 `~+N` 被 Brigadier 拒（`Expected double`）⇒ 规则收窄为 `/~\+\d/`
- `\` 行尾续行的**行首缩进**是排版、合法（`test/check.mcfunction` / `test/validate.mcfunction`
  用 `\` 续行写多行 JSON 数组）⇒ 双空格规则改测 `line.trim()`
- `#$(tag)` 是宏标签选择器、不是行尾注释 ⇒ `#` 剥离字符类补 `$`

### 📌 首发（v0.1.0-beta.1，2026-10-13）

本库此前无公开来源，随 `doom.consumable` 开源一并发布。
