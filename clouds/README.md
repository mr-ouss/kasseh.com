# Ocean Shader Demo

This is a recreation of the Three.js ocean shader example without the rotating cube.

## Features

- Realistic water simulation with wave animations
- Dynamic sky with sun positioning
- Interactive camera controls (orbit around the scene)
- GUI controls for customizing:
  - Sky elevation and azimuth
  - Water distortion scale
  - Water wave size

## How to Use

### Option 1: Open Directly
Simply open `index.html` in a modern web browser. The page uses CDN links for Three.js libraries.

### Option 2: Local Server (Recommended)
For better performance and to avoid CORS issues, serve the file through a local server:

```bash
# Using Python 3
python -m http.server 8000

# Or using Node.js http-server
npx http-server

# Or using PHP
php -S localhost:8000
```

Then navigate to `http://localhost:8000/ocean/` in your browser.

## Controls

- **Left Mouse Button**: Rotate camera (orbit)
- **Right Mouse Button**: Pan camera
- **Mouse Wheel**: Zoom in/out
- **GUI Panel**: Adjust sky and water parameters in real-time

## Technical Details

This demo uses:
- **Three.js r160** - 3D graphics library
- **Water.js** - Advanced water shader with reflections and refractions
- **Sky.js** - Atmospheric scattering sky shader
- **OrbitControls** - Camera control system
- **lil-gui** - GUI controls for parameters

## Source

Based on the official Three.js example:
https://threejs.org/examples/webgl_shaders_ocean.html

Modified to remove the rotating cube mesh and focus solely on the ocean and sky environment.
