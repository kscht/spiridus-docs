<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Школа | теги: физика, астрономия, 7 класс, 8 класс, 9 класс, 10 класс, 11 класс, механика, термодинамика, электричество, оптика, атом, ядро, орбита, звёзды, проверка -->
# Физика и астрономия: 7–11 класс

Типичные рисунки учебника и задачника по разделам школьного курса: графики движения, силы на теле, схемы цепей, ход лучей, графики процессов, уровни энергии, орбиты и звёзды. Всё собрано из блоков рендера — TikZ (pgfplots, circuitikz), формул KaTeX, диаграмм ECharts и расчётов Modelica.

## Механика

### Графики равноускоренного движения

Три тела: 1 — разгоняется с $a = 1$ м/с², 2 — движется равномерно, 3 — тормозит с $a = -2$ м/с². Площадь под графиком скорости — перемещение.

```tikz
\begin{tikzpicture}
  \begin{axis}[name=v, width=9cm, height=5.5cm, grid=major, xmin=0, xmax=6, ymin=-6, ymax=8,
      ylabel={$v_x$, м/с}, xticklabels={}, legend pos=south west, legend style={font=\small}]
    \addplot[fill=blue!15, draw=none, domain=0:4, forget plot] {2+x} \closedcycle;
    \addplot[blue, thick, domain=0:6] {2+x};
    \addplot[red, thick, domain=0:6] {4};
    \addplot[green!50!black, thick, domain=0:6] {6-2*x};
    \legend{1: $v=2+t$, 2: $v=4$, 3: $v=6-2t$}
    \node at (axis cs:2,1.5) {$s_1$};
  \end{axis}
  \begin{axis}[at={(v.south)}, anchor=north, yshift=-0.3cm, width=9cm, height=5.5cm, grid=major,
      xmin=0, xmax=6, ymin=-5, ymax=32, xlabel={$t$, с}, ylabel={$x$, м}]
    \addplot[blue, thick, domain=0:6] {2*x + x^2/2};
    \addplot[red, thick, domain=0:6] {4*x};
    \addplot[green!50!black, thick, domain=0:6] {6*x - x^2};
  \end{axis}
\end{tikzpicture}
```

$$
v_x = v_{0x} + a_x t, \qquad x = x_0 + v_{0x} t + \frac{a_x t^2}{2}, \qquad v_x^2 - v_{0x}^2 = 2 a_x s_x
$$

### Силы на теле: брусок на наклонной плоскости

```tikz
\begin{tikzpicture}[>=stealth]
  \draw[fill=gray!15] (0,0) -- (7,0) -- (7,{7*tan(30)}) -- cycle;
  \draw (1.4,0) arc (0:30:1.4);
  \node at (1.75,0.4) {$\alpha$};
  \begin{scope}[shift={(4,{4*tan(30)})}, rotate=30]
    \draw[fill=orange!30] (-0.7,0) rectangle (0.7,0.9);
    \coordinate (C) at (0,0.45);
    \draw[->, dashed, gray] (C) -- (2.6,0.45) node[right] {$x$};
    \draw[->, dashed, gray] (C) -- (0,2.6) node[above] {$y$};
    \draw[->, very thick, blue] (0,0) -- (0,1.73) node[left] {$\vec N$};
    \draw[->, very thick, green!50!black] (0,0) -- (1.0,0) node[below right] {$\vec F_{\mbox{\scriptsize тр}}$};
    \draw[->, very thick, red] (C) -- ++(-120:2) node[below] {$m\vec g$};
    \fill (C) circle (1.5pt);
  \end{scope}
\end{tikzpicture}
```

$$
Ox:\; F_{\text{тр}} - mg\sin\alpha = ma, \qquad Oy:\; N - mg\cos\alpha = 0, \qquad F_{\text{тр}} \le \mu N
$$

### Блоки

