#!/bin/sh
# Регистрация в Spiridus: на почту придёт письмо со ссылкой; откройте её и нажмите
# «Согласен, подтвердить» — страница покажет ключ sp_…  Запуск: ./register.sh you@example.com reader
set -eu
EMAIL=${1:?адрес почты: ./register.sh you@example.com reader}
NICKNAME=${2:?обязательный никнейм: ./register.sh you@example.com reader}
case $NICKNAME in *[!A-Za-z0-9._-]*|[._-]*|*[._-]|"") echo "неверный никнейм" >&2; exit 1 ;; esac
[ "${#NICKNAME}" -le 64 ] || { echo "никнейм длиннее 64 знаков" >&2; exit 1; }
API=${SPIRIDUS_API:-https://v2.spiridus.ru}
case $EMAIL in *[\"\\\ ]*|"") echo "странный адрес: $EMAIL" >&2; exit 1 ;; esac
curl -fsS -X POST "$API/api/v1/register" -H 'content-type: application/json' -d "{\"email\": \"$EMAIL\", \"nickname\": \"$NICKNAME\"}"
echo
