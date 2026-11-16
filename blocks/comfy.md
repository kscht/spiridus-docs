<!-- Собрано автоматически из справки render_block_docs — правки в основном репозитории Spiridus. -->

# Изображения ComfyUI

Вариант без версии задаётся атрибутом строки ограждения `variant=<имя>` или аргументом MCP `variant`.
Допустимо: `flux1-fp8`, `flux1-fp8-nc`, `flux2`, `flux2-nc`, `nc`, `standard`. По умолчанию — `standard`.
Выбирается последняя не deprecated сборка варианта; точный `build` имеет приоритет.
Старую строку `build:` уберите, если переходите на `variant=`.

`comfy` хранит рецепт txt2img и ссылку на сохранённый набор PNG + JSON. Просмотр и `render_check`
читают набор без GPU, в том числе после снятия сборки. Явный запуск — `comfy_generate`.

Выбирайте сборку по задаче:

| Задача | Сборка и шаблоны |
| --- | --- |
| SDXL, универсальная генерация | `variant=standard` — `default`, шаблон `sdxl-txt2img@1`; `build` можно не указывать. |
| Быстрые фото-иллюстрации, FLUX.1 schnell/dev FP8 | Явно `variant=flux1-fp8` с `flux1-schnell-fp8-txt2img@1`; dev — явно `variant=flux1-fp8-nc` с `flux1-dev-fp8-txt2img@1`, только для некоммерческого применения. |
| Работа по референсу и композиции, FLUX.2 klein + RefControl | Явно `variant=flux2` (4B) либо `variant=flux2-nc` (9B, только для некоммерческого применения). Ноды и модели RefControl входят в сборки; передача изображений и готовые шаблоны стилизации в `comfy_generate` появятся отдельным этапом. Для txt2img доступны шаблоны fast/quality ниже. |

Все четыре сборки FLUX.1 FP8 и FLUX.2 — `stable`: поддерживаются и выбираются явно
через `variant` у инструмента или `variant=` в строке ограждения. Статус `stable` не меняет выбор по умолчанию:
им остаётся `variant=standard`. NC-сборки выбирайте явно только для некоммерческого применения:
FLUX.1 dev — FLUX.1 [dev] Non-Commercial License v1.1.1,
FLUX.2 9B — FLUX Non-Commercial License v2.1.

```comfy
workflow: sdxl-txt2img@1
prompt: маяк на скале, акварель, вечерний свет
seed: 603
steps: 30
width: 1024
height: 1024
```

Встроенные шаблоны: `sdxl-txt2img@1`, `flux1-schnell-txt2img@1`, `flux1-dev-txt2img@1`.
Для RTX 3090 добавлены `flux1-schnell-fp8-txt2img@1` с явным
`variant=flux1-fp8` и `flux1-dev-fp8-txt2img@1` с
`variant=flux1-fp8-nc`. Пример ниже — 1024×1024, batch 1, 4 шага.
У dev по умолчанию сохранены 20 шагов; для короткого запуска задайте `steps: 4` явно.

```comfy variant=flux1-fp8
workflow: flux1-schnell-fp8-txt2img@1
prompt: маяк на скале, акварель
seed: 655
steps: 4
width: 1024
height: 1024
```

Новый профиль хранит UNET в `fp8_e4m3fn`, вычисляет в fp16, VAE — в fp32;
CLIP/T5 закреплены на CPU. Используются исходные веса из models.json с прежними sha256:
новые файлы весов скачивать не требуется. Это преобразование при загрузке, без fast FP8.
Настройки offload сохранены: lowvram, резерв 1 ГиБ, dynamic VRAM выключен.
В новых сборках разрешён только этот dtype UNET; SDXL и FLUX.2 в их допуск не входят.
Старые шаблоны, профили и образы сохранены; совпадение PNG между fp16 и fp8 не обещается.

Лимит сборок FLUX.1 FP8 — 22528 МиБ VRAM.