```tikz
\begin{tikzpicture}[>=stealth]
  % неподвижный блок
  \fill[gray!40] (-1.3,4) rectangle (1.3,4.25);
  \draw (0,4) -- (0,3);
  \draw (-0.5,3) -- (-0.5,1.2);
  \draw (0.5,3) -- (0.5,1.8);
  \draw[thick, fill=gray!15] (0,3) circle (0.5);
  \fill (0,3) circle (1.5pt);
  \draw[fill=blue!20] (-0.85,0.5) rectangle (-0.15,1.2);
  \node at (-0.5,0.85) {$m_1$};
  \draw[fill=red!20] (0.1,0.8) rectangle (0.9,1.8);
  \node at (0.5,1.3) {$m_2$};
  \draw[->, thick, blue] (-0.5,1.2) -- (-0.5,2.1) node[left] {$\vec T$};
  \draw[->, thick, blue] (0.5,1.8) -- (0.5,2.7) node[right] {$\vec T$};
  \draw[->, thick, red] (-0.5,0.5) -- (-0.5,-0.3) node[left] {$m_1\vec g$};
  \draw[->, thick, red] (0.5,0.8) -- (0.5,-0.4) node[right] {$m_2\vec g$};
  \draw[->, thick, green!50!black] (-1.2,0.5) -- (-1.2,1.2) node[left] {$\vec a$};
  \draw[->, thick, green!50!black] (1.3,1.8) -- (1.3,1.1) node[right] {$\vec a$};
  \node[align=center, font=\small] at (0,-1.1) {неподвижный блок:\\выигрыша в силе нет};
  % подвижный блок
  \fill[gray!40] (4.4,4) rectangle (5.6,4.25);
  \draw (5,4) -- (5,1.5);
  \draw (6,1.5) -- (6,2.9);
  \draw[thick, fill=gray!15] (5.5,1.5) circle (0.5);
  \fill (5.5,1.5) circle (1.5pt);
  \draw (5.5,1.5) -- (5.5,0.8);
  \draw[fill=red!20] (5,0.2) rectangle (6,0.8);
  \node at (5.5,0.5) {$P$};
  \draw[->, very thick, blue] (6,2.9) -- (6,3.8) node[right] {$\vec F$};
  \node[align=center, font=\small] at (5.5,-1.1) {подвижный блок:\\$F = P/2$};
\end{tikzpicture}
```

### Тело, брошенное под углом к горизонту

Начальная скорость 15 м/с под углом 45°. Синий — без сопротивления воздуха (парабола, дальность $v_0^2 \sin 2\alpha / g \approx 23$ м), рыжий — с сопротивлением, пропорциональным квадрату скорости.

```modelica
// result: artifact:6fc8a785361099e8/result.csv
// build: openmodelica-1.27.1
// animate: line -1,0 24,0 color=#1c1f26 | земля
// animate: trace x=x0 y=y0 color=#2f6fb3
// animate: circle x=x0 y=y0 r=0.4 color=#2f6fb3
// animate: trace x=x y=y color=#c05621
// animate: circle x=x y=y r=0.4 color=#c05621
// plot: y0, y
// plot: v
model Projectile "Тело, брошенное под углом к горизонту: без сопротивления и с сопротивлением воздуха"
  parameter Real g = 9.81 "ускорение свободного падения, м/с²";
  parameter Real v0 = 15 "начальная скорость, м/с";
  parameter Real alpha = 45 * Modelica.Constants.pi / 180 "угол броска, рад";
  parameter Real k = 0.04 "сопротивление воздуха на единицу массы, 1/м";
  parameter Real T0 = 2 * v0 * sin(alpha) / g "время полёта без сопротивления, с";
  Real x0 = v0 * cos(alpha) * min(time, T0) "без сопротивления: x, м";
  Real y0 = v0 * sin(alpha) * min(time, T0) - g * min(time, T0)^2 / 2 "без сопротивления: y, м";
  Real x(start = 0, fixed = true) "с сопротивлением: x, м";
  Real y(start = 0, fixed = true) "с сопротивлением: y, м";
  Real vx(start = v0 * cos(alpha), fixed = true);
  Real vy(start = v0 * sin(alpha), fixed = true);
  Real v = sqrt(vx^2 + vy^2) "модуль скорости, м/с";
  Boolean landed(start = false, fixed = true);
equation
  der(x) = if landed then 0 else vx;
  der(y) = if landed then 0 else vy;
  der(vx) = if landed then 0 else -k * v * vx;
  der(vy) = if landed then 0 else -g - k * v * vy;
  when y < 0 and time > 0.1 then
    landed = true;
  end when;
  annotation(experiment(StopTime = 2.5));
end Projectile;
```

### Законы сохранения

$$
\begin{aligned}
&m_1\vec v_1 + m_2\vec v_2 = m_1\vec v_1\,' + m_2\vec v_2\,' &&\text{импульс}\\
&\frac{mv^2}{2} + mgh + \frac{kx^2}{2} = \text{const} &&\text{механическая энергия}\\
&A = Fs\cos\alpha, \quad N = \frac{A}{t} &&\text{работа и мощность}
\end{aligned}
$$

### Механическая волна

```tikz
\begin{tikzpicture}[>=stealth]
  \begin{axis}[width=11cm, height=4.8cm, axis lines=middle, xmin=0, xmax=8.8, ymin=-3, ymax=3.8,
      xlabel={$x$, м}, ylabel={$y$, см}, xtick={2,4,6,8}, ytick={-2,2}]
    \addplot[blue, thick, domain=0:8, samples=200] {2*sin(deg(2*pi*x/4))};
    \draw[<->] (axis cs:1,3) -- (axis cs:5,3) node[midway, above] {$\lambda$};
    \draw[dashed] (axis cs:1,0) -- (axis cs:1,3);
    \draw[dashed] (axis cs:5,0) -- (axis cs:5,3);
    \draw[<->, red] (axis cs:3,0) -- (axis cs:3,-2) node[midway, right] {$A$};
    \draw[->, very thick] (axis cs:6.6,2.6) -- (axis cs:7.8,2.6) node[midway, above] {$\vec v$};
  \end{axis}
\end{tikzpicture}
```

