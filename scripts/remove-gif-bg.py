import sys
from PIL import Image, ImageSequence
from collections import deque

TOLERANCE = 30  # how close to white counts as "background"


def is_bg(px, ref=(255, 255, 255)):
    return all(abs(px[i] - ref[i]) <= TOLERANCE for i in range(3))


def flood_fill_transparent(rgba_img):
    w, h = rgba_img.size
    px = rgba_img.load()
    visited = bytearray(w * h)
    q = deque()

    for x in range(w):
        for y in (0, h - 1):
            if not visited[y * w + x] and is_bg(px[x, y]):
                q.append((x, y))
                visited[y * w + x] = 1
    for y in range(h):
        for x in (0, w - 1):
            if not visited[y * w + x] and is_bg(px[x, y]):
                q.append((x, y))
                visited[y * w + x] = 1

    while q:
        x, y = q.popleft()
        r, g, b, a = px[x, y]
        px[x, y] = (r, g, b, 0)
        for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if 0 <= nx < w and 0 <= ny < h and not visited[ny * w + nx]:
                if is_bg(px[nx, ny]):
                    visited[ny * w + nx] = 1
                    q.append((nx, ny))
    return rgba_img


def main():
    src, out_gif, out_preview = sys.argv[1], sys.argv[2], sys.argv[3]
    im = Image.open(src)
    durations = []
    frames_rgba = []

    for i, frame in enumerate(ImageSequence.Iterator(im)):
        rgba = frame.convert("RGBA")
        rgba = flood_fill_transparent(rgba)
        frames_rgba.append(rgba)
        durations.append(frame.info.get("duration", 100))

    # crop to the union bounding box of all frames so the sprite has no dead space,
    # using the same box for every frame to avoid jitter
    boxes = [f.getbbox() for f in frames_rgba]
    crop_box = (
        min(b[0] for b in boxes),
        min(b[1] for b in boxes),
        max(b[2] for b in boxes),
        max(b[3] for b in boxes),
    )
    frames_rgba = [f.crop(crop_box) for f in frames_rgba]

    frames_rgba[0].save(out_preview)

    # build a palette-based transparent GIF
    pal_frames = []
    for rgba in frames_rgba:
        alpha = rgba.split()[3]
        bg = Image.new("RGBA", rgba.size, (255, 255, 255, 255))
        composited = Image.alpha_composite(bg, rgba)
        pal = composited.convert("RGB").convert("P", palette=Image.ADAPTIVE, colors=255)
        mask = alpha.point(lambda a: 255 if a <= 10 else 0)
        pal.paste(255, mask)
        pal_frames.append(pal)

    pal_frames[0].save(
        out_gif,
        save_all=True,
        append_images=pal_frames[1:],
        duration=durations,
        loop=0,
        transparency=255,
        disposal=2,
        optimize=False,
    )
    print("wrote", out_gif, "frames", len(pal_frames))


if __name__ == "__main__":
    main()
