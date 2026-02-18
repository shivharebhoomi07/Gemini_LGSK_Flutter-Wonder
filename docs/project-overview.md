# Project Overview: LG Star Command

## 🌟 Vision
An interactive, educational dashboard designed specifically for Liquid Galaxy. The app features a modern, dark-themed UI displaying the **New Seven Wonders of the World**. It dynamically generates and executes cinematic `<gx:FlyTo>` KML payloads via SSH, providing smooth, angled 3D orbits with a special emphasis on a high-fidelity flight for the **Taj Mahal**.

## 🛠 Rig Topology
- **Screen Count**: 3
- **Master IP**: Dynamic (User input at runtime)
- **SSH Port**: 22
- **Target Device**: Phone (Portrait)

## 🏗 Architecture
The project follows a strict **Clean Architecture** with feature-based modularity:

### Core Layer (`lib/core`)
- **SSHService**: encapsulated logic for `dartssh2`.
- **AppConstants**: defaults for Rig configuration.
- **Failures**: custom `LGException` handling.

### Features (`lib/features`)
1.  **Connection**: Handles SSH handshake, credential storage, and connection state.
2.  **Dashboard**: Manages the main UI, KML generation, and visualization state.

## 🚀 Next Steps (Brainstorming)
- Define `ConnectionBloc` events for dynamic IP entry.
- Define `DashboardBloc` events for "View Wonder", "Orbit", "Fly To Home".
- Design the KML template for the **Taj Mahal** orbit.
