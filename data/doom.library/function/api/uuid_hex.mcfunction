# 将 @s 的 UUID 转换为 hex 字符串
# 结果存入 storage doom.library:ctx uuid
# UUID[0] — 4 字节
execute store result score #lib_t lib.var run data get entity @s UUID[0]
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.b0 int 1 run scoreboard players get #lib_b lib.var
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.b1 int 1 run scoreboard players get #lib_b lib.var
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.b2 int 1 run scoreboard players get #lib_b lib.var
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.b3 int 1 run scoreboard players get #lib_b lib.var

# UUID[1] — 4 字节
execute store result score #lib_t lib.var run data get entity @s UUID[1]
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.b4 int 1 run scoreboard players get #lib_b lib.var
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.b5 int 1 run scoreboard players get #lib_b lib.var
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.b6 int 1 run scoreboard players get #lib_b lib.var
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.b7 int 1 run scoreboard players get #lib_b lib.var

# UUID[2] — 4 字节
execute store result score #lib_t lib.var run data get entity @s UUID[2]
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.b8 int 1 run scoreboard players get #lib_b lib.var
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.b9 int 1 run scoreboard players get #lib_b lib.var
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.ba int 1 run scoreboard players get #lib_b lib.var
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.bb int 1 run scoreboard players get #lib_b lib.var

# UUID[3] — 4 字节
execute store result score #lib_t lib.var run data get entity @s UUID[3]
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.bc int 1 run scoreboard players get #lib_b lib.var
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.bd int 1 run scoreboard players get #lib_b lib.var
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.be int 1 run scoreboard players get #lib_b lib.var
scoreboard players operation #lib_b lib.var = #lib_t lib.var
scoreboard players operation #lib_b lib.var %= #256 lib.var
scoreboard players operation #lib_t lib.var /= #256 lib.var
execute if score #lib_b lib.var matches ..-1 run scoreboard players remove #lib_t lib.var 1
execute if score #lib_b lib.var matches ..-1 run scoreboard players add #lib_b lib.var 256
execute store result storage doom.library:ctx hex.bf int 1 run scoreboard players get #lib_b lib.var

# 组装 UUID 字符串
function doom.library:api/hex/join with storage doom.library:ctx hex