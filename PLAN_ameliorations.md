# Plan d'Amélioration - Sample Sports Stats

Stratégie de développement pour rendre le projet production-ready.

## 🔴 Priorité Haute

### 1. Ajouter des Tests Unitaires

**Problème:** Aucun test pour les DAOs ou Cubits. Risque de régressions à chaque changement.

**Actions:**
- [ ] Créer des tests pour `GameDAO`
  - Test insert game
  - Test update game
  - Test get games by team
  - Test delete game
- [ ] Créer des tests pour `PlayerStatsDAO`
  - Test insert/update player stats
  - Test query stats by player/game
- [ ] Créer des tests pour `TeamDAO`
- [ ] Créer des tests pour `QuarterDAO`
- [ ] Créer des tests pour chaque `Cubit`
  - Test initial state
  - Test state changes après actions
  - Test interactions avec DAOs
- [ ] Setup mocking (mockito pour les DAOs)
- [ ] Viser au minimum 70% de coverage

**Outils:**
```bash
flutter test --coverage
# Générer rapport coverage
genhtml coverage/lcov.info -o coverage/html
```

**Ressources:**
- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [Mocktail for Mocking](https://pub.dev/packages/mocktail)

---

### 2. Implémenter Gestion d'Erreurs Robuste

**Problème:** Les DAOs font des opérations sans try/catch. Les erreurs causent des crashes silencieux.

**Actions:**
- [ ] Créer une classe personnalisée pour les erreurs
  ```dart
  abstract class AppException implements Exception {
    final String message;
    AppException(this.message);
  }

  class DatabaseException extends AppException {
    DatabaseException(String message) : super(message);
  }

  class ValidationException extends AppException {
    ValidationException(String message) : super(message);
  }
  ```

- [ ] Wrapper tous les appels database dans les DAOs
  ```dart
  Future<List<Game>> getGamesByTeam(int teamId) async {
    try {
      final db = await database;
      final games = await db.query('game', where: 'team_id = ?', whereArgs: [teamId]);
      return games.map((g) => GameEntity.fromMap(g)).toList();
    } on DatabaseException catch (e) {
      // Log erreur
      rethrow;
    }
  }
  ```

- [ ] Mettre à jour les Cubits pour gérer les états d'erreur
  ```dart
  class GameState {
    final List<Game> games;
    final bool isLoading;
    final String? error;
    GameState({
      this.games = const [],
      this.isLoading = false,
      this.error,
    });
  }
  ```

- [ ] Afficher des messages d'erreur aux utilisateurs avec SnackBar/Dialog
- [ ] Implémenter retry logic pour les opérations critiques

---

### 3. Ajouter Logging

**Problème:** Aucun logging. Impossible de débugger en production.

**Actions:**
- [ ] Ajouter dépendance logging
  ```yaml
  dependencies:
    logger: ^2.0.0  # ou talker, ou sentry
  ```

- [ ] Créer service de logging centralisé
  ```dart
  class LogService {
    static final _logger = Logger();

    static void debug(String message) => _logger.d(message);
    static void info(String message) => _logger.i(message);
    static void warning(String message) => _logger.w(message);
    static void error(String message, dynamic error) => _logger.e(message, error: error);
  }
  ```

- [ ] Logger dans les DAOs: avant/après opérations DB
- [ ] Logger dans les Cubits: changements d'état, erreurs
- [ ] Logger dans les pages: navigation, interactions utilisateur
- [ ] Configurer export de logs (fichier ou service cloud)

---

## 🟠 Priorité Moyenne

### 4. Refactoriser Duplication Schema Database

**Problème:** Code du schema duplicé entre `onCreate` et `onUpgrade` dans SqliteHelper.

**Actions:**
- [ ] Extraire définition des tables dans des constantes
  ```dart
  const String _teamTableSchema = '''
    CREATE TABLE team (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      division TEXT,
      season TEXT
    )
  ''';

  const String _playerStatsTableSchema = '''
    CREATE TABLE player_stats (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      score INTEGER NOT NULL DEFAULT 0,
      ...
    )
  ''';
  ```

- [ ] Réutiliser dans onCreate et onUpgrade
  ```dart
  onCreate: (db, version) async {
    await db.execute(_teamTableSchema);
    await db.execute(_playerStatsTableSchema);
    ...
  }

  onUpgrade: (db, previous, after) async {
    if (previous < 2) {
      await db.execute(_playerStatsTableSchema);
    }
  }
  ```

- [ ] Améliorer la logique de versioning pour futures migrations

---

### 5. Nettoyer Code Boilerplate

**Problème:** `MyHomePage` et `_MyHomePageState` dans main.dart ne sont pas utilisés.

**Actions:**
- [ ] Vérifier qu'ils ne sont appelés nulle part
  ```bash
  grep -r "MyHomePage" lib/
  ```
- [ ] Les supprimer si vraiment inutilisés
- [ ] Garder les imports essentiels uniquement

---

### 6. Ajouter Validation des Inputs

**Problème:** Pas de validation avant d'insérer en database. Risque de données corrompues.

**Actions:**
- [ ] Créer classe utilitaire de validation
  ```dart
  class Validators {
    static bool isValidTeamName(String name) => name.isNotEmpty && name.length <= 100;
    static bool isValidScore(int score) => score >= 0;
    static bool isValidQuarterNumber(int quarter) => quarter >= 1 && quarter <= 4;
  }
  ```

- [ ] Valider avant les appels DAO
  ```dart
  Future<void> saveGame(Game game) async {
    if (!Validators.isValidTeamName(game.opponentName)) {
      throw ValidationException('Invalid opponent name');
    }
    await gameDao.insert(game);
  }
  ```

- [ ] Valider dans les Cubits aussi
- [ ] Afficher erreurs de validation à l'utilisateur

---

### 7. Améliorer Typage des DAOs

**Problème:** Return types faibles (List<Map>) au lieu de types fortement typés.

**Actions:**
- [ ] S'assurer tous les DAOs retournent des objets typés
  ```dart
  // ❌ Avant
  Future<List<Map<String, dynamic>>> getGames() async { ... }

  // ✅ Après
  Future<List<Game>> getGames() async { ... }
  ```

- [ ] Utiliser les Entities pour mapper les résultats
- [ ] Ajouter méthodes de conversion dans les Entities si nécessaire

---

## 🟡 Priorité Basse

### 8. Optimiser Initialisation des Cubits

**Problème:** Tous les Cubits sont créés au démarrage même s'ils ne sont pas immédiatement utilisés.

**Actions:**
- [ ] Évaluer s'il faut vraiment tous les Cubits au démarrage
  - `TeamSelectionCubit` → Nécessaire (première page)
  - `HistoriesCubit` → Peut attendre la navigation
  - `HistoryCubit` → Peut attendre la navigation

- [ ] Implémenter lazy loading si nécessaire
  ```dart
  BlocProvider<HistoriesCubit>(
    lazy: true,  // Créé à la première utilisation
    create: (_) => HistoriesCubit(gameDAO: GameDAO(), quarterDao: QuarterDao()),
  )
  ```

---

### 9. Considérer Repository Pattern (Optionnel)

**Problème:** DAOs directement injectés dans Cubits. Peut devenir difficile à maintenir.

**Actions:**
- [ ] Créer une couche Repository pour encapsuler la logique métier
  ```dart
  class GameRepository {
    final GameDAO _gameDAO;
    final QuarterDAO _quarterDAO;

    GameRepository(this._gameDAO, this._quarterDAO);

    Future<List<Game>> getTeamGames(int teamId) async {
      // Logique métier ici
      return await _gameDAO.getGamesByTeam(teamId);
    }
  }
  ```

- [ ] Injecter Repositories au lieu de DAOs
- [ ] Permet de centraliser la logique métier

---

## 📊 Matrice d'Impact/Effort

| Recommandation | Impact | Effort | Ratio | Notes |
|---|---|---|---|---|
| Tests | 🔴 Critique | 🟠 Moyen | ⬆️⬆️⬆️ | Essentiel pour stabilité |
| Erreur handling | 🔴 Critique | 🟠 Moyen | ⬆️⬆️⬆️ | Empêche crashes |
| Logging | 🔴 Critique | 🟢 Bas | ⬆️⬆️⬆️ | Debugging essentiel |
| Duplication DB | 🟠 Moyen | 🟢 Bas | ⬆️⬆️ | Maintenance future |
| Boilerplate | 🟡 Bas | 🟢 Très bas | ⬆️ | Nettoyage simple |
| Validation | 🟠 Moyen | 🟡 Moyen | ⬆️ | Qualité données |
| Typage DAO | 🟡 Bas | 🟢 Bas | ⬆️ | Refactoring |
| Lazy Cubits | 🟡 Bas | 🟢 Bas | ⬆️ | Optimization |
| Repository | 🟡 Bas | 🔴 Élevé | ➡️ | Peut attendre |

---

## 🎯 Ordre d'Exécution Recommandé

1. **Semaine 1:** Tests + Error handling (30% du projet)
2. **Semaine 2:** Logging + Validation (20% du projet)
3. **Semaine 3:** Refactoring DB + Nettoyage (15% du projet)
4. **Semaine 4+:** Optimisations et Repository pattern

---

## ✅ Checklist de Production-Readiness

- [ ] 70%+ test coverage
- [ ] Error handling complet
- [ ] Logging en place
- [ ] Validation des inputs
- [ ] Pas de boilerplate inutilisé
- [ ] Code review effectuée
- [ ] Performance profiling effectué
- [ ] Sécurité DB auditée (SQL injection?)
- [ ] Documentation complétée
- [ ] Release notes préparées
