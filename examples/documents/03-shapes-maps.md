<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Контуры и карты | теги: анатомия, сердце, химия, таблица Менделеева, география, карта, материки -->
# Контуры и карты

Части рисунка названы, данные красят их по имени — как в примере geo-beef-cuts из галереи ECharts. Автор и лицензия рисунка — под диаграммой.

```echarts
{"width":560,"height":480,"title":{"text":"Сердце: артериальная и венозная кровь","left":"center","textStyle":{"fontSize":14}},
 "visualMap":{"type":"piecewise","pieces":[{"value":1,"label":"артериальная","color":"#c1121f"},{"value":2,"label":"венозная","color":"#1d4ed8"}],"orient":"horizontal","left":"center","bottom":0},
 "series":[{"type":"map","map":"сердце","top":40,"bottom":40,"label":{"color":"#111","textBorderColor":"#fff","textBorderWidth":3,"show":false},
  "data":[{"name":"аорта","value":1,"label":{"show":true}},{"name":"левый желудочек","value":1,"label":{"show":true,"offset":[8,12]}},{"name":"левое предсердие","value":1},
          {"name":"правый желудочек","value":2,"label":{"show":true,"offset":[-30,-10]}},{"name":"правое предсердие","value":2},{"name":"лёгочный ствол","value":2,"label":{"show":true}}]}]}
```

```echarts
{"width":680,"height":400,"title":{"text":"Электроотрицательность по Полингу","left":"center","textStyle":{"fontSize":14}},
 "visualMap":{"type":"continuous","min":0.7,"max":4,"orient":"horizontal","left":"center","bottom":0,"inRange":{"color":["#2c7bb6","#ffffbf","#d7191c"]}},
 "series":[{"type":"map","map":"таблица Менделеева","top":40,"bottom":50,"label":{"color":"#111","textBorderColor":"#fff","textBorderWidth":3,"show":true,"fontSize":10},
  "data":[{"name":"H","value":2.2},{"name":"Li","value":0.98},{"name":"C","value":2.55},{"name":"N","value":3.04},{"name":"O","value":3.44},{"name":"F","value":3.98},
          {"name":"Na","value":0.93},{"name":"Cl","value":3.16},{"name":"K","value":0.82},{"name":"Fe","value":1.83},{"name":"Cu","value":1.9},{"name":"Br","value":2.96},{"name":"I","value":2.66},{"name":"Cs","value":0.79}]}]}
```

```echarts
{"width":700,"height":420,"title":{"text":"Материки по площади, млн км²","left":"center","textStyle":{"fontSize":14}},
 "visualMap":{"type":"continuous","min":5,"max":55,"orient":"horizontal","left":"center","bottom":0,"inRange":{"color":["#d8f3dc","#40916c","#081c15"]}},
 "series":[{"type":"map","map":"материки","top":44,"bottom":50,"label":{"color":"#111","textBorderColor":"#fff","textBorderWidth":3,"show":false,"formatter":"{b}\n{c}"},
  "data":[{"name":"Евразия","value":54.6,"label":{"show":true}},{"name":"Африка","value":30.3,"label":{"show":true}},{"name":"Северная Америка","value":24.2,"label":{"show":true}},{"name":"Южная Америка","value":17.8,"label":{"show":true}},{"name":"Антарктида","value":14.1,"label":{"show":true}},{"name":"Австралия","value":7.7,"label":{"show":true}}]}]}
```

Минимальная карта без данных:

```echarts
{"series":[{"type":"map","map":"утка"}]}
```
