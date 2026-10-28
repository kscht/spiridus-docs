<!-- Собрано автоматически из справки render_block_docs — правки в основном репозитории Spiridus. -->

# `tikz` — рисунки на TeX

Настоящий TeX Live 2025 в браузере (pdfTeX, для раскладки графов и Фейнмана — LuaTeX). Подходит
для геометрии, графиков функций, схем, химических структур, электрических цепей, деревьев.

Содержимое блока — тело документа без преамбулы: `\begin{tikzpicture} … \end{tikzpicture}` (или
`circuitikz`, `tikzcd`, `forest`, `axis` внутри `tikzpicture`). Перед окружением можно писать
`\usetikzlibrary{…}`, `\usepgfplotslibrary{…}`, `\usegdlibrary{…}`, `\tdplotsetmaincoords{…}`.

Пакеты подключаются сами, по командам: pgfplots, chemfig, mhchem, circuitikz, tikz-cd,
tikz-feynman, xlop, tikz-3dplot, tkz-euclide, algpseudocode, forest, pgf-pie, venndiagram,
karnaugh-map, pgfgantt, tikz-timing, siunitx, modiagram, bohr, colortbl, tipa, quantikz, yquant,
braket.

```tikz
\begin{tikzpicture}
  \begin{axis}[xlabel={$x$}, ylabel={$y$}, grid=major]
    \addplot[blue, thick, domain=-2:2] {x^2};
  \end{axis}
\end{tikzpicture}
```

- Кириллица работает в подписях и в тексте (кодировка T2A, шрифты ParaType).
- В раскладке графов (`\usegdlibrary`, LuaTeX) имена вершин — латиницей, русский текст — подписью:
  `a/трава -> b/заяц`, а не `трава -> заяц`.
- Не больше 16 КБ исходника. Ошибка TeX показывается текстом с номером и строкой, а не картинкой.
- Первый рисунок на странице ждёт загрузки движка (несколько секунд), следующие — быстрее.

Подключается само, по признаку в исходнике (писать `\usetikzlibrary`/`\usepackage` не нужно,
но можно): `arrows.meta` (`>=Stealth`, `-{Latex[length=3mm]}`), `calc` (`$(A)!0.5!(B)$`),
`positioning` (`right=of a`), `patterns` (`pattern=`), `angles` и `quotes` (`pic{angle=…}`),
`decorations.*` (`decoration={brace}`, `zigzag`, `markings`), `shapes.geometric`,
`intersections`; пакеты `pgfplots`, `circuitikz`, `chemfig`, `mhchem`, `tkz-euclide`,
`tikz-3dplot`, `forest`, `venndiagram`, `siunitx`, `xlop` (арифметика столбиком: `\opadd`,
`\opsub`, `\opmul`, `\opdiv`), `amsmath` (`\dfrac`, `\text`, `\binom`, `cases`, `pmatrix`).

Ловушки:
- Ударение над русской буквой — `\'{я}` со скобками (без скобок блок поставит их сам) или знак
  U+0301 после буквы.
- Диаметр — `$\varnothing$` или `\O`; градус — `$^\circ$`; русские единицы — текстом
  («0,5 моль/л»): `\pu{…}` из mhchem пишет единицы по-английски.
- `circuitikz [european]`: амперметр и вольтметр — `to[rmeter, t=A]` и `to[rmeter, t=V]`.
- chemfig: неподелённые пары — `\charge{90=\:,270=\:}{O}` (`\lewis` не собирается); изогнутые
  стрелки механизмов `\chemmove` пока не работают (нужен второй проход TeX).
- Цвет по длине волны `\definecolor{…}{wave}{500}` не поддерживается (модель hsb) — спектр
  градиентом из готовых цветов.
- Текст в рисунке мельче основного: подписи — `font=\small` и крупнее, рисунок — не шире 16 см.

## Квантовые схемы

Схема на кубитах — `quantikz` (вторая версия, стандарт статей): строка — кубит, столбцы через `&`,
строки через `\\`. Пакет подключается сам по `\begin{quantikz}`; `\ket{0}`, `\bra{}` — его же.

```tikz
\begin{quantikz}
\lstick{$\ket{0}$} & \gate{H} & \ctrl{1} & \meter{} \\
\lstick{$\ket{0}$} &          & \targ{}  & \meter{}
\end{quantikz}
```

- вентили: `\gate{H}`, `\gate[2]{U}` (на два кубита), `\phase{\theta}`, `\swap{1}` и `\targX{}`;
- управление: `\ctrl{1}` (на 1 строку ниже), `\octrl{1}` (по нулю), `\targ{}` — ⊕;
- измерение `\meter{}`; классический провод — `\setwiretype{c}` в ячейке **после** измерения
  (тип провода задаёт провод слева от своей ячейки), `\setwiretype{n}` — провода дальше нет;
  классическое управление — `\control{}\wire[d][2]{c}` (вниз на 2 строки); в одной ячейке
  `\control{}` — **до** `\setwiretype`: наоборот quantikz печатает «[phase=]» текстом;
