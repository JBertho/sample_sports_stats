# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Flutter basketball statistics tracking application** (sample_sport_stats). It allows users to track game statistics for basketball teams including player stats, quarters, and game history. The app uses SQLite for persistent storage and has a landscape-only UI.

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: BLoC/Cubit (flutter_bloc)
- **Routing**: go_router
- **Database**: SQLite (sqflite)
- **Charts**: fl_chart
- **UI**: Material Design 3
- **Fonts**: google_fonts

## Architecture

The project follows a layered architecture:

### Core Layers

1. **Pages Layer** (`lib/pages/`)
   - Contains screen implementations organized by feature
   - Each feature (currentGame, histories, TeamsSelection, etc.) has its own folder with:
     - `logic/` - Cubits for state management
     - `widget/` or `widgets/` - Reusable UI components
     - Feature-specific pages (e.g., `CurrentMatchPage.dart`)

2. **Infrastructure Layer** (`lib/infrastructure/`)
   - **DAO** (Data Access Objects) - Direct database operations
     - `game_dao.dart` - Game CRUD operations
     - `player_stats_dao.dart` - Player stats persistence
     - `quarter_dao.dart` - Quarter data management
     - `team_dao.dart` - Team CRUD operations
   - **Entities** - SQLite entity definitions matching database schema
     - `game_entity.dart`, `player_stats_entity.dart`, etc.
   - **SqliteHelper** - Singleton database initialization and connection management
     - Handles schema versioning (currently v2)
     - Manages table creation for teams, games, quarters, player_stats

3. **Models Layer** (`lib/models/`)
   - Business logic models (Game, Team, Player, MatchPlayer, etc.)
   - Separate from database entities

4. **Router** (`lib/router/`)
   - `router.dart` - GoRouter configuration with nested navigation
   - `routes.dart` - Route path constants
   - Uses `StatefulShellRoute` for bottom navigation with multiple branches

5. **UI Utilities**
   - `LayoutScaffold.dart` - Main scaffold with bottom navigation (Match, Historique, Stats)
   - `AppColors.dart` - Color constants
   - `AppFontStyle.dart` - Typography definitions

## Key State Management Pattern

The app uses **Cubit** (simplified BLoC) for state management:
- Cubits are instantiated in `main.dart` via `MultiBlocProvider`
- Current Cubits: `TeamSelectionCubit`, `HistoriesCubit`, `HistoryCubit`, `CurrentGameCubit`, `MatchCubit`
- Cubits are accessed via `context.read<CubitType>()` or `BlocBuilder`

## Database Schema

**Key Tables:**
- `team` - Team information (name, division, season)
- `game` - Game records with team/opponent scores and location (home/away)
- `quarter` - Quarter-level score tracking (associated with games)
- `player_stats` - Detailed player statistics including:
  - Shooting stats (2pt, 3pt, free throws - makes and misses)
  - Rebounds (offensive, defensive)
  - Blocks, counters, steals, turnovers, fouls/faults

**Access Pattern:** SQLite is accessed through DAOs, which use entities to map database rows to objects.

## Orientation

The app is locked to **landscape orientation** (set in `main.dart:23-26`). All UI should be designed with landscape aspect ratio in mind.

## Common Development Commands

**Install dependencies:**
```bash
flutter pub get
```

**Run the app:**
```bash
flutter run
```

**Run on a specific device:**
```bash
flutter run -d <device_id>
```

**Analyze code for linting issues:**
```bash
flutter analyze
```

**Format code:**
```bash
dart format lib
```

**Build for release:**
```bash
flutter build apk      # Android
flutter build ios      # iOS
flutter build windows  # Windows
```

**Run tests:**
```bash
flutter test
```

**Run a specific test file:**
```bash
flutter test test/widget_test.dart
```

## Code Style & Linting

- Follows `flutter_lints` from `pubspec.yaml`
- Lint rules are configured in `analysis_options.yaml`
- No special rule overrides currently enabled
- Run `flutter analyze` before committing to catch issues early

## Navigation Flow

The app has a **three-tab bottom navigation** structure:
1. **Match** - Create/manage current game and track live player stats
2. **Historique (History)** - View past games and their details
3. **Stats** - View aggregate statistics

Initial route is the **Teams Selection page** (`Routes.teamsPage`) where users must select their team before accessing the three-tab interface.

## Important Implementation Notes

- **Singleton Pattern**: `SqliteHelper` uses singleton pattern for database access
- **Landscape Lock**: Remember that landscape is enforced - don't add UI that assumes portrait
- **Player Stats Calculation**: Player stats are tracked per game and linked via `player_id` and `game_id`
- **DAO Pattern**: Always use DAOs for database operations, not direct queries
- **Cubit Access**: Use `context.read<CubitType>()` for Cubits, not providers directly

## Future Considerations

- The `MyHomePage` and `_MyHomePageState` classes in `main.dart` appear to be boilerplate from Flutter template and may be candidates for removal if not used
- Database schema versioning is in place (see `onUpgrade` in SqliteHelper) - plan for future migrations if schema changes

---

## Annexes: Technical Assessment

### Strengths ✅

1. **Well-structured architecture** - Clear separation of concerns (Pages → Infrastructure → Database)
2. **Modern & maintainable** - GoRouter, flutter_bloc, Material 3
3. **Solid DAO pattern** - Good abstraction for data access
4. **Feature-based organization** - Each page has its logic (Cubit) and widgets separated
5. **Database versioning** - Prepared for future migrations

### Technical Issues ⚠️

#### 1. **Nearly non-existent test coverage**
- Only `widget_test.dart` (boilerplate template)
- Zero tests for DAOs or Cubits
- High regression risk

#### 2. **Missing error handling**
DAOs perform SQL operations without visible try/catch blocks. If a query fails, the app crashes silently.

#### 3. **Database schema code duplication**
```dart
// In SqliteHelper
onCreate: (db, version) async { /* creates player_stats */ }
onUpgrade: (db, previous, after) async { /* recreates player_stats */ }
```
Same code duplicated → maintenance burden

#### 4. **Unused Flutter template boilerplate**
- `MyHomePage` and `_MyHomePageState` in main.dart appear unused
- Should be cleaned up

#### 5. **Weak typing in DAOs**
DAO return types could be more strongly typed (Future<List<T>> vs Future<List<Map>>)

#### 6. **No logging**
Difficult to debug in production without logs

#### 7. **Missing input validation**
- No validation before inserting into database
- Risk of corrupted data

#### 8. **Cubit initialization**
Cubits are created at startup via `MultiBlocProvider` even if not immediately used. Consider lazy initialization for better resource management.

### Priority Recommendations

| Priority | Action |
|----------|--------|
| 🔴 High | Add unit tests for DAOs and Cubits |
| 🔴 High | Implement robust error handling |
| 🟠 Medium | Refactor database schema duplication |
| 🟠 Medium | Add logging throughout the app |
| 🟠 Medium | Remove unused boilerplate code |
| 🟡 Low | Consider Repository pattern to encapsulate DAOs |

### Summary

The base architecture is solid, but the project **lacks robustness** (tests, error handling, logging). It's a functional MVP but not production-ready in its current state.
