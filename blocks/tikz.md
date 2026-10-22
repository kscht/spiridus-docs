<!-- Собрано из notations/tikz/docs.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

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

## Как чинить замечания `render_check`

`render_check` смотрит внутрь рисунка: `label-crossed` — линия через подпись, `label-tight` — линия касается подписи, `label-overlap` — подписи налезают, `label-outside` — подпись шире своей фигуры, `label-small` — после ужатия под колонку мельче 9 точек. В замечании — текст подписи, а в ответе — вырез места (`label-<строка>-<n>.png`).

- `label-crossed` — подпись узла на линии: `node[above]`, `[below right]`, `xshift`/`yshift`, `fill=white` у подписи (подложка закроет линию), больше `node distance`.
- `label-overlap` — подписи соседних точек: разведите `anchor`, увеличьте масштаб рисунка (`scale=1.5`) вместе с `transform shape` только если шрифт не станет крупнее нужного.
