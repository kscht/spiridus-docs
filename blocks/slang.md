<!-- Собрано автоматически из справки render_block_docs — правки в основном репозитории Spiridus. -->

# HLSL и Slang — пиксельные шейдеры

Блоки `hlsl` и `slang` компилируются инструментом `hlsl_compile` (Slang 2026.19) на сервере, без сети. Браузер рисует результат GLSL ES 3.00 общим запускателем `glsl`: анимация, мышь, ползунки, ограничение тяжёлого кадра и PNG для печати. Сам HLSL в браузере не исполняется.

Сначала вызовите `hlsl_compile {source, language:"hlsl"}` или `language:"slang"`, затем вставьте возвращённый блок со строкой `// result: artifact:<id>/shader.glsl`. Не придумывайте id. Примеры ниже — исходники для компиляции; без результата читатель увидит «не скомпилировано» и кнопку. Изменённый исходник требует пересчёта. Без входа можно попробовать свой шейдер: до 300 компиляций в час с одного адреса, исходник до 16 КиБ. Пробный результат виден только на странице и не сохраняется на сервере как артефакт. В документ результат со строкой `result:` сохраняется только с ключом через `hlsl_compile`. Готовое из кеша доступно без входа и не тратит квоту.

## Обвязка

Пишите `float4 mainImage(float2 fragCoord)` — цвет RGBA. Начало координат внизу слева, единицы — пиксели. Автоматически добавляются `iResolution` (float3), `iTime`, `iTimeDelta` (float), `iFrame` (int), `iMouse`, `iDate` (float4). Не объявляйте их повторно. Имена глобальных параметров в результате сохраняются. Дополнительные скалярные параметры объявляйте в `cbuffer Params`, до восьми:

```hlsl
cbuffer Params {
    float radius; // @range 0.1 0.8 0.35
};
float4 mainImage(float2 fragCoord) {
    float2 uv = fragCoord / iResolution.xy;
    float d = length(uv - 0.5);
    float circle = 1.0 - smoothstep(radius, radius + 0.01, d);
    return float4(uv.x, circle, 0.5 + 0.5 * sin(iTime), 1.0);
}
```

Атрибуты: `aspect=16:9`, `time=1.0` (кадр печати), `play=click` или `auto` (учитывает reduced-motion), `scale=0.5` (0.1–1), `entry=mainImage`, `profile=ps_6_0`, `build=slang-2026.19`. `entry` выбирает функцию с той же сигнатурой. В этой версии другой профиль не поддержан.

## HLSL и GLSL

| HLSL / Slang | GLSL | Замечание |
|---|---|---|
| float2/float3/float4 | vec2/vec3/vec4 | Это разные имена типов |
| lerp(a,b,t) | mix(a,b,t) | Интерполяция |
| frac(x) | fract(x) | Дробная часть |
| float3x3 | mat3 | mul(M,v) — умножение матрицы на вектор |
| mul(M,v) | M*v | Не путайте с покомпонентным `*` в HLSL |
| Texture2D.Sample | texture | Текстуры пока не поддержаны |

По умолчанию компилятор Slang использует row-major для матриц; при переносе проверяйте порядок и `mul`. `smoothstep` используйте с возрастающими границами. `while`, `do`, циклы без постоянного начального значения и предела или более 4096 итераций, директивы препроцессора и свои include/import недоступны. Предел входа 64 КиБ. Нет compute/vertex, текстур, нескольких проходов и внешних файлов. Стандартные математические функции и средства Slang доступны без import. `import slang;` разрешён политикой, но нужность/наличие проверяет компилятор.

## Градиент

```hlsl
float4 mainImage(float2 p) {
    float2 uv = p / iResolution.xy;
    return float4(uv, 0.5 + 0.5 * sin(iTime), 1.0);
}
```

## Шум

```hlsl
float hash(float2 p) { return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453); }
float4 mainImage(float2 p) {
    float2 cell = floor(p / 12.0);
    float n = hash(cell);
    return float4(n, n * 0.7, n * 0.3, 1.0);
}
```

## Raymarching с пределом

```hlsl
float4 mainImage(float2 p) {
    float2 uv = (2.0 * p - iResolution.xy) / iResolution.y;
    float3 ro = float3(0.0, 0.0, -3.0);
    float3 rd = normalize(float3(uv, 1.5));
    float t = 0.0;
    for (int i = 0; i < 64; i++) {
        float d = length(ro + rd * t) - 0.8;
        if (d < 0.001 || t > 8.0) break;
        t += d;
    }
    float glow = 1.0 - smoothstep(2.5, 8.0, t);
    return float4(glow * float3(0.3, 0.6, 1.0), 1.0);
}
```

## Что добавляет Slang

HLSL — привычная математика DirectX; Slang добавляет интерфейсы, generics и автоматическое дифференцирование. Используйте `slang`, когда нужны эти возможности; для простых градиентов достаточно `hlsl`.

```slang
interface IShape { float sdf(float2 p); }
struct Circle : IShape {
    float r;
    float sdf(float2 p) { return length(p) - r; }
}
float4 mainImage(float2 p) {
    float2 uv = (2.0 * p - iResolution.xy) / iResolution.y;
    Circle circle = { 0.5 + 0.1 * sin(iTime) };
    float v = 1.0 - smoothstep(0.0, 0.01, circle.sdf(uv));
    return float4(v, 0.3 * v, 0.7 * v, 1.0);
}
```

```slang
[Differentiable]
float wave(float x) { return sin(x) * x; }
float4 mainImage(float2 p) {
    float x = (p.x / iResolution.x - 0.5) * 6.0;
    DifferentialPair<float> result = fwd_diff(wave)(diffPair(x, 1.0));
    float gradient = 0.5 + 0.1 * result.d;
    return float4(gradient, 1.0 - gradient, 0.4, 1.0);
}
```

`fwd_diff` вычисляет производную в компиляторе, а не численную разность в JavaScript. Линтер и компиляция используют одну обвязку и номера строк исходного блока; сбой самого slangc означает ошибку проверки, а не чистый результат.

## Сверка DirectX

Основная сборка — `slang-2026.19`. Для HLSL можно выбрать `build=dxc-1.9.2609` (статус next): DXC → SPIR-V, spirv-val и SPIRV-Cross → GLSL ES 3.00. Slang в этой сборке не поддержан. DXC работает с `-Od`: так сохраняется простой ограниченный цикл, совместимый со сторожем GLSL. `hlsl_compile` со сборкой DXC и `disassemble:true` дополнительно вернёт shader.spvasm. Диагностика DXC полезна для сверки типов/семантики DirectX; основной линтер всегда Slang.

Четыре HLSL-примера выше можно компилировать и как `language:slang`. Интерфейсы и fwd_diff требуют Slang. Нет гарантии произвольных возможностей HLSL: выход проверяется на совместимость с WebGL2.
## Статьи проектов

Вызывайте `hlsl_compile` с `project` (editor и выше), затем сохраняйте готовый
блок через `project_write`. Шлюз переносит весь набор (`shader.glsl`,
`reflect.json`, `shader.src`, meta и необязательный `shader.spvasm`) ресурсами
того же проекта. `result:` становится относительным путём, временные ссылки
в статье не остаются. Читатель получает сохранённый GLSL без компиляции.

Сверяются исходник, язык, `entry`, `profile` и сборка; изменённый блок требует
пересчёта. Во фрейм передаётся только GLSL, без подписанных URL и meta.
Заверение исполнения приходит из индекса набора; авторская meta его не создаёт.
Внешние include/import, текстуры и файловые входы этим инструментом не поддержаны.
Проектные фоновые задания пока не поддержаны.
