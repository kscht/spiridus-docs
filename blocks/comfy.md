<!-- Собрано автоматически из справки render_block_docs — правки в основном репозитории Spiridus. -->

# Изображения ComfyUI

`comfy` хранит рецепт txt2img и ссылку на сохранённый набор PNG + JSON. Просмотр и `render_check`
читают набор без GPU, в том числе после снятия сборки. Явный запуск — `comfy_generate`.

```comfy
workflow: sdxl-txt2img@1
prompt: маяк на скале, акварель, вечерний свет
seed: 603
steps: 30
width: 1024
height: 1024
```

Встроенные шаблоны: `sdxl-txt2img@1`, `flux1-schnell-txt2img@1`, `flux1-dev-txt2img@1`.
FLUX.2: `flux2-fast-4b@1`, `flux2-quality-4b@1` с явным
`build: comfyui-0.41.0-flux2`; `flux2-fast-9b@1`, `flux2-quality-9b@1` — только с
`build: comfyui-0.41.0-flux2-nc`. Эти сборки имеют статус next и требуют аппаратной приёмки.
Fast использует klein FP8, 4 шага/CFG=1 по умолчанию (steps 1..8); quality — base,
50 шагов/CFG=4 (steps 1..50). 4B base — BF16, 9B base — FP8. Энкодеры — Qwen3-4B BF16
и Qwen3-8B FP8 соответственно; VAE — полный FLUX.2. Размеры width/height одновременно
меняют scheduler и latent, seed закрепляет RandomNoise. Старые сборки FLUX.2 не допускают.
Новый профиль выбирает точность трансформера по модели, VAE FP32; старый профиль fp16 сохранён.
Веса 4B/Qwen3-4B/VAE — Black Forest Labs / Comfy-Org / Qwen, Apache-2.0;
9B и упаковка Qwen3-8B — отдельный NC-комплект (FLUX Non-Commercial License v2.1).
Точные авторы, источники и условия каждой части — в models.lock.json.

```comfy
workflow: flux2-fast-4b@1
build: comfyui-0.41.0-flux2
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

По умолчанию `build: comfyui-0.41.0`. FLUX dev разрешён только явным выбором
`build: comfyui-0.41.0-nc` и шаблона dev; некоммерческие веса отсутствуют в основной сборке.
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
