<!-- Собрано из notations/glsl/docs.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

# `glsl` — шейдер GLSL ES 3.00

Фрагментный шейдер рисует картинку в WebGL2 во фрейме. Основная форма — как у Shadertoy:
`void mainImage(out vec4 fragColor, in vec2 fragCoord)`. Запускатель добавляет `#version 300 es`,
точность, uniforms и `main()`. Ошибки компиляции нумеруются по строкам вашего блока, начиная с 1.
Текст документа и JavaScript основной страницы шейдеру недоступны.

Сразу показан кадр `time` (по умолчанию 1 с). «▶» запускает анимацию, «⏸» ставит на паузу,
«↺» возвращает к кадру `time`. Кнопка «⤢» разворачивает просмотр. Анимация останавливается вне
экрана и на скрытой вкладке; `play=auto` учитывает настройку уменьшенного движения.

## Uniforms

- `vec3 iResolution`: ширина и высота буфера в пикселях, третья компонента 1.
- `float iTime`: время в секундах; `float iTimeDelta`: шаг времени (0 на неподвижном кадре).
- `int iFrame`: номер кадра, при сбросе 0.
- `vec4 iMouse`: xy — положение указателя от левого нижнего угла в пикселях буфера;
  zw — место нажатия, положительное при удержании и отрицательное после отпускания. Поддержаны касания.
- `vec4 iDate`: год, месяц 1–12, день, секунды суток UTC. Для печати и проверки дата фиксирована:
  1970-01-01 и секунды `time`, чтобы снимки не зависели от дня запуска.

В основной форме не объявляйте эти uniforms повторно. `iChannel`, звук, текстуры и несколько
проходов пока не поддержаны. Код Shadertoy с такими входами нужно упростить.

## Атрибуты и параметры

Атрибуты — в строке забора, например `glsl aspect=1:1 time=2.5 play=click scale=0.5`.
`aspect` — отношение сторон от 1:4 до 4:1, по умолчанию 16:9; `time` — от 0 до 86400 секунд;
`play` — `click` (по умолчанию) или `auto`; `scale` — доля разрешения от 0.1 до 1 (по умолчанию 1).

`uniform float uRadius; // @range 0.1 0.8 0.35` создаёт ползунок: минимум, максимум, начальное
значение. До восьми параметров, числа в пределах ±1000000. Ползунок сразу меняет кадр;
значения сохраняются в query-параметрах адреса документа, независимо для каждого блока.
Скопируйте текущий адрес браузера, чтобы передать выбранные значения.

## Ограничения и диагностика

Нужны WebGL2 и OffscreenCanvas в worker. Если они недоступны, вместо пустого холста будет
сообщение. Устройство ограничено `devicePixelRatio` до 2, площадью 2 млн пикселей и стороной
4096 пикселей; `scale` снижает нагрузку. Анимация и компиляция исполняются в worker с внешним
таймером; два кадра дольше 250 мс или один неответивший кадр дольше 500 мс останавливают просмотр.
При потере контекста или тяжёлом кадре есть кнопка повторного запуска.

Используйте короткие `for` с постоянным числовым пределом до 4096 и шагом `++`.
`while`, `do` и циклы без явного предела отклоняются до передачи GPU; это предохранитель,
а не доказательство безопасности произвольного цикла. Драйвер и браузер могут ограничивать
исполнение дополнительно. Предел блока — 64 КиБ UTF-8; `#include`, `#extension` и `#line` запрещены.
Линтер glslang проверяет синтаксис и типы, свои правила замечают опасные циклы и деление на ноль.

Это GLSL ES 3.00, не ES 1.00: `texture2D` замените на `texture`, `gl_FragColor` — на `fragColor`
в `mainImage`, `varying` — на `in/out` в полном шейдере. Проверяйте типы: `float x = 1.0`,
для смешанных выражений используйте `float(i)`. Ошибка «mainImage: no matching overloaded function»
обычно означает неверные типы или порядок параметров: нужны `out vec4` и `in vec2`.

Полная форма начинается с `#version 300 es` и содержит `void main()`, свои `precision`, uniforms
и `out vec4`. Обёртка в таком случае не добавляется. Именованные служебные uniforms передаются,
если вы сами объявили их с типами из списка выше; остальные uniforms без @range остаются нулевыми.

При печати/PDF показан PNG кадра `time` с выбранными параметрами и подписью, без кнопок.
`render_check` проверяет такой же фиксированный кадр через программный WebGL2; работа кнопок,
мыши и ползунков проверяется отдельно сценариями `interact`.

## Примеры

### Градиент и время

```glsl
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord / iResolution.xy;
  fragColor = vec4(uv, 0.5 + 0.5 * sin(iTime), 1.0);
}
```

### SDF круг и ползунок

```glsl aspect=1:1
uniform float uRadius; // @range 0.1 0.8 0.35
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 p = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
  vec2 center = iMouse.z > 0.0
    ? (2.0 * iMouse.xy - iResolution.xy) / iResolution.y : vec2(0.0);
  float d = length(p - center) - uRadius;
  float edge = 1.0 - smoothstep(-0.01, 0.01, d);
  fragColor = vec4(mix(vec3(0.04, 0.07, 0.12), vec3(0.2, 0.8, 0.6), edge), 1.0);
}
```

### Процедурный шум

```glsl
float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
float noise(vec2 p) {
  vec2 i = floor(p), f = fract(p);
  f = f * f * (3.0 - 2.0 * f);
  return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x),
    mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0)), f.x), f.y);
}
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord / iResolution.y;
  float n = noise(uv * 8.0 + vec2(iTime * 0.3, 0.0));
  fragColor = vec4(vec3(n * 0.3, n * 0.6, n), 1.0);
}
```

### Raymarching с 48 шагами

```glsl scale=0.5
float scene(vec3 p) { return length(p) - 0.7; }
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
  vec3 ro = vec3(0.0, 0.0, 2.5), rd = normalize(vec3(uv, -1.8));
  float travel = 0.0;
  vec3 color = vec3(0.03, 0.04, 0.08);
  for (int step = 0; step < 48; step++) {
    vec3 p = ro + rd * travel;
    float d = scene(p);
    if (d < 0.002) {
      vec3 normal = normalize(p);
      vec3 light = normalize(vec3(cos(iTime), 1.0, 2.0));
      float shade = max(dot(normal, light), 0.0);
      color = vec3(0.15, 0.5, 0.9) * (0.2 + 0.8 * shade);
      break;
    }
    travel += d;
    if (travel > 5.0) break;
  }
  fragColor = vec4(color, 1.0);
}
```
