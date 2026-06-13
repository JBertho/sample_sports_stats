# Plan d'Implémentation - Affichage Stats et Visualisation des Tirs sur Terrain

## Contexte

### Situation actuelle
Le dernier commit a implémenté la sauvegarde des statistiques individuelles des joueurs dans la base de données lors de la fin d'un match. Les données sont stockées dans la table `player_stats` avec 13 types de statistiques différentes (tirs réussis/ratés, rebonds, contres, interceptions, fautes, etc.).

### Problème
- La page "Statistiques du match" (History page) possède 3 onglets (Résumé, Stats, Tirs) mais seul l'onglet "Résumé" est fonctionnel
- Les onglets "Stats" et "Tirs" affichent des placeholders ("Les Stats", "Les tirs")
- Pendant un match actif, il n'y a aucune visualisation spatiale du terrain - tout est basé sur des boutons
- Le système ne capture pas la position des tirs sur le terrain

### Objectif
Implémenter 3 fonctionnalités majeures :
1. Afficher les statistiques détaillées des joueurs dans l'onglet "Stats" de la page History
2. Ajouter une interface de demi-terrain lors des tirs pendant un match actif pour enregistrer la position
3. Visualiser tous les tirs de l'équipe sur un demi-terrain dans l'onglet "Tirs" de la page History

---

## Étape 1 : Affichage des Statistiques des Joueurs (Onglet Stats)

### Objectif
Remplacer le placeholder "Les Stats" dans `StatsHistoryPage` par un affichage complet des statistiques individuelles de chaque joueur pour le match sélectionné.

### Fichiers à Modifier/Créer

**À Modifier :**
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\pages\history\widgets\StatsHistoryPage.dart`
  - Remplacer le `Text("Les Stats")` par une vraie UI

**À Créer :**
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\pages\history\widgets\PlayerStatsCard.dart`
  - Widget réutilisable pour afficher les stats d'un joueur

**À Utiliser (Existants) :**
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\infrastructure\DAO\player_stats_dao.dart`
  - Méthode `getPlayerStatsByGameId(int id)` pour récupérer les stats
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\models\PlayerStats.dart`
  - Modèle avec toutes les statistiques
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\AppColors.dart`
  - Couleurs cohérentes
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\AppFontStyle.dart`
  - Typographie cohérente

### Implémentation Détaillée

#### 1.1 Créer PlayerStatsCard Widget

**Structure recommandée :**
```dart
class PlayerStatsCard extends StatelessWidget {
  final String playerName;
  final int playerNumber;
  final PlayerStats stats;

  // Afficher dans une Card avec :
  // - Header : Nom + Numéro + Score total
  // - Section Tirs :
  //   - 2pts : X/Y (% de réussite)
  //   - 3pts : X/Y (% de réussite)
  //   - LF : X/Y (% de réussite)
  // - Section Rebonds : Off / Def / Total
  // - Section Défense : Contres / Interceptions
  // - Section Fautes : Fautes / Pertes de balle
}
```

**Design :**
- Utiliser `ListView.builder` ou `Wrap` pour afficher plusieurs cartes
- Coloriser les statistiques (vert pour bonnes perfs, rouge pour mauvaises)
- Calculer les pourcentages de réussite aux tirs
- Trier les joueurs par score ou numéro

#### 1.2 Modifier StatsHistoryPage

**Actions :**
1. Ajouter un `FutureBuilder` pour charger les stats depuis la BDD
2. Utiliser `PlayerStatsDAO().getPlayerStatsByGameId(game.id)`
3. Mapper les `PlayerStatsEntity` vers des `PlayerStatsCard`
4. Gérer les cas d'erreur et loading state
5. Afficher un message si aucune stat disponible

**Note importante :**
La relation entre `player_id` dans `player_stats` et le joueur réel doit être clarifiée :
- Actuellement, `player_id` correspond au `number` du joueur (numéro de maillot)
- Il faudra récupérer le nom du joueur depuis l'équipe associée au match

### Vérification

**Tests manuels :**
1. Lancer l'app et créer/finir un match avec des stats
2. Aller dans "Historique" → Sélectionner le match
3. Naviguer vers l'onglet "Stats"
4. Vérifier que toutes les stats s'affichent correctement
5. Vérifier les pourcentages de tir calculés
6. Vérifier que plusieurs joueurs s'affichent proprement

---

## Étape 2 : Interface Demi-Terrain pour Enregistrer Position des Tirs

### Objectif
Lors d'un match actif, quand l'utilisateur clique sur un bouton de tir (2pts, 3pts, LF raté/réussi), afficher une interface modale avec un demi-terrain de basket permettant de toucher l'écran pour enregistrer la position exacte du tir.

### Défis Techniques

**Problème majeur :** Le modèle `History` ne stocke pas de coordonnées de position actuellement.

**Solution :** Ajouter des champs optionnels `shotX` et `shotY` (ou créer un nouveau modèle `ShotPosition`).

### Modifications du Modèle de Données

#### 2.1 Modifier le Modèle History

**Fichier :** `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\models\History.dart`

**Ajout :**
```dart
class History {
  final ActionGame actionGame;
  final MatchPlayer player;
  final MatchPlayer? opponent;
  final Duration elapsedTime;

  // NOUVEAU : Position du tir (nullable, seulement pour les actions de tir)
  final double? shotX;  // Coordonnée X (0.0 à 1.0 relatif à la largeur du terrain)
  final double? shotY;  // Coordonnée Y (0.0 à 1.0 relatif à la hauteur du terrain)

  History({
    required this.actionGame,
    required this.player,
    this.opponent,
    required this.elapsedTime,
    this.shotX,
    this.shotY,
  });
}
```

