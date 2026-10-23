<!-- Собрано из notations/legalruleml/docs.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

# Нормы права — LegalRuleML 1.0

Блок `legalruleml` принимает XML по OASIS LegalRuleML Core Specification 1.0
(OS 30.08.2021), в компактной или нормализованной записи. Он показывает нормы,
источники, формулировки и направленный граф перекрытий. Это представление заданной
модели: блок не устанавливает применимость закона и не выполняет правовой вывод.

В строке забора: `view=table|text|graph|all` (по умолчанию `all`), `lang=ru|en`
(по умолчанию `ru`), `select=ключ` или `select="точный refID источника"`.
Выбор ключа допускает `#`, но не регулярные выражения. После select граф содержит
только выбранные нормы и их источники. Подписи меняют язык, авторский текст сохраняется.

## Минимальный шаблон

```legalruleml
<lrml:LegalRuleML xmlns:lrml="http://docs.oasis-open.org/legalruleml/ns/v1.0/"
                  xmlns:ruleml="http://ruleml.org/spec">
  <lrml:LegalReferences>
    <lrml:LegalReference refersTo="source" refID="Учебный регламент, п. 1"/>
  </lrml:LegalReferences>
  <lrml:Associations>
    <lrml:Association><lrml:appliesSource keyref="#source"/><lrml:toTarget keyref="#norms"/></lrml:Association>
  </lrml:Associations>
  <lrml:Statements key="norms">
    <lrml:PrescriptiveStatement key="consent">
      <ruleml:Rule closure="universal">
        <lrml:Paraphrase>При обработке персональных данных оператор обязан получить согласие субъекта.</lrml:Paraphrase>
        <ruleml:if><ruleml:Atom><ruleml:Rel>Обрабатываются персональные данные</ruleml:Rel></ruleml:Atom></ruleml:if>
        <ruleml:then>
          <lrml:Obligation>
            <ruleml:slot><lrml:Bearer/><ruleml:Ind>Оператор</ruleml:Ind></ruleml:slot>
            <ruleml:Atom><ruleml:Rel>Получить согласие субъекта</ruleml:Rel></ruleml:Atom>
          </lrml:Obligation>
        </ruleml:then>
      </ruleml:Rule>
    </lrml:PrescriptiveStatement>
  </lrml:Statements>
</lrml:LegalRuleML>
```

## Как записать норму

- `PrescriptiveStatement key="..."` — норма; ключ уникален в блоке.
- `ruleml:Rule/ruleml:if` — условие, `ruleml:then` — следствие.
- В `then`: `Obligation` — обязанность, `Permission` — разрешение,
  `Prohibition` — запрет, `Right` — право. Внутри — `ruleml:Atom`,
  его `ruleml:Rel` задаёт действие, `ruleml:Ind` — участника/объект.
- Носитель: `<ruleml:slot><lrml:Bearer/><ruleml:Ind>Сторона</ruleml:Ind></ruleml:slot>`;
  другая сторона — такой же slot с `AuxiliaryParty`. Не помещайте текст внутрь Bearer.
- `lrml:Paraphrase` в Rule — готовая формулировка. Любая разметка внутри читается
  как текст, без HTML. Без Paraphrase формулировка собирается из условия, носителя и действия.
- Источник объявляется `LegalReference refersTo="source" refID="статья, пункт"`.
  `refersTo` объявляет идентификатор; `Association` связывает `appliesSource keyref="#source"`
  с `toTarget keyref="#ключ-нормы"` или ключом группы Statements.
- Сроки: `Times`/`ruleml:Time`, `TemporalCharacteristics`, связь
  `Association/appliesTemporalCharacteristics` с `toTarget`.
  `Context/inScope` также задаёт область метаданных, включая `appliesAssociations`.
- Авторитет и юрисдикция: `Authorities/Authority`, `Jurisdictions/Jurisdiction`,
  ссылки `appliesAuthority` и `appliesJurisdiction` через Association или Context.
- Перекрытие: `<lrml:OverrideStatement><lrml:Override over="#special" under="#general"/></lrml:OverrideStatement>`.
  Стрелка идёт от более сильной нормы к перекрываемой. Циклы запрещены.
  `Defeater` в `hasStrength` отмечает опровержение; ссылки `hasAlternative keyref="#норма"` в `Alternatives`
  показываются как ветви альтернатив; ссылка на Statements задаёт группу норм. Это визуализация отношений, без вычисления победившей нормы.

## Логические выражения, шаблоны и определения

