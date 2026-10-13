# doom.library:io/_write_current —— 把队列头那条写入 players.data
# 调用：function doom.library:io/_write_current with storage doom.library:io _.current
# _.current = {index:<int>, data:{…}, [mode:"merge"]}
#
# ⚠ 2026-09-20 修了两个问题：
#
#   1) **merge 分支从来没生效过**（数据静默丢失）：
#      旧条件写的是 `if data … _.current.mode.merge` —— 那是把 `.merge` 当成 `mode` 的**子键**去找，
#      而 mode 是字符串 "merge"，路径根本不存在 ⇒ 恒假。
#      同时 `unless data … _.current.mode` 又因为 `.mode` **存在**而为假 ⇒ **两行都不执行，
#      条目却被弹掉** ⇒ 用 api/update 写的数据凭空消失。
#      正确写法是 **compound 匹配器** `_.current{mode:"merge"}`（判断 mode 的值）。
#
#   2) 弹队动作已移到 io/cycle（先弹后处理），本函数不再负责 remove input[0]。
#      原因见 io/cycle 的注释：宏函数缺参数会整段不执行，弹队放在这里会让坏条目永久卡住队列。
#
#   3) 顺带给 replace 分支加 `if data … _.current.data` 守卫：
#      缺 data 的坏条目不再让 `set from` 取空源（那会失败/中止，把后面的清理一起带走）。
$execute if data storage doom.library:io _.current{mode:"merge"} if data storage doom.library:io _.current.data run data modify storage doom.library:io players.data.$(index) merge from storage doom.library:io _.current.data
$execute unless data storage doom.library:io _.current{mode:"merge"} if data storage doom.library:io _.current.data run data modify storage doom.library:io players.data.$(index) set from storage doom.library:io _.current.data
