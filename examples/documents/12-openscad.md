<!-- Собрано из apps/playground/examples/12-openscad.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: 3D | теги: openscad, модель, 3d, параметры, rotate_extrude, linear_extrude, hull, minkowski, корпус, ваза -->
# OpenSCAD: подборка

Исходник собирается прямо в браузере (OpenSCAD в WebAssembly). Поменяйте число в редакторе — модель пересоберётся.

## Ваза: вращение профиля

```openscad
// rotate_extrude вращает плоский контур вокруг оси Z
rotate_extrude($fn = 96)
  polygon([[0, 0], [14, 0], [18, 10], [12, 28], [10, 36], [13, 42],
           [11.5, 42], [8.5, 36], [10.5, 28], [16.5, 10], [12.5, 1.5], [0, 1.5]]);
```

## Витая колонна: выдавливание с закруткой

```openscad
linear_extrude(height = 40, twist = 120, slices = 60, scale = 0.7)
  offset(r = 1.5, $fn = 24) square(14, center = true);
```

## Корпус со скруглёнными углами и крышкой

```openscad
// параметры корпуса, мм
w = 50; d = 34; h = 18; wall = 2; r = 4;
module rounded(w, d, h, r) hull()
  for (x = [r, w - r], y = [r, d - r]) translate([x, y, 0]) cylinder(r = r, h = h, $fn = 40);

difference() {
  rounded(w, d, h, r);
  translate([wall, wall, wall]) rounded(w - 2 * wall, d - 2 * wall, h, r - wall);
}
// крышка рядом, с бортиком внутрь корпуса
translate([w + 8, 0, 0]) {
  rounded(w, d, wall, r);
  translate([wall + 0.3, wall + 0.3, wall])
    difference() {
      rounded(w - 2 * wall - 0.6, d - 2 * wall - 0.6, 3, r - wall);
      translate([1.2, 1.2, -1]) rounded(w - 2 * wall - 3, d - 2 * wall - 3, 5, r - wall - 1);
    }
}
```

## Пластина с отверстиями: скругление через minkowski

```openscad
difference() {
  minkowski() { cube([40, 24, 2]); cylinder(r = 3, h = 1, $fn = 32); }
  for (x = [4, 36], y = [4, 20]) translate([x, y, -1]) cylinder(d = 3.4, h = 5, $fn = 32);
}
```

## Кубики Лего: модуль с параметрами

```openscad
module brick(nx, ny, h = 9.6) {
  p = 8;
  difference() {
    cube([nx * p - 0.2, ny * p - 0.2, h]);
    translate([1.2, 1.2, -1]) cube([nx * p - 2.6, ny * p - 2.6, h]);
  }
  for (i = [0 : nx - 1], j = [0 : ny - 1])
    translate([p / 2 + i * p - 0.1, p / 2 + j * p - 0.1, h]) cylinder(d = 4.8, h = 1.7, $fn = 32);
}
brick(4, 2);
translate([0, 22, 0]) brick(2, 2);
translate([20, 22, 0]) brick(1, 3, 3.2);
```
