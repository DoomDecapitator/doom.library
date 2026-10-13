# doom.library:api/cache_get [MACRO] — 把玩家某个缓存条目的 data 复制到固定路径
# 调用：function doom.library:api/cache_get with storage doom.library:ctx _
# 前置：_.idx 已就位（api/ensure / api/open 会写）；_.cache_key 已设
# 产物：storage doom.library:ctx cache_result = players.data.<idx>.CACHE.<key>.data 的内容
#       缓存条目不存在 ⇒ cache_result 不存在（先删旧值，上一轮残留不会冒充本次结果）
# 说明：直读 players.data，**不依赖先调 api/read**；与 api/cache 的写入路径互为镜像。
#       读取成功后请尽快消费 ctx.cache_result（它会被下一次 cache_get 清掉）。
data remove storage doom.library:ctx cache_result
$execute if data storage doom.library:io players.data.$(idx).CACHE.$(cache_key) run data modify storage doom.library:ctx cache_result set from storage doom.library:io players.data.$(idx).CACHE.$(cache_key).data
