"""Hiệu chỉnh hình học một ảnh toàn cảnh chụp bằng chế độ "Panorama" của điện thoại (chiếu trụ).

Ảnh toàn cảnh gửi qua chat không có EXIF nên không biết tiêu cự. Cách làm: so khớp SIFT với các ảnh rectilinear đã biết
tiêu cự (ảnh Xiaomi 4000x3000, ảnh Canon EOS 50D) rồi giải đồng thời:
  - f_pano : bán kính trụ (px)  => hfov = rộng / f_pano
  - cy     : hàng ảnh nằm ngang tầm mắt (px)
  - R_k    : phép quay giữa toàn cảnh và từng ảnh tham chiếu k (3 góc)
  - f_x    : tiêu cự chung của các ảnh Xiaomi (px ở độ phân giải đã thu nhỏ), nếu có trong danh sách
Sai số đo bằng PIXEL trên ảnh tham chiếu (đo bằng góc sẽ suy biến về f -> vô cực). Điểm khớp sai bị loại dần.

Cách dùng:
  python3 -I 02_calibrate_cylinder.py <pano.jpg> <ref1.jpg:f_px|x> [<ref2.jpg:f_px|x> ...]
  f_px là tiêu cự của ảnh tham chiếu đã thu nhỏ; "x" = ẩn số (nhóm Xiaomi, cùng một ống kính).
"""
import sys, json
import cv2
import numpy as np
from PIL import Image
from scipy.optimize import least_squares
from scipy.spatial.transform import Rotation as Rot

pano_path = sys.argv[1]
refs = []
for a in sys.argv[2:]:
    p, f = a.rsplit(':', 1)
    refs.append((p, None if f == 'x' else float(f)))

def load_gray(p):
    return np.array(Image.open(p).convert('L'))

sift = cv2.SIFT_create(nfeatures=8000)
pg = load_gray(pano_path)
Hp, Wp = pg.shape
pk, pd = sift.detectAndCompute(pg, None)
bf = cv2.BFMatcher()

matches = []
for k, (p, f) in enumerate(refs):
    g = load_gray(p)
    rk, rd = sift.detectAndCompute(g, None)
    m = bf.knnMatch(pd, rd, k=2)
    good = [a for a, b in (x for x in m if len(x) == 2) if a.distance < 0.8 * b.distance]
    A = np.float32([pk[g_.queryIdx].pt for g_ in good])
    B = np.float32([rk[g_.trainIdx].pt for g_ in good])
    inl = np.ones(len(A), bool)
    if len(A) >= 8:
        _, mask = cv2.findHomography(A, B, cv2.RANSAC, 14.0)
        if mask is not None:
            inl = mask.ravel() > 0
    print(p, 'khớp', len(A), 'homography inliers', int(inl.sum()), flush=True)
    matches.append({'A': A, 'B': B, 'sel': inl, 'size': g.shape[::-1]})

n_x = sum(1 for _, f in refs if f is None)

def pano_rays(A, f, cy):
    th = (A[:, 0] - Wp / 2) / f
    y = (cy - A[:, 1]) / f
    v = np.stack([np.sin(th), y, np.cos(th)], 1)
    return v / np.linalg.norm(v, axis=1, keepdims=True)

def project_ref(d, R, fr, size):
    """d: tia trong khung toàn cảnh -> điểm ảnh trên ảnh tham chiếu. Trả (xy, hợp lệ)."""
    dr = R.inv().apply(d)
    ok = dr[:, 2] > 1e-3
    z = np.where(ok, dr[:, 2], 1.0)
    w, h = size
    x = fr * dr[:, 0] / z + w / 2
    y = -fr * dr[:, 1] / z + h / 2
    return np.stack([x, y], 1), ok

def unpack(t):
    return np.exp(t[0]), t[1], (np.exp(t[2]) if n_x else None), [Rot.from_rotvec(t[3 + 3 * k: 6 + 3 * k]) for k in range(len(refs))]