$$
v = \lambda \nu = \frac{\lambda}{T}, \qquad T = 2\pi\sqrt{\frac{l}{g}}, \qquad T = 2\pi\sqrt{\frac{m}{k}}
$$

## Молекулярная физика и термодинамика

### График нагревания и плавления льда

```tikz
\begin{tikzpicture}
  \begin{axis}[width=11cm, height=6cm, grid=major, xmin=0, xmax=26, ymin=-30, ymax=120,
      xlabel={$\tau$, мин}, ylabel={$t$, $^\circ$C}, ytick={-20,0,20,...,100}]
    \addplot[very thick, blue] coordinates {(0,-20) (2,0) (8,0) (16,100) (24,100)};
    \node[font=\small, anchor=south] at (axis cs:5,2) {плавление};
    \node[font=\small, anchor=south] at (axis cs:20,102) {кипение};
    \node[font=\small, rotate=40] at (axis cs:13.3,58) {нагрев воды};
    \node[font=\small, anchor=west] at (axis cs:1.6,-14) {нагрев льда};
  \end{axis}
\end{tikzpicture}
```

$$
Q = cm\Delta t, \qquad Q = \lambda m, \qquad Q = Lm, \qquad Q = qm
$$

### Изотермы идеального газа

```tikz
\begin{tikzpicture}
  \begin{axis}[width=9cm, height=6cm, xmin=0, xmax=6.5, ymin=0, ymax=7, axis lines=left,
      xlabel={$V$}, ylabel={$p$}, xtick=\empty, ytick=\empty, legend style={font=\small}]
    \addplot[blue, thick, domain=0.6:6, samples=80] {3/x};
    \addplot[violet, thick, domain=0.9:6, samples=80] {6/x};
    \addplot[red, thick, domain=1.4:6, samples=80] {9/x};
    \node[blue, font=\small] at (axis cs:6.2,0.5) {$T_1$};
    \node[violet, font=\small] at (axis cs:6.2,1.0) {$T_2$};
    \node[red, font=\small] at (axis cs:6.2,1.5) {$T_3$};
  \end{axis}
\end{tikzpicture}
```

$$
pV = \nu RT, \qquad p = \frac{1}{3} m_0 n \overline{v^2}, \qquad \bar E_k = \frac{3}{2}kT
$$

### Цикл Карно

Нагреватель 1→2 (изотерма $T_1$), адиабата 2→3, холодильник 3→4 (изотерма $T_2$), адиабата 4→1. Площадь внутри цикла — работа газа за цикл.

```tikz
\usetikzlibrary{decorations.markings}
\begin{tikzpicture}[
    fwd/.style={postaction={decorate}, decoration={markings, mark=at position 0.55 with {\arrow{>}}}},
    back/.style={postaction={decorate}, decoration={markings, mark=at position 0.55 with {\arrow{<}}}}]
  \begin{axis}[width=10cm, height=7cm, xmin=0, xmax=4.6, ymin=0, ymax=4.6, axis lines=left,
      xlabel={$V$}, ylabel={$p$}, xtick={1,2,4}, ytick=\empty]
    \addplot[red, very thick, domain=1:2, fwd] {4/x};
    \addplot[black, thick, domain=2:4, fwd] {5.278/x^1.4};
    \addplot[blue, very thick, domain=2:4, back] {3.031/x};
    \addplot[black, thick, domain=1:2, back] {4/x^1.4};
    \node[above right] at (axis cs:1,4) {1};
    \node[above right] at (axis cs:2,2) {2};
    \node[above right] at (axis cs:4,0.758) {3};
    \node[below left] at (axis cs:2,1.516) {4};
    \node[red] at (axis cs:1.75,3.1) {$T_1$};
    \node[blue] at (axis cs:3.2,0.6) {$T_2$};
  \end{axis}
\end{tikzpicture}
```

$$
\Delta U = Q - A, \qquad \eta = \frac{Q_1 - Q_2}{Q_1}, \qquad \eta_{\max} = 1 - \frac{T_2}{T_1}
$$

## Электродинамика

### Электрическая цепь со смешанным соединением

```tikz
\begin{circuitikz}
  \draw (0,0) to[battery1, l=$\mathcal{E}$] (0,3) to[nos, l=$K$] (2.5,3)
    to[R, l_=$R_1$, *-*] (5,3);
  \draw (5,3) -- (5,4) to[R, l=$R_2$] (8,4) -- (8,3);
  \draw (5,3) -- (5,2) to[R, l=$R_3$] (8,2) -- (8,3);
  \draw (8,3) to[short, *-] (9.5,3) to[rmeter, t=A] (9.5,0) -- (0,0);
  \draw (2.5,3) -- (2.5,5.2) to[rmeter, t=V] (5,5.2) to[short, -*] (5,4);
\end{circuitikz}
```