`And`, `Or`, `Neg` и `Naf` сохраняют структуру, в том числе в следствии.
У каждой модальности остаются её носитель, сторона и действие: `(А обязан X или Б вправе Y)`.
Группы показываются в скобках. `Neg` — отрицание «не (…)», `Naf` — отсутствие
сведений «нет сведений, что (…)» / «not known that (…)», когда схема допускает Naf.
Поиск по исходнику и XSD не заменяют проверку смысла автоматически собранного текста.

`ConstitutiveStatement` поддержан и без предписаний: таблица показывает вид
«Определение», а текст — «A означает B» для `if A / then B`, либо «Определение: B».
Для условий и действий поддержаны Atom/Rel, Ind/Var/Data, Expr/Fun и логические
группы. Неизвестные выражения (например, неподдерживаемые кванторы) отклоняются
с названием элемента; они не превращаются в приблизительную формулировку.

`Rule key=":template"` объявляет шаблон; `Rule keyref=":template"` раскрывает его.
У изменённого Rule собственные `if`, `then`, `hasStrength` и Paraphrase заменяют
одноимённые роли шаблона; остальные роли сохраняются. Ссылки без собственного
содержимого раскрываются также в выражениях. Произвольное слияние аргументов и
коллекций через keyref не поддержано: такой шаблон нужно раскрыть явно.
Циклические ссылки — ошибка. `Context/appliesAssociations` сохраняет ограничения
`Association/toTarget`: чужие источники, сроки и юрисдикции не переносятся на норму.
Отдельная временная характеристика задаётся `appliesTemporalCharacteristic`,
коллекция — `appliesTemporalCharacteristics`; обе формы поддержаны.

Лимиты: UTF-8 не больше 256 КиБ, суммарно 500 PrescriptiveStatement,
ConstitutiveStatement и PenaltyStatement, 20000 исходных XML-элементов.
Глубина раскрытия шаблонов — 64, число элементов итоговой модели — не больше 20000.
Раскрытие ограничено также 100000 промежуточных элементов и 4 млн символов копируемого текста.
Запрещены DOCTYPE, объявления сущностей, XInclude, инструкции обработки, xml:base,
xsi:schemaLocation и внешние keyref. Символы `&amp;`, `&lt;` разрешены.
URI в `iri`, `sameAs`, `refID` — только идентификаторы, никогда не загружаются.
Никакие ресурсы из XML не запрашиваются: валидатор использует закреплённые локальные XSD.
Не добавляйте `xsi:schemaLocation` из внешних примеров OASIS.

Ошибки XML, XSD и ключей показываются с номером строки блока.
`lint_check` проверяет той же XSD плюс правила нотации; отсутствие источника — замечание,
остальные ошибки блокируют отображение. `render_check` проверяет SVG графа и представление
на ширинах 760/390. Для больших наборов используйте несколько блоков или `select`.
При печати сохраняются таблица, формулировки и SVG графа в выбранном view.

## Примеры

Примеры учебные, условия намеренно упрощены; это не пересказ всех требований закона.

### Персональные данные: обязанность и исключение

```legalruleml
<lrml:LegalRuleML xmlns:lrml="http://docs.oasis-open.org/legalruleml/ns/v1.0/"
                  xmlns:ruleml="http://ruleml.org/spec">
  <lrml:LegalReferences>
    <lrml:LegalReference refersTo="source" refID="Учебная модель 152-ФЗ, ст. 6 и 9"/>
  </lrml:LegalReferences>
  <lrml:Associations>
    <lrml:Association><lrml:appliesSource keyref="#source"/><lrml:toTarget keyref="#norms"/></lrml:Association>
  </lrml:Associations>
  <lrml:Statements key="norms">
    <lrml:PrescriptiveStatement key="consent">
      <ruleml:Rule closure="universal">

        <ruleml:if><ruleml:Atom><ruleml:Rel>Обработка по согласию</ruleml:Rel></ruleml:Atom></ruleml:if>
        <ruleml:then>
          <lrml:Obligation>
            <ruleml:slot><lrml:Bearer/><ruleml:Ind>Оператор</ruleml:Ind></ruleml:slot>
            <ruleml:Atom><ruleml:Rel>Получить согласие</ruleml:Rel></ruleml:Atom>
          </lrml:Obligation>
        </ruleml:then>
      </ruleml:Rule>
    </lrml:PrescriptiveStatement>
    <lrml:PrescriptiveStatement key="exception">
      <ruleml:Rule closure="universal">

        <ruleml:if><ruleml:Atom><ruleml:Rel>Есть самостоятельное законное основание</ruleml:Rel></ruleml:Atom></ruleml:if>
        <ruleml:then>
          <lrml:Permission>
            <ruleml:slot><lrml:Bearer/><ruleml:Ind>Оператор</ruleml:Ind></ruleml:slot>
            <ruleml:Atom><ruleml:Rel>Обработать на этом основании</ruleml:Rel></ruleml:Atom>
          </lrml:Permission>
        </ruleml:then>
      </ruleml:Rule>
    </lrml:PrescriptiveStatement>
    <lrml:OverrideStatement><lrml:Override over="#exception" under="#consent"/></lrml:OverrideStatement>
  </lrml:Statements>
</lrml:LegalRuleML>
```

