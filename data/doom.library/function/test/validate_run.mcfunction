$data modify storage doom.library:test current set value "$(path)"
$execute if predicate doom.library:$(path) run scoreboard players set #lib_val lib.var 1
$execute unless predicate doom.library:$(path) run scoreboard players set #lib_val lib.var 0
execute if score #lib_val lib.var matches 1 run tellraw @s [{"text":"[✓] ","color":"green"},{"nbt":"current","storage":"doom.library:test"}]
execute if score #lib_val lib.var matches 0 run tellraw @s [{"text":"[✓] ","color":"green"},{"nbt":"current","storage":"doom.library:test","color":"gray"}]
data remove storage doom.library:test list[0]
execute if data storage doom.library:test list[0] run function doom.library:test/validate_run with storage doom.library:test list[0]