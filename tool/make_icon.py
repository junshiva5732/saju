"""앱 아이콘 생성 스크립트. 실행: python tool/make_icon.py
assets/icon/icon.png (1024x1024, 배경 포함) 과
assets/icon/icon_fg.png (Android adaptive 전경, 투명 배경) 을 만든다.

모티프: 앱의 사주 원국 표(2행 x 4열, 오행 색 셀) + 일간 셀의 금색 테두리 + 반짝이 별.
"""
import math
import os

from PIL import Image, ImageDraw, ImageFilter

SIZE = 1024
OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "icon")
os.makedirs(OUT, exist_ok=True)

# 앱 시드 컬러(0xFF4B3AA8) 계열 남보라 그라데이션. adaptive 배경색(pubspec) 은 BOTTOM.
TOP = (75, 58, 168)
BOTTOM = (31, 26, 61)
GOLD = (255, 214, 86)
CREAM = (255, 246, 214)

WOOD = (46, 125, 50)
FIRE = (198, 40, 40)
EARTH = (249, 168, 37)
METAL = (230, 230, 230)
WATER = (21, 101, 192)

# 위(천간) / 아래(지지) 두 줄, 왼쪽부터 시·일·월·연.
GRID = [
    [WOOD, FIRE, EARTH, METAL],
    [FIRE, WATER, WOOD, FIRE],
]
DAY_COL = 1  # 일간 위치 (금색 테두리)


def gradient_bg(size):
    img = Image.new("RGB", (size, size))
    px = img.load()
    for y in range(size):
        t = y / (size - 1)
        for x in range(size):
            k = (t * 0.7 + (x / (size - 1)) * 0.3)
            px[x, y] = tuple(int(TOP[i] + (BOTTOM[i] - TOP[i]) * k) for i in range(3))
    return img


def star4(draw, cx, cy, r, inner_ratio, fill):
    """4각 반짝이 별."""
    pts = []
    for i in range(8):
        ang = math.pi / 4 * i - math.pi / 2
        rr = r if i % 2 == 0 else r * inner_ratio
        pts.append((cx + rr * math.cos(ang), cy + rr * math.sin(ang)))
    draw.polygon(pts, fill=fill)


def draw_symbol(layer, scale=1.0):
    """2x4 오행 셀 + 별. layer 는 RGBA."""
    d = ImageDraw.Draw(layer)
    s = SIZE * scale
    cell = s * 0.18
    gap = s * 0.032
    gw = 4 * cell + 3 * gap
    gh = 2 * cell + gap
    x0 = (SIZE - gw) / 2
    y0 = (SIZE - gh) / 2 + s * 0.04
    rad = cell * 0.22
    for r, row in enumerate(GRID):
        for c, col in enumerate(row):
            x = x0 + c * (cell + gap)
            y = y0 + r * (cell + gap)
            d.rounded_rectangle([x, y, x + cell, y + cell], radius=rad, fill=col + (255,))
            if r == 0 and c == DAY_COL:
                d.rounded_rectangle([x, y, x + cell, y + cell], radius=rad,
                                    outline=GOLD + (255,), width=int(cell * 0.09))
    # 별 (오른쪽 위)
    star4(d, SIZE * 0.80, SIZE * 0.20, s * 0.075, 0.38, GOLD + (255,))
    star4(d, SIZE * 0.70, SIZE * 0.13, s * 0.035, 0.38, CREAM + (255,))


def with_glow(symbol):
    glow = symbol.filter(ImageFilter.GaussianBlur(SIZE * 0.025))
    glow = Image.eval(glow, lambda v: int(v * 0.45))
    out = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    out.alpha_composite(glow)
    out.alpha_composite(symbol)
    return out


# 1) 풀 아이콘 (iOS / 스토어용, 불투명)
bg = gradient_bg(SIZE).convert("RGBA")
sym = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw_symbol(sym)
bg.alpha_composite(with_glow(sym))
bg.convert("RGB").save(os.path.join(OUT, "icon.png"))

# 2) Adaptive 전경 (Android). flutter_launcher_icons 가 안전 영역 인셋을 넣으므로 그대로.
fg = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw_symbol(fg)
fg = with_glow(fg)
fg.save(os.path.join(OUT, "icon_fg.png"))

print("written:", os.path.abspath(OUT))
