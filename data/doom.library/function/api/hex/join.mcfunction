# 组装 UUID —— 第一段：查表，把 16 个字节变成 16 个两字符的十六进制片段
# 调用：function doom.library:api/hex/join with storage doom.library:ctx hex
# 前置：ctx.hex 里已有 b0..bf（16 个 0..255 的整数）
#
# ⚠ 2026-09-20 修复（由 doom.library:test/probe_uuid 探针定案）：
#   原先"查表"和"拼串"写在**同一个**宏函数里。但宏是在**调用期整批展开**的：
#   拼串那行引用的 $(h0)..$(hf) 是同一函数里刚写进 ctx 的**局部结果**，
#   不在调用方提供的参数里 → 缺参数 → **整次调用被静默放弃**（连查表都没跑）。
#   探针实测：uuid_hex 跑完后 ctx.hex 里只剩 b0..bf，既没有 h*、也没有 uuid。
#   现在拆成两个宏：本函数只负责查表；查完把 ctx.hex 交给 api/hex/join2 拼串 ——
#   那一刻 ctx.hex 里已经有 h* 了，参数齐全。
$data modify storage doom.library:ctx hex.h0 set from storage doom.library:const hex_chars[$(b0)]
$data modify storage doom.library:ctx hex.h1 set from storage doom.library:const hex_chars[$(b1)]
$data modify storage doom.library:ctx hex.h2 set from storage doom.library:const hex_chars[$(b2)]
$data modify storage doom.library:ctx hex.h3 set from storage doom.library:const hex_chars[$(b3)]
$data modify storage doom.library:ctx hex.h4 set from storage doom.library:const hex_chars[$(b4)]
$data modify storage doom.library:ctx hex.h5 set from storage doom.library:const hex_chars[$(b5)]
$data modify storage doom.library:ctx hex.h6 set from storage doom.library:const hex_chars[$(b6)]
$data modify storage doom.library:ctx hex.h7 set from storage doom.library:const hex_chars[$(b7)]
$data modify storage doom.library:ctx hex.h8 set from storage doom.library:const hex_chars[$(b8)]
$data modify storage doom.library:ctx hex.h9 set from storage doom.library:const hex_chars[$(b9)]
$data modify storage doom.library:ctx hex.ha set from storage doom.library:const hex_chars[$(ba)]
$data modify storage doom.library:ctx hex.hb set from storage doom.library:const hex_chars[$(bb)]
$data modify storage doom.library:ctx hex.hc set from storage doom.library:const hex_chars[$(bc)]
$data modify storage doom.library:ctx hex.hd set from storage doom.library:const hex_chars[$(bd)]
$data modify storage doom.library:ctx hex.he set from storage doom.library:const hex_chars[$(be)]
$data modify storage doom.library:ctx hex.hf set from storage doom.library:const hex_chars[$(bf)]
function doom.library:api/hex/join2 with storage doom.library:ctx hex
