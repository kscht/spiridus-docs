#!/bin/sh
# Запись в существующий проект: дерево → put с base → проверка → приглашение (если email задан).
# Запуск: ./project.sh atlas Начало.md ./статья.md [colleague@example.com]
# SPIRIDUS_KEY задайте заранее вне репозитория. Нужны Python 3 и соседний spiridus.py.
set -eu
: "${SPIRIDUS_KEY:?задайте SPIRIDUS_KEY вне репозитория}"
PROJECT=${1:?slug проекта}
ARTICLE=${2:?путь статьи в проекте}
FILE=${3:?локальный Markdown-файл}
EXAMPLES=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
python3 - "$EXAMPLES" "$PROJECT" "$ARTICLE" "$FILE" "${4:-}" <<'PY'
import pathlib
import sys
sys.path.insert(0, sys.argv[1])
from spiridus import Spiridus, SpiridusError

_, _, project, article, file, email = sys.argv
s = Spiridus()
try:
    tree = s.call("project_read", project=project, op="tree")
    saved = s.call("project_write", project=project, base=tree["commit"],
                   files=[{"path": article, "content": pathlib.Path(file).read_text(encoding="utf-8")}])
    print("Без изменений" if saved.get("unchanged") else "Сохранено", saved["url"])
    checked = s.call("render_check", project=project, path=article, shots="none",
                     strict=["warning", "layout"])
    print(checked["verdict"])
    if not checked["clean"]:
        print("Исправьте замечания перед приглашением:", checked.get("issues", []))
        sys.exit(1)
    if email:
        s.call("invitations", project=project, action="invite", email=email, role="reader")
        print("Приглашение отправлено; адресат должен явно принять его.")
except SpiridusError as e:
    print(e, file=sys.stderr)
    if e.status == 422:
        print("При конфликте 409 перечитайте статью, наложите правку на новый текст и повторите с новым base.", file=sys.stderr)
    sys.exit(1)
PY
