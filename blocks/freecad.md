<!-- Собрано из packages/render/src/blocks/freecad/docs.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

# `freecad` — модель FreeCAD с параметрами

3D-модель из FreeCAD и таблица её параметров. Читатель меняет значения в полях под моделью и
нажимает «↻ пересчитать»: песочница открывает тот же документ FreeCAD, вписывает значения и
выгружает новую модель. Блок целиком даёт `cad_run`, если модель построена от таблицы параметров
(`block` в ответе):

```freecad
model: artifact:37824fa8d7b7f745/model.FCStd
result: artifact:37824fa8d7b7f745/model.stl
build: freecad-1.1.4
| Параметр | Значение | Что это |
|---|---|---|
| length | 120 mm | длина пластины |
| width | 60 mm | ширина |
| thick | =length / 20 | толщина (формула) |
| hole | 8 mm | радиус отверстия |
```

- `model:` — документ FreeCAD (`artifact:<id>/model.FCStd` из `cad_run`): из него пересчитывается
  модель. Остаётся тем же и после пересчёта — меняются значения в таблице.
- `result:` — модель для показа (`artifact:<id>/model.stl`); после пересчёта — новая строка.
- Таблица — параметры: имя (алиас ячейки в таблице FreeCAD), значение как в ячейке (число, можно с
  единицей: `120 mm`, `30 °`; или формула `=length / 20`), пояснение. Первая строка — шапка.
- `section`, `cut`, `hatch` — сечения и вырез, как у [`stl`](stl.md). Положение плоскости можно
  задать от параметров таблицы: `section А-А: x = length / 2` — сечение посередине при любой
  длине; `cut: z < thick / 2 slider` — вырез, который читатель двигает ползунком. Вырез из двух
  плоскостей: `cut: x < length / 2 & y < width / 2`.
- В строке забора — как у `stl`: ` ```freecad touch=views gyro=on ` (сенсорный экран), `build=`.

Модель показывается, как у `stl`: вращается, «⤢» — на весь экран, кнопки скачать FCStd, STEP и
сценарий. Под ней — поля параметров; изменённое поле подсвечено, Enter — пересчитать. Модель
посчитана с другими значениями, чем в таблице, — блок скажет, какими.

**Пересчёт без входа.** Пересчитать с другими параметрами может любой читатель, без ключа: это
пересчёт уже готового документа FreeCAD с сервера, а не свой код. Готовое из кеша — сразу. В
редакторе новые значения и строка `result:` попадают в текст документа; на странице документа —
показываются, документ не меняется.

**Как сделать модель с параметрами** (сценарий `cad_run`): таблица `Spreadsheet::Sheet`, у каждой
ячейки-параметра — **псевдоним** (`setAlias`), размеры — формулами от псевдонимов. Пояснение — в
ячейке слева от значения.

- Параметр — только ячейка с псевдонимом. Его имя в блоке и при пересчёте — псевдоним, адрес ячейки
  (`B1`) нигде не записывается: строки таблицы можно переставлять, параметры останутся теми же.
  Ячейка без псевдонима параметром не считается и в таблицу блока не попадает.
- Есть таблица с именем `Params` (или «Параметры») — параметры читателя берутся **только из неё**;
  промежуточные формулы с псевдонимами держите в другой таблице (`Calc`): формулы модели на них
  ссылаются, а в блок они не попадают и полем не меняются. Таблицы `Params` нет — параметры из всех.
- Параметр-текст (надпись, имя исполнения) меняется полем как текст. Числовой — только числом
  (можно с единицей): «abc» вместо 120 mm — ошибка.
- В формулах — только псевдоним: `Params.length`, а не `Params.B1`. Ссылку по адресу `cad_run`
  отметит в `warnings`: такой размер не пересчитать полем.

```python
import FreeCAD as App
doc = App.newDocument("Plate")
p = doc.addObject("Spreadsheet::Sheet", "Params")
p.set("A1", "длина пластины"); p.set("B1", "120 mm"); p.setAlias("B1", "length")
p.set("A2", "радиус отверстия"); p.set("B2", "8 mm"); p.setAlias("B2", "hole")
b = doc.addObject("Part::Box", "Plate")
b.setExpression("Length", "Params.length"); b.Width = 60; b.Height = 6
c = doc.addObject("Part::Cylinder", "Hole")
c.setExpression("Radius", "Params.hole"); c.Height = 10; c.Placement.Base.z = -2
c.setExpression(".Placement.Base.x", "Params.length / 2"); c.Placement.Base.y = 30
cut = doc.addObject("Part::Cut", "Result"); cut.Base = b; cut.Tool = c
doc.recompute()
```

**Надписи на детали** — гравировка, выпуклый текст, таблички, — `Draft.make_shapestring` и выдавливание.
Шрифты с кириллицей есть в песочнице: `font("имя", bold=False, italic=False)` даёт путь к файлу, `fonts()` —
список. Чертёжный ГОСТ 2.304 — `"GOST 2.304 Type A"` и `"GOST 2.304 Type B"`, прямой и наклонный (75° к
строке): `font("GOST 2.304 Type A", italic=True)`; прямой есть и под исходным именем `"OpenGost Type A TT"`
(OpenGOST, OFL-1.1; наклонный — производная от него). Ещё PT Sans,
PT Serif, PT Mono, Liberation Sans/Serif/Mono, DejaVu, Noto Sans/Serif, Linux Libertine и Biolinum, CMU,
FreeSans/FreeSerif, JetBrains Mono, Ubuntu, osifont. Шрифта нет — ошибка со списком.
`Size` у `make_shapestring` — высота прописной буквы в мм (замерено), а не кегль: размер шрифта по ГОСТ
2.304 (2,5; 3,5; 5; 7; 10; 14 мм) пишется как есть — `Size=5` даёт прописную 5 мм у любого шрифта.

```python
import FreeCAD as App, Draft
doc = App.newDocument("Sign")
plate = doc.addObject("Part::Box", "Plate"); plate.Length = 120; plate.Width = 30; plate.Height = 3
ss = Draft.make_shapestring(String="Шухов ГОСТ 2.304", FontFile=font("OpenGost Type A TT"), Size=7)
ss.Placement.Base = App.Vector(4, 4, 3)
doc.recompute()
ex = doc.addObject("Part::Extrusion", "Text"); ex.Base = ss; ex.Dir = App.Vector(0, 0, 1.2); ex.Solid = True
fu = doc.addObject("Part::MultiFuse", "Sign"); fu.Shapes = [plate, ex]
doc.recompute()
```

Гравировка вглубь — `Part::Cut` вместо `MultiFuse`. Размер и текст можно вынести в таблицу параметров:
`ss.setExpression("Size", "Params.text_h")`, текст — `ss.setExpression("String", "Params.label")`.

Пересчитать без документа — MCP-инструмент `cad_recompute`: `model` — ссылка на FCStd, `params` —
новые значения (`{"length": "200 mm"}`). Ошибка называет параметр: такого нет, не число, с такими
значениями модель не строится.
