<!-- Собрано из apps/playground/examples/11-freecad.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: 3D | теги: freecad, cad, деталь, stl, step, скругление, фаска, кронштейн, фланец, mcp -->
# Детали из FreeCAD

Модели собраны сценарием FreeCAD 1.1 в песочнице на сервере через MCP-инструмент `cad_run`. Он возвращает STL для просмотра, STEP для CAD и сводку: объём, габариты, валидность. В документ модель попадает одной строкой `artifact:<id>/model.stl`.

В отличие от OpenSCAD, FreeCAD строит точную геометрию (BREP): скругления и фаски на рёбрах, вращение профиля, честный STEP.

## Уголок-кронштейн

40 × 30 × 30 мм, толщина 4 мм. Внутренний угол скруглён R5, верх стенки — фаска 1 мм, в полке и в стенке по два отверстия Ø5,5 под M5. Объём — 8752 мм³.

```stl
file: artifact:354b4e72030919c4/model.stl
build: freecad-1.1.4
```

Строка `build:` записывает сборку песочницы, в которой модель посчитана; под моделью — чем посчитано (см. справку «Сборки песочниц»).

```python
import FreeCAD as App, Part
# уголок-кронштейн 40×30×30, толщина 4, скругление внутреннего угла R5,
# фаска 1 по верху стенки, по два отверстия Ø5,5 под M5 в полке и в стенке
near = lambda a, b: abs(a - b) < 1e-6
body = Part.makeBox(40, 30, 4).fuse(Part.makeBox(40, 4, 30)).removeSplitter()
inner = [e for e in body.Edges if all(near(v, 4) for v in (e.BoundBox.YMin, e.BoundBox.YMax, e.BoundBox.ZMin, e.BoundBox.ZMax))]
assert len(inner) == 1, len(inner)
body = body.makeFillet(5, inner)
top = [e for e in body.Edges if near(e.BoundBox.ZMin, 30) and near(e.BoundBox.ZMax, 30)]
body = body.makeChamfer(1, top)
for x in (10, 30):
    body = body.cut(Part.makeCylinder(2.75, 10, App.Vector(x, 19, -1)))
    body = body.cut(Part.makeCylinder(2.75, 10, App.Vector(x, -1, 19), App.Vector(0, 1, 0)))
assert body.isValid()
Part.show(body, "Bracket")
```

## Фланец

Профиль вращается вокруг оси: диск Ø60 × 6 со ступицей Ø30 × 16, отверстие под вал Ø12, шесть отверстий Ø6 по окружности Ø46, скругление R2 у ступицы. Объём — 21 289 мм³.

```stl
artifact:8d2da09aed8809c6/model.stl
```

```python
import FreeCAD as App, Part, math
# фланец: профиль вращается вокруг оси Z — диск Ø60×6 со ступицей Ø30×16,
# отверстие под вал Ø12, шесть отверстий Ø6 по окружности Ø46, скругление R2 у ступицы
V = App.Vector
pts = [V(6, 0, 0), V(30, 0, 0), V(30, 0, 6), V(15, 0, 6), V(15, 0, 16), V(6, 0, 16), V(6, 0, 0)]
body = Part.Face(Part.makePolygon(pts)).revolve(V(0, 0, 0), V(0, 0, 1), 360)
body = Part.Solid(body) if body.ShapeType != "Solid" else body
near = lambda a, b: abs(a - b) < 1e-6
root = [e for e in body.Edges if near(e.BoundBox.ZMin, 6) and near(e.BoundBox.ZMax, 6) and near(e.BoundBox.XMax, 15)]
body = body.makeFillet(2, root)
for k in range(6):
    a = math.radians(60 * k)
    body = body.cut(Part.makeCylinder(3, 10, V(23 * math.cos(a), 23 * math.sin(a), -2)))
assert body.isValid()
Part.show(body, "Flange")
```

## Цилиндр с пазом

Самый первый результат `cad_run`: цилиндр R10 × 30 минус брусок 8 × 8 × 40.

```stl
artifact:08e4d5eeee8e3c5d/model.stl
```

## Сборка не совпала

Если в блоке записана одна сборка, а результат посчитан в другой, блок предупреждает:

```stl
file: artifact:354b4e72030919c4/model.stl
build: freecad-1.0.0
```
