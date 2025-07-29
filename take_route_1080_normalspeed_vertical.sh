#!/bin/bash

# Prompt the user for the GoPro file.
echo "This is the 1080p VERTICAL version. Enter the path to the GoPro file or drag-and-drop here:"
read gopro_file  

# Prompt the user for the GPX file.
echo "Enter the path to the gpx file or drag-and-drop here:"
read gpx_file  

# Build the output file path for bottom map
output_goprovertical="${gopro_file%.*}_vertical.mp4"

#Vertical crop gopro video

ffmpeg -hide_banner \
    -i "$gopro_file" \
    -vf "crop=608:1080" \
    "$output_goprovertical"

# Build the output file path for padded vertical cropped video
output_goproverticalpadded="${gopro_file%.*}_verticalpadded.mp4"

# pad vertical cropped video

ffmpeg -hide_banner \
    -i "$output_goprovertical" \
    -vf "pad=width=iw:height=1200:x=0:y=0:color=black" \
    "$output_goproverticalpadded"

# Create bottom animated map

# Build the output file path for bottom map
output_map="${gpx_file%.*}_verticalmap.mp4"

# Run GPX Animator with the provided file paths.
java -jar /Users/evanmann/gpx-animator-1.8.2-all.jar \
  --height 10240 \
  --width 4320 \
  --color '#003AFF' \
  --tail-color '#3D69FF' \
  --tms-url-template 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={zoom}' \
  --background-map-visibility 1.0 \
  --viewport-height 200 \
  --viewport-width 608 \
  --speedup 1 \
  --tail-duration 10000 \
  --attribution-position hidden \
  --information-position hidden \
  --marker-size 15 \
  --line-width 10 \
  --input "$gpx_file" \
  --output "$output_map"

# Provide feedback to the user.
echo "Bottom map animation generated and saved to: $output_map"

# Build the output file path for overlay
output_overlay="${gopro_file%.*}_verticalgpx_overlay.mp4"

# Run ffmpeg command for overlay
ffmpeg -hide_banner \
    -i "$output_goproverticalpadded" \
    -i "$output_map" \
    -filter_complex "[0:v][1:v]overlay=W-w:H-h[outv]" \
    -map "[outv]" \
    -c:v libx264 \
    -crf 18 \
    -preset veryfast \
    -c:a copy \
    -r 30 \
    -loglevel warning \
    "$output_overlay"

# Provide feedback to the user.
echo "Overlay video generated and saved to: $output_overlay"

# Build the output file path for overlaycrop
output_overlay_cropped="${gopro_file%.*}_verticalgpx_overlay_cropped.mp4"

#crop final overlay video


ffmpeg -hide_banner \
    -i "$output_overlay" \
    -vf "crop=608:1080:0:120" \
    "$output_overlay_cropped"

echo "Final render completed and saved to: $output_goprovertical"

# cleanup unneeded files
rm "$output_map"
rm "$output_goprovertical"
rm "$output_goproverticalpadded"
rm "$output_overlay"
