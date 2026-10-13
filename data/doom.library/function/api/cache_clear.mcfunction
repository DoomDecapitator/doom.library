# doom.library:api/cache_clear [MACRO] — 删除玩家的一个缓存条目（data + timestamp 一起）
# 调用：function doom.library:api/cache_clear with storage doom.library:ctx _
# 前置：_.idx 已就位（api/ensure / api/open 会写）；_.cache_key 已设
# 效果：移除 players.data.<idx>.CACHE.<key> 整个条目
# 说明：带 if data 守卫 —— 对不存在的路径执行 data remove 会失败，
#       可能连带中止调用方后面的命令；条目不存在时本函数安静跳过。
$execute if data storage doom.library:io players.data.$(idx).CACHE.$(cache_key) run data remove storage doom.library:io players.data.$(idx).CACHE.$(cache_key)
