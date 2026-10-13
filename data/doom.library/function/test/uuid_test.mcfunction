# 测试 UUID hex 转换
function doom.library:api/uuid_hex
tellraw @s [{"text":"UUID: ","color":"green"},{"nbt":"ctx.uuid","storage":"doom.library:ctx"}]