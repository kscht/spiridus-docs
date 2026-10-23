<!-- Собрано из notations/lean/docs.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

# Lean 4: доказательства с проверкой

Блок `lean` содержит программу **Lean 4.34.0** с **Mathlib v4.34.0**.
`lean_check` проверяет её в одноразовой песочнице без сети и возвращает сообщения,
цели до и после тактик, дерево доказательства, зависимости и аксиомы объявлений.
Читатель видит сохранённый результат. Кнопка «проверить» запускает новую проверку;
гость получает пробный результат без сохранения. Повторная проверка того же исходника
и сборки использует кеш. В браузере Lean не исполняется.

## Атрибуты

| Атрибут | Значения | По умолчанию |
|---|---|---|
| `goals` | `all`, `click`, `none` | `all`: цели под строками тактик |
| `messages` | `inline`, `list` | `inline`: сообщения у строк |
| `continue` | без значения | продолжить предыдущую цепочку блоков Lean |
| `hide` | без значения или `imports` | скрыть строки `import` и `open`, продолжая их проверять |
| `tree` | `tree`, `boxes`, `none` | `none`: дерево скрыто |
| `deps` | `block`, `document`, `none` | `none`: граф зависимостей скрыт |
| `build` | имя из `sandbox_builds` | `lean-4.34.0` |

Каждый блок по умолчанию независим. `continue` дописывает код к предыдущему
блоку Lean; между ними можно писать обычный текст. Следующий независимый блок
начинает новую цепочку. При пересчёте передаются все исходники цепочки;
номера строк и сообщения относятся к своему блоку. `continue` у первого блока — ошибка.
Для MCP передайте исходники предыдущих блоков массивом `previous` в `lean_check`.

`deps=document` показывает объявления всей цепочки, `deps=block` — текущего блока.
Рёбра получены из проверенных выражений Lean; внешние зависимости Mathlib доступны
в `declarations[].dependencies` ответа `lean_check`. Цвет соответствует отметке проверки.
Дерево получено из InfoTree: гипотезы, цели до/после, вложенные тактики и закрытые ветки.
Ветви можно раскрывать; нажатие выделяет строку. Предел — 500 шагов с явной пометкой.
При печати цели и содержимое ветвей раскрыты.

## Отметки и сообщения

- «проверено»: Lean принял объявление; только `propext`, `Classical.choice`, `Quot.sound` либо без аксиом.
- «использует sorry»: в транзитивных зависимостях есть `sorryAx` (включая `admit`).
- «свои аксиомы»: перечислены дополнительные аксиомы, в том числе из ранее объявленных лемм.
- «нативное вычисление (native_decide)»: отдельно от стандартной проверки. Lean 4.34.0 создаёт вспомогательные аксиомы `…._native.native_decide.ax_…`; прежний `Lean.ofReduceBool` также распознаётся.
- «ошибка»: файл содержит ошибку; зелёные отметки в таком результате не выдаются.

Сообщения `#eval`, `#check`, `#print` выводятся у соответствующей строки.
Цели имеют вид `гипотезы ⊢ утверждение`; пустое состояние означает «целей нет».
Ошибка доказательства возвращает `ok=false`, сообщения и номера строк; сбой песочницы
или превышение лимита также не считается успешной проверкой. `ok=true` значит только «Lean не нашёл
ошибок»: `sorry` — предупреждение, и `ok` его не меняет. Доказано ли всё, показывает `proved`: `true` —
без ошибок, без `sorry` и только со стандартными аксиомами; иначе `unproved` перечисляет объявления со
статусом (`sorry`, `axioms`, `native_decide`, `error`), `sorryCount` — число `sorry`.

## Импорты и ограничения

Доступны `Init`, `Std`, `Lean`, `Batteries`, `Aesop`, `Mathlib` и их модули из образа.
Имена модулей чувствительны к регистру. Неизвестный импорт выдаёт ошибку;
пакеты Lake, `require` и загрузка дополнительных зависимостей недоступны.
`import Mathlib.Tactic` обычно удобнее общего `import Mathlib`.
Имена лемм зависят от версии: используйте `#check`, `exact?` и `apply?`.

Lean 3 не поддерживается: `begin … end` заменяется на `by`, `λ x,` — на `fun x =>`,
`import data.nat.basic` — на `import Mathlib.Data.Nat.Basic`.
Для кириллического имени используйте экранированный идентификатор, например `theorem «тождество»`.

Лимиты: 60 с на вызов, 6 ГиБ памяти, 256 КиБ кода всей цепочки, до 20 блоков,
вывод REPL до 1 МиБ, 500 узлов дерева. `maxHeartbeats` ограничен 400000,
`maxRecDepth` — 1024. Ноль и превышение заменяются пределом с предупреждением.
Жёсткие лимиты времени и памяти действуют также на `run_cmd`, макросы и `initialize`.
`#eval` с `IO` исполняется внутри песочницы: файлы образа доступны для чтения,
сети и файлов хоста нет. Большой вывод и зависание дают ошибку.
Виджеты ProofWidgets4 и Penrose отложены в отдельную версию: JavaScript из документа
не загружается, интерактивные виджеты в этой версии не показываются.

