# doom.library

> ## ⚠️ Beta 阶段声明（请先读这一段）
>
> 本包目前处于 **中期制作（Beta）阶段**：接口与数据格式**仍可能变动**，已写入的数据结构、函数名、storage 布局**不保证向后兼容**。
>
> - 本文档记录的是**当前开发状态**，**内容仅供参考**，不代表稳定承诺。
> - 用于正式地图 / 服务器前，请**先备份存档**，并在你自己的环境里实测确认。
> - 升级本包版本后，请在测试世界里先跑一遍，再放到线上存档。
>
> 如果你只是想「拿来就用、不折腾」，建议等它退出 Beta 再来。

---

## 目录

- [一、这是什么？](#一这是什么)
- [二、装了它有什么用？谁需要它？](#二装了它有什么用谁需要它)
- [三、和 doom.consumable 是什么关系？](#三和-doomconsumable-是什么关系)
- [四、安装步骤](#四安装步骤)
- [五、五分钟上手](#五五分钟上手)
- [六、使用注意事项](#六使用注意事项)
- [七、技术参考](#七技术参考)
  - [7.1 架构](#71-架构)
  - [7.2 API：玩家数据](#72-api玩家数据)
  - [7.3 API：工具函数](#73-api工具函数)
  - [7.4 谓词清单（37 个）](#74-谓词清单37-个)
  - [7.5 函数标签](#75-函数标签)
  - [7.6 已知限制（设计取舍，使用前读一遍）](#76-已知限制设计取舍使用前读一遍)
- [八、测试与自检](#八测试与自检)
- [九、当前用户](#九当前用户)

---

## 一、这是什么？

**一句话：这是一个给其他数据包用的「玩家数据仓库」，它自己没有任何玩法。**

Minecraft 的数据包想给玩家「记点东西」——比如某个玩家吃过几次药、背包里有什么、
上次打开箱子是什么时候——都得自己找地方存。原版的记分板只能存数字，存不了物品、坐标、
复杂的结构；而直接往存储空间里乱写，多个包之间还会互相打架。

`doom.library` 就是来解决这件事的：

- 它给每个玩家**自动分配一个编号**，以后你要存取数据，认编号就行；
- 它提供一套**统一的读写接口**，你只管「读出来」「写回去」，落地、排队、冲突这些杂活它处理；
- 它还顺手提供了一小批**常用判断工具**（比如「这个玩家是不是在潜行」「主手物品有没有自定义数据」）。

所以：**它不产出玩法，它产出「别人做玩法时能用的地基」。**

> 如果你不是数据包作者，只是想装个有趣的东西玩——那你要找的是**用了它**的那些包
> （比如 `doom.consumable`），而不是它本身。单独装它，游戏里不会有任何变化。

---

## 二、装了它有什么用？谁需要它？

| 你是谁 | 你需要它吗 | 为什么 |
|---|---|---|
| 普通玩家 / 只想要玩法 | 不需要单独装 | 它没有玩法。你装的玩法包会自动带上它。 |
| 地图作者（做整合包、做地图） | **看情况** | 如果你用的 `doom.*` 系列包提示「缺少依赖」，那就得装上。 |
| 数据包作者（写 mcfunction） | **很可能需要** | 它可以省掉你自己写一套"玩家数据存取"的功夫。 |
| 想改动 doom 系列包的人 | 需要 | 其他包的数据都躺在它这里，读它才能看懂别人存了什么。 |

**它解决的具体痛点**：原版数据包没有「按玩家持久化一个任意结构」的现成设施。
记分板只能放整数，storage 是全局的、不会自动跟着玩家走，而且多个包共用一个 storage 很容易互相覆盖。
本包用「玩家 → 编号 → 数据树」的映射把这层封装起来了。

---

## 三、和 doom.consumable 是什么关系？

`doom.consumable` 是「统一的物品使用框架」（消耗 / 放置 / 丢弃 / 钓鱼 / 射击 / 投掷）。
它是本包的**重用户**：

```
doom.consumable  （玩法层：物品怎么用）
      │  需要存"这个玩家的物品状态"
      ▼
doom.library     （地基：玩家数据往哪存、怎么存）
```

具体来说，`doom.consumable` 会调用本包的
`api/ensure`（确保玩家有编号）、`api/read`（读数据）、`api/cache` / `api/cache_get`（读写缓存条目）、
`api/open`（一步打开）这几条接口。

**所以：想用 `doom.consumable`，就必须同时装 `doom.library`。** 反过来不成立——本包可以单独装（只是装了也没玩法）。

---

## 四、安装步骤

数据包就是一堆文件夹，**丢进正确的位置**即可，不需要任何第三方加载器。

**客户端（单人存档）**

1. 打开你的存档文件夹：
   `%appdata%\.minecraft\saves\<你的存档名>\`
2. 进去后找到（没有就自己建一个）名为 `datapacks` 的文件夹；
3. 把整个 `doom.library` 文件夹**整个拷进去**，最终长这样：
   ```
   saves\<存档名>\datapacks\doom.library\pack.mcmeta
   saves\<存档名>\datapacks\doom.library\data\...
   ```
   ⚠️ 注意是 `pack.mcmeta` 直接在 `doom.library` 下面，**不要再套一层同名文件夹**。
4. 回到游戏，执行 `/reload`；若已进过存档，建议退出重进一次。

**服务器**

1. 把 `doom.library` 文件夹拷进服务器的 `<服务端目录>\world\datapacks\`；
2. 控制台执行 `reload`。

**要不要同时装别的？**

- 只是想让某个玩法包能跑 → **那个包**和**它声明的依赖**都要装。以 `doom.consumable` 为例：`doom.library` 是必装。
- 建议连同 `doom.test`（系列自检套件）一起装，方便排查问题。

**版本要求**：本包声明支持 `pack_format` **48 – 82**，当前 `pack_format` 为 **81**（读自 `pack.mcmeta`）。
如果你的游戏版本加载时提示「数据包版本不兼容」，说明你的游戏不在这个区间里。
（仓库旧文档里标注过「1.21.6 = 80」，可作换算参考。）

---

## 五、五分钟上手

下面这三段是**最常用**的动作。看不懂语法没关系，先照抄改改。

### ① 打开某个玩家的数据

```mcfunction
# 给所有玩家分配编号，并把他们的数据读出来
execute as @a run function doom.library:api/open
```

跑完之后，玩家数据就在 `storage doom.library:io output[-1].data` 里。
（`api/open` = `api/ensure` + `api/read` 两件事一步做完，推荐用它。）

### ② 写一个缓存条目

「缓存条目」是挂在玩家身上的一块带时间戳的数据，适合存「上次看到的样子」。

```mcfunction
# 需要先执行过 api/ensure 或 api/open，_.idx 才有值
data modify storage doom.library:ctx _.cache_key set value "inventory"
data modify storage doom.library:ctx _.cache_data set value {}
data modify storage doom.library:ctx _.cache_data.Inventory set from entity @s Inventory
function doom.library:api/cache with storage doom.library:ctx _

# 用完把参数清干净（好习惯）
data remove storage doom.library:ctx _.cache_key
data remove storage doom.library:ctx _.cache_data
```

### ③ 读一个缓存条目

```mcfunction
data modify storage doom.library:ctx _.cache_key set value "inventory"
function doom.library:api/cache_get with storage doom.library:ctx _
# 结果在 storage doom.library:ctx cache_result 里
```

**注意**：`cache_get` **不需要**先 `api/read`，它直读数据，是 `api/cache` 的镜像操作。

> **为什么函数名后面老跟着 `with storage doom.library:ctx _`？**
> 因为带 `$` 开头的那几行是「宏」——参数得从别处传进去。本包的约定是：
> **参数写在 `storage doom.library:ctx` 的 `_` 下面**。
> 而且宏有个硬规矩：**参数缺一个，整次调用会被静默放弃**（不报错、什么也不做）。
> 所以调用前务必把该设的参数都设好。

---

## 六、使用注意事项

新手最容易踩的四条，先记住：

1. **`api/write` 和 `api/update` 不是立刻生效的。** 它们只是把写入塞进队列，
   服务器每 tick 只处理**一条**。而 `api/cache`、`api/reset` 是**立刻直写**的。
   两种写入**不要对同一个玩家在同一刻混用**——队列里压着的整体替换会把后来的直写盖掉。
2. **`output` 只有一个槽位。** 每次 `api/read` 都会整体覆盖它。读完赶紧用掉，
   不要「读一次，过一会儿再用」。
3. **索引不会回收。** 玩家退出后，他的数据仍然留在存储里。需要清理时，
   调用方自己调 `api/reset`。
4. **effect 系列函数的返回值是全局假分数**（`#lib_result lib.var`）。
   在循环里逐个玩家调用时，后一个玩家会覆盖前一个的结果——**必须在同一次调用内读走**。

---

## 七、技术参考

> 以下内容是给数据包作者的完整资料。数值与名称**均以仓库内的实际文件为准**
> （`pack.mcmeta`、`data/doom.library/function/`、`data/doom.library/predicate/`、`data/doom.library/tags/`）。

### 7.1 架构

| 资源 | 用途 |
|---|---|
| 计分板 `lib.var` | 库内部临时计算（`#lib_t` / `#lib_b` / `#lib_result` / `#lib_exists` / `#lib_amp` / `#lib_dur` / `#256` / `#0`…） |
| 计分板 `lib.idx` | **玩家 → 索引**绑定（`@s lib.idx`，由 `api/ensure` 分配，全局计数器 `#lib_idx` 只增不减） |
| `storage doom.library:io` | `{players:{index:{},data:{}}, input:[], output:[], stack:[]}` |
| `storage doom.library:ctx` | 调用方上下文；`_` 前缀键 = 宏函数参数（`_.idx` / `_.cache_key` / `_.cache_data` / `_.data`） |
| `storage doom.library:const` | 常量表（`hex_chars`，256 项，供 UUID 转换查表） |
| `storage doom.library:test` | 自检函数用的临时清单（`test/check`、`test/validate`） |

**入口**（读自 `data/minecraft/tags/function/`）：

- `#minecraft:load` → `doom.library:__load__`（建 `lib.var` / `lib.idx` 两个计分板、填 `hex_chars` 常量表、初始化 `io` 的四个字段）
- `#minecraft:tick` → `doom.library:tick/tick` → `doom.library:io/cycle`（每 tick 处理队列里的一条写入）

**数据形状**：`players.data.<idx>` = 该玩家的数据树；
`players.data.<idx>.CACHE.<key>` = `{data:…, timestamp:<gametime>}`（由 `api/cache` 写）。

**宏调用约定**：所有 `api/*` 宏函数用
`function doom.library:api/<name> with storage doom.library:ctx _` 调用，参数写在 `ctx` 的 `_` 键下。
宏在调用期整批展开——缺参数 ⇒ **整次调用静默放弃**，所以调用前务必把参数写全。

### 7.2 API：玩家数据

| 函数 | 宏 | 参数（ctx `_` 下） | 产物 |
|---|---|---|---|
| `api/ensure` | 否 | 无（需 `@s`） | 给 `@s` 分配 `lib.idx`；把 `_.idx` 写进 ctx；顺带补齐 `io` 的缺失字段 |
| `api/open` | 否 | 无（需 `@s`） | = `api/ensure` + `api/read`；数据落到 `io output[-1].data` |
| `api/read` | 是 | `idx` | `io output[-1].data` = 玩家数据（下一次 read 前有效） |
| `api/write` | 是 | `idx`、`data` | 入队 `input`，**整体替换**玩家数据（每 tick 落地一条） |
| `api/update` | 是 | `idx`、`data` | 入队 `input`，`mode:"merge"` **合并**进玩家数据（每 tick 落地一条） |
| `api/reset` | 是 | `idx` | 立即清空该玩家数据（直写，不走队列） |
| `api/cache` | 是 | `idx`、`cache_key`、`cache_data` | 立即写 `players.data.<idx>.CACHE.<key>` = `{data, timestamp}`（直写，不走队列） |
| `api/cache_get` | 是 | `idx`、`cache_key` | `ctx cache_result` = `CACHE.<key>.data` 的内容（条目不存在则 `cache_result` 不存在；不依赖先 `read`） |
| `api/cache_clear` | 是 | `idx`、`cache_key` | 删除 `CACHE.<key>` 整个条目（带存在性守卫，条目缺失时安静跳过） |

队列处理细节：`io/cycle` 采用**先弹后处理**（pop-then-process）——先把队首条目挪走、再执行写入。
这样即使队列里混进一条坏数据，也只会被「吃掉并跳过」，不会永久堵死队列。

### 7.3 API：工具函数

| 函数 | 说明 |
|---|---|
| `api/uuid_hex` | 把 `@s` 的 UUID 转成 36 字符 hex 串（`8-4-4-4-12`），产物落在 `storage doom.library:ctx uuid`。内部经 `api/hex/join` → `api/hex/join2` 两级宏完成查表与拼串。 |
| `effect/has_effect` | 宏参数 `$(effect)`；可选 ctx `min_amplifier` / `min_duration`；结果 `#lib_result lib.var`（1 / 0） |
| `effect/get_amplifier` | 宏参数 `$(effect)`；结果 `#lib_result lib.var`（无该效果 = -1） |
| `effect/get_duration` | 宏参数 `$(effect)`；结果 `#lib_result lib.var`（无该效果 = -1） |
| `test/check` | 逐个诊断当前玩家命中了哪些谓词并打印 |
| `test/validate` | 批量校验全部谓词列表（打印清单长度） |
| `test/list` | 打印谓词参考清单（含中文释义，见 7.4） |
| `test/probe_uuid` | 探针：打印真实 UUID 与 `ctx.uuid` / `ctx.hex`，用于定位 `api/uuid_hex` 的产物路径 |
| `test/uuid_test` | UUID 转换的测试用例 |
| `test/cache_api` | `api/cache` / `api/cache_get` / `api/cache_clear` 的四项自检（READ / CLEAR / STALE / PARAMS） |

> `api/hex/join` 与 `api/hex/join2` 是 `api/uuid_hex` 的内部实现，一般不直接调用。

### 7.4 谓词清单（37 个）

共 **37 个**谓词文件，分布在 `data/doom.library/predicate/` 下：
`effect/*` 14 个、`player/*` 17 个、`entity/*` 2 个、`item/*` 4 个。

**effect/（14）**：`has_strength` 力量 · `has_strength_2` 力量 II+ · `has_speed` 速度 ·
`has_speed_2` 速度 II+ · `has_resistance` 抗性 · `has_fire_resistance` 防火 ·
`has_water_breathing` 水下呼吸 · `has_night_vision` 夜视 · `has_regeneration` 生命恢复 ·
`has_absorption` 吸收 · `has_haste` 急迫 · `has_levitation` 飘浮 · `has_slow_falling` 缓降 ·
`has_jump_boost` 跳跃提升

**player/（17）**：`gamemode_survival` / `gamemode_creative` / `gamemode_adventure` / `gamemode_spectator`
四种游戏模式 · `is_sneaking` 潜行 · `is_sprinting` 疾跑 · `is_swimming` 游泳 · `is_on_ground` 在地面 ·
`is_burning` 着火 · `has_vehicle` 骑乘中 · `is_in_overworld` / `is_in_nether` / `is_in_end` 三个维度 ·
`input_jump` / `input_sneak` / `input_sprint` 三个按键输入 · `xp_high` 经验 ≥30 级

**entity/（2）**：`is_player` 是玩家 · `is_undead` 是不死生物

**item/（4）**：`has_custom_data` 主手有 `custom_data` · `has_armor_head` 头盔有物品 ·
`has_armor_chest` 胸甲有物品 · `has_armor_feet` 靴子有物品

> 最权威的清单在函数 `doom.library:test/list` 里（游戏内执行
> `/function doom.library:test/list` 即可看到带中文释义的完整列表）。

### 7.5 函数标签

| 标签 | 内容 | 说明 |
|---|---|---|
| `#doom.library:read` | `doom.library:api/read` | 历史接口 |
| `#doom.library:write` | `doom.library:api/write` | 历史接口 |
| `#doom.library:data_read` | `doom.library:api/read` | 与 `read` 内容相同 |
| `#doom.library:data_write` | `doom.library:api/write` | 与 `write` 内容相同 |

> 这四个标签内容两两相同，当前仓库内**没有任何包引用它们**，保留作为历史接口。
> 新代码请直接调用函数，不要依赖这些标签。

### 7.6 已知限制（设计取舍，使用前读一遍）

1. **写路径双轨**：`api/write` / `api/update` 走 `input` 队列（每 tick 只落地**一条**）；
   `api/cache` / `api/reset` 直写。若同玩家的队列里还压着一条整体替换，后写的直写缓存会被它盖掉
   ——两种写入不要混用于同一玩家同一拍。
2. **`output` 单槽**：每次 `api/read` 整体覆盖；读完结果尽快消费，不要隔着下一次 read 再用。
3. **effect 函数用全局假分数**（`#lib_result lib.var`）：逐玩家循环里结果会被后一个玩家覆盖，
   须在同一次调用内读走。
4. **索引不回收**：玩家退出后 `players.data.<idx>` 永久保留（存储不会自动清理）；
   需要清理时调用方自己调 `api/reset`。
5. **标签冗余**：`tags/function/read|write|data_read|data_write` 四个标签内容两两相同，
   当前无任何包引用，保留作历史接口。
6. **队列丢一条 vs 卡死**：`io/cycle` 选择「先弹后处理」，代价是处理中途失败时这条写入会**丢失**——
   这是刻意取舍，比旧版「坏条目永久堵死整条队列」好得多。

---

## 八、测试与自检

游戏内执行以下命令即可自查（需要 `@s` 为玩家）：

| 命令 | 作用 |
|---|---|
| `/function doom.library:test/list` | 打印全部谓词清单与中文释义 |
| `/function doom.library:test/check` | 逐个诊断：当前玩家命中了哪些谓词 |
| `/function doom.library:test/validate` | 批量校验谓词列表（会打印清单长度） |
| `/function doom.library:test/probe_uuid` | 打印真实 UUID 与 `ctx.uuid` / `ctx.hex`，定位 UUID 转换的产物 |
| `/function doom.library:test/cache_api` | 缓存 API 自检，期望四行绿：`READ OK` / `CLEAR OK` / `STALE OK` / `PARAMS OK` |

> ⚠️ `test/cache_api` 会**真的写入并删除**一条名为 `selftest` 的缓存条目，
> 请在测试环境里使用，不要在正式存档里随手跑。

跨包的完整回归套件在 `doom.test` 里（含本包的 `library_queue` 等用例）。

---

## 九、当前用户

- **`doom.consumable`** —— 重用户：`api/ensure` / `api/read` / `api/cache` / `api/open` 等
- **`doom.test`** —— 库自检与 `doom.consumable` 套件

---

<sub>本文件由仓库维护。数值如与游戏内表现不符，请以 `pack.mcmeta` 与 `data/` 下的实际文件为准。</sub>
