<!-- Собрано из apps/playground/examples/40-quantum.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: Схемы | теги: квантовые вычисления, кубит, квантовая схема, quantikz, yquant, braket, белл, телепортация, гровер, преобразование фурье, qft, физика, информатика -->
# Квантовые схемы

Схема на кубитах — блок `tikz` с окружением `quantikz` (пакет подключается сам): строка — кубит,
время идёт слева направо, столбцы — через `&`. `\gate{H}` — вентиль, `\ctrl{1}` — управление
кубитом строкой ниже, `\targ{}` — ⊕ (CNOT), `\meter{}` — измерение, двойная линия — классический
бит.

## Состояние Белла

Адамар на первом кубите и CNOT: из $\ket{00}$ получается $\frac{1}{\sqrt2}(\ket{00} + \ket{11})$ —
результаты измерений всегда совпадают.

```tikz
\begin{quantikz}
\lstick{$\ket{0}$} & \gate{H} & \ctrl{1} & \meter{} \\
\lstick{$\ket{0}$} &          & \targ{}  & \meter{}
\end{quantikz}
```

## Квантовая телепортация

Пара Белла на кубитах 2 и 3, измерение кубитов 1 и 2 в базисе Белла, два классических бита — и
поправки $X$ и $Z$ возвращают на третьем кубите исходное $\ket{\psi}$.

```tikz
\begin{quantikz}
\lstick{$\ket{\psi}$} &          &          & \ctrl{1} & \gate{H} & \meter{} & \setwiretype{c} & \control{}\wire[d][2]{c} & \setwiretype{n} \\
\lstick{$\ket{0}$}    & \gate{H} & \ctrl{1} & \targ{}  &          & \meter{} & \control{}\setwiretype{c}\wire[d][1]{c} & \setwiretype{n} & \\
\lstick{$\ket{0}$}    &          & \targ{}  &          &          &  & \gate{X} & \gate{Z} & \rstick{$\ket{\psi}$}
\end{quantikz}
```

## Алгоритм Гровера на двух кубитах

Ищем $\ket{11}$: оракул меняет знак у искомого состояния (CZ), диффузия отражает амплитуды
относительно среднего. Для четырёх состояний хватает одной итерации — измерение даёт 11 с
вероятностью 1.

```tikz
\begin{quantikz}
\lstick{$\ket{0}$} & \gate{H} & \ctrl{1}\gategroup[2,steps=1,style={dashed,rounded corners,inner sep=4pt}]{оракул} & \gate{H}\gategroup[2,steps=5,style={dashed,rounded corners,inner sep=4pt}]{диффузия} & \gate{X} & \ctrl{1} & \gate{X} & \gate{H} & \meter{} \\
\lstick{$\ket{0}$} & \gate{H} & \control{} & \gate{H} & \gate{X} & \control{} & \gate{X} & \gate{H} & \meter{}
\end{quantikz}
```

## Квантовое преобразование Фурье, 3 кубита

$R_k$ — поворот фазы на $2\pi/2^k$, управляемый кубитом ниже; в конце порядок кубитов
переворачивает обмен (SWAP).

```tikz
\begin{quantikz}
\lstick{$q_0$} & \gate{H} & \gate{R_2} & \gate{R_3} &           &            &          & \swap{2} & \rstick{$y_2$} \\
\lstick{$q_1$} &          & \ctrl{-1}  &            & \gate{H}  & \gate{R_2} &          &          & \rstick{$y_1$} \\
\lstick{$q_2$} &          &            & \ctrl{-2}  &           & \ctrl{-1}  & \gate{H} & \targX{} & \rstick{$y_0$}
\end{quantikz}
```

## Схема по программе: yquant

`yquant` рисует схему по коду, похожему на OpenQASM: объявить кубиты, применить вентили, измерить.

```tikz
\begin{yquant}
qubit {$\ket{0}$} q[2];
h q[0];
cnot q[1] | q[0];
measure q;
\end{yquant}
```

## Живая модель: OpenQASM

Блок `qasm` — схема на языке OpenQASM (2.0 или 3.0, как в Qiskit), и браузер сам её моделирует:
вероятности исходов и амплитуды. Ползунок «шаг» проходит схему по операциям.

Состояние GHZ — три кубита, запутанных так, что все измерения совпадают:

```qasm
OPENQASM 3.0;
include "stdgates.inc";
qubit[3] q;
bit[3] c;
h q[0];
cx q[0], q[1];
cx q[1], q[2];
c = measure q;
```

Алгоритм Гровера из примера выше — без измерений, поэтому видны амплитуды всех четырёх состояний:
после одной итерации вся вероятность — у $\ket{11}$.

```qasm
OPENQASM 2.0;
include "qelib1.inc";
qreg q[2];
h q;
cz q[0], q[1];   // оракул: меняет знак у |11⟩
h q;
x q;
cz q[0], q[1];   // диффузия: отражение относительно среднего
x q;
h q;
```

Интерференция на одном кубите: поворот $R_y$ на угол $\theta$ и измерение. Вероятность единицы —
$\sin^2(\theta/2)$; при $\theta = \pi/3$ это 25 %.

```qasm
OPENQASM 2.0;
include "qelib1.inc";
qreg q[1];
creg c[1];
ry(pi/3) q[0];
measure q[0] -> c[0];
```

## Qiskit и ZX-исчисление

Блок `qiskit` рисует MCP-инструмент `quantum_run` (Qiskit и PyZX в песочнице): схема в виде,
привычном по документации IBM, сферы Блоха и ZX-диаграмма. Состояние GHZ — у запутанных кубитов
точка на сфере Блоха уходит в центр: по отдельности каждый кубит — полная неопределённость.

```qiskit
// result: artifact:ca7de9c1946963b1/circuit.svg
// build: qiskit-2.5.2
// view: circuit, histogram, bloch
OPENQASM 2.0;
include "qelib1.inc";
qreg q[3];
creg c[3];
h q[0];
cx q[0],q[1];
cx q[1],q[2];
measure q -> c;
```

Тот же Гровер в ZX-исчислении: PyZX упрощает диаграмму правилами перерисовки — из 12 вентилей
остаётся 6, и проверка тензорами подтверждает, что схема делает то же самое.

```qiskit
// result: artifact:09b172fa98596738/circuit.svg
// build: qiskit-2.5.2
// view: circuit, zx, zx-reduced
OPENQASM 2.0;
include "qelib1.inc";
qreg q[2];
h q;
cz q[0],q[1];
h q;
x q;
cz q[0],q[1];
x q;
h q;
```
