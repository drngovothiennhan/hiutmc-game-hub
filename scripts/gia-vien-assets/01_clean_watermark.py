"""Gỡ dòng chữ ghi thông số của máy ảnh (watermark Xiaomi) khỏi ảnh gốc 4000x3000.

Chữ là nét trắng sáng, mỏng, nằm giữa mép dưới ảnh, trên nền sân gạch. Cách làm:
  1. Mặt nạ = điểm ảnh rất sáng (cả 3 kênh >= 225) trong vùng chữ, nở ra vài px để phủ viền khử răng cưa.
  2. cv2.inpaint (Telea) lấp phần màu nền; sau đó "cấy" lại hạt đá của sân gạch (thành phần tần số cao,
     cắt biên độ để không cấy nhầm vết nứt) lấy từ vùng sân sạch cùng độ cao trong ảnh,
     để chỗ vừa gỡ không bị nhoè so với mặt sân xung quanh.
Chỉ xử lý vùng sân gạch phía dưới; không đụng phần cây, tường, bảng. Ảnh không có người.

Cách dùng:  python3 -I 01_clean_watermark.py <anh_goc.jpg> <anh_da_sach.png>
"""
import sys
import cv2
import numpy as np
from PIL import Image, ImageOps

src, dst = sys.argv[1], sys.argv[2]
im = ImageOps.exif_transpose(Image.open(src)).convert('RGB')
a = np.array(im)
h, w = a.shape[:2]
# Vùng chữ (tỉ lệ theo kích thước ảnh): giữa dưới, cao khoảng 17% ảnh
x0, x1 = int(w * 0.34), int(w * 0.69)
y0, y1 = int(h * 0.82), int(h * 0.995)
roi = a[y0:y1, x0:x1]
bright = (roi.min(axis=2) >= 225).astype(np.uint8) * 255
bright = cv2.dilate(bright, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (7, 7)), iterations=1)
mask = np.zeros((h, w), np.uint8)
mask[y0:y1, x0:x1] = bright

bgr = cv2.cvtColor(a, cv2.COLOR_RGB2BGR)
filled = cv2.inpaint(bgr, mask, 5, cv2.INPAINT_TELEA).astype(np.float32)

# Hạt đá: thành phần tần số cao của ảnh gốc ở vùng sân sạch, dịch ngang ~ 1500 px (cùng độ cao => cùng tỉ lệ phối cảnh)
src_f = bgr.astype(np.float32)
hp = src_f - cv2.GaussianBlur(src_f, (0, 0), 5)
hp = np.clip(hp, -14, 14)
shift = int(w * 0.375)
yy, xx = np.mgrid[y0:y1, x0:x1]
mid = (x0 + x1) // 2
xs = np.where(xx < mid, xx + shift, xx - shift)
xs = np.clip(xs, 0, w - 1)
grain = np.zeros_like(filled)
grain[y0:y1, x0:x1] = hp[yy, xs]
# Chỉ cấy ở chỗ vừa lấp, làm mềm biên mặt nạ để không lộ viền
soft = cv2.GaussianBlur(mask, (0, 0), 2).astype(np.float32)[..., None] / 255.0
out = np.clip(filled + grain * soft, 0, 255).astype(np.uint8)
Image.fromarray(cv2.cvtColor(out, cv2.COLOR_BGR2RGB)).save(dst, compress_level=3)
print(dst, 'mask px:', int((mask > 0).sum()), f'({(mask > 0).mean() * 100:.2f}% ảnh)')