### Договор: обязанность и санкция

`PrescriptiveStatement` задаёт обязанность поставки. `PenaltyStatement` описывает
санкцию, а `ReparationStatement/Reparation` связывает её с нарушенной нормой через
`appliesPenalty` и `toPrescriptiveStatement`. Это отличается от самостоятельного
правила с условием «нарушен срок»: связь санкции с обязанностью задана структурно.
`SuborderList` задаёт последовательность: каждая следующая мера применяется при
нарушении предыдущей. В таблице санкция имеет свой вид, в графе — «санкция за»,
в формулировке — «За нарушение delivery — Поставщик обязан …».

```legalruleml
<lrml:LegalRuleML xmlns:lrml="http://docs.oasis-open.org/legalruleml/ns/v1.0/" xmlns:ruleml="http://ruleml.org/spec">
  <lrml:LegalReferences><lrml:LegalReference refersTo="source" refID="Учебный договор, п. 4 и 8"/></lrml:LegalReferences>
  <lrml:Associations><lrml:Association><lrml:appliesSource keyref="#source"/><lrml:toTarget keyref="#norms"/></lrml:Association></lrml:Associations>
  <lrml:Statements key="norms">
    <lrml:PrescriptiveStatement key="delivery">
      <ruleml:Rule><ruleml:if><ruleml:Atom><ruleml:Rel>Наступил срок поставки</ruleml:Rel></ruleml:Atom></ruleml:if>
        <ruleml:then><lrml:Obligation><ruleml:slot><lrml:Bearer/><ruleml:Ind>Поставщик</ruleml:Ind></ruleml:slot><ruleml:Atom><ruleml:Rel>Передать товар</ruleml:Rel></ruleml:Atom></lrml:Obligation></ruleml:then>
      </ruleml:Rule>
    </lrml:PrescriptiveStatement>
    <lrml:PenaltyStatement key="penalty">
      <lrml:SuborderList>
        <lrml:Obligation><ruleml:slot><lrml:Bearer/><ruleml:Ind>Поставщик</ruleml:Ind></ruleml:slot><ruleml:Atom><ruleml:Rel>Уплатить неустойку</ruleml:Rel></ruleml:Atom></lrml:Obligation>
      </lrml:SuborderList>
    </lrml:PenaltyStatement>
    <lrml:ReparationStatement><lrml:Reparation><lrml:appliesPenalty keyref="#penalty"/><lrml:toPrescriptiveStatement keyref="#delivery"/></lrml:Reparation></lrml:ReparationStatement>
  </lrml:Statements>
</lrml:LegalRuleML>
```

### Правило с переходным периодом

```legalruleml
<lrml:LegalRuleML xmlns:lrml="http://docs.oasis-open.org/legalruleml/ns/v1.0/"
                  xmlns:ruleml="http://ruleml.org/spec">
  <lrml:LegalReferences>
    <lrml:LegalReference refersTo="source" refID="Учебный регламент, п. 12"/>
  </lrml:LegalReferences>
  <lrml:Times><ruleml:Time key=":start"><ruleml:Data>2027-01-01</ruleml:Data></ruleml:Time></lrml:Times>
  <lrml:TemporalCharacteristics key="period">
    <lrml:TemporalCharacteristic><lrml:forStatus iri="urn:status:InForce"/><lrml:hasStatusDevelopment iri="urn:status:Starts"/><lrml:atTime keyref="#start"/></lrml:TemporalCharacteristic>
  </lrml:TemporalCharacteristics>
  <lrml:Associations>
    <lrml:Association><lrml:appliesSource keyref="#source"/><lrml:toTarget keyref="#norms"/></lrml:Association>
    <lrml:Association><lrml:appliesTemporalCharacteristics keyref="#period"/><lrml:toTarget keyref="#transition"/></lrml:Association>
  </lrml:Associations>
  <lrml:Statements key="norms">
    <lrml:PrescriptiveStatement key="transition">
      <ruleml:Rule closure="universal">

        <ruleml:if><ruleml:Atom><ruleml:Rel>Заявление подано после переходного периода</ruleml:Rel></ruleml:Atom></ruleml:if>
        <ruleml:then>
          <lrml:Obligation>
            <ruleml:slot><lrml:Bearer/><ruleml:Ind>Заявитель</ruleml:Ind></ruleml:slot>
            <ruleml:Atom><ruleml:Rel>Использовать новую форму</ruleml:Rel></ruleml:Atom>
          </lrml:Obligation>
        </ruleml:then>
      </ruleml:Rule>
    </lrml:PrescriptiveStatement>
  </lrml:Statements>
</lrml:LegalRuleML>
```