**Justification :** Coordonnées relatives (0.0-1.0) pour être indépendant de la taille de l'écran.

#### 2.2 Ajouter Stockage en BDD (Optionnel mais recommandé)

**Option A (Simple) :** Ne stocker les positions que dans la session en cours (`History` list dans `CurrentGameCubit`)
- ✅ Implémentation rapide
- ❌ Positions perdues après fermeture de l'app
- ❌ Ne peut pas visualiser les tirs dans l'historique

**Option B (Recommandé) :** Créer une table `shot_positions` en BDD
- ✅ Persistence des données
- ✅ Permet visualisation dans l'historique
- ❌ Plus complexe

**Recommandation :** Commencer par Option A pour MVP, puis migrer vers Option B.

### Fichiers à Modifier/Créer

**À Créer :**
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\pages\currentGame\widget\CourtShotSelector.dart`
  - Widget modal avec demi-terrain interactif
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\widgets\CourtBackground.dart`
  - Widget réutilisable pour afficher le demi-terrain (utilisable étape 2 ET 3)

**À Modifier :**
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\models\History.dart`
  - Ajouter `shotX` et `shotY`
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\pages\currentGame\logic\CurrentGameCubit.dart`
  - Modifier méthode `saveAction()` pour accepter position optionnelle
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\pages\currentGame\widget\ActionsSide.dart`
  - Intercepter les clics sur boutons de tir pour afficher `CourtShotSelector`

### Implémentation Détaillée

#### 2.3 Créer CourtBackground Widget

**Structure :**
```dart
class CourtBackground extends StatelessWidget {
  final Widget? child;
  final BoxFit fit;

  // Affiche court_bg.png comme background
  // Permet de superposer des widgets par-dessus (child)
  // Gère le ratio d'aspect du terrain (2551x1393 ≈ 1.83:1)
}
```

**Asset à utiliser :** `assets/court_bg.png` (existe déjà)

#### 2.4 Créer CourtShotSelector Widget

**Structure :**
```dart
class CourtShotSelector extends StatefulWidget {
  final ActionGame shotType; // Pour afficher le type (2pts, 3pts, etc.)
  final Function(double x, double y) onPositionSelected;

  // Affiche un Dialog/BottomSheet en plein écran
  // - Background : Demi-terrain de basket (CourtBackground)
  // - GestureDetector pour capturer le tap
  // - Convertir position du tap en coordonnées relatives (0.0-1.0)
  // - Afficher un cercle temporaire à l'endroit touché
  // - Bouton "Valider" ou "Annuler"
}
```

**Interactions :**
1. User clique sur "+2" dans `ActionsSide`
2. Au lieu de directement ouvrir la sélection de joueur, afficher `CourtShotSelector`
3. User touche le terrain pour indiquer la position
4. Fermer la modal et retourner (x, y)
5. Puis afficher la sélection de joueur comme avant
6. Sauvegarder l'action avec la position

#### 2.5 Modifier CurrentGameCubit

**Méthode à modifier :**
```dart
// AVANT
void saveAction(MatchPlayer player, ActionGame actionGame, Duration elapsedTime)

// APRÈS
void saveAction(
  MatchPlayer player,
  ActionGame actionGame,
  Duration elapsedTime,
  {double? shotX, double? shotY}  // Paramètres optionnels
)
```

**Dans la méthode :**
```dart
// Créer History avec position si fournie
histories.add(History(
  actionGame: actionGame,
  player: player,
  opponent: state.selectedOpponent,
  elapsedTime: elapsedTime,
  shotX: shotX,
  shotY: shotY,
));
```

#### 2.6 Modifier ActionsSide

**Logique à ajouter :**
```dart
// Pour chaque bouton de tir (2pts, 3pts, LF)
onPressed: () {
  if (actionIsShotType(action)) {
    // NOUVEAU : Afficher CourtShotSelector
    showDialog(
      context: context,
      builder: (_) => CourtShotSelector(
        shotType: action,
        onPositionSelected: (x, y) {
          // Fermer dialog
          // Puis ouvrir sélection joueur avec position stockée
          _showPlayerSelection(action, shotX: x, shotY: y);
        },
      ),
    );
  } else {
    // Actions non-tir : comportement normal
    _showPlayerSelection(action);
  }
}
```

**Helper method :**
```dart
bool actionIsShotType(ActionGame action) {
  return [
    ActionGame.twoPoint,
    ActionGame.threePoint,
    ActionGame.freeThrow,
    ActionGame.failedTwoPoint,
    ActionGame.failedThreePoint,
    ActionGame.failedFreeThrow,
  ].contains(action);
}
```

### Considérations UX

**Points d'attention :**
1. **Orientation paysage :** L'app est locked en landscape - le terrain doit bien s'afficher
2. **Taille du terrain :** Assurer que le terrain est assez grand pour être précis (utiliser maxWidth/maxHeight)
3. **Feedback visuel :** Afficher un cercle/marker où l'utilisateur a touché
4. **Validation :** Bouton "Valider" pour confirmer (pas juste un tap) pour éviter les erreurs
5. **Annulation :** Permettre d'annuler et ne pas enregistrer l'action
6. **Instructions claires :** "Touchez l'écran pour indiquer la position du tir"

### Vérification

**Tests manuels :**
1. Démarrer un match
2. Cliquer sur "+2" ou "+3"
3. Vérifier que le dialog du terrain s'affiche
4. Toucher différents endroits du terrain
5. Vérifier le feedback visuel
6. Valider la position
7. Sélectionner un joueur
8. Vérifier que l'action est enregistrée avec position
9. Tester l'annulation
10. Vérifier que les actions non-tir (rebonds, fautes) fonctionnent toujours normalement

---

## Étape 3 : Visualisation des Tirs sur Terrain (Onglet Tirs)

### Objectif
Dans la page "Statistiques du match" (History), onglet "Tirs", afficher un demi-terrain avec tous les tirs effectués par l'équipe pendant le match, avec des markers différents selon le type (réussi/raté, 2pts/3pts/LF).

### Prérequis
Cette étape nécessite que l'Étape 2 soit complétée (positions des tirs enregistrées).

### Fichiers à Modifier/Créer

**À Modifier :**
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\pages\history\widgets\ShootsHistoryPage.dart`
  - Remplacer le `Text("Les tirs")` par la visualisation