def residuals(t, mask_key='sel'):
    f_pano, cy, fx, Rs = unpack(t)
    out = []
    for k, (p, f) in enumerate(refs):
        mt = matches[k]; sel = mt[mask_key]
        if not sel.any():
            continue
        fr = fx if f is None else f
        xy, ok = project_ref(pano_rays(mt['A'][sel], f_pano, cy), Rs[k], fr, mt['size'])
        e = np.linalg.norm(xy - mt['B'][sel], axis=1)
        e = np.where(ok, e, 400.0)
        out.append(e)
    return np.concatenate(out) if out else np.zeros(1)

def init_rot(k, f_pano, fx, cy):
    """Quét yaw (và pitch nhỏ) để tìm phép quay khởi tạo tốt nhất cho ảnh tham chiếu k."""
    mt = matches[k]; sel = mt['sel']
    fr = fx if refs[k][1] is None else refs[k][1]
    best = (1e18, np.zeros(3))
    d = pano_rays(mt['A'][sel], f_pano, cy)
    for yaw in np.radians(np.arange(-180, 180, 4)):
        for pitch in np.radians([-12, 0, 12]):
            R = Rot.from_euler('yx', [yaw, pitch])
            xy, ok = project_ref(d, R, fr, mt['size'])
            e = np.where(ok, np.linalg.norm(xy - mt['B'][sel], axis=1), 400.0)
            c = np.median(e)
            if c < best[0]:
                best = (c, R.as_rotvec())
    return best[1]

best = None
for f0 in (550., 700., 850., 1000., 1200.):
    for fx0 in ((780., 900.) if n_x else (850.,)):
        t0 = [np.log(f0), Hp / 2, np.log(fx0)]
        for k in range(len(refs)):
            t0 += list(init_rot(k, f0, fx0, Hp / 2))
        t = np.array(t0)
        saved = [m['sel'].copy() for m in matches]
        for it in range(4):
            sol = least_squares(residuals, t, loss='soft_l1', f_scale=4.0, max_nfev=300)
            t = sol.x
            f_pano, cy, fx, Rs = unpack(t)
            thr = [30, 14, 8, 5][it]
            for k, (p, f) in enumerate(refs):
                mt = matches[k]
                fr = fx if f is None else f
                xy, ok = project_ref(pano_rays(mt['A'], f_pano, cy), Rs[k], fr, mt['size'])
                mt['sel'] = ok & (np.linalg.norm(xy - mt['B'], axis=1) < thr)
        used = int(sum(m['sel'].sum() for m in matches))
        e = residuals(t)
        rms = float(np.sqrt(np.mean(e ** 2))) if used else 1e9
        print(f'f0={f0:.0f} fx0={fx0:.0f} -> f_pano={np.exp(t[0]):.1f} cy={t[1]:.1f} f_x={np.exp(t[2]) if n_x else 0:.1f} used={used} rms_px={rms:.2f}', flush=True)
        score = used - 40 * rms
        if best is None or score > best[0]:
            best = (score, t.copy(), used, rms)
        for m, s in zip(matches, saved):
            m['sel'] = s
score, t, used, rms = best
f_pano, cy, fx, Rs = unpack(t)
res = {'pano': pano_path, 'W': Wp, 'H': Hp, 'f_pano': float(f_pano), 'cy': float(cy), 'f_x': None if fx is None else float(fx),
       'hfov_deg': float(np.degrees(Wp / f_pano)), 'yTop': float(cy / f_pano), 'yBot': float(-(Hp - cy) / f_pano),
       'vfov_top_deg': float(np.degrees(np.arctan(cy / f_pano))), 'vfov_bot_deg': float(np.degrees(np.arctan((Hp - cy) / f_pano))),
       'used_matches': used, 'rms_px': rms, 'refs': [r_[0] for r_ in refs],
       'rot_deg': [Rs[k].as_euler('yxz', degrees=True).tolist() for k in range(len(refs))]}
print(json.dumps(res, indent=1, ensure_ascii=False))
json.dump(res, open(pano_path.rsplit('.', 1)[0] + '.calib.json', 'w'), indent=1)
