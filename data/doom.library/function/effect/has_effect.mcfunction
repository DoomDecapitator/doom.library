scoreboard players set #lib_result lib.var 0
$execute if data entity @s ActiveEffects[{id:$(effect)}] run scoreboard players set #lib_result lib.var 1
execute if score #lib_result lib.var matches 1 if data storage doom.library:ctx min_amplifier run scoreboard players set #lib_amp lib.var 0
$execute if score #lib_result lib.var matches 1 if data storage doom.library:ctx min_amplifier store result score #lib_amp lib.var run data get entity @s ActiveEffects[{id:$(effect)}].amplifier
execute if score #lib_result lib.var matches 1 if data storage doom.library:ctx min_amplifier store result score #lib_amp_min lib.var run data get storage doom.library:ctx min_amplifier
execute if score #lib_result lib.var matches 1 if data storage doom.library:ctx min_amplifier if score #lib_amp lib.var < #lib_amp_min lib.var run scoreboard players set #lib_result lib.var 0
execute if score #lib_result lib.var matches 1 if data storage doom.library:ctx min_duration run scoreboard players set #lib_dur lib.var 0
$execute if score #lib_result lib.var matches 1 if data storage doom.library:ctx min_duration store result score #lib_dur lib.var run data get entity @s ActiveEffects[{id:$(effect)}].duration
execute if score #lib_result lib.var matches 1 if data storage doom.library:ctx min_duration store result score #lib_dur_min lib.var run data get storage doom.library:ctx min_duration
execute if score #lib_result lib.var matches 1 if data storage doom.library:ctx min_duration if score #lib_dur lib.var < #lib_dur_min lib.var run scoreboard players set #lib_result lib.var 0