**À Créer :**
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\pages\history\widgets\CourtShotsVisualization.dart`
  - Widget pour afficher le terrain avec les tirs

**À Réutiliser :**
- `C:\Users\jbertho1\dev\perso\sample_sports_stats\lib\widgets\CourtBackground.dart`
  - Créé à l'étape 2

**BDD (Si Option B de l'étape 2) :**
- Table `shot_positions` pour récupérer les positions des tirs

### Implémentation Détaillée

#### 3.1 Créer CourtShotsVisualization Widget

**Structure :**
```dart
class CourtShotsVisualization extends StatelessWidget {
  final List<ShotData> shots;  // List de tirs avec position et type

  // Affiche :
  // - CourtBackground comme fond
  // - Stack avec Positioned pour chaque tir
  // - Markers colorés selon type :
  //   * Vert : 2pts/3pts réussi
  //   * Rouge : 2pts/3pts raté
  //   * Bleu : LF réussi
  //   * Orange : LF raté
  // - Taille des markers selon importance (3pts > 2pts > LF)
}
```

**ShotData Model :**
```dart
class ShotData {
  final double x;  // 0.0 à 1.0
  final double y;  // 0.0 à 1.0
  final ActionGame shotType;
  final String playerName;
  final int playerNumber;

  bool get isSuccess => [
    ActionGame.twoPoint,
    ActionGame.threePoint,
    ActionGame.freeThrow,
  ].contains(shotType);
}
```

#### 3.2 Modifier ShootsHistoryPage

**Implémentation :**
```dart
class ShootsHistoryPage extends StatelessWidget {
  final Game game;

  @override
  Widget build(BuildContext context) {
    // Option A (session courante) :
    // - Si game est le match actif : récupérer depuis CurrentGameCubit
    // - Sinon : afficher message "Données non disponibles"

    // Option B (BDD) :
    // - FutureBuilder pour charger depuis shot_positions table
    // - Filtrer par game_id
    // - Mapper vers List<ShotData>

    return Column(
      children: [
        // Légende
        _buildLegend(),

        // Terrain avec tirs
        Expanded(
          child: CourtShotsVisualization(shots: shots),
        ),

        // Stats résumé (optionnel)
        _buildSummaryStats(shots),
      ],
    );
  }

  Widget _buildLegend() {
    // Afficher les couleurs et leur signification
    // Ex: ⚫ Vert = Réussi, 🔴 Rouge = Raté
  }

