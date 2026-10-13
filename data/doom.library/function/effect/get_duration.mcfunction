scoreboard players set #lib_result lib.var -1
$execute if data entity @s ActiveEffects[{id:$(effect)}] run scoreboard players set #lib_exists lib.var 1
$execute if score #lib_exists lib.var matches 1 store result score #lib_result lib.var run data get entity @s ActiveEffects[{id:$(effect)}].duration
scoreboard players set #lib_exists lib.var 0