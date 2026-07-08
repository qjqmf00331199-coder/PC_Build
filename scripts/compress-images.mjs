import sharp from "sharp";
import { statSync, renameSync } from "fs";
import path from "path";

const PUBLIC = path.resolve(process.cwd(), "public");

const targets = [
  { file: "ad-desktop.jpg", opts: { quality: 78, mozjpeg: true } },
  { file: "miku-bg-mobile.png", opts: { quality: 82, compressionLevel: 9 } },
  { file: "miku-bg-desktop.jpg", opts: { quality: 82, mozjpeg: true } },
  { file: "og-image.png", opts: { quality: 82, compressionLevel: 9 } },
];

for (const { file, opts } of targets) {
  const filePath = path.join(PUBLIC, file);
  const tmpPath = filePath + ".tmp";
  const before = statSync(filePath).size;

  const img = sharp(filePath);
  const ext = path.extname(file).toLowerCase();
  if (ext === ".jpg" || ext === ".jpeg") {
    await img.jpeg(opts).toFile(tmpPath);
  } else if (ext === ".png") {
    await img.png(opts).toFile(tmpPath);
  }

  const after = statSync(tmpPath).size;
  if (after < before) {
    renameSync(tmpPath, filePath);
    console.log(`${file}: ${(before / 1024).toFixed(0)}KB -> ${(after / 1024).toFixed(0)}KB`);
  } else {
    console.log(`${file}: skip (no improvement, ${(before / 1024).toFixed(0)}KB -> ${(after / 1024).toFixed(0)}KB)`);
  }
}