- подписи: `\lstick{…}` слева, `\rstick{…}` справа, `\gategroup[2,steps=3]{подпись}` — рамка,
  `\slice{…}` — срез по времени.

Схема по программе — `yquant` (внутри само заворачивается в `tikzpicture`):
`qubit {$\ket{0}$} q[2]; h q[0]; cnot q[1] | q[0]; measure q;`. Обозначения Дирака в
подписях любых рисунков — `\ket{\psi}`, `\bra{\phi}`, `\braket{\phi|\psi}` (пакет braket).

## Построения циркулем и линейкой (tkz-euclide)

Точки пересечения считает TeX, а не автор. Числами задаются только свободные точки (`\tkzDefPoints`) и
раствор циркуля; производные точки — пересечениями. Не пишите `(2,2.236)` вместо точки пересечения: такое
число никто не проверяет, и чертёж расходится с построением. Пакет — tkz-euclide 5.13c, подключается сам
по любой команде `\tkz…`.

- Свободные точки: `\tkzDefPoints{0/0/A, 4/0/B}`, одна — `\tkzDefPoint(1,2){C}`.
- Окружность — центр и точка на ней: `(A,B)` — центр $A$, радиус $AB$. Раствор числом — опция `R`:
  `\tkzInterLC[R](A,B)(C,2.8)`; радиус, равный другому отрезку, — `with nodes`: `(O,E,F)` — центр $O$,
  радиус $EF$.
- Пересечения: `\tkzInterCC(O1,P1)(O2,P2)` — две окружности, `\tkzInterLC(A,B)(O,P)` — прямая $AB$ и
  окружность, `\tkzInterLL(A,B)(C,D)` — две прямые. Точки забирают сразу следующей командой:
  `\tkzGetPoints{P}{Q}`, `\tkzGetFirstPoint{P}`, `\tkzGetSecondPoint{Q}`, у `tkzInterLL` — `\tkzGetPoint{M}`.
- Какую из двух точек берёт имя:
  - `\tkzInterCC`: первая — слева от направления от первого центра ко второму. `(A,B)(B,A)` при $A$
    левее $B$ — первая над $AB$; поменяли центры местами — первая под $AB$.
  - `\tkzInterLC[near](A,B)(…)`: первая — ближе к $A$. Без `near` порядок от направления прямой не
    зависит: точку на нужном луче выбирайте через `near`.
  - `common=X` (у обеих команд): одна точка пересечения — уже известная $X$, `\tkzGetFirstPoint` даёт
    другую. Так продолжают цепочку засечек и берут второй конец диаметра.
- Окружности не пересекаются (раствор меньше половины расстояния между центрами) — `\tkzInterCC` **молча**
  даёт ложные точки, ошибки не будет; прямая не пересекает окружность — ошибка TeX «Missing number».
  Раствор выбирайте с запасом: радиус $AB$, а не «чуть больше половины».
- Рисование: `\tkzCompass[gray, delta=10](A,P)` — засечка (дуга окружности с центром $A$ через $P$, по
  10° в обе стороны); `\tkzDrawArc[gray](O,E)(F)` — дуга с центром $O$ от $E$ до $F$ против часовой стрелки
  (`delta=5` — с запасом); `\tkzDrawCircle(O,A)`, `\tkzDrawSegment(A,B)`, `\tkzDrawSegments(A,B C,D)`,
  `\tkzDrawLine[add=0.1 and 0.1](P,Q)` — прямая с запасом за точками, `\tkzDrawPolygon(A,B,C,D)`,
  `\tkzDrawPoints(A,B)`.
- Отметки: `\tkzMarkRightAngle(B,M,P)`, `\tkzMarkAngle[size=1, mark=|](A,O,K)`,
  `\tkzMarkSegments[mark=|](A,M M,B)`.
- Подписи: `\tkzLabelPoints[below right](B,M)` — несколько точек с одной стороны,
  `\tkzLabelPoint[above](P){$P'$}` — своим текстом. Сторону берите от линий, сходящихся в точке.
- Порядок: сначала все `\tkzDef…`, `\tkzInter…`, `\tkzGet…`, затем `\tkzDraw…`, `\tkzMark…`, `\tkzLabel…`.
  Построение (серые засечки) — `gray`, результат — `red, thick`.

Граница: здесь — статичный чертёж построения со списком шагов текстом. Нужны показ по шагам и проверка
построения блоком («$ABCD$ — квадрат») — это будущая нотация построений, а не `tikz`.

Шесть эталонных построений: свободные точки и раствор — числами, остальное — пересечениями.

