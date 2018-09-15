@echo off
gource --load-config gource.conf -o - | ffmpeg -r 30 -f image2pipe -vcodec ppm -i - -vcodec libx264 -pix_fmt yuv420p -crf 1 -bf 0 gource.mp4