$$
I = \frac{U}{R}, \qquad R_{\text{посл}} = R_1 + R_2, \qquad \frac{1}{R_{\text{пар}}} = \frac{1}{R_2} + \frac{1}{R_3}, \qquad I = \frac{\mathcal{E}}{R + r}
$$

### Вольт-амперные характеристики

```echarts
{"width":560,"height":340,
 "title":{"text":"I(U): резистор, лампа накаливания, диод","left":"center","textStyle":{"fontSize":14}},
 "legend":{"top":36},
 "grid":{"left":60,"right":24,"top":70,"bottom":50},
 "tooltip":{"trigger":"axis"},
 "xAxis":{"type":"value","name":"U, В","nameLocation":"middle","nameGap":28,"min":0,"max":10},
 "yAxis":{"type":"value","name":"I, А","max":1.2},
 "series":[
  {"name":"резистор 10 Ом","type":"line","showSymbol":false,"data":[[0,0],[10,1]]},
  {"name":"лампа","type":"line","smooth":true,"showSymbol":false,
   "data":[[0,0],[0.5,0.12],[1,0.2],[2,0.3],[3,0.38],[4,0.44],[6,0.54],[8,0.62],[10,0.69]]},
  {"name":"диод (прямое включение)","type":"line","smooth":true,"showSymbol":false,
   "data":[[0,0],[0.4,0.002],[0.55,0.02],[0.65,0.1],[0.72,0.35],[0.77,0.7],[0.8,1.0],[0.82,1.2]]}
 ]}
```

### Силовые линии электрического поля

Слева — поле двух разноимённых зарядов, справа — однородное поле плоского конденсатора.

```tikz
\usetikzlibrary{decorations.markings}
\begin{tikzpicture}[>=stealth,
    fl/.style={blue!70!black, postaction={decorate}, decoration={markings, mark=at position 0.5 with {\arrow{>}}}}]
  \foreach \a in {20,40,60,80} {
    \draw[fl] (-1.5,0) to[out=\a, in=180-\a] (1.5,0);
    \draw[fl] (-1.5,0) to[out=-\a, in=180+\a] (1.5,0);
  }
  \draw[fl] (-1.5,0) -- (1.5,0);
  \foreach \a in {130,160,180,200,230} \draw[fl] (-1.5,0) -- ++(\a:1.3);
  \foreach \a in {-50,-20,0,20,50} \draw[fl] (1.5,0) ++(\a:1.3) -- (1.5,0);
  \draw[fill=red!70] (-1.5,0) circle (0.25) node[white] {\textbf{+}};
  \draw[fill=blue!70] (1.5,0) circle (0.25) node[white] {\textbf{--}};
  % конденсатор
  \fill[red!60] (4.5,-1.6) rectangle (4.7,1.6);
  \fill[blue!60] (7.3,-1.6) rectangle (7.5,1.6);
  \foreach \y in {-1.2,-0.6,0,0.6,1.2} \draw[fl] (4.7,\y) -- (7.3,\y);
  \node[red!70!black] at (4.6,1.95) {$+q$};
  \node[blue!70!black] at (7.4,1.95) {$-q$};
  \node at (6,-2) {$\vec E$};
\end{tikzpicture}
```

$$
F = k\frac{|q_1||q_2|}{r^2}, \qquad E = \frac{F}{q}, \qquad E = k\frac{|q|}{r^2}, \qquad C = \frac{\varepsilon\varepsilon_0 S}{d}
$$

### Магнитное поле тока и сила Ампера

Слева — линии индукции прямого тока, направленного от нас (правило буравчика). Справа — проводник с током к нам в однородном поле: сила Ампера по правилу левой руки.

```tikz
\usetikzlibrary{decorations.markings}
\begin{tikzpicture}[>=stealth]
  \foreach \r in {0.8,1.4,2.0}
    \draw[blue!70!black, postaction={decorate},
      decoration={markings, mark=at position 0.25 with {\arrow{<}}, mark=at position 0.75 with {\arrow{<}}}]
      (0,0) circle (\r);
  \draw[thick, fill=white] (0,0) circle (0.25);
  \draw[thick] (-0.17,-0.17) -- (0.17,0.17) (-0.17,0.17) -- (0.17,-0.17);
  \node[right] at (0.25,-0.3) {$I$};
  \node[blue!70!black] at (2.2,1.2) {$\vec B$};
  % сила Ампера
  \foreach \y in {-1.5,-0.75,0.75,1.5} \draw[->, blue!70!black] (3.6,\y) -- (7.4,\y);
  \draw[->, blue!70!black] (3.6,0) -- (5.2,0);
  \draw[->, blue!70!black] (5.8,0) -- (7.4,0) node[right] {$\vec B$};
  \draw[thick, fill=white] (5.5,0) circle (0.25);
  \fill (5.5,0) circle (0.07);
  \node at (5.85,-0.35) {$I$};
  \draw[->, very thick, red] (5.5,0.25) -- (5.5,1.9) node[above] {$\vec F_A$};
\end{tikzpicture}
```