  Widget _buildSummaryStats(List<ShotData> shots) {
    // Calculer et afficher :
    // - Total tirs : X
    // - Réussis : Y (Z%)
    // - 2pts : A/B
    // - 3pts : C/D
    // - LF : E/F
  }
}
```

#### 3.3 Stratégie de Données

**Si Option A (Pas de BDD) :**
- Ajouter une méthode dans `CurrentGameCubit` pour exposer les tirs
- Problème : Comment accéder au Cubit depuis History page ?
  - Solution 1 : Passer les données via navigation (state.extra)
  - Solution 2 : Afficher seulement pour le match actif

**Si Option B (Avec BDD - RECOMMANDÉ) :**
1. Créer migration DB (version 3)
2. Créer table `shot_positions`:
```sql
CREATE TABLE shot_positions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  game_id INTEGER NOT NULL,
  player_id INTEGER NOT NULL,
  action_type TEXT NOT NULL,
  shot_x REAL NOT NULL,
  shot_y REAL NOT NULL,
  elapsed_time INTEGER NOT NULL
)
```
3. Créer `ShotPositionEntity` et `ShotPositionDAO`
4. Sauvegarder les positions lors de `finishGame()` dans `CurrentGameCubit`
5. Récupérer via `getShotPositionsByGameId(int gameId)`

### Design des Markers

**Recommandations visuelles :**
- **Forme :** Cercles avec bordure
- **Taille :**
  - 3pts : 24dp (plus gros)
  - 2pts : 20dp
  - LF : 16dp (plus petit)
- **Couleurs :**
  - Réussi 2pts/3pts : Vert (Colors.green[700])
  - Raté 2pts/3pts : Rouge (Colors.red[700])
  - Réussi LF : Bleu (Colors.blue[700])
  - Raté LF : Orange (Colors.orange[700])
- **Interaction (bonus) :** Tap sur marker pour afficher details (joueur, temps, type)

### Features Bonus (Optionnelles)

**Filtres :**
- Filtrer par joueur (dropdown)
- Filtrer par type de tir (2pts/3pts/LF)
- Filtrer par résultat (réussi/raté)

**Heat Map :**
- Au lieu de markers individuels, afficher une heat map de densité
- Utiliser CustomPaint avec gradients

**Zones de tir :**
- Afficher les pourcentages de réussite par zone du terrain
- Diviser le terrain en 5-7 zones

**Timeline :**
- Slider pour voir l'évolution des tirs au fil du match
- Afficher seulement les tirs jusqu'à un certain temps

### Vérification

**Tests manuels :**
1. Jouer un match complet avec plusieurs tirs à différentes positions
2. Finir le match
3. Aller dans "Historique" → Sélectionner le match
4. Naviguer vers l'onglet "Tirs"
5. Vérifier que tous les tirs s'affichent correctement
6. Vérifier les couleurs selon type (réussi/raté)
7. Vérifier les positions correspondent aux tirs effectués
8. Vérifier la légende
9. Vérifier les stats résumé

---

## Étape 4 : Filtrage des Tirs par Joueur (Header de Sélection)

### Objectif
Améliorer l'onglet "Tirs" de la page Historique en ajoutant un en-tête avec la liste des joueurs présents dans le match. Un bouton "Tous" (sélectionné par défaut) permet d'afficher tous les tirs, et les autres boutons filtrent pour un joueur spécifique. La visualisation du terrain et le résumé statistique se mettent à jour en fonction de la sélection.

### Besoin utilisateur
- Voir d'un coup d'œil qui a shooté où
- Analyser la performance d'un joueur spécifique (ses zones chaudes/froides)
- Comparer rapidement les joueurs en passant d'un filtre à l'autre

### Fichiers à Modifier/Créer

**À Modifier :**
- `lib/pages/history/widgets/ShootsHistoryPage.dart`
  - Devenir `StatefulWidget` pour gérer l'état de sélection
  - Ajouter une barre horizontale de filtres en haut
  - Filtrer la liste de tirs avant de la passer à `CourtShotsVisualization` et `_Summary`

**À Créer :**
- `lib/pages/history/widgets/PlayerFilterBar.dart` (optionnel, extraction possible)
  - Widget stateless avec liste de "chips" joueurs + callback de sélection

### Implémentation Détaillée

#### 4.1 État et dérivation de la liste de joueurs
- Stocker `int? _selectedPlayerId` (null = "Tous")
- Dériver la liste unique des `playerId` depuis les `shots` chargés (tri croissant)
- Construire une map `playerId → nom` depuis `state.game.teamPlayers` quand disponible ; fallback sur `"#numéro"`

#### 4.2 Barre de filtres
- `ListView` horizontal (ou `Wrap`) de `FilterChip` / boutons custom
- Premier élément : "Tous" (sélectionné ⇒ `_selectedPlayerId == null`)
- Élements suivants : un par joueur ayant au moins un tir
- Style cohérent avec le thème (bleu `AppColors.blue` pour sélectionné, bordure/texte bleu pour non-sélectionné)

#### 4.3 Filtrage
- `filteredShots = _selectedPlayerId == null ? shots : shots.where((s) => s.playerId == _selectedPlayerId).toList()`
- Passer `filteredShots` à `CourtShotsVisualization` et `_Summary`

### Considérations UX
- "Tous" toujours en premier, toujours visible
- Si un seul joueur a tiré, masquer la barre (ou la laisser pour cohérence)
- Feedback visuel clair sur la sélection active
- Scroll horizontal fluide si beaucoup de joueurs

### Vérification

**Tests manuels :**
1. Ouvrir un match avec plusieurs tireurs
2. Vérifier que "Tous" est sélectionné par défaut et affiche tous les markers
3. Cliquer sur un joueur → seuls ses tirs apparaissent, résumé mis à jour
4. Revenir sur "Tous" → tout réapparaît
5. Vérifier qu'un match sans tirs ou avec un seul joueur se comporte correctement

---

## Étape 5 : Gestion Dynamique des Joueurs

### Objectif
Remplacer la liste de joueurs codée en dur dans `MatchCubit` par une vraie gestion persistée en base de données, liée à chaque équipe. L'utilisateur peut créer ses joueurs depuis l'interface de configuration du match, les sauvegarder, et les retrouver à chaque nouveau match. La sélection au démarrage d'un match est limitée à **5 joueurs maximum**. En parallèle, le panneau "adversaire" est nettoyé de sa liste inutilisée.

---

### 5.1 Migration BDD — Table `player` (v3 → v4)

**Fichier à modifier :** `lib/infrastructure/SqliteHelper.dart`

**Schéma à ajouter :**
```sql
CREATE TABLE IF NOT EXISTS player (
  id   INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT    NOT NULL,
  number INTEGER NOT NULL,
  team_id INTEGER NOT NULL
)
```

**Changements dans `SqliteHelper` :**
- Incrémenter `version: 3` → `version: 4`
- Ajouter le schéma comme constante `_playerSchema`
- Dans `onCreate` : ajouter `await db.execute(_playerSchema);`
- Dans `onUpgrade` : ajouter `if (previous < 4) { await db.execute(_playerSchema); }`

**Note :** La colonne `player_id` dans `player_stats` et `shot_positions` référence actuellement le numéro de maillot (`MatchPlayer.number`). Après cette migration, `player_id` devra référencer l'`id` BDD du joueur pour une cohérence relationnelle correcte. Adapter en conséquence dans `CurrentGameCubit.finishGame()`.

---

### 5.2 Infrastructure — PlayerEntity et PlayerDAO

**Fichier à créer :** `lib/infrastructure/Entities/player_entity.dart`
```dart
class PlayerEntity {
  int? id;
  String name;
  int number;
  int teamId;