## Примеры

### Индукция по натуральным

```lean tree=boxes
-- result: artifact:91700277dceaec0e/result.json
-- build: lean-4.34.0
import Mathlib.Tactic

theorem add_zero_right (n : ℕ) : n + 0 = n := by
  induction n with
  | zero => rfl
  | succ k ih => simp
```

### Неравенство

```lean
-- result: artifact:58a8f60ae9e78978/result.json
-- build: lean-4.34.0
import Mathlib.Tactic

theorem square_nonnegative (x : ℝ) : 0 ≤ x ^ 2 := by
  positivity
```

### Функция и вычисление

```lean
-- result: artifact:49794bc7cdb1d7aa/result.json
-- build: lean-4.34.0
import Mathlib.Tactic

def squares (n : ℕ) := (List.range n).map (fun x => x ^ 2)
#eval squares 10
```

### Теорема о списках

```lean
-- result: artifact:d305a9a4eb914b91/result.json
-- build: lean-4.34.0
import Mathlib.Data.List.Basic

theorem append_nil_right (xs : List ℕ) : xs ++ [] = xs := by
  simp
```

### Конечная сумма

```lean tree=tree deps=block
-- result: artifact:79b20e16e81ab889/result.json
-- build: lean-4.34.0
import Mathlib.Tactic

theorem sum_constant (n : ℕ) : ∑ _k ∈ Finset.range n, (1 : ℕ) = n := by
  simp
```

### Литературная цепочка

```lean
-- result: artifact:71c1efa0ee004c98/result.json
-- build: lean-4.34.0
import Mathlib.Tactic

def twice (n : ℕ) := n + n
```

Определение остаётся доступно в следующем блоке:

```lean continue deps=document
-- result: artifact:785a1b306a7dc86a/result.json
-- build: lean-4.34.0
lemma twice_eq (n : ℕ) : twice n = 2 * n := by
  simp [twice, two_mul]
```

## MCP и долгие сеансы

`lean_check({source, previous?, build?})` возвращает `messages`, `goals`, `tree`,
`declarations` с аксиомами и `dependencies`. Поля `block` нумеруются с нуля,
`line` — с единицы. Результат с ключом сохраняется в `result.json`; инструмент
возвращает готовый блок с `-- result: artifact:…/result.json` и `-- build: …`.

При включённых сеансах:

1. `lean_session_open({imports:["Mathlib.Tactic"]})` загружает среду один раз.
2. `lean_session_command({session, source:"example (n : ℕ) : n = n := by sorry"})`
   возвращает `sorries[].proofState`.
3. `lean_session_tactic({session, proofState, tactic:"rfl"})` возвращает новый
   `proofState`, `goals` и `proofStatus`. Для следующего шага нужен новый индекс.
4. `lean_session_goals({session})` повторно показывает последний результат.
5. `lean_session_save({session})` сохраняет приватный пакет `session.json` с журналом команд и тактик
   (до 2 МиБ и 200 команд). Пикл среды не сохраняется: восстановление воспроизводит журнал.
6. `lean_session_close({session})` освобождает память и закрывает сеанс окончательно.
   Чтобы вернуться позже, сначала сохраните snapshot.
   `lean_session_open({from: "upload:<id>/session.json"})` создаёт новый сеанс той же сборки и воспроизводит
   журнал; импорты уже включены. Возвращается последнее состояние с новыми локальными
   индексами. Пакет читает только владелец; версия и образ сборки проверяются.
   Для повторного исполнения на другой сборке нужен явный `rebuild:true`.
   Для восстановления всех состояний тактик
   используется журнал; произвольные загруженные `.olean` не импортируются.
   При простое сеанс автоматически выключается и поднимается по общему механизму.
   Ограничения REPL на scoped extensions не обходятся.
   Закрытое сеансом доказательство переносите в исходник и проверяйте
   через `lean_check`: REPL не подставляет тактики обратно вместо исходного `sorry`.

Память ядра резервируется из общего бюджета сеансов; при нехватке памяти открытие
отклоняется. Гостям долгие сеансы недоступны.


## Виджеты ProofWidgets и Penrose

Сборка `lean-4.34.0-widgets` поддерживает `import ProofWidgets.Component.HtmlDisplay`
и `import ProofWidgets.Component.PenroseDiagram`. `#html` передаёт ограниченные
данные виджета. Поддержаны HtmlDisplay, HtmlDisplayPanel и Penrose.Diagram из
закреплённой сборки ProofWidgets. Остальные компоненты показывают заглушку.

