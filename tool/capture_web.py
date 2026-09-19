"""스토어 스크린샷 원본 캡처.

Windows ARM64 에는 Android 에뮬레이터가 없어 웹 빌드를 Chrome 헤드리스 + DevTools 프로토콜로 찍는다.
(--window-size 만으로는 Chrome 창 최소 너비 때문에 360px 폰 화면이 안 나와서 기기 에뮬레이션을 쓴다.)

실행:
  flutter build web
  python -m http.server 8765 -d build/web   (다른 터미널)
  python tool/capture_web.py
출력: store/raw/s_home.png, s_home2.png, s_detail.png, s_share.png (1080x1920)
"""
import base64
import json
import os
import shutil
import subprocess
import tempfile
import time
import urllib.request

import websocket  # pip install websocket-client

CHROME = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
PORT = 9333
BASE = "http://localhost:8765/?demo=1&shot=1&screen="
ROOT = os.path.join(os.path.dirname(__file__), "..")
OUT = os.path.join(ROOT, "store", "raw")
os.makedirs(OUT, exist_ok=True)

# 360x640 논리 해상도 x3 = 1080x1920. 홈은 길어서 위/아래 두 장.
SHOTS = [
    ("s_home", "home", 0),
    ("s_home2", "home", 610),
    ("s_detail", "detail", 0),
    ("s_share", "share", 0),
]


class Cdp:
    def __init__(self, ws_url):
        self.ws = websocket.create_connection(ws_url, suppress_origin=True)
        self.n = 0

    def call(self, method, **params):
        self.n += 1
        self.ws.send(json.dumps({"id": self.n, "method": method, "params": params}))
        while True:
            msg = json.loads(self.ws.recv())
            if msg.get("id") == self.n:
                if "error" in msg:
                    raise RuntimeError(msg["error"])
                return msg.get("result", {})


def main():
    profile = tempfile.mkdtemp(prefix="saju_shot_")
    proc = subprocess.Popen([
        CHROME, "--headless=new", "--disable-gpu", "--hide-scrollbars", "--lang=ko-KR",
        f"--remote-debugging-port={PORT}", f"--user-data-dir={profile}", "about:blank",
    ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    try:
        for _ in range(50):
            try:
                targets = json.load(urllib.request.urlopen(f"http://localhost:{PORT}/json"))
                page = next(t for t in targets if t["type"] == "page")
                break
            except Exception:
                time.sleep(0.2)
        else:
            raise SystemExit("chrome did not start")

        cdp = Cdp(page["webSocketDebuggerUrl"])
        cdp.call("Page.enable")
        cdp.call("Emulation.setDeviceMetricsOverride", width=360, height=640, deviceScaleFactor=3, mobile=True)
        cdp.call("Emulation.setLocaleOverride", locale="ko-KR")
        for name, screen, scroll in SHOTS:
            cdp.call("Page.navigate", url=f"{BASE}{screen}&scroll={scroll}")
            time.sleep(6)  # Flutter 엔진 로드 + 폰트(한자) 로드 대기
            data = cdp.call("Page.captureScreenshot", format="png")["data"]
            path = os.path.join(OUT, f"{name}.png")
            with open(path, "wb") as f:
                f.write(base64.b64decode(data))
            print("captured", path)
    finally:
        proc.kill()
        shutil.rmtree(profile, ignore_errors=True)


if __name__ == "__main__":
    main()