$$
F_A = IBl\sin\alpha, \qquad F_\text{Л} = qvB\sin\alpha, \qquad \mathcal{E}_i = -\frac{\Delta\Phi}{\Delta t}, \qquad \Phi = BS\cos\alpha
$$

### Трансформатор

```tikz
\begin{circuitikz}
  \draw (0,0) node[transformer core] (T) {};
  \draw (T.A1) -- ++(-1.5,0) coordinate (a) to[sV, l=$U_1$] (a |- T.A2) -- (T.A2);
  \draw (T.B1) -- ++(1.5,0) coordinate (b) to[lamp, l=$H$] (b |- T.B2) -- (T.B2);
  \node[above] at (T.north) {$N_1 : N_2$};
\end{circuitikz}
```

$$
\frac{U_1}{U_2} = \frac{N_1}{N_2} = k, \qquad T = 2\pi\sqrt{LC}, \qquad X_L = \omega L, \qquad X_C = \frac{1}{\omega C}
$$

## Оптика

### Отражение и преломление света

```tikz
\usetikzlibrary{angles, quotes}
\begin{tikzpicture}[>=stealth]
  \fill[blue!10] (-3,-2.2) rectangle (3,0);
  \draw[thick] (-3,0) -- (3,0);
  \draw[dashed] (0,2.2) -- (0,-2.2);
  \coordinate (O) at (0,0);
  \coordinate (N) at (0,2);
  \coordinate (M) at (0,-2);
  \coordinate (A) at (-1.532,1.286);
  \coordinate (R) at (1.532,1.286);
  \coordinate (B) at (1.021,-1.720);
  \draw[->, very thick, red] (A) -- (O);
  \draw[->, thick, red!60] (O) -- (R);
  \draw[->, very thick, red] (O) -- (B);
  \pic[draw, "$\alpha$", angle eccentricity=1.4, angle radius=0.8cm] {angle = N--O--A};
  \pic[draw, "$\gamma$", angle eccentricity=1.4, angle radius=0.8cm] {angle = R--O--N};
  \pic[draw, "$\beta$", angle eccentricity=1.4, angle radius=0.8cm] {angle = M--O--B};
  \node[anchor=west, font=\small] at (-3,1.9) {воздух, $n_1 = 1$};
  \node[anchor=west, font=\small] at (-3,-1.9) {стекло, $n_2 = 1{,}5$};
\end{tikzpicture}
```

$$
\gamma = \alpha, \qquad n_1\sin\alpha = n_2\sin\beta, \qquad \sin\alpha_0 = \frac{n_2}{n_1}\ \ (\text{полное отражение, } n_1 > n_2)
$$

### Построение изображения в собирающей линзе

Предмет между $F$ и $2F$: изображение действительное, перевёрнутое, увеличенное.

```tikz
\begin{tikzpicture}[>=stealth, scale=0.95]
  \draw[->] (-4.5,0) -- (7,0);
  \draw[<->, very thick, blue] (0,-2.9) -- (0,1.9);
  \foreach \x/\n in {-4/2F, -2/F, 2/F, 4/2F} {
    \fill (\x,0) circle (1.5pt);
    \node[below, font=\small] at (\x,0) {$\n$};
  }
  \node[below left, font=\small] at (0,0) {$O$};
  \draw[->, very thick] (-3,0) -- (-3,1.2) node[above] {$AB$};
  \draw[->, very thick, red!70!black] (6,0) -- (6,-2.4) node[below] {$A'B'$};
  \draw[orange!80!black, thick] (-3,1.2) -- (0,1.2) -- (6,-2.4);
  \draw[green!50!black, thick] (-3,1.2) -- (6,-2.4);
  \draw[violet, thick] (-3,1.2) -- (0,-2.4) -- (6,-2.4);
  \draw[<->] (-3,-0.7) -- (0,-0.7) node[midway, below] {$d$};
  \draw[<->] (0,0.5) -- (6,0.5) node[midway, above] {$f$};
\end{tikzpicture}
```

$$
\frac{1}{F} = \frac{1}{d} + \frac{1}{f}, \qquad D = \frac{1}{F}, \qquad \Gamma = \frac{H}{h} = \frac{f}{d}
$$

### Интерференция от двух щелей

Распределение освещённости на экране и сама картина полос.

```tikz
\begin{tikzpicture}[x=1.6cm, y=1cm]
  \draw[->] (-3.2,0) -- (3.3,0) node[right] {$x$};
  \draw[->] (0,0) -- (0,2.6) node[above] {$I$};
  \draw[thick, red!80!black, domain=-3:3, samples=300, smooth, variable=\t]
    plot (\t, {2.2*(cos(deg(pi*\t)))^2 * (sin(deg(pi*\t/3))/(pi*\t/3))^2});
  \foreach \k in {-2,-1,1,2} \node[below, font=\small] at (\k,0) {$\k$};
  \node[below, font=\small] at (0,0) {$0$};
  \foreach \t in {-3,-2.97,...,2.98} {
    \pgfmathsetmacro\I{100*(cos(deg(pi*(\t+0.015))))^2 * (sin(deg(pi*(\t+0.015)/3))/(pi*(\t+0.015)/3))^2}
    \fill[red!\I!black] (\t,-1.6) rectangle ++(0.031,0.8);
  }
\end{tikzpicture}
```