  PlayerEntity({this.id, required this.name, required this.number, required this.teamId});

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'number': number,
    'team_id': teamId,
  };

  static PlayerEntity fromMap(Map<String, dynamic> map) => PlayerEntity(
    id: map['id'],
    name: map['name'],
    number: map['number'],
    teamId: map['team_id'],
  );
}
```

**Fichier à créer :** `lib/infrastructure/DAO/player_dao.dart`
```dart
class PlayerDAO {
  Future<int> insertPlayer(PlayerEntity entity) async { ... }
  Future<List<PlayerEntity>> getPlayersByTeamId(int teamId) async { ... }
  Future<void> deletePlayer(int id) async { ... }
}
```

---

### 5.3 Modèle Player — Ajout du champ `id`

**Fichier à modifier :** `lib/models/Player.dart`

```dart
class Player {
  final int? id;      // NOUVEAU : id BDD (null si pas encore persisté)
  final String name;
  final int number;
  bool selected;

  Player({this.id, required this.name, required this.number, this.selected = false});
}
```

---

### 5.4 MatchCubit — Chargement depuis BDD + Ajout joueur + Limite 5

**Fichier à modifier :** `lib/pages/matchMenu/logic/MatchCubit.dart`

**Suppressions :**
- Retirer la liste `teamPlayers` codée en dur (10 joueurs hardcodés)

**Modifications de `initGame(Team team)` :**
```dart
void initGame(Team team) async {
  final entities = await PlayerDAO().getPlayersByTeamId(team.id!);
  final players = entities.map((e) => Player(id: e.id, name: e.name, number: e.number)).toList();
  emit(MatchStateInProgress(team: team, teamPlayers: players, atHome: true));
}
```
→ La méthode devient `async` ; état initial vide tant que le `Future` n'est pas résolu.

**Nouvelle méthode `addPlayer(String name, int number)` :**
```dart
Future<void> addPlayer(String name, int number) async {
  final entity = PlayerEntity(name: name, number: number, teamId: state.team.id!);
  final id = await PlayerDAO().insertPlayer(entity);
  final newPlayer = Player(id: id, name: name, number: number);
  final updated = List<Player>.from(state.teamPlayers)..add(newPlayer);
  emit(MatchStateInProgress(team: state.team, teamPlayers: updated, atHome: state.atHome));
}
```

**Modification de `selectPlayer` — limite 5 :**
```dart
void selectPlayer(Player player) {
  final selectedCount = state.teamPlayers.where((p) => p.selected).length;
  if (selectedCount >= 5) return;  // Bloquer si déjà 5 sélectionnés
  // ... logique existante
}
```

**Getter utilitaire dans le state (ou cubit) :**
```dart
bool get isMaxPlayersReached =>
    state.teamPlayers.where((p) => p.selected).length >= 5;
```

---

### 5.5 MatchPage — UI Ajout Joueur + Compteur sélection

**Fichier à modifier :** `lib/pages/matchMenu/MatchPage.dart` — classe `RightSideWidget`

**Ajouts :**

1. **Compteur de sélection** en haut de la liste :
```dart
Text(
  '${selectedCount}/5 joueurs sélectionnés',
  style: TextStyle(
    color: selectedCount == 5 ? AppColors.orange : AppColors.blue,
    fontWeight: FontWeight.bold,
  ),
)
```

2. **Bouton "Ajouter un joueur"** en bas de la grille (visible seulement si nombre total de joueurs < limite raisonnable, ex: 15) :
```dart
AddPlayerWidget(
  onAdd: (name, number) => context.read<MatchCubit>().addPlayer(name, number),
)
```

3. **Grisage des joueurs non-sélectionnés** quand 5 sont déjà sélectionnés :
- Dans `PlayerSelectionWidget` : ajouter param `bool disabled`
- Si `disabled`, rendre le bouton semi-transparent et `onTap: null`

**Dialog de création joueur** (inline dans `MatchPage.dart` ou fichier séparé `AddPlayerDialog.dart`) :
```dart
class AddPlayerDialog extends StatelessWidget {
  final Function(String name, int number) onConfirm;
  // Deux champs : Nom + Numéro de maillot
  // Validation : nom non-vide, numéro entre 0 et 99
}
```

**Structure finale de `RightSideWidget` :**
```
Column:
  - Text "Choix de mes joueurs :"
  - Text "X/5 sélectionnés"  ← NOUVEAU
  - GridView (joueurs existants, avec grisage si max atteint)
  - Bouton "+ Ajouter un joueur"  ← NOUVEAU
