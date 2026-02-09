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

**Durée totale estimée :** 9-13 heures

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
- [ ] (Bonus) Ajouter filtres
- [ ] (Bonus) Ajouter interaction sur markers

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
