<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

# Lean: виджеты ProofWidgets и Penrose

Коммутативный квадрат проверен как `CategoryTheory.CommSq` Mathlib.
Во второй диаграмме изображена функция над парой натуральных чисел.
Клик по фигуре выделяет её; при печати остаётся статичный рисунок.

## Коммутативный квадрат

```lean build=lean-4.34.0-widgets
-- result: artifact:b0ea20a8c599ea13/result.json
-- build: lean-4.34.0-widgets
import ProofWidgets.Component.HtmlDisplay
import ProofWidgets.Component.PenroseDiagram
import Mathlib.CategoryTheory.CommSq
import Mathlib.CategoryTheory.Types.Basic
open CategoryTheory
example : CommSq (𝟙 (Nat : Type)) (𝟙 _) (𝟙 _) (𝟙 _) := ⟨rfl⟩

open ProofWidgets
#html Html.ofComponent Penrose.Diagram {
  dsl := "type Obj"
  sty := r#"canvas {
 width = 320
 height = 240
}
forall Obj x {
 x.textBox = Rectangle {
 center:(0,0)
 width:40
 height:28
 fillColor:rgba(1,1,1,1)
 strokeWidth:0
 }
}
forall Obj `a` { override `a`.textBox.center = (-100,75) }
forall Obj `b` { override `b`.textBox.center = (100,75) }
forall Obj `c` { override `c`.textBox.center = (-100,-75) }
forall Obj `d` { override `d`.textBox.center = (100,-75) }
arrows {
 a0 = Line { start:(-75,75)
 end:(75,75)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
 a1 = Line { start:(-100,50)
 end:(-100,-50)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
 a2 = Line { start:(100,50)
 end:(100,-50)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
 a3 = Line { start:(-75,-75)
 end:(75,-75)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
}
"#
  sub := "Obj a, b, c, d"
  embeds := #[("a", Html.text "ℕ"), ("b", Html.text "ℕ"), ("c", Html.text "ℕ"), ("d", Html.text "ℕ")]
  maxOptSteps := 100
} #[]
```

## Строковая диаграмма

```lean build=lean-4.34.0-widgets
-- result: artifact:e04c47d3b464f9c8/result.json
-- build: lean-4.34.0-widgets
import ProofWidgets.Component.HtmlDisplay
import ProofWidgets.Component.PenroseDiagram
def tensorStep (p : Nat × Nat) := (p.1 + 1, p.2 + 1)
example : tensorStep (2, 3) = (3, 4) := rfl

open ProofWidgets
#html Html.ofComponent Penrose.Diagram {
  dsl := "type Obj"
  sty := r#"canvas {
 width = 320
 height = 240
}
forall Obj x {
 x.textBox = Rectangle {
 center:(0,0)
 width:40
 height:28
 fillColor:rgba(1,1,1,1)
 strokeWidth:0
 }
}
forall Obj `a` { override `a`.textBox.center = (-80,80) }
forall Obj `b` { override `b`.textBox.center = (80,80) }
forall Obj `c` { override `c`.textBox.center = (-80,-80) }
forall Obj `d` { override `d`.textBox.center = (80,-80) }
arrows {
 a0 = Line { start:(-80,60)
 end:(-80,18)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
 a1 = Line { start:(80,60)
 end:(80,18)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
 a2 = Line { start:(-80,-18)
 end:(-80,-60)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
 a3 = Line { start:(80,-18)
 end:(80,-60)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
}
operation {
 box = Rectangle {
 center:(0,0)
 width:230
 height:30
 fillColor:rgba(0.9,0.95,1,1)
 strokeColor:rgba(0.2,0.3,0.5,1)
 strokeWidth:1
}
 label = Text {
 center:(0,0)
 string:"succ ⊗ succ"
 fontSize:"16px"
 fillColor:rgba(0,0,0,1)
}
}"#
  sub := "Obj a, b, c, d"
  embeds := #[("a", Html.text "ℕ"), ("b", Html.text "ℕ"), ("c", Html.text "ℕ"), ("d", Html.text "ℕ")]
  maxOptSteps := 100
} #[]
```

