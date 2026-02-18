# Design Document: The Taj Mahal Cinematic Tour
**Date:** 2026-02-15
**Feature:** Native KML Tour Engine (Option B)

## 1. Overview
This feature implements a "Native Tour" strategy for the Liquid Galaxy rig. Instead of streaming continuous `flyTo` commands (which can jitter), we will generate a robust KML `<gx:Tour>` file, upload it once, and trigger it. This ensures frame-perfect, smooth 360-degree orbits of the Taj Mahal.

## 2. User Interface (Presentation Layer)
### Connection Page
- **Input Fields:** IP Address, Port (def: 22), **Username** (def: lg), **Password** (def: lg), Screen Count (def: 3).
- **Validation:** All fields required.
- **Action:** "Connect" button triggers `ConnectToLG` event.

### Dashboard Page
- **Grid Layout:** 
    - Card 1: **"Visit Taj Mahal"** (FlyTo directly).
    - Card 2: **"Start Orbit"** (Triggers Tour).
    - Card 3: **"Stop Orbit"** (Halts Tour).
- **State Feedback:** When orbiting, the "Start" button becomes "Stop" or is disabled.

## 3. BLoC Architecture
### `ConnectionBloc`
- **Event:** `ConnectToLG(DisconnectParams params)`
- **Logic:** Calls `repository.connect()`. Fails if credentials invalid.

### `DashboardBloc`
- **Event:** `StartOrbit(Wonder wonder)`
- **Logic:**
    1.  Calls `KMLGenerator.generateTour(wonder)`.
    2.  Calls `repository.uploadKml(kmlString)`.
    3.  Calls `repository.startTour()`.
    4.  Emits `DashboardTouring`.

## 4. Data Layer & KML Logic
### `KMLGenerator` (Core Utility)
- **Method:** `generateOrbitTag(double lat, double lng, double range, double tilt, double heading)`
- **Output:** XML string containing:
    ```xml
    <gx:Tour>
      <name>Orbit</name>
      <gx:Playlist>
        <gx:FlyTo>...</gx:FlyTo> <!-- Go to start -->
        <gx:Wait><gx:duration>1.0</gx:duration></gx:Wait>
        <gx:FlyTo>...</gx:FlyTo> <!-- 360 degree path -->
      </gx:Playlist>
    </gx:Tour>
    ```

### `DashboardRepository`
- **Method:** `execute` (from SSHService) used to run `echo "playtour=Orbit" > /tmp/query.txt` on the Master.

## 5. Engineering Concepts (Knowledge Capture)
- **State Sovereignty:** The BLoC determines if the Rig is orbiting, not the Rig itself.
- **Latency Masking:** By uploading the *entire* tour at once, we eliminate network lag during the animation.
- **Separation of Concerns:** Connection credentials are strictly handled in the Connection feature; Dashboard only knows *that* it is connected.
