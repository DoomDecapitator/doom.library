# doom.library:test/cache_api — api/cache_get / api/cache_clear 自检
# 用法:/function doom.library:test/cache_api(需要 @s:api/open 会给它分配索引)
# 期望:四行绿(READ OK / CLEAR OK / STALE OK / PARAMS OK);任何红 = 新 API 行为异常。
# 注意:③ 的判据走 output[-1],所以删除后又跑了一次 api/open ——
#       output 是 read 时点的快照,不刷新就查不到"删除后的真实状态"(会是假绿)。
execute as @s run function doom.library:api/open
# ① 写入一个测试缓存条目
data modify storage doom.library:ctx _.cache_key set value "selftest"
data modify storage doom.library:ctx _.cache_data set value {probe:1b}
function doom.library:api/cache with storage doom.library:ctx _
# ② cache_get 应把它带到 ctx.cache_result(直读 players.data,不依赖 read)
data modify storage doom.library:ctx _.cache_key set value "selftest"
function doom.library:api/cache_get with storage doom.library:ctx _
execute if data storage doom.library:ctx cache_result{probe:1b} run tellraw @s {"text":"[cache_api] READ OK — cache_result = {probe:1b}","color":"green"}
execute unless data storage doom.library:ctx cache_result{probe:1b} run tellraw @s {"text":"[cache_api] READ FAIL — cache_result 没取到 {probe:1b}","color":"red"}
# ③ cache_clear 应删掉整个条目(先刷新 output 再判)
function doom.library:api/cache_clear with storage doom.library:ctx _
execute as @s run function doom.library:api/open
execute if data storage doom.library:io output[-1].data.CACHE.selftest run tellraw @s {"text":"[cache_api] CLEAR FAIL — CACHE.selftest 仍存在","color":"red"}
execute unless data storage doom.library:io output[-1].data.CACHE.selftest run tellraw @s {"text":"[cache_api] CLEAR OK — CACHE.selftest 已删除","color":"green"}
# ④ 条目已删 ⇒ 再 get 一次,cache_result 必须不存在(上一轮残留不会冒充)
function doom.library:api/cache_get with storage doom.library:ctx _
execute if data storage doom.library:ctx cache_result run tellraw @s {"text":"[cache_api] STALE FAIL — 条目已删但 cache_result 仍有残留","color":"red"}
execute unless data storage doom.library:ctx cache_result run tellraw @s {"text":"[cache_api] STALE OK — 删除后 get 不残留","color":"green"}
# 清理参数
data remove storage doom.library:ctx _.cache_key
data remove storage doom.library:ctx _.cache_data
execute if data storage doom.library:ctx _.cache_key if data storage doom.library:ctx _.cache_data run tellraw @s {"text":"[cache_api] PARAMS FAIL — 参数没清干净","color":"red"}
execute unless data storage doom.library:ctx _.cache_key unless data storage doom.library:ctx _.cache_data run tellraw @s {"text":"[cache_api] PARAMS OK — ctx 参数已清理","color":"green"}
