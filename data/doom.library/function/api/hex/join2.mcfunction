# 组装 UUID —— 第二段：把查好的 16 个十六进制片段拼成标准 UUID 串
# 调用：function doom.library:api/hex/join2 with storage doom.library:ctx hex
# 前置：ctx.hex 里已有 h0..hf（每个是两字符的十六进制片段）
# 产物：ctx.uuid（36 字符，8-4-4-4-12）
#
# 为什么必须单独一个函数：宏在**调用期整批展开**，本行的 $(h0)..$(hf) 必须是
# **调用方提供的参数**。写在 join 里面时它们是同一函数刚产生的局部结果 → 缺参数 → 整次放弃。
# 拆出来后，join 查完表再调本函数，ctx.hex 里 h* 已就位，参数就齐全了。
#
# 字节序：前 4 字节按 h3h2h1h0 倒序（对应 NBT 里 UUID 的高位 int 按低字节在前存储）。
$data modify storage doom.library:ctx uuid set value "$(h3)$(h2)$(h1)$(h0)-$(h7)$(h6)-$(h5)$(h4)-$(hb)$(ha)-$(h9)$(h8)$(hf)$(he)$(hd)$(hc)"
data remove storage doom.library:ctx hex
