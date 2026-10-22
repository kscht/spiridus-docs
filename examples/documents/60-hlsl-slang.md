<!-- Собрано из apps/playground/examples/60-hlsl-slang.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

# Шейдеры HLSL и Slang

```hlsl
// result: artifact:df95145d41246b08/shader.glsl
// build: slang-2026.19
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

```hlsl
// result: artifact:c1ba954bde9ac1fa/shader.glsl
// build: slang-2026.19
float4 mainImage(float2 p) {
    float2 uv = p / iResolution.xy;
    return float4(uv, 0.5 + 0.5 * sin(iTime), 1.0);
}
```

```hlsl
// result: artifact:7ca70c304094f403/shader.glsl
// build: slang-2026.19
float hash(float2 p) { return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453); }
float4 mainImage(float2 p) {
    float2 cell = floor(p / 12.0);
    float n = hash(cell);
    return float4(n, n * 0.7, n * 0.3, 1.0);
}
```

```hlsl
// result: artifact:d57dc402ba1cb121/shader.glsl
// build: slang-2026.19
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

```slang
// result: artifact:39bd40ed46f6a2d4/shader.glsl
// build: slang-2026.19
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
// result: artifact:8472d924d781c6ee/shader.glsl
// build: slang-2026.19
[Differentiable]
float wave(float x) { return sin(x) * x; }
float4 mainImage(float2 p) {
    float x = (p.x / iResolution.x - 0.5) * 6.0;
    DifferentialPair<float> result = fwd_diff(wave)(diffPair(x, 1.0));
    float gradient = 0.5 + 0.1 * result.d;
    return float4(gradient, 1.0 - gradient, 0.4, 1.0);
}
```