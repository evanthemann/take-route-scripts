#!/bin/bash

# Prompt the user for the GPX file.
echo "Enter the path to the GPX file or drag-and-drop the file here:"
read -e gpx_file  # -e option enables tab completion for file paths

# Extract the directory path (without the file name) from the provided GPX file path.
output_directory=$(dirname "$gpx_file")

# Build the output file path by replacing the .gpx extension with .mp4.
output_file="${gpx_file%.*}_corner.mp4"

# Run GPX Animator with the provided file paths.
java -jar gpx-animator-1.8.2-all.jar \
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
  --output "$output_file"

# Provide feedback to the user.
echo "Animation generated and saved to: $output_file"
