= typst基本用法(基于版本： 0.13.1 (8ace67d9))

=== 实时编译
```bash
$: typst watch file.typ
```
=== 基本语法

typst总共有三个模式`math`, `code`, `markup`\
math 用于数学公式，code用于编程和扩展，markup语法层面是math和code的共同父级，核心在code，把注意力着重放在code上。
typst的code有以下特征
- 类型系统
- 循环和逻辑判断
- 代码块
- 函数
- 规则
- 判断与循环
- 模块

类型系统
- None
- Auto
- Boolean
- Int
- Float
- Length
- Angle
- Fraction
- Ratio
- String
- Label
- Math
- RawText

开始实践
导入模块cetz类似latex的tikz
```typc
#import "@preview/cetz:0.4.1"
#cetz.canvas({
    import cetz.draw: *
    rect(name: "customBox",(0, 0), (1, 1))//画一个方框
    circle((rel: (0, -2), to: "customBox"))//rel是相对定位,y轴相对方框
})
```
#import "@preview/cetz:0.4.1"
#cetz.canvas({
    import cetz.draw: *
    rect(name: "customBox",(0, 0), (1, 1))
    circle((rel: (0, -2), to: "customBox"))//rel是相对定位
    line(name: "line",(0.5,0.5), (0.5,-1.5), stroke: orange+2pt)
    content(name:"markup-line", (rel: (-0.4,0), to: "line"))[#text("-2的距离",size: 1em)]
})

画5个方框，每个方框中间放个数字
```typc
#cetz.canvas({
    let colors = (green, red, orange, gray, blue)
    for value in (1, 2, 3, 4, 5) {
        import cetz.draw: *
        rect(name: str(value),(value - 1, 0), (value, 1))
        content(name: str(value)+"text", (rel: (0, 0), to: str(value)))[#text(str(value), stroke: colors.at(value - 1))]
    }
})
```
#cetz.canvas({
    let colors = (green, red, orange, gray, blue)
    for value in (1, 2, 3, 4, 5) {
        import cetz.draw: *
        rect(name: str(value),(value - 1, 0), (value, 1))
        content(name: str(value)+"text", (rel: (0, 0), to: str(value)))[#text(str(value), stroke: colors.at(value - 1))]
    }
})

利用位操作画紫微斗数十二宫#footnote("一种玄学命盘，这里的数字顺序并不严谨，真实的命盘是逆时针或顺时针的顺序，这里命盘中的数字只是显示绘制顺序，因为是扫描式（一行一行）绘制的")
#cetz.canvas({
    import cetz.draw: *
    let palaces = (0,1,2,3,4,7,8,11,12,13,14,15)
    for value in palaces {
        //text(str(value))
        rect(name: str(value),(value.bit-and(3), - value.bit-rshift(2)), (value.bit-and(3) + 1, - value.bit-rshift(2) - 1))
        content(name: str(value)+"text", (rel: (0, 0), to: str(value)))[#text(str(value))]
    }
})
```typc
#cetz.canvas({
    import cetz.draw: *
    let palaces = (0,1,2,3,4,7,8,11,12,13,14,15)//定出工位的索引
    for value in palaces {
        //text(str(value))
        rect(name: str(value),(value.bit-and(3), - value.bit-rshift(2)), (value.bit-and(3) + 1, - value.bit-rshift(2) - 1))//typst中没有整除和取模，整除通过右移（只适用除数为$2^n$情况），通过xmod4=x & 3的原理实现取模（只适用模数为$2^n$的情况）
        content(name: str(value)+"text", (rel: (0, 0), to: str(value)))[#text(str(value))]
    }
})
```

#cetz.canvas(({
    import cetz.draw: *
    let edge = 2
    let palaces = (
        (0, "命宫"),
        (1, "兄弟宫"),
        (2, "夫妻宫"),
        (3, "子女宫"),
        (4, "财帛宫"),
        (7, "疾厄宫"),
        (8, "迁移宫"),
        (11, "交友宫"),
        (12, "事业宫"),
        (13, "田宅宫"),
        (14, "福德宫"),
        (15, "父母宫")
    )//定出工位的索引和名称
    for (index, name) in palaces {
        rect(name: str(index),(index.bit-and(3) * edge, - index.bit-rshift(2) * edge), (index.bit-and(3) * edge + edge, - index.bit-rshift(2) * edge - edge))
        content(name: str(index)+"text", (rel: (0, 0), to: str(index)))[#text(name, size: 0.4em)];//显示工位名称
    }
    move-to((rel: (- edge * 0.5, edge * 0.5), to: "15"))
    line(name: "self0-15", (),(rel: (edge * 0.5, - edge * 0.5), to: "0"), mark: (start: ">", fill: red), stroke: red)
    content(name: "self0-15d", (rel: (0.5em, 0), to: "self0-15"))[#text("A", size: 0.8em, stroke: red)];//显示工位名称
    // let next(mark) = {
    //     line((), (rel: (1, 0)), mark: mark)
    //     move-to((rel: (-1, .25)))
    // }

    // set-style(fill: blue, mark: (fill: auto))
    // rotate(190deg)

    // let marks = (">", "<", "|", "<>", "o")
    // for m in marks {
    //     next((end: m))
    // }

    // for m in marks {
    //     next((start: m))
    // }

    // fill(none)

    // let marks = (">", "<")
    // for m in marks {
    //     next((end: m))
    // }

    // for m in marks {
    //     next((start: m))
    // }
    //画出宫位的边框
}))