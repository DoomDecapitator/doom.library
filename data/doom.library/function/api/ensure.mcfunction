# doom.library:api/ensure — ensure player has index, create if needed
# Ensure IO storage exists (initialize one field at a time)
execute unless data storage doom.library:io output run data modify storage doom.library:io output set value []
execute unless data storage doom.library:io input run data modify storage doom.library:io input set value []
execute unless data storage doom.library:io stack run data modify storage doom.library:io stack set value []
execute unless data storage doom.library:io players run data modify storage doom.library:io players set value {}
execute unless data storage doom.library:io players.index run data modify storage doom.library:io players.index set value {}
execute unless data storage doom.library:io players.data run data modify storage doom.library:io players.data set value {}

# Ensure player has index
execute unless score @s lib.idx matches 1.. run scoreboard players add #lib_idx lib.idx 1
execute unless score @s lib.idx matches 1.. run scoreboard players operation @s lib.idx = #lib_idx lib.idx
execute store result storage doom.library:ctx _.idx int 1 run scoreboard players get @s lib.idx