Внутри HTML доступны текст, простые теги, списки, таблицы и `details`/`summary`.
Атрибуты HTML не переносятся; ссылки, скрипты, произвольные SVG-теги и внешние файлы
не поддержаны. Текст и несколько диаграмм в одной панели нужно разделить на отдельные `#html`.
Компоненты с серверным RPC и произвольные JS-модули не загружаются.
Penrose принимает `dsl`, `sty`, `sub`, `embeds` и `maxOptSteps`; встроенные HTML-метки
показываются как SVG-текст. Программа раскладки работает отдельно от страницы.

Пределы: 16 панелей, 64 КиБ данных панели, 512 узлов HTML и глубина 24;
Текст узла — до 8 КиБ; статичный текст HTML — до 4096 символов.
32 встроенные метки (до 400 × 100 точек каждая), 128 фигур, 500 шагов оптимизатора и 15 секунд раскладки.
Готовый SVG — до 256 КиБ. Неизвестные компоненты и превышение пределов объясняются
вместо исполнения. Клик или Enter выделяет фигуру; для печати используется статичный SVG.
Диаграмма показывает переданные параметры: математическое утверждение проверяется
в Lean отдельно, как `CommSq` в следующем примере.

## Коммутативный квадрат

```lean build=lean-4.34.0-widgets
-- result: artifact:b0ea20a8c599ea13/result.json
-- build: lean-4.34.0-widgets
import ProofWidgets.Component.HtmlDisplay
import ProofWidgets.Component.PenroseDiagram
import Mathlib.CategoryTheory.CommSq
import Mathlib.CategoryTheory.Types.Basic
open CategoryTheory
example : CommSq (𝟙 (Nat : Type)) (𝟙 _) (𝟙 _) (𝟙 _) := ⟨rfl⟩

open ProofWidgets
#html Html.ofComponent Penrose.Diagram {
  dsl := "type Obj"
  sty := r#"canvas {
 width = 320
 height = 240
}
forall Obj x {
 x.textBox = Rectangle {
 center:(0,0)
 width:40
 height:28
 fillColor:rgba(1,1,1,1)
 strokeWidth:0
 }
}
forall Obj `a` { override `a`.textBox.center = (-100,75) }
forall Obj `b` { override `b`.textBox.center = (100,75) }
forall Obj `c` { override `c`.textBox.center = (-100,-75) }
forall Obj `d` { override `d`.textBox.center = (100,-75) }
arrows {
 a0 = Line { start:(-75,75)
 end:(75,75)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
 a1 = Line { start:(-100,50)
 end:(-100,-50)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
 a2 = Line { start:(100,50)
 end:(100,-50)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
 a3 = Line { start:(-75,-75)
 end:(75,-75)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
}
"#
  sub := "Obj a, b, c, d"
  embeds := #[("a", Html.text "ℕ"), ("b", Html.text "ℕ"), ("c", Html.text "ℕ"), ("d", Html.text "ℕ")]
  maxOptSteps := 100
} #[]
```

## Строковая диаграмма

```lean build=lean-4.34.0-widgets
-- result: artifact:e04c47d3b464f9c8/result.json
-- build: lean-4.34.0-widgets
import ProofWidgets.Component.HtmlDisplay
import ProofWidgets.Component.PenroseDiagram
def tensorStep (p : Nat × Nat) := (p.1 + 1, p.2 + 1)
example : tensorStep (2, 3) = (3, 4) := rfl

open ProofWidgets
#html Html.ofComponent Penrose.Diagram {
  dsl := "type Obj"
  sty := r#"canvas {
 width = 320
 height = 240
}
forall Obj x {
 x.textBox = Rectangle {
 center:(0,0)
 width:40
 height:28
 fillColor:rgba(1,1,1,1)
 strokeWidth:0
 }
}
forall Obj `a` { override `a`.textBox.center = (-80,80) }
forall Obj `b` { override `b`.textBox.center = (80,80) }
forall Obj `c` { override `c`.textBox.center = (-80,-80) }
forall Obj `d` { override `d`.textBox.center = (80,-80) }
arrows {
 a0 = Line { start:(-80,60)
 end:(-80,18)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
 a1 = Line { start:(80,60)
 end:(80,18)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
 a2 = Line { start:(-80,-18)
 end:(-80,-60)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
 a3 = Line { start:(80,-18)
 end:(80,-60)
 strokeWidth:1.5
 strokeColor:rgba(0,0,0,1)
 endArrowhead:"straight" }
}
operation {
 box = Rectangle {
 center:(0,0)
 width:230
 height:30
 fillColor:rgba(0.9,0.95,1,1)
 strokeColor:rgba(0.2,0.3,0.5,1)
 strokeWidth:1
}
 label = Text {
 center:(0,0)
 string:"succ ⊗ succ"
 fontSize:"16px"
 fillColor:rgba(0,0,0,1)
}
}"#
  sub := "Obj a, b, c, d"
  embeds := #[("a", Html.text "ℕ"), ("b", Html.text "ℕ"), ("c", Html.text "ℕ"), ("d", Html.text "ℕ")]
  maxOptSteps := 100
} #[]
```

