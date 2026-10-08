#!/usr/bin/env python3
"""Prepare HLS-CMDS clips for the Phòng Cận Lâm Sàng auscultation module.

Source: Torabi, Shirani, Reilly, "Descriptor: Heart and Lung Sounds Dataset Recorded
from a Clinical Manikin using Digital Stethoscope (HLS-CMDS)", IEEE Data Descriptions,
doi:10.1109/IEEEDATA.2025.3566012 — licensed CC BY 4.0.

Usage:
  python3 -I scripts/can-lam-sang/build-auscultation-audio.py <extracted-HLS-CMDS-dir> <out-audio-dir> <out-private-manifest.json>

<extracted-HLS-CMDS-dir> must contain HS/HS/*.wav and LS/LS/*.wav (the dataset's inner zips).
Each clip is DC-removed, loudness-normalised (the recordings are very quiet), resampled to
8 kHz mono and encoded as MP3. Output file names are random ids so the public file name
never reveals the sound type. The id -> label manifest is PRIVATE: this repository is
public, so the manifest is written outside the repo and must be loaded into the database
only (can_lam_sang_private.aus_clips), never committed.
"""
import array, json, os, secrets, subprocess, sys, tempfile, wave

HEART = {'N': 'normal', 'ESM': 'early_systolic_murmur', 'MSM': 'mid_systolic_murmur',
         'LSM': 'late_systolic_murmur', 'LDM': 'late_diastolic_murmur', 'S3': 's3', 'S4': 's4',
         'AF': 'atrial_fibrillation', 'AVB': 'av_block', 'T': 'tachycardia'}
LUNG = {'N': 'normal', 'CC': 'coarse_crackles', 'FC': 'fine_crackles', 'W': 'wheezing',
        'R': 'rhonchi', 'PR': 'pleural_rub'}
HEART_SITES = {'A': 'apex', 'RUSB': 'rusb', 'LUSB': 'lusb', 'LLSB': 'llsb', 'RC': 'rc', 'LC': 'lc'}
LUNG_SITES = {'RUA': 'rua', 'RMA': 'rma', 'RLA': 'rla', 'LUA': 'lua', 'LMA': 'lma', 'LLA': 'lla'}
TARGET_RMS_DBFS = -24.0
PEAK_LIMIT = 0.89  # about -1 dBFS


def normalise(src, dst):
    with wave.open(src) as w:
        assert w.getsampwidth() == 2 and w.getnchannels() == 1, src
        rate = w.getframerate()
        samples = array.array('h')
        samples.frombytes(w.readframes(w.getnframes()))
    mean = sum(samples) / len(samples)
    x = [s - mean for s in samples]
    rms = (sum(v * v for v in x) / len(x)) ** 0.5 or 1.0
    peak = max(abs(v) for v in x) or 1.0
    gain = min(10 ** (TARGET_RMS_DBFS / 20) * 32768 / rms, PEAK_LIMIT * 32768 / peak)
    out = array.array('h', (max(-32768, min(32767, int(round(v * gain)))) for v in x))
    with wave.open(dst, 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(rate)
        w.writeframes(out.tobytes())
    return round(20 * __import__('math').log10(gain), 1)


def main(src_root, out_dir, manifest_path):
    os.makedirs(out_dir, exist_ok=True)
    clips, used = [], set()
    jobs = []
    for kind, folder, types, sites in (('heart', 'HS/HS', HEART, HEART_SITES), ('lung', 'LS/LS', LUNG, LUNG_SITES)):
        for name in sorted(os.listdir(os.path.join(src_root, folder))):
            if not name.endswith('.wav'):
                continue
            sex, code, site = name[:-4].split('_')
            jobs.append((kind, os.path.join(src_root, folder, name), sex, types[code], sites[site], name))
    with tempfile.TemporaryDirectory() as tmp:
        for kind, path, sex, sound, site, name in jobs:
            clip_id = secrets.token_hex(8)
            while clip_id in used:
                clip_id = secrets.token_hex(8)
            used.add(clip_id)
            wav = os.path.join(tmp, clip_id + '.wav')
            gain_db = normalise(path, wav)
            mp3 = os.path.join(out_dir, clip_id + '.mp3')
            subprocess.run(['ffmpeg', '-v', 'error', '-y', '-i', wav, '-ar', '8000', '-ac', '1',
                            '-codec:a', 'libmp3lame', '-b:a', '24k', '-map_metadata', '-1',
                            '-write_xing', '0', mp3], check=True)
            clips.append({'clip_id': clip_id, 'kind': kind, 'sex': 'nam' if sex == 'M' else 'nu',
                          'sound_type': sound, 'site': site, 'source_file': name, 'gain_db': gain_db,
                          'bytes': os.path.getsize(mp3)})
    with open(manifest_path, 'w', encoding='utf-8') as f:
        json.dump(clips, f, ensure_ascii=False, indent=1)
    total = sum(c['bytes'] for c in clips)
    print(f'{len(clips)} clips, {total/1e6:.2f} MB, gain dB min/max '
          f'{min(c["gain_db"] for c in clips)}/{max(c["gain_db"] for c in clips)}')


if __name__ == '__main__':
    if len(sys.argv) != 4:
        sys.exit(__doc__)
    main(*sys.argv[1:])