```

---

### 5.6 Suppression de la liste "Joueurs adverses"

**Fichier à modifier :** `lib/pages/matchMenu/MatchPage.dart` — classe `OpponentGameConfiguration`

**Suppression :** Retirer le `ListView.builder` (lignes ~331-357) qui génère 10 lignes "Joueur adverse X" avec des containers vides. Cette liste n'est jamais utilisée et prend de la place inutilement.

**Résultat :** Le panneau gauche n'affiche plus que :
- Champ "Nom de l'équipe adverse"
- Boutons Domicile / Extérieur

Optionnellement, l'espace libéré peut accueillir d'autres informations du match (date, lieu, arbitre…) si besoin dans le futur.

---

### Vérification

**Tests manuels :**
1. Créer une équipe → aller dans le menu match → vérifier que la liste de joueurs est vide (plus de joueurs en dur)
2. Ajouter 3 joueurs via le bouton → vérifier qu'ils apparaissent dans la grille
3. Fermer et rouvrir le match pour la même équipe → vérifier que les joueurs persistent (rechargés depuis BDD)
4. Sélectionner 5 joueurs → vérifier que le 6ème joueur ne peut pas être sélectionné (bouton grisé)
5. Désélectionner un joueur → vérifier que la sélection est de nouveau possible
6. Vérifier que le panneau adversaire n'affiche plus la liste inutile
7. Démarrer un match → vérifier que les 5 joueurs sélectionnés sont bien en `teamPlayers` dans `CurrentGame`

**Cas limites :**
- Équipe sans joueur : message "Aucun joueur, ajoutez-en un"
- Numéro de maillot déjà utilisé dans l'équipe : avertissement ou blocage
- Équipe avec 1 seul joueur : bouton "GO !" doit-il être bloqué ? (À décider : avertissement ou libre)

---

### Checklist Étape 5
- [ ] Incrémenter DB version 3 → 4 dans `SqliteHelper`
- [ ] Ajouter constante `_playerSchema` et l'appeler dans `onCreate` et `onUpgrade`
- [ ] Créer `PlayerEntity.dart`
- [ ] Créer `PlayerDAO.dart` (insert, getByTeamId, delete)
- [ ] Ajouter champ `id` dans `Player.dart`
- [ ] Modifier `MatchCubit.initGame()` → async, charge depuis BDD
- [ ] Ajouter `MatchCubit.addPlayer()`
- [ ] Ajouter limite max 5 dans `MatchCubit.selectPlayer()`
- [ ] Modifier `RightSideWidget` : compteur + bouton ajout + grisage
- [ ] Créer `AddPlayerDialog` (nom + numéro)
- [ ] Supprimer liste adversaire dans `OpponentGameConfiguration`
- [ ] Tester migration BDD sur install existante
- [ ] Tester persistence des joueurs entre sessions

---

## Étape 6 : Résolution des Noms de Joueurs dans Stats et Tirs

### Objectif
Dans les onglets "Stats" et "Tirs" de l'historique, afficher le **vrai nom** et le **numéro de maillot** des joueurs au lieu du fallback générique `Joueur #X`. Les données sont chargées depuis la table `player` (créée à l'Étape 5) en parallèle avec les statistiques ou les positions de tirs.

### Problème résolu
`Game.fromEntity()` reconstruit un `Game` avec `teamPlayers: List.empty()` — les noms ne sont donc jamais disponibles depuis l'état. La seule source fiable est la table `player` (jointure via `team_id`).

---

### 6.1 StatsHistoryPage — Chargement parallèle stats + joueurs

**Fichier modifié :** `lib/pages/history/widgets/StatsHistoryPage.dart`

**Changements :**
- Converti en `StatefulWidget` pour stocker le `Future` dans `initState` (évite re-query à chaque rebuild)
- `_future` combine `PlayerStatsDAO.getPlayerStatsByGameId` et `PlayerDAO.getPlayersByTeamId` via `Future.wait`
- Construction d'une `Map<int, String>` `(numéro maillot → nom)` depuis les `PlayerEntity` chargés
- `_buildCard()` résout le nom via la map ; fallback `'Joueur #X'` si joueur inconnu

**Résultat :**
- `PlayerStatsCard` affiche le vrai nom du joueur en header
- Le numéro de maillot `#N` (déjà présent dans la card) reste correct

---

### 6.2 ShootsHistoryPage — Chargement parallèle tirs + joueurs

**Fichier modifié :** `lib/pages/history/widgets/ShootsHistoryPage.dart`

**Changements :**
- `_future` remplace `_shotsFuture` : combine `ShotPositionDAO.getShotPositionsByGameId` et `PlayerDAO.getPlayersByTeamId` via `Future.wait`
- `Map<int, String>` construite depuis les `PlayerEntity` chargés
- `_playerLabel(playerId, playerNames)` retourne `'Nom  #N'` si nom connu, sinon `'#N'`
- `_PlayerFilterBar` reçoit `getPlayerLabel` au lieu de `getPlayerName`
- Les chips du filtre affichent donc `'Jamso  #1'`, `'Carlito  #14'`, etc.

---

### Checklist Étape 6
- [x] Convertir `StatsHistoryPage` en `StatefulWidget`
- [x] Charger `PlayerDAO.getPlayersByTeamId` en parallèle dans `StatsHistoryPage`
- [x] Résoudre noms dans `_buildCard` via `Map<int, String>`
- [x] Remplacer `_shotsFuture` par `_future` combiné dans `ShootsHistoryPage`
- [x] Charger `PlayerDAO.getPlayersByTeamId` en parallèle dans `ShootsHistoryPage`
- [x] Afficher `'Nom  #N'` dans les chips du filtre joueur

---

## Ordre d'Exécution Recommandé

### Phase 1 : Foundation (Étape 1)
**Durée estimée :** 2-3 heures
- Implémenter l'affichage des stats des joueurs
- **Validation :** Stats visibles dans l'onglet Stats de l'historique

### Phase 2 : Data Model (Étape 2 - Part 1)
**Durée estimée :** 1-2 heures
- Modifier le modèle History
- Créer CourtBackground widget
- **Validation :** Widget de terrain affiche correctement

### Phase 3 : Shot Recording (Étape 2 - Part 2)
**Durée estimée :** 3-4 heures
- Créer CourtShotSelector
- Modifier CurrentGameCubit
- Modifier ActionsSide
- **Validation :** Tirs enregistrés avec positions pendant match

### Phase 4 : Shot Visualization (Étape 3)
**Durée estimée :** 3-4 heures
- Créer CourtShotsVisualization
- Modifier ShootsHistoryPage
- (Optionnel) Implémenter BDD pour persistence
- **Validation :** Tirs visibles sur terrain dans historique

### Phase 5 : Filtrage par Joueur (Étape 4)
**Durée estimée :** 1-2 heures
- Transformer ShootsHistoryPage en StatefulWidget
- Ajouter la barre de filtres (Tous + un bouton par joueur)
- Filtrer markers et résumé selon sélection
- **Validation :** Chaque joueur est isolable depuis le header, "Tous" rétablit la vue complète

