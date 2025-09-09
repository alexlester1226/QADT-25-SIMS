Square-Cone IR Marker Simulation & GPS Conversion
Overview

This repository contains two parts:

MATLAB Script – Animates a 3D "square-based cone" representing a simulated drone’s field of view (FOV). The script places random IR markers on the ground plane and shows how the cone (camera view) detects them as the drone follows a predefined flight path. Detected markers are logged with line-of-sight traces.

Python Script – Converts the local waypoint coordinates (from the MATLAB simulation or predefined values) into GPS latitude/longitude coordinates. It generates a .kml file that can be visualized in Google Earth to see the waypoints in real-world locations.

This project was developed as part of the Queen’s Aerospace Design Team (QADT) to simulate IR marker detection and waypoint mapping.

Features
MATLAB Script

Simulates a drone-like cone-shaped field of view.

Generates random IR markers on the ground within a circular radius.

Animates drone movement in stages, including straight paths and turns.

Highlights markers when they are inside the field of view.

Logs line-of-sight connections between the drone apex and visible markers.

Python Script

Converts local Cartesian waypoints into latitude/longitude coordinates.

Accounts for Earth’s curvature by adjusting longitude scaling with latitude.

Generates a KML file (map.kml) with labeled waypoints for visualization in Google Earth
