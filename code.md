# Code Mode: JavaScript и Python

`code_run` выполняет код в одноразовой изолированной песочнице, без сети и файлов сервера.
Он доступен в профиле default; профиль lite его не включает. Установки своих пакетов нет.
JavaScript: Node 22.23.3. Python: 3.13.7, numpy 2.2.6, scipy 1.15.3, sympy 1.14.0, pandas 2.2.3.

`language` — `javascript` или `python`, `code` — тело функции с `return`, `task` — необязательное
описание цели для журнала. Итог: `value` (JSON) и `output` (последние 20 000 знаков лога).
Вызовы `spiridus` возвращают `structuredContent`, иначе разобранный JSON или `{result: текст}`.
Картинки в промежуточном ответе исключаются; ссылки на файлы в результате сохраняются.

```javascript
const a = await spiridus.render_block_docs({lang: "dot"});
console.log(a.result.length);
return {documentation: a.result.slice(0, 120)};
```

```python
import spiridus
import sympy as sp
x = sp.Symbol('x')
r = spiridus.render_block_docs({'lang': 'dot'})
print(len(r['result']))
return {'integral': str(sp.integrate(x**2, x)), 'documentation': r['result'][:120]}
```

Для CAD: `a = spiridus.cad_run(...)`, затем `spiridus.cad_recompute(...)` с `ref` из результата,
затем `spiridus.render_check(...)` с документом, ссылающимся на артефакты. Между вызовами можно
проверять объёмы и выбирать параметры; в `return` оставляйте только нужные модели данные.

Пределы: 20 вызовов, строго последовательно (`await` в JavaScript), 300 секунд на весь сценарий,
2 ГБ RAM, 2 CPU; код до 256 КиБ, ответ инструмента до 1000 КиБ. Каждый вложенный вызов проходит
обычные пользовательские квоты, кеш и очередь. Вызовы удаления, публикации, инструменты владельца и вложенный `code_run` недоступны.
`session` разрешён у перечисленных ниже инструментов пошагового CAD и у самого Python `code_run`.
Ошибка инструмента вызывает исключение с её текстом (тем же, что видно при прямом вызове); его можно
обработать, но лимит вызовов не сбрасывается. В Python числа и массивы numpy, таблицы pandas и множества
в аргументах и в `return` переводятся в JSON сами, NaN и бесконечность — в `null`.

Шлюз сам определяет пользователя: `caller`, токены и идентификаторы чужих разговоров передать
нельзя. Код и вложенные вызовы записываются в один разговор (`parent` — id вызова `code_run`);
для просмотра невидимых символов используйте `reveal` в журнале. Код не кешируется.

Ниже `render_block_docs code` добавляет актуальные TypeScript и TypedDict из схем
зарегистрированных инструментов. Недописанные выходные схемы обозначены `unknown`/`Any`.

## Сеансы Python

Сеансы есть, только если сервер их включил: тогда в списке инструментов видны `session_open` и
`session_call`, а у `code_run` — аргумент `session`.

`session_open` без аргументов открывает Python-ядро. Передавайте его `id` как `session` в
`code_run` или `session_call`: переменные, импорты и функции сохраняются между шагами.
JavaScript пока одноразовый. `session_open` принимает также `tool` или конкретный `build` из
`sandbox_builds`; `session_list` показывает свои сеансы и расход минут·ГБ, `session_close` закрывает.

```json
{"session":"<id из session_open>","language":"python","code":"import numpy as np\nx = np.arange(10)\nreturn int(x.sum())"}
```

Следующий `session_call`: `{"session":"<тот же id>","code":"x *= 2\nreturn int(x.sum())"}`.
`return` завершает текущий шаг; определения верхнего уровня остаются в интерпретаторе.

У пользователя не больше двух открытых сеансов, у гостя — ноль. Начальный бюджет — 480 минут·ГБ
в сутки: память оплачивается временем жизни ядра, включая простой. После 15 минут простоя или
двух часов жизни ядро сохраняется и выключается, следующий шаг восстанавливает состояние.
Один шаг сохраняет прежний предел времени сборки; зависание останавливает контейнер.

Python восстанавливается исполнением успешных команд из журнала; явно записанные в `/out` файлы
сохраняются отдельно. Ответы `spiridus.*` при восстановлении берутся из журнала: инструменты второй
раз не вызываются. Для повторяемых вычислений фиксируйте случайные числа и исходные данные;
время и другие недетерминированные операции при повторном исполнении могут дать другой результат.
Ошибка шага сбрасывает частично изменённую память к последнему успешному состоянию; уже выполненные
внешние действия этого шага не отменяются. Журнал ограничен 200 командами и 8 МиБ.

## Пошаговый FreeCAD из Code Mode

В `spiridus` доступны `cad_session_open`, `cad_exec`, `cad_inspect`, `cad_view`, `cad_session_save`,
`session_list`, `session_close`. Создавать вложенный `code_run` или вызывать `session_call` из кода
по-прежнему нельзя. Сеанс Python и сеанс CAD занимают оба доступных места.

```python
cad = spiridus.cad_session_open({})
sid = cad['id']
spiridus.cad_exec({'session': sid, 'code': 'doc = App.ActiveDocument\nbox = doc.addObject("Part::Box", "Box")'})
spiridus.cad_exec({'session': sid, 'code': 'box.Length=10\nbox.Width=20\nbox.Height=30'})
info = spiridus.cad_inspect({'session': sid})
saved = spiridus.cad_session_save({'session': sid})
spiridus.session_close({'session': sid})
return {'objects': info['objects'], 'block': saved['block']}
```

В документ помещайте `block` и ссылки на артефакты, а не идентификатор сеанса.
