# doom.library:api/open — 打开玩家数据（ensure + read 一步到位）
# 调用：execute as <玩家> run function doom.library:api/open
#       （需要 @s：api/ensure 会给 @s 分配 lib.idx）
# 行为：① api/ensure —— 确保 io 存在、给 @s 分配索引、把 _.idx 写进 ctx
#       ② api/read   —— 该玩家的数据落到 storage doom.library:io output[-1].data
# 产物：output[-1].data = 该玩家的完整数据（在下一次 api/read 之前有效）
# 等价于（旧写法，仍然可用，向后兼容）：
#   function doom.library:api/ensure
#   function doom.library:api/read with storage doom.library:ctx _
function doom.library:api/ensure
function doom.library:api/read with storage doom.library:ctx _
