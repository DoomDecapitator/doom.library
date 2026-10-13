# 探针：api/uuid_hex 的产物到底落在哪个路径（还是根本没留下）
# 用法：/function doom.library:test/probe_uuid
#
# 背景（代码里读出来的疑点，还没证实）：
#   · api/uuid_hex 把结果写进 `ctx.hex.uuid`
#   · 它最后调用的 api/hex/join，结尾一行是 `data remove storage doom.library:ctx hex`
#     —— 把包含 uuid 的**整个 hex 一起删掉**
#   · 作者自带的 test/uuid_test 打印的却是 `ctx.uuid`（另一个路径）
#   · 全库检索：没有任何地方读 `ctx.hex.uuid` 或 `ctx.uuid`
#   所以先用探针把"真值 / 两条候选路径 / 整个 ctx"一起打出来比对，不靠推测下结论。
#
# 注释里的 `#` 开头行不算；下面用 execute 守卫住 data remove（删不存在的路径会失败）。
execute if data storage doom.library:ctx hex run data remove storage doom.library:ctx hex
execute if data storage doom.library:ctx uuid run data remove storage doom.library:ctx uuid

function doom.library:api/uuid_hex

tellraw @s [{"text":"[U] 真实 UUID   = ","color":"gold"},{"nbt":"UUID","entity":"@s","interpret":false}]
tellraw @s [{"text":"[U] ctx.uuid    = ","color":"gold"},{"nbt":"uuid","storage":"doom.library:ctx","interpret":false}]
tellraw @s [{"text":"[U] ctx.hex     = ","color":"gold"},{"nbt":"hex","storage":"doom.library:ctx","interpret":false}]
tellraw @s [{"text":"判读：哪一行打出了 8-4-4-4-12 的十六进制串，那个路径才是真产物；全空 = 结果被丢掉了","color":"yellow"}]
