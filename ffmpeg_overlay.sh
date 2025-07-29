ffmpeg \
    -i /Users/evanmann/Desktop/five_second_1080p.mp4 \
    -i /Users/evanmann/Desktop/five_second_corner.mp4 \
    -filter_complex "[0:v][1:v]overlay=W-w-50:H-h-50[outv]" \
    -map "[outv]" \
    -c:v libx264 \
    -crf 18 \
    -preset veryfast \
    -c:a copy \
    /Users/evanmann/Desktop/overlay.mp4