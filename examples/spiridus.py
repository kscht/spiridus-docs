#!/usr/bin/env python3
"""Клиент REST API Spiridus — только стандартная библиотека Python 3.8+.

    python3 spiridus.py register you@example.com reader  # только для установок с открытой регистрацией
    # SPIRIDUS_KEY уже задан вне репозитория
    python3 spiridus.py me
    python3 spiridus.py tools                        # список инструментов
    python3 spiridus.py check документ.md            # render_check: замечания к документу
    python3 spiridus.py call render_block_docs '{"lang": "mermaid"}'
    python3 spiridus.py async plantuml_run '{"source": "A -> B"}'

Из своей программы: from spiridus import Spiridus; s = Spiridus(); s.call("render_check", markdown=…).
"""
import json
import os
import sys
import time
import urllib.error
import urllib.request

API = os.environ.get("SPIRIDUS_API", "https://v2.spiridus.ru")


class SpiridusError(Exception):
    def __init__(self, status, body):
        super().__init__(f"{status}: {body.get('error', body)}")
        self.status, self.body = status, body


class Spiridus:
    def __init__(self, key=None, api=API, timeout=660):
        self.key, self.api = key or os.environ.get("SPIRIDUS_KEY"), api.rstrip("/")
        self.timeout = timeout  # code_run может ждать очередь и исполняться около 610 с

    def _req(self, method, path, body=None, timeout=None):
        data = json.dumps(body).encode() if body is not None else None
        req = urllib.request.Request(self.api + path, data=data, method=method)
        req.add_header("content-type", "application/json")
        if self.key:
            req.add_header("authorization", "Bearer " + self.key)
        try:
            with urllib.request.urlopen(req, timeout=self.timeout if timeout is None else timeout) as r:
                return json.load(r)
        except urllib.error.HTTPError as e:
            try:
                payload = json.load(e)
            except ValueError:
                payload = {"error": e.reason}
            raise SpiridusError(e.code, payload) from None

    def register(self, email, nickname):
        return self._req("POST", "/api/v1/register", {"email": email, "nickname": nickname})

    def me(self):
        return self._req("GET", "/api/v1/me")

    def tools(self):
        return self._req("GET", "/api/v1/tools")["tools"]

    @staticmethod
    def _value(result):
        # Большой результат задания — приватный JSON полного REST-ответа.
        # Верните ref вызывающему; скачивать его нужно с ключом и текущими правами.
        if result.get("ref"):
            return result
        if result.get("data") is not None:
            return result["data"]
        return {"result": "\n".join(c["text"] for c in result.get("content", []) if c["type"] == "text")}

    def call_full(self, tool, **args):
        """Полный REST-ответ: ok, data и content, включая картинки и текстовую справку."""
        return self._req("POST", f"/api/v1/tools/{tool}", args)

    def call(self, tool, **args):
        """Ждёт результата: data, а для текстовой справки — {result: текст}."""
        return self._value(self.call_full(tool, **args))

    def call_async(self, tool, poll=30, **args):
        """Задача в очередь, результат — когда будет готов (без открытого соединения на всё время)."""
        job = self._req("POST", f"/api/v1/tools/{tool}?async=1", args)
        while True:
            j = self._req("GET", f"/api/v1/jobs/{job['id']}?wait={poll}", timeout=poll + 30)
            if j["status"] == "done":
                return self._value(j["result"])
            if j["status"] not in ("queued", "running"):
                raise SpiridusError(422, {"error": j.get("error") or j["status"]})
            time.sleep(0.5)

    def check(self, markdown, **opts):
        """render_check без снимков: { clean, issues: [{ line, kind, text, hint? }] }."""
        return self.call("render_check", markdown=markdown, shots="none", **opts)


def main(argv):
    if not argv:
        print(__doc__)
        return 2
    s, cmd, rest = Spiridus(), argv[0], argv[1:]
    if cmd == "register":
        if len(rest) != 2:
            print("register требует email и nickname", file=sys.stderr)
            return 2
        out = s.register(rest[0], rest[1])
    elif cmd == "me":
        out = s.me()
    elif cmd == "tools":
        out = [t["name"] + " — " + (t.get("title") or "") for t in s.tools()]
    elif cmd == "check":
        with open(rest[0], encoding="utf-8") as f:
            d = s.check(f.read())
        print("чисто" if d.get("clean") else "есть замечания")
        for i in d.get("issues", []):
            print("  строка", i.get("line"), "—", i["kind"] + ":", i["text"])
        return 0 if d.get("clean") else 1
    elif cmd in ("call", "async"):
        args = json.loads(rest[1]) if len(rest) > 1 else {}
        out = (s.call if cmd == "call" else s.call_async)(rest[0], **args)
    else:
        print(__doc__)
        return 2
    print(json.dumps(out, ensure_ascii=False, indent=1))
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except SpiridusError as e:
        print("ошибка", e, file=sys.stderr)
        sys.exit(1)
