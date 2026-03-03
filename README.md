# Take Route Scripts

Shell scripts for generating animated GPX route map videos and compositing them onto GoPro footage using GPX Animator and FFmpeg.

## What It Does

These scripts take a GPX track file and optionally a GoPro video, then produce a final video that combines the action footage with an animated map showing the route. The pipeline typically involves:

1. Generating animated map videos from GPX data (fullscreen and/or small corner overlay).
2. Optionally speeding up GoPro footage.
3. Overlaying the animated map onto the GoPro video.
4. Concatenating a fullscreen map intro with the overlaid video for the final render.

## Scripts

### End-to-End Pipelines

- **take_route_1080.sh** -- Full pipeline at 1080p. Speeds up GoPro video 4x, generates fullscreen and corner map animations, overlays the corner map, concatenates with the fullscreen intro, and cleans up intermediate files.
- **take_route_1080_normalspeed.sh** -- Same as above at 1080p but keeps the GoPro video at normal speed (no 4x speedup).
- **take_route_1080_normalspeed_vertical.sh** -- 1080p vertical (portrait) version. Crops GoPro footage to 608x1080, generates a bottom-edge map strip, overlays and crops to final vertical output.
- **take_route_4k.sh** -- Full pipeline at 4K (3840x2160). Speeds up GoPro video 4x, upscales map animations to 4K.
- **take_route_4k_normalspeed.sh** -- 4K pipeline at normal GoPro speed (no speedup).
- **take_route_4k_fullviewcorner.sh** -- 4K pipeline at normal speed with a full-view corner map.

### Standalone GPX Animation

- **gpxAnimatorCode_2_corner.sh** -- Generates a small corner-sized map animation (300x300 viewport) from a GPX file.
- **gpxAnimatorCode_3_fullscreen.sh** -- Generates a fullscreen map animation (1280x720) from a GPX file.
- **gpxAnimatorCode_4_webpage.sh** -- Generates a high-resolution map animation (1920x1080 viewport) intended for web use.

### Utility

- **ffmpeg_overlay.sh** -- Standalone FFmpeg command that composites one video on top of another in the bottom-right corner.

## Requirements

- Java (required to run GPX Animator)
- [GPX Animator](https://gpx-animator.app/) (`gpx-animator-1.8.2-all.jar`)
- FFmpeg
- A `.gpx` track file for the route
- GoPro video (`.mp4`) for the pipeline scripts