### Phase 6 : Gestion Dynamique des Joueurs (Étape 5)
**Durée estimée :** 3-4 heures
- Migration BDD v3 → v4 (table `player`)
- Créer `PlayerEntity` et `PlayerDAO`
- Charger les joueurs depuis la BDD dans `MatchCubit` (fin des joueurs en dur)
- Ajouter la création de joueur depuis l'interface (dialog nom + numéro)
- Limiter la sélection à 5 joueurs max avec feedback visuel
- Supprimer la liste adversaire inutilisée dans `OpponentGameConfiguration`
- **Validation :** Joueurs créés, persistés, rechargés entre sessions ; max 5 respecté

### Phase 7 : Noms et Numéros de Maillot dans Stats et Tirs (Étape 6)
**Durée estimée :** 1 heure
- Charger les joueurs depuis `PlayerDAO` en parallèle dans `StatsHistoryPage` et `ShootsHistoryPage`
- Afficher le vrai nom + `#N` dans les cartes stats et les chips de filtre
- **Validation :** Plus de `Joueur #X` — noms réels partout dans l'historique

**Durée totale estimée :** 14-20 heures

---

## Recommandations Techniques

### 1. Gestion des Coordonnées

**Utiliser des coordonnées relatives (0.0 - 1.0) :**
```dart
// Conversion tap → coordonnées relatives
final RenderBox box = context.findRenderObject() as RenderBox;
final Offset localPosition = box.globalToLocal(details.globalPosition);
final double relativeX = localPosition.dx / box.size.width;
final double relativeY = localPosition.dy / box.size.height;

// Clamp pour éviter les valeurs hors limites
final double shotX = relativeX.clamp(0.0, 1.0);
final double shotY = relativeY.clamp(0.0, 1.0);
```

**Conversion relatives → pixels pour affichage :**
```dart
Positioned(
  left: shot.x * courtWidth,
  top: shot.y * courtHeight,
  child: ShotMarker(shot: shot),
)
```

### 2. Aspect Ratio du Terrain

**Image court_bg.png :** 2551 x 1393 pixels ≈ 1.83:1

**Utiliser AspectRatio widget :**
```dart
AspectRatio(
  aspectRatio: 2551 / 1393,
  child: Stack(
    children: [
      Image.asset('assets/court_bg.png', fit: BoxFit.fill),
      // ... markers ...
    ],
  ),
)
```

### 3. Performance

**Si beaucoup de tirs :**
- Ne pas reconstruire tout le widget à chaque frame
- Utiliser const constructors quand possible
- Envisager CustomPaint pour dessiner tous les markers en une seule fois au lieu de Stack avec multiples Positioned

### 4. Erreur Handling

**Cas à gérer :**
- Pas de stats disponibles (match sans tirs enregistrés)
- Erreur de chargement BDD
- Coordonnées invalides (null, hors limites)
- Match actif vs match historique (Option A)

### 5. Tests

**Recommandations :**
- Tester avec 0 tirs
- Tester avec 1 tir
- Tester avec beaucoup de tirs (50+)
- Tester dans tous les coins du terrain
- Tester sur différentes tailles d'écran
- Tester en mode portrait (même si locked landscape) pour robustesse

### 6. Database Migration (Si Option B)

**Checklist :**
1. Incrémenter version dans SqliteHelper (2 → 3)
2. Ajouter condition dans onUpgrade:
```dart
if (previous < 3) {
  await db.execute(_shotPositionsTableSchema);
}
```
3. Créer `ShotPositionEntity.dart`
4. Créer `ShotPositionDAO.dart`
5. Sauvegarder positions dans `finishGame()` de `CurrentGameCubit`
6. Tester migration sur une BDD existante

### 7. Architecture Propre

**Séparation des responsabilités :**
- **CourtBackground :** Affichage du terrain (réutilisable)
- **CourtShotSelector :** Interaction utilisateur pour sélectionner position
- **CourtShotsVisualization :** Affichage read-only des tirs
- **ShotMarker :** Widget pour un marker individuel

**Avantages :**
- Réutilisabilité
- Testabilité
- Maintenance facilitée

---

## Alternatives et Optimisations Futures

### Alternative 1 : Utiliser CustomPaint au lieu d'Image

Au lieu d'utiliser `court_bg.png`, dessiner le terrain avec CustomPaint :
- ✅ Performances meilleures
- ✅ Scalable (pas de pixelisation)
- ✅ Personnalisable (couleurs, lignes, etc.)
- ❌ Plus complexe à implémenter
- ❌ Nécessite connaissance de CustomPainter

**Recommandation :** Utiliser l'image pour MVP, considérer CustomPaint plus tard.

### Alternative 2 : Heatmap avec Gradients

Au lieu de markers individuels, générer une heatmap :
- ✅ Visualisation plus claire avec beaucoup de tirs
- ✅ Montre les zones chaudes
- ❌ Perd le détail individuel
- ❌ Plus complexe (nécessite calcul de densité)

**Recommandation :** Feature bonus après implémentation de base.

### Alternative 3 : 3D Visualization

Utiliser un package comme fl_chart pour visualisation 3D :
- ✅ Wow factor
- ❌ Overkill pour le besoin
- ❌ Complexité élevée

**Recommandation :** Non recommandé.

### Optimisation : Lazy Loading

Si beaucoup de matchs avec beaucoup de tirs :
- Charger les tirs seulement quand l'onglet "Tirs" est sélectionné
- Utiliser `AutomaticKeepAliveClientMixin` pour garder le widget en mémoire après premier chargement

---

## Checklist d'Implémentation

