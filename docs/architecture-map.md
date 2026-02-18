# Architecture Map

## Data Flow
```mermaid
graph TD
    User[User Interaction] -->|Clicks 'Orbit'| UI[Dashboard Page]
    UI -->|Adds Event| Bloc[DashboardBloc]
    Bloc -->|Requests KML| Gen[KMLGenerator]
    Gen -->|Returns XML| Bloc
    Bloc -->|Calls Upload| Repo[DashboardRepository]
    Repo -->|SFTP Upload| SSH[SSHService]
    SSH -->|Network| Master[LG Master Rig]
    Master -->|Syncs| Slaves[LG Slaves]
    Master -->|Renders| Screen[Display]
```

## Component Roles
1.  **Presentation**: `lib/features/*/presentation` - Dumb widgets + Smart BLoCs.
2.  **Domain/Data**: `lib/features/*/data` - Business logic and device communication.
3.  **Core**: `lib/core` - Shared utilities (SSH, Constants, KML Math).