### Серединный перпендикуляр

```tikz
\begin{tikzpicture}
  \tkzDefPoints{0/0/A, 4/0/B}
  \tkzInterCC(A,B)(B,A) \tkzGetPoints{P}{Q}
  \tkzInterLL(P,Q)(A,B) \tkzGetPoint{M}
  \tkzCompass[gray, delta=10](A,P) \tkzCompass[gray, delta=10](A,Q)
  \tkzCompass[gray, delta=10](B,P) \tkzCompass[gray, delta=10](B,Q)
  \tkzDrawSegment[thick](A,B)
  \tkzDrawLine[red, thick, add=0.1 and 0.1](P,Q)
  \tkzMarkRightAngle(B,M,P) \tkzMarkSegments[mark=|](A,M M,B)
  \tkzDrawPoints(A,B,P,Q) \tkzDrawPoints[red](M)
  \tkzLabelPoints[below left](A) \tkzLabelPoints[below right](B,M)
  \tkzLabelPoints[above left](P) \tkzLabelPoints[below left](Q)
\end{tikzpicture}
```

Окружности $(A, AB)$ и $(B, BA)$ пересекаются в $P$ и $Q$; прямая $PQ$ — серединный перпендикуляр, $M$ — середина $AB$.

### Перпендикуляр из точки к прямой

```tikz
\begin{tikzpicture}
  \tkzDefPoints{0/0/A, 6/0/B, 2.5/2/C}
  \tkzInterLC[R](A,B)(C,2.8) \tkzGetPoints{E}{F}
  \tkzInterCC[common=C](E,C)(F,C) \tkzGetFirstPoint{D}
  \tkzInterLL(C,D)(A,B) \tkzGetPoint{H}
  \tkzDrawLine[thick](A,B)
  \tkzCompass[gray, delta=10](C,E) \tkzCompass[gray, delta=10](C,F)
  \tkzCompass[gray, delta=8](E,D) \tkzCompass[gray, delta=8](F,D)
  \tkzDrawSegment[gray, dashed](H,D)
  \tkzDrawSegment[red, thick](C,H)
  \tkzMarkRightAngle(B,H,C)
  \tkzDrawPoints(A,B,C,D,E,F) \tkzDrawPoints[red](H)
  \tkzLabelPoints[above](A,B,C) \tkzLabelPoints[below](D)
  \tkzLabelPoints[below left](E) \tkzLabelPoints[below right](F,H)
\end{tikzpicture}
```

Окружность с центром $C$ (раствор больше расстояния до прямой) отсекает на $AB$ точки $E$, $F$; окружности $(E, EC)$ и $(F, FC)$ пересекаются в $C$ и $D$; $CD \perp AB$, $H$ — основание.

### Биссектриса угла

```tikz
\begin{tikzpicture}
  \tkzDefPoints{0/0/O, 5/0/A, 3/4/B}
  \tkzInterLC[R, near](A,O)(O,2) \tkzGetFirstPoint{E}
  \tkzInterLC[R, near](B,O)(O,2) \tkzGetFirstPoint{F}
  \tkzInterCC[common=O](E,O)(F,O) \tkzGetFirstPoint{K}
  \tkzDrawSegments[thick](O,A O,B)
  \tkzDrawArc[gray](O,E)(F)
  \tkzCompass[gray, delta=12](E,K) \tkzCompass[gray, delta=12](F,K)
  \tkzDrawLine[red, thick, add=0 and 0.6](O,K)
  \tkzMarkAngle[size=1.1, mark=|](A,O,K) \tkzMarkAngle[size=1.1, mark=|](K,O,B)
  \tkzDrawPoints(O,A,B,E,F,K)
  \tkzLabelPoints[below](O,A,E) \tkzLabelPoints[above left](B,F) \tkzLabelPoints[above right](K)
\end{tikzpicture}
```

Окружность с центром $O$ отсекает на сторонах $E$ и $F$ (`near` — точка на луче, а не за вершиной); окружности $(E, EO)$ и $(F, FO)$ — вторая точка $K$ (`common=O`); луч $OK$ — биссектриса.

### Перенос угла

```tikz
\begin{tikzpicture}
  \tkzDefPoints{0/0/A, 2.8/0/B, 1.6/1.9/C, 4/0/O, 7/0/M}
  \tkzInterLC[R, near](B,A)(A,1.5) \tkzGetFirstPoint{E}
  \tkzInterLC[R, near](C,A)(A,1.5) \tkzGetFirstPoint{F}
  \tkzInterLC[R, near](M,O)(O,1.5) \tkzGetFirstPoint{G}
  \tkzInterCC[with nodes](O,A,E)(G,E,F) \tkzGetFirstPoint{N}
  \tkzDrawSegments[thick](A,B A,C O,M)
  \tkzDrawArc[gray](A,E)(F) \tkzDrawArc[gray, delta=5](O,G)(N)
  \tkzCompass[gray, delta=15](G,N)
  \tkzDrawLine[red, thick, add=0 and 0.5](O,N)
  \tkzMarkAngle[size=0.8](B,A,C) \tkzMarkAngle[size=0.8](M,O,N)
  \tkzDrawPoints(A,B,C,O,M,E,F,G,N)
  \tkzLabelPoints[below](A,B,O,M,E,G) \tkzLabelPoints[above left](C,F,N)
\end{tikzpicture}
```