### Étape 1 : Stats des Joueurs
- [ ] Créer `PlayerStatsCard.dart`
- [ ] Modifier `StatsHistoryPage.dart`
- [ ] Tester récupération depuis BDD
- [ ] Calculer pourcentages de tir
- [ ] Gérer cas d'erreur/vide
- [ ] Tester UI sur différents écrans
- [ ] Vérifier cohérence visuelle (couleurs, fonts)

### Étape 2 : Enregistrement Position Tirs
- [ ] Modifier modèle `History.dart` (shotX, shotY)
- [ ] Créer `CourtBackground.dart`
- [ ] Créer `CourtShotSelector.dart`
- [ ] Implémenter GestureDetector pour capture position
- [ ] Convertir position tap → coordonnées relatives
- [ ] Afficher feedback visuel (cercle)
- [ ] Modifier `CurrentGameCubit.saveAction()`
- [ ] Modifier `ActionsSide.dart` (interception boutons tir)
- [ ] Tester workflow complet
- [ ] Gérer annulation
- [ ] (Optionnel) Créer table BDD `shot_positions`
- [ ] (Optionnel) Implémenter persistence BDD

### Étape 3 : Visualisation Tirs
- [ ] Créer `CourtShotsVisualization.dart`
- [ ] Créer modèle `ShotData`
- [ ] Modifier `ShootsHistoryPage.dart`
- [ ] Récupérer données (session ou BDD)
- [ ] Afficher markers avec bonnes couleurs
- [ ] Implémenter légende
- [ ] Calculer stats résumé
- [ ] Tester avec 0, 1, beaucoup de tirs
- [ ] Vérifier performance
- [ ] (Bonus) Ajouter interaction sur markers

### Étape 4 : Filtrage par Joueur
- [ ] Transformer `ShootsHistoryPage` en `StatefulWidget`
- [ ] Ajouter `_selectedPlayerId` + logique de filtrage
- [ ] Construire la barre de filtres horizontale (Tous + joueurs)
- [ ] Résoudre les noms de joueurs depuis `state.game.teamPlayers` (fallback `#numéro`)
- [ ] Mettre à jour markers et résumé selon la sélection
- [ ] Tester cas : aucun tir, un seul joueur, plusieurs joueurs

### Étape 5 : Gestion Dynamique des Joueurs
- [ ] Incrémenter version BDD 3 → 4 dans `SqliteHelper.dart`
- [ ] Ajouter `_playerSchema` dans `SqliteHelper` (`onCreate` + `onUpgrade`)
- [ ] Créer `lib/infrastructure/Entities/player_entity.dart`
- [ ] Créer `lib/infrastructure/DAO/player_dao.dart` (insert, getByTeamId, delete)
- [ ] Ajouter champ `id` dans `lib/models/Player.dart`
- [ ] Modifier `MatchCubit.initGame()` : async, chargement depuis `PlayerDAO`
- [ ] Ajouter `MatchCubit.addPlayer(String name, int number)` avec persistance
- [ ] Bloquer sélection dans `MatchCubit.selectPlayer()` si déjà 5 sélectionnés
- [ ] Modifier `RightSideWidget` : compteur "X/5", bouton "+ Ajouter", grisage si max
- [ ] Créer dialog `AddPlayerDialog` (champs nom + numéro, validation)
- [ ] Supprimer `ListView.builder` des joueurs adverses dans `OpponentGameConfiguration`
- [ ] Tester migration sur BDD existante (v3 → v4)
- [ ] Tester persistence des joueurs entre sessions

---

## Plan de Vérification Finale

### Test End-to-End

**Scénario complet :**
1. ✅ Démarrer l'application
2. ✅ Sélectionner une équipe
3. ✅ Démarrer un nouveau match
4. ✅ Enregistrer plusieurs tirs (2pts, 3pts, LF - réussis et ratés)
5. ✅ Pour chaque tir, sélectionner une position sur le terrain
6. ✅ Enregistrer d'autres actions (rebonds, fautes, etc.)
7. ✅ Finir le match
8. ✅ Aller dans "Historique"
9. ✅ Sélectionner le match
10. ✅ Onglet Résumé : Vérifier que les scores sont corrects
11. ✅ Onglet Stats : Vérifier que toutes les stats des joueurs s'affichent
12. ✅ Onglet Tirs : Vérifier que tous les tirs s'affichent sur le terrain
13. ✅ Vérifier les couleurs/tailles des markers
14. ✅ Vérifier les pourcentages calculés

### Cas Limites à Tester
- Match sans aucun tir
- Match avec seulement des lancers francs
- Match avec beaucoup de tirs (50+)
- Tirs dans les coins du terrain
- Annulation pendant sélection position
- Rotation d'écran (même si locked landscape)
- Navigation rapide entre onglets

### Validation Technique
- Pas d'erreurs dans les logs
- Pas de memory leaks
- UI fluide (60 fps)
- Données cohérentes entre onglets
- Persistence BDD fonctionne (si Option B)

---

## Notes Finales

### Points d'attention
1. **Landscape only** - Toujours penser en mode paysage
2. **Coordonnées relatives** - Essentiel pour multi-device
3. **Séparation modèle/vue** - Garder architecture propre
4. **Réutilisabilité** - CourtBackground utilisé dans étapes 2 et 3
5. **MVP first** - Implémenter base avant features bonus

### Après implémentation
- Mettre à jour `CLAUDE.md` avec nouvelles fonctionnalités
- Mettre à jour `PLAN_ameliorations.md` si nouvelles dettes techniques
- Commit avec messages clairs pour chaque étape
- Documenter format des coordonnées pour futurs développeurs

### Évolutions futures possibles
- Analytics des zones préférées par joueur
- Comparaison avec moyennes NBA
- Export des cartes de tir en image
- Partage social des performances
