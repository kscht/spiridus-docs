<!-- Собрано из apps/playground/examples/00-overview.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: Основы | теги: обзор, markdown, формулы, таблица -->
# Обзор: всё вместе

Обычный **Markdown** — заголовки, списки, таблицы, `код`, ссылки — и наглядные блоки, которые пишутся текстом и рисуются у читателя.

Формула по KaTeX: $E = mc^2$, а отдельной строкой —

$$\int_0^1 x^2\,dx = \frac{1}{3}$$

Химия формулой: $\ce{2H2 + O2 -> 2H2O}$.

| Блок | Что рисует |
|---|---|
| `tikz` | рисунки и графики на TeX |
| `echarts` | диаграммы, схемы-контуры, карты |
| `smiles`, `mol3d` | молекулы плоско и в 3D |
| `abc` | ноты с проигрыванием |
| `razbor` | разбор слова и предложения |
| `svg` | произвольный рисунок |

```tikz
\begin{tikzpicture}
  \begin{axis}[xlabel={$x$}, ylabel={$y$}, grid=major, width=8cm, height=5cm]
    \addplot[blue, thick, domain=-2:2] {x^2};
    \addplot[red, thick, domain=-2:2] {2*x - 1};
  \end{axis}
\end{tikzpicture}
```

```echarts
{"width":520,"height":300,"title":{"text":"Осадки, мм","left":"center"},
 "xAxis":{"type":"category","data":["янв","фев","мар","апр","май","июн"]},"yAxis":{},
 "series":[{"type":"bar","data":[53,44,39,37,61,77]}]}
```

```mol3d
C1=CC=CC=C1
```

- [x] список задач
- [ ] ещё не сделано
