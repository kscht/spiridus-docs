<!-- Собрано автоматически из публичной регистрации, профилей и контрактов — правки в основном репозитории Spiridus. -->

# Публичный каталог

Это проекция исходников со всеми перечисленными возможностями, **не подтверждение их включения
на сервере**. Перед публикацией сверяют выложенную версию и её флаги; будущие возможности явно
помечают. Фактические инструменты — `GET /api/v1/tools` и MCP `tools/list`.
Полные аргументы — [arguments.md](arguments.md), назначение — [tools.md](tools.md).

## Инструменты

| Инструмент | REST | Назначение | Описание |
|---|---|---|---|
| `account_delete` | — | Удалить учётную запись Spiridus, её ключи, сайты, загрузки, приватные результаты и опубликованные документы (ссылки /d/… перестанут открываться). | [справка](tools.md#учётная-запись-и-ключи) |
| `account_register` | — | Отправить письмо подтверждения email. Обязателен nickname: 1–64 ASCII знака, буква или цифра по краям, внутри также . _ -. | [справка](tools.md#учётная-запись-и-ключи) |
| `blender_exec` | да | Blender: шаг Python (bpy, load, render, export) в той же сцене и интерпретаторе; переменные сохраняются, return — итог. | [справка](tools.md#долгие-сеансы) |
| `blender_inspect` | да | Blender: объекты сцены — тип, положение, размеры, сетка, материалы; камера и кадр. | [справка](tools.md#долгие-сеансы) |
| `blender_run` | да | Выполнить сценарий Blender на Python (bpy) в изолированной песочнице (без сети, 4 ГБ, 2 ядра, 300 с): рендер Cycles, конвертация и подготовка моделей. | [справка](tools.md#рисование-на-сервере) |
| `blender_session_open` | да | Blender: открыть пустую сцену в памяти (до 2 сеансов, только пользователям). Шаги blender_exec; объекты blender_inspect; кадр blender_view; файлы blender_session_save. | [справка](tools.md#долгие-сеансы) |
| `blender_session_save` | да | Blender: сохранить приватный пакет (ref), STL, scene.blend и сценарий; открыть пакет — blender_session_open {from}. | [справка](tools.md#долгие-сеансы) |
| `blender_view` | да | Blender: кадр Cycles текущей сцены, PNG; без камеры — общий вид всех мешей. | [справка](tools.md#долгие-сеансы) |
| `cad_exec` | да | FreeCAD: выполнить шаг Python в том же документе и интерпретаторе; переменные сохраняются. | [справка](tools.md#долгие-сеансы) |
| `cad_inspect` | да | FreeCAD: дерево объектов, свойства, объёмы, габариты и валидность текущей модели. | [справка](tools.md#долгие-сеансы) |
| `cad_recompute` | да | Пересчитать FCStd (model до 32 МБ): params — ячейка Spreadsheet → число или строка с единицей, {} — текущие. Ответ: тела, файлы и block. Справка — render_block_docs freecad. | [справка](tools.md#рисование-на-сервере) |
| `cad_run` | да | FreeCAD: Python → тела, параметры, STL/STEP/FCStd и block. Без сети. Справка — render_block_docs freecad; пересчёт — cad_recompute. | [справка](tools.md#рисование-на-сервере) |
| `cad_session_open` | да | 2 сеанса, только пользователям; cad_exec/cad_inspect/cad_view; из cad_session_save. | [справка](tools.md#долгие-сеансы) |
| `cad_session_save` | да | FreeCAD: сеанс — в свои файлы (ref, cad_session_open {from}); STL, STEP, FCStd, сценарий, блок документа. | [справка](tools.md#долгие-сеансы) |
| `cad_view` | да | FreeCAD: проекция top/front/right в SVG. | [справка](tools.md#долгие-сеансы) |
| `code_run` | да | Code Mode исполняет JavaScript/Python с проверенными tools; выключенный по умолчанию пилот SQLite даёт временные ручки одного Python-сеанса без переноса и автоматического сохранения. Чтение вне inputs закрыто без учёта регистра имён, включая COUNT(*) и встроенные виртуальные таблицы. Отклонённый запрос с подтверждённым откатом сохраняет сеанс и прежние ручки. Чтение одного ProjectSource в Code Mode за отдельным флагом, с происхождением и общими бюджетами. | [справка](tools.md#сценарии-code-mode) |
| `comfy_generate` | да | Явная генерация txt2img: source — YAML блока comfy; definition — необязательный блок comfy-workflow для #id@версии. Только объявленные параметры и модели манифеста; картинки на входе и цепочки следующим этапом. | [справка](tools.md#рисование-на-сервере) |
| `document_delete` | да | Удалить свой опубликованный документ со всей историей версий: ссылка /d/&lt;id&gt; перестанет открываться у всех. Вызывайте, только если пользователь сам попросил. | [справка](tools.md#поделиться-документом) |
| `document_share` | да | Новая версия своего опубликованного документа /d по его id (documents_list): та же ссылка, прежние версии остаются в истории (ссылка с ?v=&lt;версия&gt;). Сначала проверьте документ render_check. | [справка](tools.md#поделиться-документом) |
| `documents_catalog` | да | Ссылка на страницу-каталог всех документов, опубликованных document_share: заголовок со ссылкой, о чём (начало текста), когда изменён, сколько версий, ✎ — в живой редактор. | [справка](tools.md#поделиться-документом) |
| `documents_list` | да | Документы, опубликованные document_share: id, ссылка, заголовок, когда изменён, сколько версий; kind: catalog — каталог (documents_catalog). Одной ссылкой для пользователя — documents_catalog. | [справка](tools.md#поделиться-документом) |
| `ffmpeg_run` | да | HLS 720p ≤10 мин. CPU: blob: ≤5 ГиБ, прочее ≤32 МиБ; CAS → private:. Синхронно 300 с, фон CPU ≤2 ч. ffmpeg-7.1.5-nvenc: общий GPU вне проектов, вход ≤32 МиБ виден администраторам — конфиденциальное запрещено. | [справка](tools.md#рисование-на-сервере) |
| `files_delete` | да | Удалить загрузку по id (из upload:&lt;id&gt;/&lt;имя&gt;) или полной ссылке blob:sha256/&lt;хеш&gt;. Результаты, уже посчитанные из неё, остаются. | [справка](tools.md#свои-файлы) |
| `files_list` | да | Свои upload: и blob:sha256/&lt;хеш&gt;, размеры и место. Удалить — files_delete. | [справка](tools.md#свои-файлы) |
| `files_publish` | да | Скопировать свой private:&lt;id&gt;/&lt;имя&gt; из Code Mode или загруженную картинку/шрифт upload:&lt;id&gt;/&lt;имя&gt; в общие результаты и получить artifact:&lt;id&gt;/&lt;имя&gt; для документа. Предел — 10 МиБ, включая private:. | [справка](tools.md#свои-файлы) |
| `files_unpublish` | да | Убрать картинку, опубликованную files_publish: ссылка artifact:&lt;id&gt;/&lt;имя&gt; перестанет работать у всех, в документах вместо неё — заглушка. Свою загрузку upload:… это не трогает. | [справка](tools.md#свои-файлы) |
| `files_upload` | да | Файл: name + data_base64 (≤10 МБ) → upload:. Большой: name + size (байты) → PUT/parts в S3; action=finish/status/cancel с upload_id, finish → blob:sha256/&lt;хеш&gt;. Только вам. | [справка](tools.md#свои-файлы) |
| `fonts_list` | да | Какие шрифты есть. site — шрифты сайта (пакет data/fonts): свои Timashkovy GOST по ГОСТ 2.304-81 (own: true, состояние state и наборы знаков sets — сколько знаков кириллицы, латиницы, цифр… уже нарисовано) и сторонние… | [справка](tools.md#сборки-песочниц-версии-программ) |
| `hdl_sim` | да | Промоделировать тестбенч в песочнице без сети: Icarus Verilog 12 (-g2012, по умолчанию для Verilog), Verilator 5 (--binary --timing), GHDL 5 (VHDL). | [справка](tools.md#рисование-на-сервере) |
| `hdl_synth` | да | Синтез Verilog/SystemVerilog/VHDL без сети. Результат: схема RTL (SVG), схема DigitalJS с переключателями, ресурсы ПЛИС и проверки. Блок hdl — схема с исходником; схема DigitalJS интерактивна. | [справка](tools.md#рисование-на-сервере) |
| `hlsl_compile` | да | Компилирует HLSL/Slang mainImage в GLSL ES 3.00. Возвращает файлы, диагностику и блок result:. Синтаксис: render_block_docs hlsl/slang. | [справка](tools.md#рисование-на-сервере) |
| `image_view` | да | Уменьшенная копия PNG, JPEG или SVG до 20 МиБ по artifact:, private:, upload: или blob: — например кадр рендера из job_status. Сторона до 1024 px, ответ до 192 КиБ. | [справка](tools.md#фоновые-задания) |
| `invitations` | да | Свои приглашения (action "list") и ответ на них: "accept" или "decline" по id — только по просьбе приглашённого. | [справка](tools.md#проекты) |
| `job_cancel` | да | Отменить своё задание; ответ — статус и метаданные без результата. Контейнер удаляется, внешние действия не откатываются. | [справка](tools.md#фоновые-задания) |
| `job_status` | да | Состояние и результат своего задания. Доступен в projects и jobs. wait — ждать завершения до 30 с; большой ответ — private:, картинки — image_ref (посмотреть — image_view). | [справка](tools.md#фоновые-задания) |
| `key_revoke` | — | Отозвать свой ключ: which — id из keys_list, others — все, кроме ключа этого клиента, all — все сразу (при утечке; новый основной ключ — повторной регистрацией). | [справка](tools.md#учётная-запись-и-ключи) |
| `keys_list` | — | Ключи своей учётной записи без секретов: имя, начало ключа, права, адреса, срок, последнее использование; current — ключ этого клиента. Чужие lastIp — только основным ключом. | [справка](tools.md#учётная-запись-и-ключи) |
| `lean_check` | да | Lean 4/Mathlib: сообщения и цели. previous — continue. ok=false — ошибка; proved=true — без ошибок, sorry и нестандартных аксиом; unproved — недоказанное. render_block_docs lean. | [справка](tools.md#проверка) |
| `lean_session_close` | да | Lean: закрыть сеанс и освободить память | [справка](tools.md#долгие-сеансы) |
| `lean_session_command` | да | Lean: объявление, #check, exact? или apply? в загруженной среде | [справка](tools.md#долгие-сеансы) |
| `lean_session_goals` | да | Lean: последние цели и сообщения | [справка](tools.md#долгие-сеансы) |
| `lean_session_open` | да | Lean: открыть REPL с импортами или восстановить пакет из lean_session_save | [справка](tools.md#долгие-сеансы) |
| `lean_session_save` | да | Lean: приватный пакет команд и файлов; ref открывается lean_session_open или session_open {from} | [справка](tools.md#долгие-сеансы) |
| `lean_session_tactic` | да | Lean: шаг тактики из proofState (из sorry или предыдущего шага) | [справка](tools.md#долгие-сеансы) |
| `lint_check` | да | Статическая проверка синтаксиса и правил линтерами без отрисовки. Передайте code с lang либо markdown/markdown_file; text:true включает русский текст. Ответ: clean, issues {line,lang,tool,rule,text,hint}. | [справка](tools.md#проверка) |
| `modelica_run` | да | Рассчитать модель Modelica в OpenModelica 1.27.1 со стандартной библиотекой Modelica 4.1 в изолированной песочнице (без сети, 1,5 ГБ, 180 с). | [справка](tools.md#рисование-на-сервере) |
| `modelica_session_open` | да | Modelica: собрать модель один раз (до 2 сеансов, только пользователям); дальше modelica_simulate с другими параметрами без пересборки. Ответ — изменяемые параметры. | [справка](tools.md#долгие-сеансы) |
| `modelica_session_save` | да | Modelica: приватный пакет модели, параметров, последнего CSV и шагов; открыть — modelica_session_open {from}. | [справка](tools.md#долгие-сеансы) |
| `modelica_simulate` | да | Modelica: расчёт собранной модели сеанса с другими параметрами без пересборки; result.csv и строки блока \`\`\`modelica. | [справка](tools.md#долгие-сеансы) |
| `plantuml_run` | да | Нарисовать схему PlantUML (UML, C4, nwdiag, mindmap, Ганта, JSON, графики @startchart…) в песочнице: PlantUML 1.2026.9 (сборка Apache-2.0, без &lt;latex&gt;), Graphviz, без сети. | [справка](tools.md#рисование-на-сервере) |
| `project_admin` | да | confirm — slug проекта, без него ничего не меняется. rename (title) — владелец или админ. | [справка](tools.md#проекты) |
| `project_comments` | да | Обсуждения выделенного текста: list (path необязателен, status open/resolved), add (path, base, body и anchor с exact/prefix/suffix или line), reply (id либо source ручной пометки), resolve/reopen. | [справка](tools.md#проекты) |
| `project_datasource` | да | SQLite и JSONL(.gz/.zst), REST за отдельным флагом. | [справка](tools.md#project_datasource) |
| `project_git_import` | да | Импорт из HTTPS git: configure — url, branch, subdir и mode (public — публичный GitHub без токена; token — личный read-only GitLab); settings; token/revoke; public_access — свой анонимный доступ. | [справка](tools.md#проекты) |
| `project_hide` | да | Убрать статьи из main одним коммитом: в истории они остаются, вернуть — project_write op "restore" с прежней version. base — commit из project_read. | [справка](tools.md#проекты) |
| `project_import` | да | Скопировать последнюю версию своего /d/&lt;id&gt; в новую статью path проекта одним коммитом от вашего имени. Чужой /d и занятый путь — отказ. | [справка](tools.md#проекты) |
| `project_members` | да | Участники и роли (action "list"); "role" — сменить роль участника (member, role); "remove" — исключить; "leave" — выйти самому (владелец — сначала передача); "journal" — журнал проекта: приглашения, роли, передачи… | [справка](tools.md#проекты) |
| `project_publish` | да | За PUBLIC_SITES_ENABLED: admin/owner меняют YAML-видимость с base, читают источник наследования и состояние снимка, проверяют полный plan и подтверждают publish/update/unpublish; update папки включает новые разрешённые статьи. Отдельные source/generation для rotate/revoke, без токенов в status; share/unshare сохраняют метки без старой публикации, shared/sharing показывают их состояние, для нового манифеста внешняя выдача закрыта; перенос прежних сайтов выполняет отдельно включаемая локальная команда lead без членства в проекте, с реальным инициатором в журнале/авторстве, dry-run и одним коммитом пометок без изменения остального YAML/текста, отзывом старой выдачи и пустым манифестом; явный republish подтверждает полный план прежнего набора, новые link-ссылки выдаются отдельно от отчёта. CLI показывает безопасную причину отказа плана: для закрытых результатов — статью и пути, без автоматического открытия ресурсов; допуск согласуют до переноса. Команда не меняет флаги production. Публичная страница показывает загрузку и ограничивает чтение 30 секундами с подсказкой повтора; уход отменяет чтение, текст не ждёт полного состава результатов. | [справка](tools.md#проекты) |
| `project_read` | да | За выключенным PROJECT_THEMES_ENABLED подготовлен общий каркас /p/ и публичного читателя; публичное закрепление и редактор остаются следующими шагами. Темы spiridus/theme.json и spiridus/theme.public.json в папках: read возвращает текст JSON в content без URL/ref; дерево помечает theme: true. За PUBLIC_SITES_ENABLED op visibility читает явную и действующую видимость с источником, ревизией политики и опубликованной версией для участника. | [справка](tools.md#проекты) |
| `project_search` | да | Поиск ru/en по видимым статьям и коду головы main, reader+. Цитаты untrusted, для клиента/LLM; путь, строки, commit и coverage. Без гостей, истории, Code Mode и текстов в журнале. Справка: render_block_docs projects. Чтение одного ProjectSource в Code Mode за отдельным флагом, с происхождением и общими бюджетами. | [справка](tools.md#проекты) |
| `project_stats` | да | Статистика публичного сайта: read — дневные счётчики статей отдельно для людей и роботов; только текущий владелец проекта. settings с enabled включает или выключает сбор проекта; по умолчанию выключен. | [справка](tools.md#проекты) |
| `project_suggestions` | да | CriticMarkup: list, accept/reject одного (start/end/raw), accept-all/reject-all, withdraw своего, finalize. | [справка](tools.md#проекты) |
| `project_write` | да | Запись статей и ресурсов; темы JSON при PROJECT_THEMES_ENABLED, закрепление общих ресурсов и update=auto при PROJECTS_SHARED. | [справка](tools.md#проекты) |
| `projects` | да | Проекты, где вы участник (с ролью), ваши ожидающие приглашения и предложения передать вам владение. | [справка](tools.md#проекты) |
| `qet_call` | да | Один вызов инструмента собственного MCP-сервера QElectroTech (список и аргументы — qet_tools) в песочнице без экрана и сети, по протоколу MCP. | [справка](tools.md#рисование-на-сервере) |
| `qet_run` | да | QElectroTech: нарисовать электрическую схему или символ без сети. Ответ: оценка раскладки, замечания, PNG, файлы и блок qet. Синтаксис — render_block_docs qet. | [справка](tools.md#рисование-на-сервере) |
| `qet_save` | да | Без files — приватный пакет всей папки (ref), открыть session_open {from}. С files — ещё файлы для документа. | [справка](tools.md#рисование-на-сервере) |
| `qet_symbols` | да | Поиск символа в библиотеке QElectroTech (8839 элементов): по названию на любом языке, без учёта регистра и ударений, по типу (kind: coil, protection…), связи (link_type: master, slave, terminal…) и числу выводов. | [справка](tools.md#рисование-на-сервере) |
| `qet_tools` | да | Инструменты собственного MCP-сервера QElectroTech, которые работают в песочнице (qet_edit, qet_conductors, qet_layout_check, qet_check, qet_continuity, qet_element_build, qet_export…; без живого режима и хранилища… | [справка](tools.md#рисование-на-сервере) |
| `quantum_run` | да | Разобрать и промоделировать квантовую схему OpenQASM 2.0 или 3.0 в песочнице без сети: Qiskit 2.5 рисует схему (circuit.svg), считает вектор состояния (вероятности, амплитуды до 6 кубитов, исходы измерений —… | [справка](tools.md#рисование-на-сервере) |
| `render_block_docs` | да | Справка по блоку: что пишется внутри fenced-блока, ограничения, пример. lang — язык блока из render_blocks (либо тема check, code, media, sandbox, markdown, projects). | [справка](tools.md#справка-и-примеры) |
| `render_blocks` | да | Какие fenced-блоки Markdown рисует рендер Spiridus (tikz, echarts, smiles, mol3d, abc, razbor, svg) и картинки из внешних источников. Синтаксис блока — render_block_docs. | [справка](tools.md#справка-и-примеры) |
| `render_check` | да | Chromium: раскладка, подписи, interact. markdown/markdown_file — документ; project и path — статья. project целиком или с paths — фоновая проверка; since — изменения и зависимости; ответ job, отчёт через job_status. | [справка](tools.md#проверка) |
| `render_examples` | да | Найти готовые примеры блоков, которые проходят render_check, и рецепты починки замечаний. | [справка](tools.md#справка-и-примеры) |
| `render_icons` | да | Наборы иконок для живых схем: affinity (сетевые — маршрутизаторы, коммутаторы, серверы, абоненты; цветные квадраты, -green/-red/-gray, -line контуром), affinity-circle (те же в круге), mdi (Material: устройства, сети,… | [справка](tools.md#справка-и-примеры) |
| `render_media` | да | Картинки с Викисклада, которые уже лежат в пакете media и покажутся в документе: ключ, страница, автор, лицензия. В документе пишется ![подпись]\(страница). | [справка](tools.md#справка-и-примеры) |
| `render_recipes` | да | Как чинить замечания render_check (label-crossed, label-tight, label-overlap, label-outside, label-small, label-contrast, image-contrast, table-broken) в конкретной библиотеке: mermaid, d2, dot, echarts, bpmn, plantuml,… | [справка](tools.md#справка-и-примеры) |
| `render_shapes` | да | Контуры и карты пакета shapes для диаграмм echarts ("type":"map", "map":"&lt;имя&gt;"): имена, названия частей (их и красят данными), автор и лицензия. query — фильтр по имени, названию, тегу или части. | [справка](tools.md#справка-и-примеры) |
| `sandbox_builds` | да | Сборки песочниц: версия программы, модули и варианты (верстаки, плагины, опции компиляции). Состояния: default — последняя основная, stable — рабочий вариант, next — на пробу. | [справка](tools.md#сборки-песочниц-версии-программ) |
| `search` | — | Найти инструмент каталога или получить его точную сигнатуру; внешний инструмент только профилей Code Mode. | [справка](tools.md#сценарии-code-mode) |
| `session_call` | да | Python: как code_run, tools — инструменты, return — итог. Команды остальных ядер — по договору сборки. | [справка](tools.md#долгие-сеансы) |
| `session_close` | да | Закрыть свой долгий сеанс и освободить его ресурсы. | [справка](tools.md#долгие-сеансы) |
| `session_list` | да | Свои открытые сеансы. | [справка](tools.md#долгие-сеансы) |
| `session_open` | да | Python/нотация: только пользователям, до двух сеансов. Сборки: sandbox_builds. | [справка](tools.md#долгие-сеансы) |
| `session_save` | да | Сеанс ядра в свои приватные файлы; открыть — session_open {from}. | [справка](tools.md#долгие-сеансы) |
| `source_attach` | да | Подключение файлового пилота или сохранённого Source и отключение с проверкой прав и ревизии. | [справка](tools.md#source_) |
| `source_browse` | да | Обзор папок проекта или Manifest сохранённого снимка с пагинацией. | [справка](tools.md#source_) |
| `source_cache` | да | Просмотр свежести, прогрев проверенных объектов и вытеснение кеша без удаления pin и цитат. | [справка](tools.md#source_) |
| `source_catalog` | да | Источники проекта и доступные действия роли: каталог проекта, файлов данных и сохранённых Source. | [справка](tools.md#source_) |
| `source_cite` | да | Открытие цитаты проекта или сохранённого источника с проверкой версии и происхождения. | [справка](tools.md#source_) |
| `source_describe` | да | Описание проекта, сохранённого Source или схемы файла данных с учётом прав читателя. | [справка](tools.md#source_) |
| `source_manage` | да | Настройка операций, политики ролей, режима хранения и закреплённого снимка с проверкой ревизии. | [справка](tools.md#source_) |
| `source_query` | да | Запрос к файлу данных через прежний обработчик project_datasource и его права. | [справка](tools.md#source_) |
| `source_read` | да | Пакетное чтение до 50 текстовых объектов одного снимка без выдачи бинарных данных. Чтение одного ProjectSource в Code Mode за отдельным флагом: происхождение, общий бюджет с project_read/helpers, проверка ключа каждого шага. Erase отменяет поток и начальный допуск восстановленной очереди; ожидание до 10 с, затем 503 и повтор стирания. | [справка](tools.md#source_) |
| `source_search` | да | Поиск по голове main проекта с проверкой роли и ссылками на цитаты. | [справка](tools.md#source_) |
| `source_snapshot` | да | Сохранение результата запроса, материализация или обновление снимка источника с контролем ревизии. | [справка](tools.md#source_) |
| `source_write` | да | Запись в проект через прежний project_write; hosted-запись сохранённых Source пока недоступна. | [справка](tools.md#source_) |
| `spiridus_feedback` | да | Сообщить владельцу об ошибке Spiridus: сбое инструмента, рендера или проверки, неверной/неполной справке, недостающей возможности. Ошибки собственного документа и обычные вопросы сюда не отправляйте. | [справка](tools.md#справка-и-примеры) |
| `structurizr_run` | да | Проверить Structurizr DSL и нарисовать его виды в песочнице: Structurizr CLI выгружает виды в C4-PlantUML, PlantUML рисует; без сети. Каждому виду нужен autolayout. | [справка](tools.md#рисование-на-сервере) |
| `text_parse` | да | Разобрать предложения одним или несколькими синтаксическими анализаторами в песочнице text.run: дерево зависимостей, часть речи, лемма и признаки — в формате CoNLL-U (Universal Dependencies). | [справка](tools.md#рисование-на-сервере) |
| `tools` | — | Набор: list/use/add/remove/current; пресеты: save/delete/default. | [справка](tools.md#набор-инструментов-mcp) |
| `tts_run` | да | Синтезировать русский/английский текст выбранной моделью. model: yandex — только владельцу; текст блока отправляется во внешний сервис Яндекса, синтезированная речь, Yandex SpeechKit. | [справка](tools.md#рисование-на-сервере) |

## Профили и пресеты

Начальные каталоги учётной записи с ключом. Динамическое подключение через `tools`,
права ключа, анонимный вход и пользовательские пресеты проверяются отдельно:
[выбор адреса](mcp.md#выбор-адреса). `execute` — внешнее имя `code_run`.
У Code Mode предметный пресет задаёт приоритет поиска; вложенные вызовы этим списком не ограничены.
В каждой строке — реальный результат преобразования профиля, включая исключения пресета.

| Адрес | Инструменты |
|---|---|
| `/mcp` | `tools`, `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `files_delete`, `document_share`, `documents_list`, `documents_catalog`, `document_delete`, `lint_check`, `render_check`, `projects`, `code_run`, `account_register`, `account_delete`, `keys_list`, `key_revoke` |
| `/mcp/default` | `tools`, `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `files_delete`, `document_share`, `documents_list`, `documents_catalog`, `document_delete`, `lint_check`, `render_check`, `projects`, `code_run`, `account_register`, `account_delete`, `keys_list`, `key_revoke` |
| `/mcp/code` | `search`, `execute`, `account_register`, `account_delete` |
| `/mcp/lite` | `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `document_share`, `lint_check`, `render_check`, `account_register`, `account_delete` |
| `/mcp/p/cad` | `tools`, `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `files_delete`, `document_share`, `documents_list`, `documents_catalog`, `document_delete`, `sandbox_builds`, `lint_check`, `render_check`, `projects`, `code_run`, `cad_run`, `cad_recompute`, `account_register`, `account_delete`, `keys_list`, `key_revoke` |
| `/mcp/code/p/cad` | `search`, `execute`, `account_register`, `account_delete` |
| `/mcp/p/cad-steps` | `tools`, `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `files_delete`, `document_share`, `documents_list`, `documents_catalog`, `document_delete`, `sandbox_builds`, `lint_check`, `render_check`, `session_list`, `session_close`, `projects`, `code_run`, `cad_session_open`, `cad_exec`, `cad_inspect`, `cad_view`, `cad_session_save`, `account_register`, `account_delete`, `keys_list`, `key_revoke` |
| `/mcp/code/p/cad-steps` | `search`, `execute`, `account_register`, `account_delete` |
| `/mcp/p/diagrams` | `tools`, `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `render_icons`, `render_recipes`, `render_media`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `files_delete`, `document_share`, `documents_list`, `documents_catalog`, `document_delete`, `fonts_list`, `lint_check`, `render_check`, `projects`, `code_run`, `render_shapes`, `plantuml_run`, `structurizr_run`, `account_register`, `account_delete`, `keys_list`, `key_revoke` |
| `/mcp/code/p/diagrams` | `search`, `execute`, `account_register`, `account_delete` |
| `/mcp/p/docs` | `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `document_share`, `lint_check`, `render_check`, `account_register`, `account_delete` |
| `/mcp/code/p/docs` | `search`, `execute`, `account_register`, `account_delete` |
| `/mcp/p/electric` | `tools`, `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `files_delete`, `document_share`, `documents_list`, `documents_catalog`, `document_delete`, `sandbox_builds`, `lint_check`, `render_check`, `projects`, `code_run`, `qet_run`, `qet_tools`, `qet_call`, `qet_save`, `qet_symbols`, `account_register`, `account_delete`, `keys_list`, `key_revoke` |
| `/mcp/code/p/electric` | `search`, `execute`, `account_register`, `account_delete` |
| `/mcp/p/electronics` | `tools`, `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `files_delete`, `document_share`, `documents_list`, `documents_catalog`, `document_delete`, `sandbox_builds`, `lint_check`, `render_check`, `projects`, `code_run`, `hdl_synth`, `hdl_sim`, `account_register`, `account_delete`, `keys_list`, `key_revoke` |
| `/mcp/code/p/electronics` | `search`, `execute`, `account_register`, `account_delete` |
| `/mcp/p/graphics` | `tools`, `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `ffmpeg_run`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `image_view`, `files_delete`, `document_share`, `documents_list`, `documents_catalog`, `document_delete`, `sandbox_builds`, `lint_check`, `render_check`, `session_list`, `session_close`, `projects`, `code_run`, `comfy_generate`, `hlsl_compile`, `blender_run`, `blender_session_open`, `blender_exec`, `blender_inspect`, `blender_view`, `blender_session_save`, `account_register`, `account_delete`, `keys_list`, `key_revoke` |
| `/mcp/code/p/graphics` | `search`, `execute`, `account_register`, `account_delete` |
| `/mcp/p/jobs` | `tools`, `spiridus_feedback`, `job_status`, `job_cancel`, `render_examples`, `render_blocks`, `render_block_docs`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `image_view`, `files_delete`, `document_share`, `documents_list`, `documents_catalog`, `document_delete`, `lint_check`, `render_check`, `projects`, `code_run`, `account_register`, `account_delete`, `keys_list`, `key_revoke` |
| `/mcp/code/p/jobs` | `search`, `execute`, `account_register`, `account_delete` |
| `/mcp/p/modelica` | `tools`, `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `files_delete`, `document_share`, `documents_list`, `documents_catalog`, `document_delete`, `sandbox_builds`, `lint_check`, `render_check`, `session_list`, `session_close`, `projects`, `code_run`, `modelica_run`, `modelica_session_open`, `modelica_session_save`, `modelica_simulate`, `account_register`, `account_delete`, `keys_list`, `key_revoke` |
| `/mcp/code/p/modelica` | `search`, `execute`, `account_register`, `account_delete` |
| `/mcp/p/projects` | `tools`, `spiridus_feedback`, `job_status`, `render_examples`, `render_blocks`, `render_block_docs`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `files_delete`, `lint_check`, `render_check`, `project_stats`, `project_datasource`, `projects`, `project_read`, `project_suggestions`, `project_comments`, `project_search`, `project_write`, `project_hide`, `project_members`, `invitations`, `project_publish`, `project_admin`, `code_run` |
| `/mcp/code/p/projects` | `search`, `execute`, `account_register`, `account_delete` |
| `/mcp/p/proofs` | `tools`, `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `files_delete`, `document_share`, `documents_list`, `documents_catalog`, `document_delete`, `sandbox_builds`, `lint_check`, `render_check`, `projects`, `code_run`, `lean_check`, `lean_session_open`, `lean_session_command`, `lean_session_tactic`, `lean_session_goals`, `lean_session_save`, `lean_session_close`, `account_register`, `account_delete`, `keys_list`, `key_revoke` |
| `/mcp/code/p/proofs` | `search`, `execute`, `account_register`, `account_delete` |
| `/mcp/p/quantum` | `tools`, `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `files_delete`, `document_share`, `documents_list`, `documents_catalog`, `document_delete`, `sandbox_builds`, `lint_check`, `render_check`, `projects`, `code_run`, `quantum_run`, `account_register`, `account_delete`, `keys_list`, `key_revoke` |
| `/mcp/code/p/quantum` | `search`, `execute`, `account_register`, `account_delete` |
| `/mcp/p/sources` | `tools`, `spiridus_feedback`, `render_examples`, `render_blocks`, `render_block_docs`, `files_upload`, `files_publish`, `files_unpublish`, `files_list`, `files_delete`, `lint_check`, `render_check`, `projects`, `source_catalog`, `source_describe`, `source_browse`, `source_read`, `source_search`, `source_cite`, `source_query`, `source_snapshot`, `source_write`, `source_attach`, `source_manage`, `source_cache`, `code_run` |
| `/mcp/code/p/sources` | `search`, `execute`, `account_register`, `account_delete` |

| Пресет | Назначение |
|---|---|
| `cad` | FreeCAD: модель сценарием на Python и пересчёт готовой модели с другими параметрами. |
| `cad-steps` | Сеанс FreeCAD: открыть, добавлять объекты, смотреть дерево и вид, сохранить; там, где включены сеансы. |
| `diagrams` | PlantUML, Structurizr (C4), контуры ECharts, иконки, картинки, шрифты и рецепты починки рендера. |
| `docs` | Документный цикл и обратная связь: блоки, справка, примеры, проверка и новая версия своего /d; новые документы — статьи проекта, /mcp/p/projects. |
| `electric` | QElectroTech: электрические схемы и символы, инструменты его MCP-сервера, сохранение файлов сессии. |
| `electronics` | HDL: синтез, схема и ресурсы ПЛИС; симуляция и осциллограммы. |
| `graphics` | ComfyUI: генерация изображений; ffmpeg: видео; HLSL/Slang: шейдеры. Blender: рендер и конвертация моделей. |
| `jobs` | Состояние, ожидание и отмена своих долгих расчётов; постановка из Code Mode. |
| `modelica` | Modelica: расчёт моделей динамических систем и графики переменных. |
| `projects` | Совместные проекты: чтение и запись статей с base, проверка и статус задания, скрытие, участники, приглашения и управление проектом. Импорт — через tools add. |
| `proofs` | Lean 4: проверка доказательств целиком и пошаговый сеанс с целями и тактиками. |
| `quantum` | Квантовые схемы: Qiskit и PyZX, симуляция и результаты измерений. |
| `sources` | Единые источники проекта: каталог, обзор, пакетное чтение, поиск, цитаты, запросы, снимки и подключение. Только при включении оператором. |

## Матрица доступности

Контроль включает сценарий всех флагов, исходные значения по умолчанию и выключение
каждого перечисленного флага отдельно. Это граничные сценарии, не все сочетания флагов.
«Изменены» означает различие полного определения (включая описание/схемы), даже если имя осталось.
Статистика также проверяется при выключенном сборе и сохранённой служебной записи для уборки.
Изменения начальных MCP-схем дополнительно закреплены в машинном снимке проверки.

| Сценарий | REST / MCP-адресов | Отсутствуют против полного сценария | Изменены определения |
|---|---|---|---|
| Все перечисленные возможности включены | 96 / 30 | — | — |
| Дата выпуска проектов ещё не наступила | 69 / 26 | `invitations`, `project_admin`, `project_comments`, `project_datasource`, `project_git_import`, `project_hide`, `project_import`, `project_members`, `project_publish`, `project_read`, `project_search`, `project_stats`, `project_suggestions`, `project_write`, `projects`, `source_attach`, `source_browse`, `source_cache`, `source_catalog`, `source_cite`, `source_describe`, `source_manage`, `source_query`, `source_read`, `source_search`, `source_snapshot`, `source_write` | `document_share` |
| Флаги по умолчанию, выпуск проектов не задан | 45 / 26 | `blender_exec`, `blender_inspect`, `blender_session_open`, `blender_session_save`, `blender_view`, `cad_exec`, `cad_inspect`, `cad_session_open`, `cad_session_save`, `cad_view`, `invitations`, `lean_session_close`, `lean_session_command`, `lean_session_goals`, `lean_session_open`, `lean_session_save`, `lean_session_tactic`, `modelica_session_open`, `modelica_session_save`, `modelica_simulate`, `project_admin`, `project_comments`, `project_datasource`, `project_git_import`, `project_hide`, `project_import`, `project_members`, `project_publish`, `project_read`, `project_search`, `project_stats`, `project_suggestions`, `project_write`, `projects`, `session_call`, `session_close`, `session_list`, `session_open`, `session_save`, `source_attach`, `source_browse`, `source_cache`, `source_catalog`, `source_cite`, `source_describe`, `source_manage`, `source_query`, `source_read`, `source_search`, `source_snapshot`, `source_write` | `code_run`, `document_share`, `render_check` |
| Ядра выключены | 72 / 30 | `blender_exec`, `blender_inspect`, `blender_session_open`, `blender_session_save`, `blender_view`, `cad_exec`, `cad_inspect`, `cad_session_open`, `cad_session_save`, `cad_view`, `lean_session_close`, `lean_session_command`, `lean_session_goals`, `lean_session_open`, `lean_session_save`, `lean_session_tactic`, `modelica_session_open`, `modelica_session_save`, `modelica_simulate`, `session_call`, `session_close`, `session_list`, `session_open`, `session_save` | `code_run` |
| До выпуска проектов | 69 / 26 | `invitations`, `project_admin`, `project_comments`, `project_datasource`, `project_git_import`, `project_hide`, `project_import`, `project_members`, `project_publish`, `project_read`, `project_search`, `project_stats`, `project_suggestions`, `project_write`, `projects`, `source_attach`, `source_browse`, `source_cache`, `source_catalog`, `source_cite`, `source_describe`, `source_manage`, `source_query`, `source_read`, `source_search`, `source_snapshot`, `source_write` | `document_share` |
| Дополнительные профили выключены | 96 / 15 | `search` | — |
| Пакет render_check выключен | 96 / 30 | — | `render_check` |
| Поиск проектов выключен | 95 / 30 | `project_search` | — |
| Статистика выключена, служебная запись не задана | 95 / 30 | `project_stats` | — |
| Пилот datasource выключен | 95 / 30 | `project_datasource` | — |
| Комментарии выключены | 95 / 30 | `project_comments` | — |
| Предложения выключены | 95 / 30 | `project_suggestions` | — |
| Публичные сайты выключены | 95 / 30 | `project_publish` | `project_read` |
| Темы выключены | 96 / 30 | — | `project_read`, `project_write` |
| Свойства выключены | 96 / 30 | — | — |
| Модель источников выключена | 84 / 28 | `source_attach`, `source_browse`, `source_cache`, `source_catalog`, `source_cite`, `source_describe`, `source_manage`, `source_query`, `source_read`, `source_search`, `source_snapshot`, `source_write` | — |
| API источников выключен | 84 / 28 | `source_attach`, `source_browse`, `source_cache`, `source_catalog`, `source_cite`, `source_describe`, `source_manage`, `source_query`, `source_read`, `source_search`, `source_snapshot`, `source_write` | — |
| Чтение источников Code Mode выключено | 96 / 30 | — | — |
| Защита фрагментов выключена | 96 / 30 | — | — |
| Отложенное расписание выключено | 96 / 30 | — | — |
| Общие ресурсы выключены | 96 / 30 | — | `project_publish`, `project_write` |
| Сбор статистики выключен, служебная запись сохранена для уборки | 96 / 30 | — | — |

## Пределы по умолчанию

Значения из контрактов установки; администратор может изменить их. Фактические квоты —
`GET /api/v1/me`; пояснения — [лимиты и очередь](api.md#лимиты-и-очередь),
[проекты](projects.md#пределы-и-имена), [сеансы](sessions.md#сроки-и-восстановление).
Bytes — байты, Ms — миллисекунды, Days — дни, Mb — МиБ, gbMinutes — ГБ·мин;
heavy/light — вызовы в час, parallel/count — одновременно, приглашения — за скользящие сутки.

| Группа | Предел | Значение |
|---|---|---|
| `account` | `heavy` | `600` |
| `account` | `light` | `6000` |
| `uploads` | `maxBytes` | `33554432` |
| `uploads` | `quotaBytes` | `524288000` |
| `uploads` | `maxFiles` | `5000` |
| `documents` | `maxBytes` | `524288` |
| `documents` | `maxDocs` | `200` |
| `projects` | `maxProjects` | `10` |
| `projects` | `maxGitBytes` | `52428800` |
| `projects` | `maxArchiveGitBytes` | `1073741824` |
| `projects` | `maxArticleBytes` | `524288` |
| `projects` | `maxFiles` | `5000` |
| `projects` | `maxMembers` | `50` |
| `projects` | `maxProjectResourceBytes` | `1073741824` |
| `projects` | `maxResourceBytes` | `12000000` |
| `projects` | `minFreeRatio` | `0.1` |
| `projects` | `maxCatalogBytes` | `33554432` |
| `projects` | `maxWriteBytes` | `16777216` |
| `sessions` | `count` | `2` |
| `sessions` | `gbMinutes` | `480` |
| `invitations` | `senderPerDay` | `50` |
| `invitations` | `recipientPerDay` | `3` |
| `invitations` | `projectPerDay` | `100` |
| `render-batch` | `maxDocuments` | `12` |
| `render-batch` | `maxBytes` | `1048576` |
| `render-batch` | `timeoutMs` | `180000` |
| `render-batch` | `documentTimeoutMs` | `45000` |
| `private-results` | `quotaBytes` | `2147483648` |
| `rest` | `parallel` | `2` |
| `jobs` | `maxPending` | `3` |
| `jobs` | `maxDelayMs` | `2592000000` |
| `jobs` | `maxOutstanding` | `5` |
| `jobs` | `maxRecords` | `1000` |
| `jobs` | `maxRecordBytes` | `268435456` |
| `jobs` | `retentionDays` | `7` |
| `jobs` | `inlineResultBytes` | `65536` |

## Прямые REST-операции

Операции OpenAPI сверх инструментов. Схемы ответов и параметры — в `/api/v1/openapi.json`;
примеры применения — [REST API](api.md). Служебные веб-маршруты сюда не входят.

| Операция | Назначение |
|---|---|
| `POST /api/v1/register` | Регистрация по почте |
| `GET /api/v1/me` | Кто я: почта и лимиты |
| `DELETE /api/v1/me` | Удалить свою учётную запись |
| `GET /api/v1/tools` | Инструменты и схемы их аргументов |
| `POST /api/v1/files` | Загрузить свой файл для песочниц (до 32 МБ) |
| `GET /api/v1/files` | Свои файлы и занятое место |
| `DELETE /api/v1/files/{id}` | Удалить свой файл |
| `GET /api/v1/origins` | Свои сайты для вызовов из браузера (CORS) |
| `POST /api/v1/origins` | Добавить сайт: с него браузер пустит запросы с вашим ключом |
| `DELETE /api/v1/origins` | Убрать сайт |
| `GET /api/v1/docs/{id}.md` | Опубликованный документ (document_share) — Markdown |
| `GET /api/v1/docs/{id}` | Опубликованный документ: заголовок и версии |
| `GET /api/v1/keys` | Свои ключи без секретов |
| `DELETE /api/v1/keys/{which}` | Отозвать ключ |
| `GET /api/v1/jobs` | Свои асинхронные задачи |
| `GET /api/v1/jobs/{id}` | Состояние и результат задачи |
| `DELETE /api/v1/jobs/{id}` | Отменить задачу (снимается из очереди песочниц) |
| `POST /api/v1/block` | Перерисовать блок песочницы |
