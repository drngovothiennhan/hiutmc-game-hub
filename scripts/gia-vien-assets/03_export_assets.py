#!/usr/bin/env python3
"""Xuất ảnh thật cho game Gia Viên Dược Thảo (public/gia-vien-duoc-thao-preview/assets).

Chạy lại được từ ảnh nguồn; không tạo, không vẽ thêm nội dung nào:
  - Ảnh Xiaomi đã gỡ chữ mờ (watermark) bằng 01_clean_watermark.py (PNG 4000x3000).
  - Ảnh toàn cảnh do chủ vườn gửi (JPG 2576 px bề ngang, bản chat đã thu nhỏ).
  - Mọi ảnh đều CẮT bỏ vùng có người (kể cả bóng người rất nhỏ ở cuối lối đi), không xoá/vá bằng AI.

Cách dùng:
  python3 -I 03_export_assets.py --clean DIR --panos DIR --out ASSETS_DIR [--canon DIR]

  --clean : thư mục chứa IMG_20260912_065456.png, IMG_20260926_065323.png, IMG_20260926_065339.png
  --panos : thư mục chứa p2.jpg p3.jpg p5.jpg p6.jpg p7.jpg p8.jpg p10.jpg (toàn cảnh chủ vườn gửi)
  --canon : (tuỳ chọn) thư mục chứa IMG_3503.JPG (Canon EOS 50D, 16/09/2026)
  --out   : .../public/gia-vien-duoc-thao-preview/assets
"""
import argparse
import os
import sys
from PIL import Image

Image.MAX_IMAGE_PIXELS = None


def save_webp(im, path, q, method=6):
    im.convert('RGB').save(path, 'WEBP', quality=q, method=method)


def save_jpg(im, path, q):
    im.convert('RGB').save(path, 'JPEG', quality=q, optimize=True, progressive=True, subsampling='4:2:0')


def fit_width(im, w):
    if im.width <= w:
        return im.copy()
    return im.resize((w, round(im.height * w / im.width)), Image.LANCZOS)


def window(im, box, aspect, out_w):
    """Cắt cửa sổ có tỉ lệ `aspect` trong vùng box (đã an toàn về người) rồi thu về out_w px."""
    x0, y0, x1, y1 = box
    bw, bh = x1 - x0, y1 - y0
    if bw / bh > aspect:
        w = round(bh * aspect)
        x0 = x0 + (bw - w) // 2
        x1 = x0 + w
    else:
        h = round(bw / aspect)
        y0 = y0 + (bh - h) // 2
        y1 = y0 + h
    c = im.crop((x0, y0, x1, y1))
    return c.resize((out_w, round(out_w / aspect)), Image.LANCZOS)


