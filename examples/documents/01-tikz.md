<!-- Собрано из apps/playground/examples/01-tikz.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: TikZ | теги: tex, latex, геометрия, графики, схемы, электрика, граф, стереометрия, транскрипция -->
# TikZ: рисунки на настоящем TeX

Компилируется в браузере (TeX Live 2025 в WebAssembly), кириллица работает, пакеты подключаются сами по командам.

Стрелка с подписью:

```tikz
\begin{tikzpicture}\draw[->] (0,0) -- (2,1) node[right] {$v$};\end{tikzpicture}
```

Русская подпись и формула:

```tikz
\begin{tikzpicture}\node[draw, rounded corners] {Русская подпись, $E=mc^2$};\end{tikzpicture}
```

Электрическая схема (circuitikz):

```tikz
\begin{circuitikz}
  \draw (0,0) to[battery1, l=$E$] (0,3) to[R=$R_1$] (3,3) to[C=$C$] (3,0) -- (0,0);
\end{circuitikz}
```

Школьная геометрия (tkz-euclide):

```tikz
\begin{tikzpicture}
  \tkzDefPoints{0/0/A,4/0/B,1/3/C}
  \tkzDrawPolygon(A,B,C)
  \tkzLabelPoints(A,B) \tkzLabelPoints[above](C)
\end{tikzpicture}
```

Площадь под кривой (pgfplots, fillbetween):

```tikz
\begin{tikzpicture}
  \begin{axis}[width=8cm, height=5cm]
    \addplot[name path=f, domain=0:3, thick] {x^2};
    \path[name path=ax] (axis cs:0,0) -- (axis cs:3,0);
    \addplot[blue!30] fill between[of=f and ax, soft clip={domain=1:2}];
  \end{axis}
\end{tikzpicture}
```

Раскладка графа (LuaTeX, graph drawing). Русские имена вершин — подписью: `имя/подпись`.

```tikz
\usegdlibrary{layered}
\begin{tikzpicture}\graph[layered layout, nodes={draw, rounded corners}]{a/трава -> {b/заяц, c/мышь} -> d/лиса};\end{tikzpicture}
```

Стереометрия (tikz-3dplot):

```tikz
\tdplotsetmaincoords{60}{110}
\begin{tikzpicture}[tdplot_main_coords, scale=2]
  \draw[->] (0,0,0) -- (1.3,0,0) node[anchor=north east] {$x$};
  \draw[->] (0,0,0) -- (0,1.3,0) node[anchor=north west] {$y$};
  \draw[->] (0,0,0) -- (0,0,1.3) node[anchor=south] {$z$};
  \draw[thick] (0,0,0) -- (1,0,0) -- (1,1,0) -- (0,1,0) -- cycle;
  \draw[thick] (0,0,1) -- (1,0,1) -- (1,1,1) -- (0,1,1) -- cycle;
  \foreach \p in {(0,0,0),(1,0,0),(1,1,0),(0,1,0)} \draw[thick] \p -- ++(0,0,1);
\end{tikzpicture}
```

Транскрипция (tipa): 

```tikz
\begin{tikzpicture}\node{cat \textipa{[k\ae t]} — кошка};\end{tikzpicture}
```
