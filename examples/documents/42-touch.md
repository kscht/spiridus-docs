<!-- Собрано из apps/playground/examples/42-touch.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: 3D | теги: телефон, планшет, сенсорный экран, гироскоп, наклон, касание, 3d, stl, openscad, modelica, multibody, атрибуты блока -->
# Телефон и планшет: модели пальцем и наклоном

В документе вертикальное движение пальцем — прокрутка страницы, поэтому вертеть модель пальцем
неудобно. Как блок ведёт себя на сенсорном экране, задают **атрибуты в строке забора** — после
языка, исходник модели не меняется:

- `touch=views` — кнопки «изо», «спереди», «сверху», «сбоку»; палец листает страницу;
- `touch=turntable` — модель сразу вращается на столе;
- `gyro=on` — кнопка «наклоном»: модель поворачивается вслед за наклоном телефона (на iPhone
  браузер спросит разрешение);
- у Modelica ещё `view=` — какие слои показать: `scene` (2D-анимация), `3d`, `plots` (графики).

На компьютере кнопки видов тоже есть, а тянуть мышью можно как обычно; кнопки «наклоном» нет —
датчика нет. Откройте эту страницу на телефоне.

## STL: виды кнопками и наклон

```stl touch=views gyro=on
artifact:08e4d5eeee8e3c5d/model.stl
```

## OpenSCAD: поворот на столе

```openscad touch=turntable gyro=on
// rotate_extrude вращает плоский контур вокруг оси Z
rotate_extrude($fn = 96)
  polygon([[0, 0], [14, 0], [18, 10], [12, 28], [10, 36], [13, 42],
           [11.5, 42], [8.5, 36], [10.5, 28], [16.5, 10], [12.5, 1.5], [0, 1.5]]);
```

## Modelica MultiBody: двойной маятник

3D-модель на телефоне жесты не забирает: страница листается, а модель — кнопками видов, «⟳» или
наклоном; вертеть пальцем — на весь экран (кнопка «⤢»). На узком экране графики под моделью
свёрнуты — «Графики» открывает их.

```modelica touch=views gyro=on
// result: artifact:41148001a18aa3e9/result.csv
// plot: revolute1.phi, revolute2.phi
model DoublePendulum3D "Двойной маятник из примеров MultiBody"
  extends Modelica.Mechanics.MultiBody.Examples.Elementary.DoublePendulum;
  annotation(experiment(StopTime = 5));
end DoublePendulum3D;
```

## Modelica: только анимация

`view=scene` — без графиков: для задачи «посмотри, как качается маятник».

```modelica view=scene
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