$$
\Delta d = k\lambda\ (\text{максимум}), \qquad \Delta d = (2k+1)\frac{\lambda}{2}\ (\text{минимум}), \qquad d\sin\varphi = k\lambda
$$

### Сплошной спектр и линии водорода

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 575 132" width="560" height="132" font-family="sans-serif" font-size="12" text-anchor="middle">
  <defs>
    <linearGradient id="sp" x1="0" x2="1" y1="0" y2="0">
      <stop offset="0" stop-color="#610061"/><stop offset="0.1" stop-color="#6a00ff"/>
      <stop offset="0.15" stop-color="#0000ff"/><stop offset="0.275" stop-color="#00ffff"/>
      <stop offset="0.325" stop-color="#00ff00"/><stop offset="0.5" stop-color="#ffff00"/>
      <stop offset="0.6625" stop-color="#ff0000"/><stop offset="0.8" stop-color="#c00000"/>
      <stop offset="1" stop-color="#400000"/>
    </linearGradient>
  </defs>
  <text x="114" y="22">400</text><text x="174" y="22">450</text><text x="234" y="22">500</text><text x="294" y="22">550</text><text x="354" y="22">600</text><text x="414" y="22">650</text><text x="474" y="22">700</text><text x="534" y="22">750</text>
  <text x="330" y="8" font-size="11">λ, нм</text>
  <rect x="90" y="30" width="480" height="40" fill="url(#sp)"/>
  <rect x="90" y="82" width="480" height="30" fill="#000"/>
  <rect x="420.1" y="82" width="3" height="30" fill="#ff0000"/><text x="421.6" y="126">Hα</text><rect x="215.8" y="82" width="3" height="30" fill="#00d8ff"/><text x="217.3" y="126">Hβ</text><rect x="153.3" y="82" width="3" height="30" fill="#3d00ff"/><text x="154.8" y="126">Hγ</text><rect x="124.7" y="82" width="3" height="30" fill="#7a00ff"/><text x="126.2" y="126">Hδ</text>
  <text x="84" y="55" text-anchor="end">сплошной</text>
  <text x="84" y="102" text-anchor="end">водород</text>
</svg>
```

## Квантовая и ядерная физика

### Уровни энергии атома водорода

```tikz
\begin{tikzpicture}[>=stealth]
  % масштаб по энергии не соблюдён: верхние уровни раздвинуты, чтобы подписи не слипались
  \foreach \n/\e/\y in {1/-13{,}6/-6, 2/-3{,}4/-3, 3/-1{,}51/-1.8, 4/-0{,}85/-1.1, 5/-0{,}54/-0.55} {
    \draw[thick] (0,\y) -- (8,\y);
    \node[left, font=\small] at (0,\y) {$n=\n$};
    \node[right, font=\small] at (8,\y) {$\e$ эВ};
  }
  \draw[dashed] (0,0) -- (8,0);
  \node[left, font=\small] at (0,0) {$n=\infty$};
  \node[right, font=\small] at (8,0) {0};
  \foreach \y/\x in {-3/0.6, -1.8/0.9, -1.1/1.2, -0.55/1.5} \draw[->, violet, thick] (\x,\y) -- (\x,-6);
  \foreach \y/\x in {-1.8/3.4, -1.1/3.8, -0.55/4.2} \draw[->, red!80!black, thick] (\x,\y) -- (\x,-3);
  \foreach \y/\x in {-1.1/6.4, -0.55/6.8} \draw[->, orange!80!black, thick] (\x,\y) -- (\x,-1.8);
  \node[font=\small, violet, anchor=west] at (1.7,-4.5) {Лайман (УФ)};
  \node[font=\small, red!80!black, anchor=west] at (4.4,-2.4) {Бальмер (видимый)};
  \node[font=\small, orange!80!black, anchor=west] at (5.0,-1.45) {Пашен (ИК)};