### Конфликт и перекрытие

```legalruleml
<lrml:LegalRuleML xmlns:lrml="http://docs.oasis-open.org/legalruleml/ns/v1.0/"
                  xmlns:ruleml="http://ruleml.org/spec">
  <lrml:LegalReferences>
    <lrml:LegalReference refersTo="source" refID="Учебная политика, п. 2 и 3"/>
  </lrml:LegalReferences>
  <lrml:Associations>
    <lrml:Association><lrml:appliesSource keyref="#source"/><lrml:toTarget keyref="#norms"/></lrml:Association>
  </lrml:Associations>
  <lrml:Statements key="norms">
    <lrml:PrescriptiveStatement key="general">
      <ruleml:Rule closure="universal">

        <ruleml:if><ruleml:Atom><ruleml:Rel>Документ содержит закрытые сведения</ruleml:Rel></ruleml:Atom></ruleml:if>
        <ruleml:then>
          <lrml:Prohibition>
            <ruleml:slot><lrml:Bearer/><ruleml:Ind>Сотрудник</ruleml:Ind></ruleml:slot>
            <ruleml:Atom><ruleml:Rel>Раскрывать документ</ruleml:Rel></ruleml:Atom>
          </lrml:Prohibition>
        </ruleml:then>
      </ruleml:Rule>
    </lrml:PrescriptiveStatement>
    <lrml:PrescriptiveStatement key="special">
      <ruleml:Rule closure="universal">

        <ruleml:if><ruleml:Atom><ruleml:Rel>Получено разрешение на раскрытие</ruleml:Rel></ruleml:Atom></ruleml:if>
        <ruleml:then>
          <lrml:Right>
            <ruleml:slot><lrml:Bearer/><ruleml:Ind>Сотрудник</ruleml:Ind></ruleml:slot>
            <ruleml:Atom><ruleml:Rel>Передать согласованную выписку</ruleml:Rel></ruleml:Atom>
          </lrml:Right>
        </ruleml:then>
      </ruleml:Rule>
    </lrml:PrescriptiveStatement>
    <lrml:OverrideStatement><lrml:Override over="#special" under="#general"/></lrml:OverrideStatement>
  </lrml:Statements>
</lrml:LegalRuleML>
```

### Уточнения для ссылок и аргументов

В нормализованной записи аргументы Atom/Expr задаются через `ruleml:arg index="1"`:
порядок определяется index, а не расположением тегов. Индексы должны быть
уникальными, без пропусков, от 1 до числа аргументов. Смешивать явные arg с
неявными аргументами нельзя. В компактной записи без arg сохраняется порядок XML.

Непустой собственный текст вместе с keyref не поддержан: раскройте такую ссылку
явно. Чистые ссылки и изменения ролей Rule работают как описано выше.
Python-линтер кеширует проверенные подграфы ссылок, сохраняет предел глубины 64
и ограничивает обход 100000 посещениями, включая обращения к кешу.

### Вложенные модальности и область формулировок

У вложенной модальности свои Bearer и AuxiliaryParty, например
«Оператор обязан (Получатель вправе удалить данные)». Внешняя модальность
не наследует носителя и сторону внутренней; таблица перечисляет участников
в порядке обхода дерева, а формулировка сохраняет их привязку к модальностям.

Готовый текст всей нормы берётся только из собственного Paraphrase её Rule
(в нормализованном XML — hasParaphrase/Paraphrase). Paraphrase внутри действия
или модальности не заменяет всю норму: условие, носители и модальности
собираются из дерева. Предел глубины 64 учитывает сохранённую глубину подграфа
при каждом обращении к кешу и не зависит от порядка определений.

### Сила нормы и выборка по источнику

Defeater можно указать в hasStrength Rule либо через применимые
Association/appliesStrength или Context/appliesStrength. Во всех случаях
связь Override такой нормы показывается как «опровергает»; ограничение toTarget
и область inScope сохраняются. Разметка Paraphrase не задаёт силу нормы.

select сопоставляется с ключом нормы, ключом источника или полным refID.
Например, `select="Учебный регламент; п. 1"` выбирает полный идентификатор
с точкой с запятой; отдельные части названия совпадением не считаются.
Источник, связанный с ключом Rule, учитывается и при использовании этого Rule
через keyref. Линтер проверяет ключи унаследованных ролей, не перенося источники
из частей шаблона, заменённых собственными if/then производного Rule.
