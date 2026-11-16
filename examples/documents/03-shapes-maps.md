<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Контуры и карты | теги: анатомия, сердце, химия, таблица Менделеева, география, карта, материки -->
# Контуры и карты

Части рисунка названы, данные красят их по имени — как в примере geo-beef-cuts из галереи ECharts. Автор и лицензия рисунка — под диаграммой.

```echarts
{"width":380,"height":480,"title":{"text":"Сердце: артериальная\nи венозная кровь","left":"center","textStyle":{"fontSize":14}},"visualMap":{"type":"piecewise","pieces":[{"value":1,"label":"артериальная","color":"#c1121f"},{"value":2,"label":"венозная","color":"#1d4ed8"}],"orient":"horizontal","left":"center","bottom":0},"series":[{"type":"map","map":"сердце","top":64,"bottom":40,"label":{"color":"#111","textBorderColor":"#fff","textBorderWidth":3,"show":false,"fontSize":14},"data":[{"name":"аорта","value":1,"label":{"show":true}},{"name":"левый желудочек","value":1,"label":{"show":true,"offset":[8,12]}},{"name":"левое предсердие","value":1},{"name":"правый желудочек","value":2,"label":{"show":true,"offset":[-30,-10]}},{"name":"правое предсердие","value":2},{"name":"лёгочный ствол","value":2,"label":{"show":true}}]}]}
```

Периодическая раскладка и раскраска контура по имени элемента. Полная карта сохраняет положение всех элементов; в каждой ячейке номер расположен над символом. Кнопка «⤢» открывает карту на весь экран. Символ и значение элемента доступны в подсказке; ниже — все 14 заданных значений отдельными строками для сравнения.

```echarts
{"width":380,"height":540,"title":{"text":"Электроотрицательность","left":"center","textStyle":{"fontSize":16}},"visualMap":{"type":"continuous","min":0.7,"max":4,"orient":"horizontal","left":"center","bottom":0,"inRange":{"color":["#2c7bb6","#ffffbf","#d7191c"]}},"tooltip":{"trigger":"item","formatter":"{b}: {c}"},"series":[{"type":"map","map":"таблица Менделеева","top":50,"bottom":75,"label":{"show":true,"fontSize":12,"color":"#111","textBorderColor":"#fff","textBorderWidth":2,"offset":[0,7]},"data":[{"name":"H","value":2.2},{"name":"Li","value":0.98},{"name":"C","value":2.55},{"name":"N","value":3.04},{"name":"O","value":3.44},{"name":"F","value":3.98},{"name":"Na","value":0.93},{"name":"Cl","value":3.16},{"name":"K","value":0.82},{"name":"Fe","value":1.83},{"name":"Cu","value":1.9},{"name":"Br","value":2.96},{"name":"I","value":2.66},{"name":"Cs","value":0.79}],"left":0,"right":0,"aspectScale":1}]}
```

```echarts
{"width":380,"height":520,"title":{"text":"Электроотрицательность","subtext":"Выбранные элементы, шкала Полинга","left":"center","textStyle":{"fontSize":16}},"grid":{"top":72,"bottom":88,"left":42,"right":48},"tooltip":{"trigger":"item","formatter":"{b}: {c}"},"xAxis":{"type":"value","max":4.1},"yAxis":{"type":"category","inverse":true,"data":["H","Li","C","N","O","F","Na","Cl","K","Fe","Cu","Br","I","Cs"]},"visualMap":{"type":"continuous","min":0.7,"max":4,"orient":"horizontal","left":"center","bottom":0,"inRange":{"color":["#2c7bb6","#ffffbf","#d7191c"]}},"series":[{"type":"bar","data":[2.2,0.98,2.55,3.04,3.44,3.98,0.93,3.16,0.82,1.83,1.9,2.96,2.66,0.79],"label":{"show":true,"position":"right","fontSize":12}}]}
```

```echarts
{"width":380,"height":420,"title":{"text":"Материки по площади","left":"center","textStyle":{"fontSize":16}},"visualMap":{"type":"continuous","min":5,"max":55,"orient":"horizontal","left":"center","bottom":0,"inRange":{"color":["#d8f3dc","#40916c","#081c15"]}},"series":[{"type":"map","map":"материки","top":44,"bottom":50,"label":{"color":"#111","textBorderColor":"#fff","textBorderWidth":3,"show":false,"formatter":"{b}\n{c}"},"data":[{"name":"Евразия","value":54.6},{"name":"Африка","value":30.3},{"name":"Северная Америка","value":24.2},{"name":"Южная Америка","value":17.8},{"name":"Антарктида","value":14.1},{"name":"Австралия","value":7.7}]}],"tooltip":{"trigger":"item","formatter":"{b}: {c} млн км²"}}
```

Названия и значения доступны в подсказках карты и в таблице:

| Материк | Площадь, млн км² |
|---|---:|
| Евразия | 54,6 |
| Африка | 30,3 |
| Северная Америка | 24,2 |
| Южная Америка | 17,8 |
| Антарктида | 14,1 |
| Австралия | 7,7 |

Минимальная карта без данных:

```echarts
{"series":[{"type":"map","map":"утка"}]}
```
