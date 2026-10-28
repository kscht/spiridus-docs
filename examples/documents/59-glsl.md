<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

# Шейдеры в документе

Нажмите «▶», чтобы увидеть движение. Во втором примере меняйте радиус и нажимайте на холст.

## Градиент и время

```glsl
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord / iResolution.xy;
  fragColor = vec4(uv, 0.5 + 0.5 * sin(iTime), 1.0);
}
```

## SDF круг и ползунок

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

## Процедурный шум

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

## Raymarching с 48 шагами

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
