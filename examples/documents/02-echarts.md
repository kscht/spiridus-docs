<!-- Собрано из apps/playground/examples/02-echarts.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: Диаграммы | теги: echarts, столбцы, линия, круговая, граф, климатограмма -->
# ECharts: диаграммы

Настройки — JSON или запись из галереи ECharts (`option = {…}`). Настройки с функциями и вычислениями рисуются живым графиком в песочнице запускателя. Наведите мышь или нажмите на диаграмму — откроется живой график.

```echarts
{"width":560,"height":320,"title":{"text":"Осадки и температура, Москва","left":"center","textStyle":{"fontSize":14}},
 "legend":{"top":36},"xAxis":{"type":"category","data":["янв","фев","мар","апр","май","июн","июл","авг","сен","окт","ноя","дек"]},
 "yAxis":[{"type":"value","name":"мм"},{"type":"value","name":"°C"}],
 "series":[{"name":"осадки, мм","type":"bar","data":[53,44,39,37,61,77,94,77,67,68,56,52]},
  {"name":"температура, °C","type":"line","yAxisIndex":1,"data":[-6.2,-5.9,-0.7,6.9,13.6,17.3,19.7,17.6,11.9,5.8,-0.5,-4.4]}]}
```

Запись из галереи, с объявлением данных:

```echarts
const data = [{ value: 1048, name: 'поиск' }, { value: 735, name: 'прямые' }, { value: 580, name: 'почта' }];
option = { width: 420, height: 300, tooltip: { trigger: 'item' }, series: [{ type: 'pie', radius: ['40%', '70%'], data: data }] };
```

Граф с заданными местами узлов (`"layout":"none"`, `x`, `y`): подписи под узлами, связи их не пересекают.

```echarts
{"width":520,"height":320,"series":[{"type":"graph","layout":"none","label":{"show":true,"position":"bottom","distance":6},"lineStyle":{"color":"#9aa4b2","width":2},
 "data":[{"name":"математика","x":260,"y":40,"symbolSize":30},{"name":"физика","x":110,"y":150,"symbolSize":24},{"name":"информатика","x":410,"y":150,"symbolSize":22},{"name":"химия","x":110,"y":260,"symbolSize":18},{"name":"биология","x":260,"y":260,"symbolSize":18}],
 "links":[{"source":"математика","target":"физика"},{"source":"физика","target":"химия"},{"source":"химия","target":"биология"},{"source":"математика","target":"информатика"}]}]}
```

С кодом — данные считаются на месте, подписи задаёт функция; такой график работает в песочнице:

```echarts
const x = Array.from({ length: 41 }, (_, i) => -2 + i * 0.1);
option = {
  width: 520, height: 300, tooltip: { trigger: 'axis', valueFormatter: (v) => v.toFixed(2) },
  xAxis: { type: 'value', min: -2, max: 2 }, yAxis: { type: 'value' },
  series: [{ type: 'line', showSymbol: false, data: x.map((t) => [t, t * t * t - t]),
    markPoint: { data: [{ coord: [-0.577, 0.385] }, { coord: [0.577, -0.385] }],
      label: { formatter: (p) => p.data.coord[1] > 0 ? 'max' : 'min' } } }]
};
```
