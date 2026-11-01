<!-- Собрано автоматически из справки render_block_docs — правки в основном репозитории Spiridus. -->

# Определение ComfyUI workflow

`comfy-workflow` определяет `id` и список `versions`. Каждая версия содержит `version`, полный
API-граф `graph`, объявленные `params` и слоты `models`. Использование — блок `comfy` со ссылкой
`workflow: "#id@версия"` и значениями только объявленных параметров.

Полный пример определения SDXL (JSON является допустимым YAML):

```json
{
  "id": "sdxl-txt2img",
  "versions": [
    {
      "version": 1,
      "graph": {
        "3": {
          "class_type": "KSampler",
          "inputs": {
            "seed": 0,
            "steps": 30,
            "cfg": 6.5,
            "sampler_name": "dpmpp_2m",
            "scheduler": "karras",
            "denoise": 1,
            "model": [
              "4",
              0
            ],
            "positive": [
              "6",
              0
            ],
            "negative": [
              "7",
              0
            ],
            "latent_image": [
              "5",
              0
            ]
          }
        },
        "4": {
          "class_type": "CheckpointLoaderSimple",
          "inputs": {
            "ckpt_name": "sd_xl_base_1.0.safetensors"
          }
        },
        "5": {
          "class_type": "EmptyLatentImage",
          "inputs": {
            "width": 1024,
            "height": 1024,
            "batch_size": 1
          }
        },
        "6": {
          "class_type": "CLIPTextEncode",
          "inputs": {
            "text": "",
            "clip": [
              "4",
              1
            ]
          }
        },
        "7": {
          "class_type": "CLIPTextEncode",
          "inputs": {
            "text": "",
            "clip": [
              "4",
              1
            ]
          }
        },
        "8": {
          "class_type": "VAEDecode",
          "inputs": {
            "samples": [
              "3",
              0
            ],
            "vae": [
              "4",
              2
            ]
          }
        },
        "9": {
          "class_type": "SaveImage",
          "inputs": {
            "filename_prefix": "comfy",
            "images": [
              "8",
              0
            ]
          }
        }
      },
      "params": {
        "prompt": {
          "type": "text",
          "max_len": 2000,
          "label": "Промпт",
          "to": "6.inputs.text"
        },
        "negative": {
          "type": "text",
          "max_len": 1000,
          "default": "text, watermark",
          "to": "7.inputs.text"
        },
        "seed": {
          "type": "int",
          "min": 0,
          "max": 9007199254740991,
          "default": 0,
          "to": "3.inputs.seed"
        },
        "steps": {
          "type": "int",
          "min": 10,
          "max": 50,
          "default": 30,
          "to": "3.inputs.steps"
        },
        "width": {
          "type": "int",
          "min": 512,
          "max": 1536,
          "step": 64,
          "default": 1024,
          "to": "5.inputs.width"
        },
        "height": {
          "type": "int",
          "min": 512,
          "max": 1536,
          "step": 64,
          "default": 1024,
          "to": "5.inputs.height"
        },
        "sampler": {
          "type": "enum",
          "values": [
            "euler",
            "dpmpp_2m"
          ],
          "default": "dpmpp_2m",
          "to": "3.inputs.sampler_name"
        }
      },
      "models": {
        "base": {
          "kind": "checkpoint",
          "allow": [
            "sdxl-base-1.0"
          ],
          "default": "sdxl-base-1.0",
          "to": "4.inputs.ckpt_name"
        }
      }
    }
  ]
}
```

`params` описывает тип (`text`, `int`, `float`, `enum`), пределы (`max_len`, `min/max/step`, `values`),
необязательные `default` и `label`, а также `to: нода.inputs.поле` либо список таких путей.
Без default параметр обязателен. `models` описывает `kind`, допустимые id `allow`, `default` и `to`.
Служебные имена workflow/models/id/build/result/graph/inputs для параметров запрещены.

Первый этап поддерживает передачу определения аргументом `definition` в `comfy_generate`.
Файлы проектов *.comfy.json, проектный реестр неизменяемых версий, ссылки между статьями
и пересчёт в статье — следующий этап. Полный синтаксис и лицензии — `render_block_docs comfy`.
