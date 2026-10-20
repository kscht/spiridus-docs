<!-- Собрано из apps/playground/examples/16-modelica.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: Моделирование | теги: modelica, openmodelica, моделирование, физика, электрическая цепь, rc, механика, колебания, пружина, мяч, уравнения, график -->
# Modelica: модель и график

Модель описывается уравнениями и готовыми компонентами стандартной библиотеки. Считает её OpenModelica в песочнице на сервере через MCP-инструмент `modelica_run`, а документ показывает исходник, графики и сцену. Кнопка «▶» проигрывает расчёт: фигуры движутся, по графикам бежит курсор, под шкалой — значения переменных в этот момент.

## Заряд конденсатора

Цепь RC: источник 10 В, резистор 1 кОм, конденсатор 1 мФ. Постоянная времени τ = RC = 1 с, за 5τ конденсатор заряжается почти полностью.

```modelica
// result: artifact:a73c81b07a6561f0/result.csv
// plot: C.v
// plot: R.i
model RC "Заряд конденсатора через резистор"
  import Modelica.Electrical.Analog.Basic;
  import Modelica.Electrical.Analog.Sources;
  Sources.ConstantVoltage U(V = 10);
  Basic.Resistor R(R = 1000);
  Basic.Capacitor C(C = 1e-3, v(start = 0, fixed = true));
  Basic.Ground G;
equation
  connect(U.p, R.p);
  connect(R.n, C.p);
  connect(C.n, U.n);
  connect(U.n, G.p);
  annotation(experiment(StopTime = 5));
end RC;
```

## Груз на пружине с демпфером

Затухающие колебания: жёсткость 40 Н/м, масса 1 кг, демпфирование 1,5 Н·с/м. Груз отпустили, сместив на 10 см.

```modelica
// result: artifact:3351026a64774c42/result.csv
// animate: line -0.3,-0.08 -0.3,0.08 color=#1c1f26 | стена
// animate: spring -0.3,0 mass.s,0 n=10 w=0.05
// animate: rect x=mass.s y=0 w=0.06 h=0.06 | груз
// plot: mass.s
// plot: mass.v, spring.f
model MassSpringDamper "Груз на пружине с демпфером"
  import Modelica.Mechanics.Translational.Components;
  Components.Fixed wall;
  Components.Spring spring(c = 40);
  Components.Damper damper(d = 1.5);
  Components.Mass mass(m = 1, s(start = 0.1, fixed = true), v(start = 0, fixed = true));
equation
  connect(wall.flange, spring.flange_a);
  connect(wall.flange, damper.flange_a);
  connect(spring.flange_b, mass.flange_a);
  connect(damper.flange_b, mass.flange_a);
  annotation(experiment(StopTime = 6));
end MassSpringDamper;
```

## Мяч отскакивает от пола

Без библиотеки — одни уравнения движения и событие `when`: при касании пола скорость меняет знак и теряет 20 %. `h` — высота центра мяча, поэтому пол на сцене опущен на радиус.

```modelica
// result: artifact:b14cb568d2e9e59f/result.csv
// animate: line -0.4,-0.05 0.4,-0.05 color=#1c1f26 | пол
// animate: circle x=0 y=h r=0.05 color=#c05621 | мяч
// plot: h
// plot: v
model BouncingBall "Мяч отскакивает от пола и теряет энергию"
  parameter Real e = 0.8 "коэффициент восстановления";
  parameter Real g = 9.81 "ускорение свободного падения, м/с²";
  Real h(start = 1, fixed = true) "высота, м";
  Real v(start = 0, fixed = true) "скорость, м/с";
equation
  der(h) = v;
  der(v) = -g;
  when h <= 0 then
    reinit(v, -e * pre(v));
  end when;
  annotation(experiment(StopTime = 3));
end BouncingBall;
```

## Маятник со следом

Груз описан координатами `x`, `y` прямо в модели, поэтому сцене хватает имён переменных: нить — отрезок от точки подвеса, груз — круг, `trace` рисует пройденный путь.

```modelica
// result: artifact:270f4ab3a24e682a/result.csv
// plot: phi, w
// animate: point x=0 y=0 color=#1c1f26
// animate: trace x=x y=y color=#2f6fb3
// animate: line 0,0 x,y color=#555
// animate: circle x=x y=y r=0.06 color=#c05621 | груз
model Pendulum "Математический маятник с небольшим трением"
  parameter Real L = 1 "длина нити, м";
  parameter Real g = 9.81 "ускорение свободного падения, м/с²";
  parameter Real b = 0.15 "трение, 1/с";
  Real phi(start = 1.2, fixed = true) "угол от вертикали, рад";
  Real w(start = 0, fixed = true) "угловая скорость, рад/с";
  Real x = L * sin(phi) "координата груза, м";
  Real y = -L * cos(phi) "высота груза, м";
equation
  der(phi) = w;
  der(w) = -g / L * sin(phi) - b * w;
  annotation(experiment(StopTime = 10));
end Pendulum;
```

## Модель изменили после расчёта

Сопротивление стало 2 кОм, а результат остался от 1 кОм — блок предупреждает.

```modelica
// result: artifact:a73c81b07a6561f0/result.csv
// plot: C.v
model RC "Заряд конденсатора через резистор"
  import Modelica.Electrical.Analog.Basic;
  import Modelica.Electrical.Analog.Sources;
  Sources.ConstantVoltage U(V = 10);
  Basic.Resistor R(R = 2000);
  Basic.Capacitor C(C = 1e-3, v(start = 0, fixed = true));
  Basic.Ground G;
equation
  connect(U.p, R.p);
  connect(R.n, C.p);
  connect(C.n, U.n);
  connect(U.n, G.p);
  annotation(experiment(StopTime = 5));
end RC;
```

## Ещё не рассчитана

```modelica
model Decay
  Real x(start = 1, fixed = true);
equation
  der(x) = -0.5 * x;
end Decay;
```
