"""Pitch-correct piano WAV samples to A=440 equal temperament.

Reads every WAV file under assets/notes/piano/, detects the actual fundamental
frequency, and resamples each one so it plays at the correct equal-tempered
pitch. Originals are backed up to assets/notes/piano_original/ before being
overwritten.

Run from the project root:
    python3 tools/tune_piano_wavs.py            # dry-run, show detection
    python3 tools/tune_piano_wavs.py --apply    # actually correct files

Requires: numpy, scipy.
    pip install numpy scipy --break-system-packages
"""

import argparse
import math
import os
import shutil
import sys
import wave
import numpy as np
from scipy.signal import resample_poly

NOTE_SEMITONES = {
    'C': 0, 'C#': 1, 'Db': 1, 'D': 2, 'D#': 3, 'Eb': 3, 'E': 4, 'F': 5,
    'F#': 6, 'Gb': 6, 'G': 7, 'G#': 8, 'Ab': 8, 'A': 9, 'A#': 10, 'Bb': 10,
    'B': 11,
}


def expected_freq(name, octave):
    semi = NOTE_SEMITONES[name] - 9 + (octave - 4) * 12
    return 440.0 * (2 ** (semi / 12))


def parse_filename(fname):
    stem = fname[:-4]
    octave_str = ''.join(c for c in stem if c.isdigit())
    note = ''.join(c for c in stem if not c.isdigit())
    return note, int(octave_str)


def read_wav(path):
    with wave.open(path, 'rb') as w:
        sr = w.getframerate()
        ch = w.getnchannels()
        sw = w.getsampwidth()
        n = w.getnframes()
        raw = w.readframes(n)
    if sw == 2:
        a = np.frombuffer(raw, dtype=np.int16).astype(np.float64)
    elif sw == 3:
        b = np.frombuffer(raw, dtype=np.uint8).reshape(-1, 3)
        i32 = (b[:, 0].astype(np.int32) | (b[:, 1].astype(np.int32) << 8) |
               (b[:, 2].astype(np.int32) << 16))
        i32[i32 >= 1 << 23] -= 1 << 24
        a = i32.astype(np.float64)
    else:
        a = np.frombuffer(raw, dtype=np.int32).astype(np.float64)
    if ch == 2:
        a = a.reshape(-1, 2)
    else:
        a = a.reshape(-1, 1)
    return a, sr, sw


def write_wav(path, samples, sr, sw):
    """Write multi-channel float samples back to PCM WAV."""
    with wave.open(path, 'wb') as w:
        w.setnchannels(samples.shape[1])
        w.setsampwidth(sw)
        w.setframerate(sr)
        if sw == 2:
            clipped = np.clip(samples, -32768, 32767).astype(np.int16)
            w.writeframes(clipped.tobytes())
        elif sw == 3:
            clipped = np.clip(samples, -(1 << 23), (1 << 23) - 1).astype(np.int32)
            packed = bytearray()
            for v in clipped.flatten():
                packed += int(v & 0xFFFFFF).to_bytes(3, 'little', signed=False)
            w.writeframes(bytes(packed))
        else:
            clipped = np.clip(samples, -(1 << 31), (1 << 31) - 1).astype(np.int32)
            w.writeframes(clipped.tobytes())


def detect_offset_cents(samples, sr, expected):
    """Return (cents_offset, detected_freq) using narrow-band FFT search."""
    mono = samples.mean(axis=1) if samples.shape[1] > 1 else samples[:, 0]
    start = int(sr * 0.15)
    seg = mono[start:start + int(sr * 1.0)]
    if len(seg) < 8192:
        return None
    seg = seg - seg.mean()
    seg *= np.hanning(len(seg))
    N = 1 << 19
    fft = np.fft.rfft(seg, N)
    mag = np.abs(fft)
    freqs = np.fft.rfftfreq(N, 1 / sr)
    lo = expected * 2 ** (-50 / 1200)
    hi = expected * 2 ** (50 / 1200)
    i_lo = np.searchsorted(freqs, lo)
    i_hi = np.searchsorted(freqs, hi)
    if i_hi <= i_lo + 2:
        return None
    band = mag[i_lo:i_hi]
    peak = i_lo + int(np.argmax(band))
    if 1 <= peak < len(mag) - 1:
        y0, y1, y2 = mag[peak - 1], mag[peak], mag[peak + 1]
        denom = (y0 - 2 * y1 + y2)
        offset = 0.5 * (y0 - y2) / denom if denom != 0 else 0
        peak_f = (peak + offset) * sr / N
    else:
        peak_f = peak * sr / N
    return 1200 * math.log2(peak_f / expected), peak_f


