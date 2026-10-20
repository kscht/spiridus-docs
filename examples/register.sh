#!/bin/sh
# Регистрация в Spiridus: на почту придёт письмо со ссылкой; откройте её и нажмите
# «Согласен, подтвердить» — страница покажет ключ sp_…  Запуск: ./register.sh you@example.com
set -eu
EMAIL=${1:?адрес почты: ./register.sh you@example.com}
API=${SPIRIDUS_API:-https://v2.spiridus.ru}
case $EMAIL in *[\"\\\ ]*|"") echo "странный адрес: $EMAIL" >&2; exit 1 ;; esac
curl -fsS -X POST "$API/api/v1/register" -H 'content-type: application/json' -d "{\"email\": \"$EMAIL\"}"
echo
