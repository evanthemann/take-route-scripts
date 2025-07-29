#!/bin/bash

export TZ="America/New_York"
current_time=$(date +"%Y-%m-%d %H:%M:%S")

# Prompt the user for the GoPro file.
echo "This is the 4k version. Enter the path to the GoPro file or drag-and-drop here:"
read gopro_file  

# Prompt the user for the GPX file.
echo "Enter the path to the gpx file or drag-and-drop here:"
read gpx_file  

# Build the output file path for fullscreen
output_fullscreen="${gpx_file%.*}_fullscreen.mp4"

# Provide feedback to the user.
echo "Creating full screen animation..."

# Run GPX Animator with the provided file paths.
java -jar gpx-animator-1.8.2-all.jar > /dev/null 2>&1 \
  --height 720 \
  --width 1280 \
  --color '#003AFF' \
  --tail-color '#3D69FF' \
  --tms-url-template 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={zoom}' \
  --background-map-visibility 1.0 \
  --speedup 1000 \
  --tail-duration 10000 \
  --attribution-position hidden \
  --information-position hidden \
  --marker-size 12 \
  --line-width 6 \
  --keep-first-frame 2000 \
  --keep-last-frame 4000 \
  --input "$gpx_file" \
  --output "$output_fullscreen"

# Provide feedback to the user.
echo "Fullscreen animation generated."

# Provide feedback to the user.
echo "Upscaling full screen animation..."

# Build the output file path for upscaled fullscreen
output_fullscreen_upscaled="${output_fullscreen}_upscaled.mp4"

# FFMPEG command to upscaled fullscreen gpx to 4k
ffmpeg -hide_banner -i "$output_fullscreen" -vf "scale=3840:2160,setsar=1" -loglevel warning -r 30 "$output_fullscreen_upscaled"

# Provide feedback to the user.
echo "Fullscreen video upscaled to 4k."

# Build the output file path for corner
output_corner="${gpx_file%.*}_corner.mp4"

# Provide feedback to the user.
echo "Creating corner animation..."

# Run GPX Animator with the provided file paths.
java -jar gpx-animator-1.8.2-all.jar > /dev/null 2>&1 \
  --height 10240 \
  --width 4320 \
  --color '#003AFF' \
  --tail-color '#3D69FF' \
  --tms-url-template 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={zoom}' \
  --background-map-visibility 1.0 \
  --viewport-height 300 \
  --viewport-width 300 \
  --speedup 4 \
  --tail-duration 10000 \
  --attribution-position hidden \
  --information-position hidden \
  --marker-size 15 \
  --line-width 10 \
  --input "$gpx_file" \
  --output "$output_corner"

# Provide feedback to the user.
echo "Corner animation generated."

# Build the output file path for upscaled corner
output_corner_upscaled="${output_corner}_upscaled.mp4"

# Provide feedback to the user.
echo "Upscaling corner animation..."

# FFMPEG command to upscaled corner gpx to 600x600
ffmpeg -hide_banner -i "$output_corner" -vf "scale=600:600,setsar=1" -loglevel warning -r 30 "$output_corner_upscaled"

# Provide feedback to the user.
echo "Corner video upscaled to 600x600."

# Provide feedback to the user.
echo "Speeding up GoPro video..."

# Build the output file path for speedup 
output_speed="${gopro_file%.*}_speed4x.mp4"

# FFMPEG Command to speed up the gopro video 4x
ffmpeg -hide_banner -i "$gopro_file" -filter_complex "[0:v]setpts=0.25*PTS[v];[0:a]asetpts=0.25*PTS[a]" -map "[v]" -map "[a]" -loglevel warning -r 30 "$output_speed"

# Provide feedback to the user.
echo "Video speed up successful."

# Build the output file path for overlay
output_overlay="${gopro_file%.*}_gpx_overlay.mp4"

# Provide feedback to the user.
echo "Overlaying upscaled corner video on GoPro video..."

# Run ffmpeg command for overlay
ffmpeg -hide_banner \
    -i "$output_speed" \
    -i "$output_corner_upscaled" \
    -filter_complex "[0:v][1:v]overlay=W-w-100:H-h-100[outv]" \
    -map "[outv]" \
    -c:v libx264 \
    -crf 18 \
    -preset veryfast \
    -c:a copy \
    -r 30 \
    -loglevel warning \
    "$output_overlay"

# Provide feedback to the user.
echo "Overlay video generated."

# Build the output file path for final render
final_render="${gopro_file%.*}_gpx_render.mp4"

# Provide feedback to the user.
echo "Concatenating videos for final render..."

# ffmpeg command to concatenate for the final render
ffmpeg -hide_banner -i "$output_fullscreen_upscaled" -i "$output_overlay" -filter_complex "[0:v][1:v]concat=n=2[v]" -map "[v]" -pix_fmt yuv420p -loglevel warning -r 30 "$final_render"

# cleanup unneeded files
rm "$output_speed"
rm "$output_fullscreen"
rm "$output_corner"
rm "$output_overlay"
rm "$output_fullscreen_upscaled"
rm "$output_corner_upscaled"

# Provide feedback to the user.
echo "Final render completed on $current_time."