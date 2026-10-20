<!-- Собрано из apps/playground/examples/17-multibody.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: Моделирование | теги: modelica, multibody, 3d, анимация, механика, маятник, пружина, шарнир, openmodelica -->
# MultiBody: механика в 3D

Модели на библиотеке `Modelica.Mechanics.MultiBody` описывают тела, шарниры и пружины в пространстве. OpenModelica отдаёт формы тел и их движение, а блок показывает их в 3D: тяните, чтобы повернуть, колесо — приблизить, «▶» — проиграть расчёт. По графикам бежит тот же курсор времени.

## Маятник на шарнире

Своя модель из компонентов: мир, шарнир с осью Z, стержень и шар. Угол 0 — стержень горизонтально вдоль X; маятник отпустили на 1 рад выше горизонтали, и он качается через нижнюю точку (−π/2) до −π − 1.

```modelica
// result: artifact:48e9cbfe8e9875e7/result.csv
// plot: hinge.phi, hinge.w
model Pendulum3D "Маятник на шарнире: стержень и шар"
  import Modelica.Mechanics.MultiBody.*;
  inner World world;
  Joints.Revolute hinge(n = {0, 0, 1}, useAxisFlange = false, phi(start = 1.0, fixed = true), w(start = 0, fixed = true));
  Parts.BodyCylinder rod(r = {0.8, 0, 0}, diameter = 0.03, density = 2700);
  Parts.BodyShape bob(r = {0, 0, 0}, r_CM = {0, 0, 0}, m = 2, shapeType = "sphere", length = 0.16, width = 0.16, height = 0.16, r_shape = {-0.08, 0, 0}, color = {255, 120, 0});
equation
  connect(world.frame_b, hinge.frame_a);
  connect(hinge.frame_b, rod.frame_a);
  connect(rod.frame_b, bob.frame_a);
  annotation(experiment(StopTime = 6));
end Pendulum3D;
```

## Двойной маятник

Пример из стандартной библиотеки: два бруса на шарнирах, у первого — демпфер. Движение второго звена хаотично.

```modelica
// result: artifact:41148001a18aa3e9/result.csv
// plot: revolute1.phi, revolute2.phi
model DoublePendulum3D "Двойной маятник из примеров MultiBody"
  extends Modelica.Mechanics.MultiBody.Examples.Elementary.DoublePendulum;
  annotation(experiment(StopTime = 5));
end DoublePendulum3D;
```

## Грузы на пружинах

Тоже из библиотеки: два груза на пружинах — один на призматическом шарнире, другой свободный.

```modelica
// result: artifact:ee90daccb496acaf/result.csv
// plot: p1.s, p2.s
model SpringMass3D "Грузы на пружинах из примеров MultiBody"
  extends Modelica.Mechanics.MultiBody.Examples.Elementary.SpringMassSystem;
  annotation(experiment(StopTime = 5));
end SpringMass3D;
```
