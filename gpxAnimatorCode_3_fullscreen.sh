#!/bin/bash

# Prompt the user for the GPX file.
echo "Enter the path to the GPX file or drag-and-drop the file here:"
read -e gpx_file  # -e option enables tab completion for file paths

# Extract the directory path (without the file name) from the provided GPX file path.
output_directory=$(dirname "$gpx_file")

# Build the output file path by replacing the .gpx extension with .mp4.
output_file="${gpx_file%.*}_fullscreen.mp4"

# Run GPX Animator with the provided file paths.
java -jar gpx-animator-1.8.2-all.jar \
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
  --output "$output_file"

# Add --zoom 15 \ or other number above if want

# Provide feedback to the user.
echo "Animation generated and saved to: $output_file"