def report(out, rel):
    p = os.path.join(out, rel)
    print(f'{os.path.getsize(p) / 1024:8.0f} KB  {rel}')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--clean', required=True)
    ap.add_argument('--panos', required=True)
    ap.add_argument('--canon')
    ap.add_argument('--out', required=True)
    a = ap.parse_args()
    out = a.out
    for d in ('fp', 'web', 'thumb'):
        os.makedirs(os.path.join(out, d), exist_ok=True)

    # ---------- 1. Toàn cảnh chủ vườn gửi: cắt vùng an toàn ----------
    # crop = (x0, y0, x1, y1) trên ảnh 2576 px; tx = vùng dùng làm ảnh nhỏ (thumb).
    # Quy tắc cắt: bỏ mọi vùng có người hoặc nghi có người (cuối lối đi, kính toà nhà).
    panos = {
        'p8': dict(crop=(0, 0, 1990, 581), fp='2026-10-giua-san', web='2026-10-toan-canh-giua-san', tx=(700, 0, 1805, 581)),
        'p7': dict(crop=(0, 0, 2400, 619), fp='2026-10-sat-gian', web='2026-10-sat-gian', tx=(900, 0, 2000, 619)),
        'p3': dict(crop=(0, 0, 2280, 572), fp='2026-10-loi-vao', web='2026-10-loi-vao-san', tx=(1000, 0, 2100, 572)),
        'p5': dict(crop=(0, 0, 2250, 573), web='2026-10-duoi-mai-che', tx=(700, 0, 1800, 573)),
        'p10': dict(crop=(0, 0, 2250, 535), web='2026-10-giang-trong-dung', tx=(600, 0, 1700, 535)),
        'p6': dict(crop=(560, 0, 1900, 719), web='2026-10-cum-cay-trai-gian', tx=(560, 100, 1900, 719)),
        'p2': dict(crop=(0, 0, 2576, 519), web='2026-10-canh-giang-dung', tx=(900, 0, 2000, 519)),
    }
    for key, cfg in panos.items():
        src = Image.open(os.path.join(a.panos, key + '.jpg')).convert('RGB')
        im = src.crop(cfg['crop'])
        tx = tuple(v - (cfg['crop'][0] if i % 2 == 0 else 0) for i, v in enumerate(cfg['tx']))
        tx = (max(0, tx[0]), max(0, tx[1]), min(im.width, tx[2]), min(im.height, tx[3]))
        if 'fp' in cfg:
            save_webp(im, os.path.join(out, 'fp', cfg['fp'] + '.webp'), 88)
            save_jpg(window(im, tx, 1.9, 360), os.path.join(out, 'fp', cfg['fp'] + '-thumb.jpg'), 80)
            report(out, f"fp/{cfg['fp']}.webp")
        save_jpg(im, os.path.join(out, 'web', cfg['web'] + '.jpg'), 86)
        save_jpg(window(im, tx, 360 / 208, 360), os.path.join(out, 'thumb', cfg['web'] + '.jpg'), 80)
        report(out, f"web/{cfg['web']}.jpg")

    # ---------- 2. Ảnh Xiaomi 4000x3000 đã gỡ watermark ----------
    xiaomi = {
        '2026-09-12-toan-dai': 'IMG_20260912_065456.png',
        '2026-09-26-truoc-tuong': 'IMG_20260926_065323.png',
        '2026-09-26-doc-tuong': 'IMG_20260926_065339.png',
    }
    srcs = {}
    for name, fn in xiaomi.items():
        im = Image.open(os.path.join(a.clean, fn)).convert('RGB')
        srcs[name] = im
        # Trạm 3D: bản nền 2048 px tải nhanh + bản nét cao 4000 px tải nền
        save_webp(fit_width(im, 2048), os.path.join(out, 'fp', name + '.webp'), 80)
        save_webp(im, os.path.join(out, 'fp', name + '-hi.webp'), 76)
        save_jpg(fit_width(im, 360), os.path.join(out, 'fp', name + '-thumb.jpg'), 80)
        # Khung Ảnh thật / Khám phá 2.5D
        save_jpg(fit_width(im, 1600), os.path.join(out, 'web', name + '.jpg'), 84)
        save_jpg(fit_width(im, 360), os.path.join(out, 'thumb', name + '.jpg'), 80)
        for rel in (f'fp/{name}.webp', f'fp/{name}-hi.webp', f'web/{name}.jpg'):
            report(out, rel)

    # ---------- 3. Ảnh cận cắt từ ảnh gốc nét cao (không phóng to bằng CSS) ----------
    # Bảng danh sách cây nằm sát mép phải ảnh 12/09: cột số 1–35 đọc rõ.
    close = [
        ('2026-09-12-bang-danh-sach', '2026-09-12-toan-dai', (3540, 230, 4000, 2000)),
        ('2026-09-26-chau-hong-beo', '2026-09-26-truoc-tuong', (900, 1100, 2500, 2700)),
        ('2026-09-26-luoi-ho', '2026-09-26-doc-tuong', (2400, 1500, 4000, 3000)),
    ]
    for name, src_name, box in close:
        im = srcs[src_name].crop(box)
        save_jpg(fit_width(im, 1600), os.path.join(out, 'web', name + '.jpg'), 86)
        save_jpg(window(im, (0, 0, im.width, im.height), 360 / 208, 360), os.path.join(out, 'thumb', name + '.jpg'), 80)
        report(out, f'web/{name}.jpg')

    # ---------- 4. Canon EOS 50D 16/09 (tuỳ chọn) ----------
    if a.canon:
        p = os.path.join(a.canon, 'IMG_3503.JPG')
        if os.path.exists(p):
            im = Image.open(p).convert('RGB')
            name = '2026-09-16-trai-gian'
            save_webp(fit_width(im, 2048), os.path.join(out, 'fp', name + '.webp'), 80)
            save_webp(im, os.path.join(out, 'fp', name + '-hi.webp'), 76)
            save_jpg(fit_width(im, 360), os.path.join(out, 'fp', name + '-thumb.jpg'), 80)
            save_jpg(fit_width(im, 1600), os.path.join(out, 'web', name + '.jpg'), 84)
            save_jpg(fit_width(im, 360), os.path.join(out, 'thumb', name + '.jpg'), 80)
            for rel in (f'fp/{name}.webp', f'fp/{name}-hi.webp', f'web/{name}.jpg'):
                report(out, rel)


if __name__ == '__main__':
    sys.exit(main())
