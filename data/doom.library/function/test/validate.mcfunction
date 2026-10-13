# doom.library 谓词验证 — 宏遍历
tellraw @s {"text":"[validate] start","color":"green"}
data modify storage doom.library:test list set value [\
  {"path":"effect/has_strength"},{"path":"effect/has_strength_2"},{"path":"effect/has_speed"},{"path":"effect/has_speed_2"},\
  {"path":"effect/has_resistance"},{"path":"effect/has_fire_resistance"},{"path":"effect/has_water_breathing"},\
  {"path":"effect/has_night_vision"},{"path":"effect/has_regeneration"},{"path":"effect/has_absorption"},\
  {"path":"effect/has_haste"},{"path":"effect/has_levitation"},{"path":"effect/has_slow_falling"},{"path":"effect/has_jump_boost"},\
  {"path":"player/gamemode_survival"},{"path":"player/gamemode_creative"},{"path":"player/gamemode_adventure"},{"path":"player/gamemode_spectator"},\
  {"path":"player/is_sneaking"},{"path":"player/is_sprinting"},{"path":"player/is_swimming"},{"path":"player/is_on_ground"},{"path":"player/is_burning"},\
  {"path":"player/has_vehicle"},{"path":"player/is_in_overworld"},{"path":"player/is_in_nether"},{"path":"player/is_in_end"},\
  {"path":"player/input_jump"},{"path":"player/input_sneak"},{"path":"player/input_sprint"},{"path":"player/xp_high"},\
  {"path":"entity/is_player"},{"path":"entity/is_undead"},\
  {"path":"item/has_custom_data"},{"path":"item/has_armor_head"},{"path":"item/has_armor_chest"},{"path":"item/has_armor_feet"}\
]
execute store result score #lib_size lib.var run data get storage doom.library:test list
tellraw @s [{"text":"[validate] list size=","color":"gray"},{"score":{"name":"#lib_size","objective":"lib.var"}}]
function doom.library:test/validate_run with storage doom.library:test list[0]