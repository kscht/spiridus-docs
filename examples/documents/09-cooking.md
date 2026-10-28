<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Контуры и карты | теги: кулинария, разделка, птица, утка, курица -->
# Разделка птицы

Части туши — по российской разделке; раскраска — по способу приготовления.

```echarts
{"width":560,"height":460,"title":{"text":"Утка","left":"center","textStyle":{"fontSize":14}},
 "visualMap":{"type":"piecewise","pieces":[{"value":1,"label":"жарка","color":"#c0392b"},{"value":2,"label":"запекание","color":"#e67e22"},{"value":3,"label":"тушение","color":"#b7950b"},{"value":4,"label":"бульон","color":"#2e86c1"}],"orient":"horizontal","left":"center","bottom":0},
 "series":[{"type":"map","map":"утка","top":36,"bottom":40,"label":{"show":true,"fontSize":10,"color":"#fff","textBorderColor":"#333","textBorderWidth":2},
  "data":[{"name":"грудка","value":1},{"name":"бедро","value":2},{"name":"голень","value":2},{"name":"крыло","value":2},{"name":"спинка","value":4},{"name":"шея","value":4},{"name":"гузка","value":4},{"name":"голова","value":4},{"name":"лапки","value":3}]}]}
```

```echarts
{"width":560,"height":460,"title":{"text":"Курица","left":"center","textStyle":{"fontSize":14}},
 "series":[{"type":"map","map":"курица","top":36,"bottom":20,"label":{"color":"#111","textBorderColor":"#fff","textBorderWidth":3,"show":true,"fontSize":10},
  "data":[{"name":"грудка","itemStyle":{"areaColor":"#c0392b"}},{"name":"бедро","itemStyle":{"areaColor":"#e67e22"}},{"name":"крыло","itemStyle":{"areaColor":"#e67e22"}}]}]}
```
