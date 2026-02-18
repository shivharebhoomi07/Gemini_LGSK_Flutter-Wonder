# 🗺️ LIQUID GALAXY STARTER KIT: FILE MANIFEST
**CRITICAL DIRECTIVE FOR ALL AI AGENTS:** This document defines the exact purpose of every core file in this Flutter project. You must use these files for their intended purposes. You are strictly forbidden from duplicating their logic, overwriting them, or bypassing them.





* **`lib/core/models/connection_params_model.dart`**
  * **Purpose:** The data entity that holds the dynamic Rig credentials (`ipAddress`, `port`, `username`, `password`). 
  * **Rule:** Never hardcode IP addresses. Always use this model.

## 🟢 2. THE CONNECTION FEATURE (`lib/features/connection/`)
*This feature handles the user interface and state for connecting to the Rig.*

* **`lib/features/connection/presentation/pages/connection_page.dart`**
  * **Purpose:** The UI screen (or Settings Drawer) containing text fields for IP, Port, Username, and Password. 
  * **Rule:** New features must assume this page exists and handles the connection beforehand.

* **`lib/features/connection/presentation/bloc/connection_bloc.dart`**
  * **Purpose:** Manages the global state (`Connected`, `Disconnected`, `Error`) of the Rig.

## 🔵 3. NEW FEATURE GENERATION RULES (`lib/features/[new_feature]/`)
*When instructed to build a new feature (e.g., "Compass", "VolcanoTracker"), you must scaffold it EXACTLY like this:*

* **`domain/entities/`**: Pure Dart models (e.g., `CompassDirection.dart`). No Flutter UI or SSH logic allowed here.
* **`domain/repositories/`**: Abstract interfaces defining what the feature can do.
* **`data/repositories/`**: The concrete implementation. **This is the ONLY place that should import `ssh_service.dart`.**
* **`presentation/bloc/`**: The state machine bridging the UI to the Data layer.
* **`presentation/pages/`**: The Flutter UI Widgets.

## 🟡 4. THE ENTRY POINT
* **`lib/main.dart`**
  * **Purpose:** App initialization.
  * **Rule:** When creating a new feature, you must register its BLoC and Repository here using the existing dependency injection (e.g., `MultiBlocProvider`).