FLUX.2: `flux2-fast-4b@1`, `flux2-quality-4b@1` с явным
`variant=flux2`; `flux2-fast-9b@1`, `flux2-quality-9b@1` — только с
`variant=flux2-nc`. Обе сборки имеют статус `stable`.
Fast использует klein FP8, 4 шага/CFG=1 по умолчанию (steps 1..8); quality — base,
50 шагов/CFG=4 (steps 1..50). 4B base — BF16, 9B base — FP8. Энкодеры — Qwen3-4B BF16
и Qwen3-8B FP8 соответственно; VAE — полный FLUX.2. Размеры width/height одновременно
меняют scheduler и latent, seed закрепляет RandomNoise. Старые сборки FLUX.2 не допускают.
Новый профиль выбирает точность трансформера по модели, VAE FP32; старый профиль fp16 сохранён.
Веса 4B/Qwen3-4B/VAE — Black Forest Labs / Comfy-Org / Qwen, Apache-2.0;
9B и упаковка Qwen3-8B — отдельный NC-комплект (FLUX Non-Commercial License v2.1).
Точные авторы, источники и условия каждой части — в models.lock.json.

```comfy variant=flux2
workflow: flux2-fast-4b@1
prompt: маяк на скале, акварель
seed: 750
```

Поддержка изображений на входе и шаблоны стилизации RefControl появятся отдельным этапом.
Версия обязательна. YAML строгий: неизвестные поля, теги, якоря, merge-ключи и повторы запрещены.
Промпт сохраняется точно; переводы строк приводятся к LF, Unicode не нормализуется.
Seed — целое 0..9007199254740991, `random` запрещён. Batch первого этапа — один.
Размеры — 512..1536 с шагом 64; SDXL steps 10..50, schnell 1..8, dev 1..50.
У SDXL доступны negative (до 1000 символов) и sampler (euler/dpmpp_2m); у FLUX
нет negative/CFG автора. Dev принимает guidance 0..10. Prompt — до 2000 символов.

По умолчанию `variant=standard`. FLUX dev разрешён только явным выбором
`variant=nc` либо `variant=flux1-fp8-nc` и соответствующего шаблона dev; некоммерческие веса отсутствуют в основной сборке.
Действуют лицензии SDXL (Stability AI, CreativeML Open RAIL++-M), FLUX schnell/VAE
(Black Forest Labs, Apache-2.0), CLIP (OpenAI, MIT), T5 (Google Research, Apache-2.0).
FLUX dev — Black Forest Labs, FLUX.1 [dev] Non-Commercial License v1.1.1:
коммерческое применение весов не разрешено. Для outputs действуют §4, запрет обучения
конкурирующих моделей, проверка/фильтрация до распространения и обозначение AI-происхождения по §2.e.
Авторы, полные условия и хеши моделей сохраняются в models.lock.json и meta.json и видны в подписи.

Определение `comfy-workflow` — объект `id`, `versions`; версия содержит `version`, `graph`, `params`, `models`.
Граф — полный API JSON с одним SaveImage; типы встроенных нод ограничены сборкой.
Параметр: `type: text|int|float|enum`, `to: 6.inputs.text` (либо список путей),
`label`, для чисел `min/max/step`, для текста `max_len`, для enum `values`, необязательный `default`.
Без default параметр обязателен. Слот модели: `kind`, `allow` (id из models.json), `default`, `to`.
Модели принимаются только по id слотов; загрузчики фиксированного графа используют filename манифеста.
Неизвестные ноды, модели, поля, висячие ссылки, неверные выходы/типы, циклы, пути и URL загрузчиков запрещены.

Для собственного определения передайте его YAML в аргументе `definition` инструмента и
`workflow: "#id@версия"` в `source`. Полное определение показано в справке `render_block_docs comfy-workflow`
(JSON также допустим в YAML-блоке).
Файлы проекта *.comfy.json, реестр неизменяемых проектных версий и проектный пересчёт — следующий этап;
на этом этапе новый шаблон получает новую версию, старые версии встроенного манифеста не переписываются.
Картинки на входе, graph:-эксперименты, импорт и цепочки блоков этим этапом не принимаются.

Ответ инструмента содержит приватный набор: image.png, workflow-api.json, workflow-ui.json,
params.json, models.lock.json и meta.json. Рецепт и PNG содержат промпт; публикация — только явно владельцем.
В статью проекта переносится весь набор через общий механизм 0053; проектную генерацию включает следующий этап.
Гарантия повторения относится к той же сборке и закреплённому профилю GPU/драйвера.
Кеш разделён по вызывающему и содержит полный рецепт; cached:true — выдача прежних байтов.