\end{tikzpicture}
```

$$
E = h\nu, \qquad h\nu = A_{\text{вых}} + \frac{mv^2}{2}, \qquad h\nu = E_k - E_n, \qquad E_n = -\frac{13{,}6\ \text{эВ}}{n^2}
$$

### Закон радиоактивного распада

```tikz
\begin{tikzpicture}
  \begin{axis}[width=10cm, height=6cm, xmin=0, xmax=4.3, ymin=0, ymax=1.1, axis lines=left,
      xlabel={$t$}, ylabel={$N/N_0$}, xtick={1,2,3,4}, xticklabels={$T$,$2T$,$3T$,$4T$},
      ytick={0.125,0.25,0.5,1}, yticklabels={$\frac18$,$\frac14$,$\frac12$,1}]
    \addplot[blue, very thick, domain=0:4.2, samples=100] {2^(-x)};
    \foreach \k/\v in {1/0.5, 2/0.25, 3/0.125} {
      \edef\temp{\noexpand\draw[dashed, gray] (axis cs:\k,0) -- (axis cs:\k,\v) -- (axis cs:0,\v);}
      \temp
    }
  \end{axis}
\end{tikzpicture}
```

$$
N = N_0 \cdot 2^{-t/T}, \qquad E = mc^2, \qquad E_{\text{св}} = \Delta m\, c^2
$$

### Ядерные реакции

$$
\begin{aligned}
&\ce{^{238}_{92}U -> ^{234}_{90}Th + ^{4}_{2}He} &&\alpha\text{-распад}\\
&\ce{^{14}_{6}C -> ^{14}_{7}N + ^{0}_{-1}e + \tilde{\nu}} &&\beta\text{-распад}\\
&\ce{^{14}_{7}N + ^{4}_{2}He -> ^{17}_{8}O + ^{1}_{1}p} &&\text{открытие протона}\\
&\ce{^{235}_{92}U + ^{1}_{0}n -> ^{141}_{56}Ba + ^{92}_{36}Kr + 3^{1}_{0}n} &&\text{деление урана}\\
&\ce{^{2}_{1}H + ^{3}_{1}H -> ^{4}_{2}He + ^{1}_{0}n} &&\text{синтез}
\end{aligned}
$$

## Астрономия

### Небесная сфера

Наблюдатель в центре $O$ на широте $\varphi = 55^\circ$: высота полюса мира над горизонтом равна широте.

```tikz
\begin{tikzpicture}[>=stealth]
  \def\R{3}
  \draw[thick] (0,0) circle (\R);
  % горизонт
  \fill[green!8] (\R,0) arc (0:-180:\R{} and 0.8) arc (180:0:\R{} and 0.8);
  \draw[thick, green!50!black] (\R,0) arc (0:-180:\R{} and 0.8);
  \draw[dashed, green!50!black] (\R,0) arc (0:180:\R{} and 0.8);
  % небесный экватор
  \draw[thick, red!70!black, rotate=35] (\R,0) arc (0:-180:\R{} and 0.8);
  \draw[dashed, red!70!black, rotate=35] (\R,0) arc (0:180:\R{} and 0.8);
  % отвесная линия и ось мира
  \draw (0,-\R) -- (0,\R);
  \draw[thick, ->] ({-\R*cos(55)*1.0},{-\R*sin(55)*-1.0}) -- ({-\R*cos(55)*1.15},{\R*sin(55)*1.15});
  \draw[thick] ({\R*cos(55)},{-\R*sin(55)}) -- ({-\R*cos(55)},{\R*sin(55)});
  \fill (0,0) circle (1.5pt) node[below right] {$O$};
  \node[above] at (0,\R) {$Z$ зенит};
  \node[below] at (0,-\R) {$Z'$ надир};
  \node[above left] at ({-\R*cos(55)*1.15},{\R*sin(55)*1.15}) {$P$};
  \node[below right] at ({\R*cos(55)},{-\R*sin(55)}) {$P'$};
  \node[left] at (-\R,0) {$N$};
  \node[right] at (\R,0) {$S$};
  \draw (-1,0) arc (180:125:1);
  \node at (-1.25,0.45) {$\varphi$};
  \node[font=\small, green!40!black] at (2.2,-1.05) {горизонт};
  \node[font=\small, red!60!black, anchor=west] at (2.0,1.6) {небесный экватор};
  \node[font=\small, rotate=-55, above] at (-1.2,1.71) {ось мира};
\end{tikzpicture}
```

### Планета на эллиптической орбите

Единицы — астрономическая единица и год, тогда $GM_\odot = 4\pi^2$. Планету отпустили на расстоянии 1 а. е. со скоростью меньше круговой: орбита — эллипс, у перигелия планета движется быстрее (второй закон Кеплера), а энергия $E$ и момент импульса $L$ не меняются.

```modelica
// result: artifact:46b7fd5183f8b39e/result.csv
// build: openmodelica-1.27.1
// animate: circle x=0 y=0 r=0.06 color=#d69e2e | звезда
// animate: trace x=x y=y color=#2f6fb3
// animate: line 0,0 x,y color=#999
// animate: circle x=x y=y r=0.03 color=#2f6fb3 | планета
// plot: r, v
// plot: E, L
model Orbit "Планета на эллиптической орбите вокруг звезды (а. е., годы)"
  parameter Real GM = 4 * Modelica.Constants.pi^2 "для Солнца, а. е.³/год²";
  Real x(start = 1, fixed = true) "а. е.";
  Real y(start = 0, fixed = true) "а. е.";
  Real vx(start = 0, fixed = true) "а. е./год";
  Real vy(start = 4.5, fixed = true) "а. е./год";
  Real r = sqrt(x^2 + y^2) "расстояние до звезды, а. е.";
  Real v = sqrt(vx^2 + vy^2) "скорость, а. е./год";
  Real E = v^2 / 2 - GM / r "полная энергия на единицу массы";
  Real L = x * vy - y * vx "момент импульса на единицу массы";
equation
  der(x) = vx;
  der(y) = vy;
  der(vx) = -GM * x / r^3;
  der(vy) = -GM * y / r^3;
  annotation(experiment(StopTime = 1.2));
end Orbit;
```

$$
\frac{T_1^2}{T_2^2} = \frac{a_1^3}{a_2^3}, \qquad v_1 = \sqrt{\frac{GM}{R}}, \qquad v_2 = \sqrt{\frac{2GM}{R}}
$$

### Планеты Солнечной системы

| Планета | Радиус, $R_\oplus$ | Большая полуось, а. е. | Период, лет | $T^2/a^3$ | Спутники |
|---|--:|--:|--:|--:|--:|
| Меркурий | 0,38 | 0,39 | 0,24 | 0,97 | 0 |
| Венера | 0,95 | 0,72 | 0,62 | 1,03 | 0 |
| Земля | 1,00 | 1,00 | 1,00 | 1,00 | 1 |
| Марс | 0,53 | 1,52 | 1,88 | 1,00 | 2 |
| Юпитер | 11,2 | 5,20 | 11,86 | 1,00 | 95 |
| Сатурн | 9,45 | 9,58 | 29,46 | 0,99 | 146 |
| Уран | 4,01 | 19,2 | 84,0 | 1,00 | 28 |
| Нептун | 3,88 | 30,1 | 164,8 | 1,00 | 16 |

### Диаграмма Герцшпрунга — Рассела

Температура растёт влево, светимость — в светимостях Солнца, обе шкалы логарифмические.

```echarts
{"width":560,"height":440,
 "title":{"text":"Диаграмма Герцшпрунга — Рассела","left":"center","textStyle":{"fontSize":14}},
 "legend":{"top":30},
 "grid":{"left":70,"right":90,"top":86,"bottom":55},
 "tooltip":{"trigger":"item","formatter":"{a}: {b}"},
 "xAxis":{"type":"log","inverse":true,"min":2500,"max":30000,"name":"Температура, К","nameLocation":"middle","nameGap":30},
 "yAxis":{"type":"log","min":0.0001,"max":1000000,"name":"L / L☉","nameGap":14},
 "series":[
  {"name":"главная последовательность","type":"scatter","symbolSize":10,"label":{"color":"#111","textBorderColor":"#fff","textBorderWidth":3,"show":true,"formatter":"{b}","position":"right","fontSize":10},
   "data":[{"name":"Спика","value":[22400,20000]},{"name":"Вега","value":[9600,40],"label":{"position":"left"}},{"name":"Сириус A","value":[9940,25]},
           {"name":"Альтаир","value":[7700,10.6]},{"name":"Солнце","value":[5772,1]},{"name":"ε Эридана","value":[5084,0.34]},
           {"name":"Звезда Барнарда","value":[3134,0.0035],"label":{"position":"left"}},{"name":"Проксима","value":[3042,0.0017]}]},
  {"name":"гиганты","type":"scatter","symbolSize":14,"label":{"color":"#111","textBorderColor":"#fff","textBorderWidth":3,"show":true,"formatter":"{b}","position":"right","fontSize":10},
   "data":[{"name":"Арктур","value":[4290,170]},{"name":"Альдебаран","value":[3900,440]},{"name":"Капелла","value":[4970,79]}]},
  {"name":"сверхгиганты","type":"scatter","symbolSize":18,"label":{"color":"#111","textBorderColor":"#fff","textBorderWidth":3,"show":true,"formatter":"{b}","position":"left","fontSize":10},
   "data":[{"name":"Ригель","value":[12100,120000]},{"name":"Денеб","value":[8500,200000]},{"name":"Бетельгейзе","value":[3600,100000]},
           {"name":"Антарес","label":{"position":"right"},"value":[3500,75000]},{"name":"Полярная","value":[6015,1260]}]},
  {"name":"белые карлики","type":"scatter","symbolSize":7,"label":{"color":"#111","textBorderColor":"#fff","textBorderWidth":3,"show":true,"formatter":"{b}","position":"right","fontSize":10},
   "data":[{"name":"Сириус B","value":[25000,0.056]},{"name":"40 Эридана B","value":[16500,0.013]},{"name":"Процион B","value":[7740,0.00049]}]}
 ]}
```

$$
L = 4\pi R^2 \sigma T^4, \qquad \lambda_{\max} = \frac{b}{T}, \qquad m - M = 5\lg\frac{r}{10\ \text{пк}}
$$
