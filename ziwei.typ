#import "base.typ": branchToIndex, palaces, stems
#import "@preview/cetz:0.4.1"

#let edge = 2//边的长度
#let selfEvolveLen = edge * 1 //离心自化的长度



#let drawPalaces(ps) = {
  cetz.canvas({
    import cetz.draw: *

    let subtends = () //向心自化的表
    for palace in ps {
      let (index, branch, stem, stars, name, stage, anchor) = palace
      rect(
        name: str(index),
        (index.bit-and(3) * edge, -index.bit-rshift(2) * edge),
        (index.bit-and(3) * edge + edge, -index.bit-rshift(2) * edge - edge),
      )
      content(name: str(index) + "branch", (rel: (edge * 0.4, -edge * 0.4), to: str(index)))[#text(
          branch,
          size: 0.5em,
        )] //显示地支
      content(name: str(index) + "stem", (rel: (edge * 0.4, -edge * 0.25), to: str(index)))[#text(
          stem,
          size: 0.5em,
        )] //显示天干

      content(name: str(index) + "name", (rel: (-edge * 0.4, -edge * 0.27), to: str(index)))[#text(
          name.split("").join("\n"),
          size: 0.5em,
        )] //显示宫位名称
      if stage.len() > 0 {
        content(name: str(index) + "stage", (rel: (0, -edge * 0.3), to: str(index)))[#text(
            stage,
            size: 0.5em,
          )] //显示阶段
        move-to((rel: (-0.25, 0), to: str(index) + "stage"))
        line(name: str(index) + "stage-l", (), (rel: (-0.5, 0), to: str(index) + "stage"), stroke: gray)
        move-to((rel: (0.25, 0), to: str(index) + "stage"))
        line(name: str(index) + "stage-r", (), (rel: (0.5, 0), to: str(index) + "stage"), stroke: gray)
      }
      /*开始绘制星辰*/
      let offsetx = 0 //星辰偏移量

      for star in stars {
        //绘制星辰和自化
        let (name, originalEvolve, selfEvolve, evolve, subtendEvolve) = star
        /*开始绘制星辰和飞宫*/
        let flyColor = if evolve == "D" { red } else if evolve == "A" { green } else if evolve == "C" { blue } else if (
          evolve == "B"
        ) { purple } else { gray }
        // rect(name: str(index) + name, (rel: (-edge * 0.4 + offsetx, edge * 0.4), to: str(index)))[#text("hh")]
        content(name: str(index) + name, (rel: (-edge * 0.4 + offsetx, edge * 0.3), to: str(index)))[
          #box(
            height: 1.2em,
            baseline: 100% + 2pt,
            text(star.name.split("").join("\n"), size: 0.4em, baseline: -5pt),
            fill: flyColor,
          ) //显示星辰名称
        ] //显示星辰名称
        /*结束绘制星辰和飞宫*/
        offsetx += 0.2
        /*开始生年四化*/
        if originalEvolve.len() > 0 {
          //生年四化
          content(name: str(index) + name + "originalEvolve", (rel: (0, -0.4), to: str(index) + name))[
            #text(originalEvolve, size: 0.4em, stroke: if originalEvolve == "D" { red } else if originalEvolve == "A" {
              green
            } else if originalEvolve == "C" { blue } else if originalEvolve == "B" { purple } else { gray })
          ]
        }
        /*结束生年四化*/
        /*开始绘制离心自化*/
        let increaseOffsetY = 0.02
        let topOfStar = -0.3 //星辰下方的偏移量
        for selfEvolve in selfEvolve {
          //自化颜色
          let (offsetDirect, offset) = anchor
          let selfEvolveColor = if selfEvolve == "D" { red } else if selfEvolve == "A" { green } else if (
            selfEvolve == "C"
          ) { blue } else if selfEvolve == "B" { purple } //自化颜色
          if offsetDirect == "x" {
            //横向离心
            let selfEvolveOffsetY = -1 //离心自化下移
            if offset < 0 {
              //绘制左边自化
              move-to((rel: (0, selfEvolveOffsetY + increaseOffsetY), to: str(index) + name))
              line(
                name: str(index) + name + "selfEvolve-y",
                (),
                (rel: (0, topOfStar), to: str(index) + name),
                stroke: selfEvolveColor,
              )
              move-to((rel: (offset, selfEvolveOffsetY + increaseOffsetY), to: str(index) + name)) //
              line(
                name: str(index) + name + "selfEvolve-x",
                (),
                (rel: (0, selfEvolveOffsetY + increaseOffsetY), to: str(index) + name),
                stroke: selfEvolveColor,
                mark: (start: ">", fill: selfEvolveColor),
              )
            } else {
              //绘制右边自化
              move-to((rel: (0, selfEvolveOffsetY + increaseOffsetY), to: str(index) + name))
              line(
                name: str(index) + name + "selfEvolve-y",
                (),
                (rel: (0, topOfStar), to: str(index) + name),
                stroke: selfEvolveColor,
              )
              move-to((rel: (offset, selfEvolveOffsetY + increaseOffsetY), to: str(index) + name)) //
              line(
                name: str(index) + name + "selfEvolve-x",
                (),
                (rel: (0, selfEvolveOffsetY + increaseOffsetY), to: str(index) + name),
                stroke: selfEvolveColor,
                mark: (start: ">", fill: selfEvolveColor),
              )
            }
          } else {
            if offset < 0 {
              //绘制下方自化
              move-to((rel: (0, offset), to: str(index) + name))
              line(
                name: str(index) + name + "selfEvolve-x",
                (),
                (rel: (0, topOfStar), to: str(index) + name),
                stroke: selfEvolveColor,
                mark: (start: ">", fill: selfEvolveColor),
              )
            } else {
              //绘制上方自化
              move-to((rel: (0, offset), to: str(index) + name))
              line(
                name: str(index) + name + "selfEvolve-x",
                (),
                (rel: (0, 0.18), to: str(index) + name),
                stroke: selfEvolveColor,
                mark: (start: ">", fill: selfEvolveColor),
              )
            }
          }
          increaseOffsetY = increaseOffsetY + 0.1 //每个自化增加0.02的偏移量
        }
        /*结束绘制离心自化*/
        /*开始绘制向心自化*/
        subtends.push((index: index, name: str(index) + name + "subtendEvolve", evolveType: subtendEvolve))
        /*结束绘制向心自化*/
      }
      /*结束绘制向心自化*/
      /*开始绘制星辰*/
    }
    /*开始绘制向心自化*/
    let subtendOffset = 0.1 //向心自化的偏移量
    for subtend in subtends {
      let (index, name, evolveType) = subtend
      let subtendColor = if evolveType == "D" { red } else if evolveType == "A" { green } else if evolveType == "C" {
        blue
      } else if evolveType == "B" { purple }
      let subtendPoint = () //对宫发射点
      //求解起点
      if index == 0 {
        move-to((rel: (edge * 0.5, -edge * 0.5), to: str(index)))
        subtendPoint = (15, (-edge * 0.5, edge * 0.5))
      } else if index == 1 {
        move-to((rel: (0, -edge * 0.5), to: str(index)))
        subtendPoint = (14, (0, edge * 0.5))
      } else if index == 2 {
        move-to((rel: (0, -edge * 0.5), to: str(index)))
        subtendPoint = (13, (0, edge * 0.5))
      } else if index == 3 {
        move-to((rel: (-edge * 0.5, -edge * 0.5), to: str(index)))
        subtendPoint = (12, (edge * 0.5, edge * 0.5))
      } else if index == 4 {
        move-to((rel: (edge * 0.5, 0), to: str(index)))
        subtendPoint = (11, (-edge * 0.5, 0))
      } else if index == 7 {
        move-to((rel: (-edge * 0.5, 0), to: str(index)))
        subtendPoint = (8, (edge * 0.5, 0))
      } else if index == 8 {
        move-to((rel: (edge * 0.5, 0), to: str(index)))
        subtendPoint = (7, (-edge * 0.5, 0))
      } else if index == 11 {
        move-to((rel: (-edge * 0.5, 0), to: str(index)))
        subtendPoint = (4, (edge * 0.5, 0))
      } else if index == 12 {
        move-to((rel: (edge * 0.5, edge * 0.5), to: str(index)))
        subtendPoint = (3, (-edge * 0.5, -edge * 0.5))
      } else if index == 13 {
        move-to((rel: (0, edge * 0.5), to: str(index)))
        subtendPoint = (2, (0, -edge * 0.5))
      } else if index == 14 {
        move-to((rel: (0, edge * 0.5), to: str(index)))
        subtendPoint = (1, (0, -edge * 0.5))
      } else if index == 15 {
        move-to((rel: (-edge * 0.5, edge * 0.5), to: str(index)))
        subtendPoint = (0, (edge * 0.5, -edge * 0.5))
      }
      //绘制向心自化
      let (subIndex, point) = subtendPoint
      line(
        name: name,
        (),
        (rel: point, to: str(subIndex)),
        stroke: subtendColor,
        mark: (start: ">", fill: subtendColor),
      )
    }
  })
}


#let ziweiDraw(palaces) = {
  for (key, index) in branchToIndex {
    let anchor = if index in (0, 1, 2, 3) {
      ("y", selfEvolveLen) //上
    } else if index in (4, 8) {
      ("x", -selfEvolveLen) //左
    } else if index in (7, 11) {
      ("x", selfEvolveLen) //右
    } else if index in (12, 13, 14, 15) {
      ("y", -selfEvolveLen) //下
    }
    palaces = palaces.map(palace => {
      palace.anchor = anchor
      palace.index = index
    })
  }
  drawPalaces(palaces)
}


```typc
result.push((
name: "命宫",
index: index,
stem: "甲",
branch: key,
anchor: anchor, //离心自化的锚点
stars: (
(name: "紫微", originalEvolve: "D", selfEvolve: ("D", "A"), evolve: "B", subtendEvolve: "C"),
), // 星辰
stage: "大官",
))```