def shift_pitch_cents(samples, cents):
    """Shift pitch by `cents` (positive = up) using polyphase resampling.

    The trick: keep the WAV header sample rate unchanged, but resample the
    audio data at a different effective rate. To raise pitch we need *fewer*
    output samples (audio plays faster when read at original sr). To lower
    pitch we need *more* output samples (audio plays slower).

    So output_len / input_len = 2^(-cents/1200).
    """
    if abs(cents) < 0.05:
        return samples  # too small to matter
    target_ratio = 2 ** (-cents / 1200.0)
    # Find integer up/down approximating target_ratio. up/down = target_ratio
    best = (1, 1, abs(1 - target_ratio))
    for down in range(1, 4096):
        up = round(down * target_ratio)
        if up <= 0:
            continue
        err = abs(up / down - target_ratio)
        if err < best[2]:
            best = (up, down, err)
            err_cents = abs(-1200 * math.log2(up / down) - cents)
            if err_cents < 0.05:
                break
    up, down, _ = best
    out_channels = []
    for ch in range(samples.shape[1]):
        out_channels.append(resample_poly(samples[:, ch], up, down))
    return np.stack(out_channels, axis=1)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--apply', action='store_true',
                        help='Actually overwrite files (otherwise dry-run).')
    parser.add_argument('--dir', default='assets/notes/piano',
                        help='WAV folder relative to project root.')
    parser.add_argument('--threshold', type=float, default=2.0,
                        help='Minimum |offset| in cents to bother correcting.')
    args = parser.parse_args()

    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    wav_dir = os.path.join(project_root, args.dir)
    backup_dir = os.path.join(project_root, args.dir + '_original')

    if not os.path.isdir(wav_dir):
        print(f'Folder not found: {wav_dir}', file=sys.stderr)
        sys.exit(1)

    files = sorted(f for f in os.listdir(wav_dir) if f.endswith('.wav'))
    if not files:
        print('No .wav files found.', file=sys.stderr)
        sys.exit(1)

    if args.apply and not os.path.isdir(backup_dir):
        os.makedirs(backup_dir)
        print(f'Created backup folder: {backup_dir}')

    print(f'{"file":12}{"detected":>11}{"target":>11}{"offset":>9}{"correction":>12}')
    print('-' * 56)

    for f in files:
        try:
            note, octave = parse_filename(f)
            target = expected_freq(note, octave)
        except (KeyError, ValueError):
            print(f'{f}: cannot parse note name; skipping')
            continue

        path = os.path.join(wav_dir, f)
        samples, sr, sw = read_wav(path)
        result = detect_offset_cents(samples, sr, target)
        if result is None:
            print(f'{f}: detection failed')
            continue
        cents, detected = result
        correction = -cents
        marker = '' if abs(cents) >= args.threshold else '  (skipped, within threshold)'
        print(f'{f:12}{detected:>9.2f}Hz{target:>9.2f}Hz{cents:>+8.2f}c{correction:>+10.2f}c{marker}')

        if not args.apply or abs(cents) < args.threshold:
            continue

        # Back up original
        backup_path = os.path.join(backup_dir, f)
        if not os.path.exists(backup_path):
            shutil.copy2(path, backup_path)

        corrected = shift_pitch_cents(samples, correction)
        write_wav(path, corrected, sr, sw)

    if not args.apply:
        print('\nDry-run only. Re-run with --apply to write corrections.')
    else:
        print(f'\nDone. Originals backed up to {backup_dir}.')


if __name__ == '__main__':
    main()
