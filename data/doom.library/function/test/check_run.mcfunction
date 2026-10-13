$data modify storage doom.library:test current set value "$(path)"
$execute if predicate doom.library:$(path) run tellraw @s [{"text":"[✓] ","color":"green"},{"nbt":"current","storage":"doom.library:test"}]
data remove storage doom.library:test list[0]
execute if data storage doom.library:test list[0] run function doom.library:test/check_run with storage doom.library:test list[0]