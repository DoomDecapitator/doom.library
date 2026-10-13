# doom.library:io/cycle —— 每 tick 处理队列头一条（由 tick/tick 调用）
#
# ⚠ 2026-09-20 修复：改成 **先弹后处理**（pop-then-process）。
#
#   旧写法把 `data remove input[0]` 放在 _write_current 的**最后一行**（先写后弹）。
#   而 _write_current 是**宏函数** —— 宏在调用期整批展开，只要有一个 $(var) 取不到值，
#   **整个函数体一行都不执行**（连末尾的 remove 也不执行）。于是队列里出现一条
#   缺 `index` 的坏条目时，input[0] 永远弹不掉 ⇒ **队列永久卡死** ⇒ 整包持久化写入停摆。
#   实测证据：doom.test:suite/library_queue 的"坏条目之后的好条目落地"与"队列已排空"两条断言。
#
#   现在弹队动作归 io/cycle 管、且**排在处理之前**：坏条目会被"吃掉并跳过"，
#   而不是堵在队首。代价是"处理中途失败 = 这条写入丢失"—— 比永久卡死好得多。
execute if data storage doom.library:io input[0] run data modify storage doom.library:io _.current set from storage doom.library:io input[0]
execute if data storage doom.library:io input[0] run data remove storage doom.library:io input[0]
execute if data storage doom.library:io _.current run function doom.library:io/_write_current with storage doom.library:io _.current
execute if data storage doom.library:io _.current run data remove storage doom.library:io _.current
