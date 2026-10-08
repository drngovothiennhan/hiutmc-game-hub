#!/usr/bin/env python3
"""Cut a compact chest model for the auscultation room from the Human Atlas (BodyParts3D 4.0, CC BY 4.0).

Usage: python3 -I build-chest-model.py <human-atlas/public/models dir> <out dir>
Writes chest.bin + chest.json. Coordinates: metres, +y up, +z anterior, +x patient's left.
Skin is cropped to the torso and decimated by vertex clustering; other parts are kept as-is.
"""
import json, os, re, sys
import numpy as np

GROUPS = {
    'skin': lambda p: p['id'] == 'FJ2810',
    'bone': lambda p: re.search(r'^(Left|Right) (first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth|eleventh|twelfth) rib$|^(Left|Right) clavicle$|^Body of sternum$|^Manubrium$|^Xiphoid process$', p['name']) is not None,
    'heart': lambda p: p['id'] in {'FJ2428', 'FJ2438', 'FJ2439', 'FJ2966', 'FJ3413', 'FJ3411', 'FJ3645', 'FJ2924', 'FJ3019'},
    'airway': lambda p: p['id'] == 'FJ2541' or re.search(r'main bronchus', p['name'], re.I) is not None or (p['system'] == 'respiratory' and 'segmental' in p['name']),
}
TORSO_Y = (1.00, 1.50)
TORSO_X = 0.20
CELL = 0.007


def load(models, p, chunks):
    b = chunks[p['chunk']]
    pos = np.frombuffer(b, np.float32, p['vertexCount'] * 3, p['positions']).reshape(-1, 3).copy()
    idx = np.frombuffer(b, np.uint32, p['indexCount'], p['indices']).reshape(-1, 3).copy()
    return pos, idx


def crop_and_cluster(pos, idx):
    c = pos[idx].mean(axis=1)
    keep = (c[:, 1] > TORSO_Y[0]) & (c[:, 1] < TORSO_Y[1]) & (np.abs(c[:, 0]) < TORSO_X)
    idx = idx[keep]
    cell = np.floor(pos / CELL).astype(np.int64)
    key = (cell[:, 0] * 73856093) ^ (cell[:, 1] * 19349663) ^ (cell[:, 2] * 83492791)
    uniq, inv = np.unique(key, return_inverse=True)
    sums = np.zeros((len(uniq), 3)); cnt = np.zeros(len(uniq))
    np.add.at(sums, inv, pos); np.add.at(cnt, inv, 1)
    cpos = (sums / cnt[:, None]).astype(np.float32)
    ni = inv[idx]
    ni = ni[(ni[:, 0] != ni[:, 1]) & (ni[:, 1] != ni[:, 2]) & (ni[:, 0] != ni[:, 2])]
    used = np.unique(ni)
    remap = -np.ones(len(cpos), np.int64); remap[used] = np.arange(len(used))
    return cpos[used], remap[ni].astype(np.uint32)


def normals(pos, idx):
    n = np.zeros_like(pos)
    f = np.cross(pos[idx[:, 1]] - pos[idx[:, 0]], pos[idx[:, 2]] - pos[idx[:, 0]])
    for k in range(3):
        np.add.at(n, idx[:, k], f)
    l = np.linalg.norm(n, axis=1, keepdims=True); l[l == 0] = 1
    return n / l


def main(models, out):
    atlas = json.load(open(os.path.join(models, 'atlas.json')))
    chunks = {}
    def chunk(i):
        if i not in chunks:
            chunks[i] = open(os.path.join(models, f'body-{i}.bin'), 'rb').read()
        return chunks[i]
    class C(dict):
        def __missing__(self, k): return chunk(k)
    cs = C()
    blob = bytearray(); parts = []
    for group, test in GROUPS.items():
        for p in atlas['parts']:
            if not test(p):
                continue
            pos, idx = load(models, p, cs)
            if group == 'skin':
                pos, idx = crop_and_cluster(pos, idx)
            nrm = normals(pos, idx)
            if len(pos) > 65535:
                raise SystemExit(f"{p['id']} has too many vertices")
            def put(arr):
                while len(blob) % 4: blob.append(0)
                off = len(blob); blob.extend(arr.tobytes()); return off
            parts.append({'id': p['id'], 'name': p['name'], 'group': group, 'vertexCount': int(len(pos)),
                          'indexCount': int(idx.size), 'positions': put(pos.astype(np.float32)),
                          'normals': put(np.round(nrm * 32767).astype(np.int16)),
                          'indices': put(idx.astype(np.uint16).ravel())})
    os.makedirs(out, exist_ok=True)
    open(os.path.join(out, 'chest.bin'), 'wb').write(blob)
    meta = {'source': 'BodyParts3D 4.0 (DBCLS), via Human Atlas', 'license': 'CC BY 4.0',
            'attribution': 'BodyParts3D, © The Database Center for Life Science licensed under CC Attribution 4.0 International',
            'axes': '+y up, +z anterior, +x patient left, metres', 'format': {'positions': 'float32x3', 'normals': 'int16x3 normalised', 'indices': 'uint16'},
            'parts': parts}
    json.dump(meta, open(os.path.join(out, 'chest.json'), 'w'), separators=(',', ':'))
    tri = sum(p['indexCount'] for p in parts) // 3
    print(len(parts), 'parts', tri, 'triangles', len(blob) / 1e6, 'MB')


if __name__ == '__main__':
    if len(sys.argv) != 3: sys.exit(__doc__)
    main(*sys.argv[1:])