Тем же раствором — дуги из $A$ ($E$, $F$) и из $O$ ($G$ на луче $OM$); окружность $(G, EF)$ пересекает окружность $(O, AE)$ в $N$ (`with nodes`: центр, затем отрезок-радиус); $\angle MON = \angle BAC$. Из двух точек первая — слева от $O \to G$, то есть над лучом.

### Квадрат по стороне

```tikz
\begin{tikzpicture}
  \tkzDefPoints{0/0/A, 2.5/0/B}
  \tkzInterLC[common=B](A,B)(A,B) \tkzGetFirstPoint{E}
  \tkzInterCC(E,B)(B,E) \tkzGetFirstPoint{P}
  \tkzInterLC[near](P,A)(A,B) \tkzGetFirstPoint{D}
  \tkzInterCC[common=A](B,A)(D,A) \tkzGetFirstPoint{C}
  \tkzDrawLine[gray, add=0.1 and 0.1](E,B)
  \tkzDrawArc[gray, delta=5](A,B)(E)
  \tkzCompass[gray, delta=8](E,P) \tkzCompass[gray, delta=8](B,P)
  \tkzDrawLine[gray, add=0 and 0.1](A,P)
  \tkzCompass[gray, delta=12](B,C) \tkzCompass[gray, delta=12](D,C)
  \tkzDrawPolygon[red, thick](A,B,C,D)
  \tkzMarkRightAngle(B,A,D)
  \tkzDrawPoints(A,B,C,D,E,P)
  \tkzLabelPoints[below](E,A,B) \tkzLabelPoints[above left](D,P) \tkzLabelPoints[above right](C)
\end{tikzpicture}
```

Окружность $(A, AB)$ на прямой $AB$ — вторая точка $E$; серединный перпендикуляр к $EB$ проходит через $A$ ($P$ — первая точка, над прямой); на нём $D$ (`near` к $P$); окружности $(B, BA)$ и $(D, DA)$ — вторая точка $C$.

### Правильный шестиугольник

```tikz
\begin{tikzpicture}
  \tkzDefPoints{0/0/O, 2.5/0/A}
  \tkzInterCC(O,A)(A,O) \tkzGetPoints{B}{F}
  \tkzInterCC[common=A](O,A)(B,O) \tkzGetFirstPoint{C}
  \tkzInterCC[common=B](O,A)(C,O) \tkzGetFirstPoint{D}
  \tkzInterCC[common=C](O,A)(D,O) \tkzGetFirstPoint{E}
  \tkzDrawCircle[gray](O,A)
  \tkzCompass[gray, delta=8](A,B) \tkzCompass[gray, delta=8](A,F)
  \tkzCompass[gray, delta=8](B,C) \tkzCompass[gray, delta=8](C,D) \tkzCompass[gray, delta=8](D,E)
  \tkzDrawPolygon[red, thick](A,B,C,D,E,F)
  \tkzDrawPoints(O,A,B,C,D,E,F)
  \tkzLabelPoints[right](A) \tkzLabelPoints[above right](B) \tkzLabelPoints[above left](C)
  \tkzLabelPoints[left](D) \tkzLabelPoints[below left](E) \tkzLabelPoints[below right](F,O)
\end{tikzpicture}
```

Сторона равна радиусу: окружности $(A, AO)$, $(B, BO)$, $(C, CO)$, $(D, DO)$ по очереди отсекают на окружности $(O, OA)$ следующую вершину (`common=` — предыдущую вершину отбросить).

## Как чинить замечания `render_check`

`render_check` смотрит внутрь рисунка: `label-crossed` — линия через подпись, `label-tight` — линия касается подписи, `label-overlap` — подписи налезают, `label-outside` — подпись шире своей фигуры, `label-small` — после ужатия под колонку мельче 9 точек. В замечании — текст подписи, а в ответе — вырез места (`label-<строка>-<n>.png`).

- `label-crossed` — подпись узла на линии: `node[above]`, `[below right]`, `xshift`/`yshift`, `fill=white` у подписи (подложка закроет линию), больше `node distance`.
- `label-overlap` — подписи соседних точек: разведите `anchor`, увеличьте масштаб рисунка (`scale=1.5`) вместе с `transform shape` только если шрифт не станет крупнее нужного.
