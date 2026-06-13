import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';
import 'package:sample_sport_stats/models/Game.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';
import 'package:sample_sport_stats/models/Player.dart';
import 'package:sample_sport_stats/pages/matchMenu/logic/MatchCubit.dart';
import 'package:sample_sport_stats/pages/matchMenu/logic/MatchState.dart';

import '../../models/Team.dart';
import '../../router/routes.dart';

class MatchPage extends StatelessWidget {
  final Team team;

  const MatchPage({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MatchCubit>(
      create: (_) => MatchCubit()..initGame(team),
      child: _MatchPage(),
    );
  }
}

class _MatchPage extends StatelessWidget {
  final TextEditingController opponentNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<MatchCubit, MatchState>(
          listener: (context, state) {
            if (state is BeginMatchState) {
              final newGame = Game(
                team: state.team,
                opponentName: state.opponentName,
                atHome: state.atHome,
                teamPlayers: state.selectedPlayers
                    .map((p) => MatchPlayer(name: p.name, number: p.number))
                    .toList(),
                substitutes: state.teamPlayers
                    .where((p) => !p.selected)
                    .map((p) => MatchPlayer(name: p.name, number: p.number))
                    .toList(),
                opponentPlayer:
                    MatchPlayer(name: state.opponentName, number: 0),
                quarters: [],
              );
              context.push(Routes.nestedCurrentMatchPage, extra: newGame);
            }
          },
          child: BlocBuilder<MatchCubit, MatchState>(
            builder: (context, state) {
              if (state is MatchStateInProgress) {
                return Container(
                  color: AppColors.grey,
                  child: Center(
                    child: Stack(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 75, left: 22),
                          child: Image(image: AssetImage('assets/court_bg.png')),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () => context.pop(),
                                    icon: const Icon(Icons.arrow_back_outlined),
                                  ),
                                  Text(state.team.name,
                                      style: AppFontStyle.blue34),
                                  Visibility(
                                    visible: false,
                                    child: IconButton(
                                      onPressed: () =>
                                          context.push(Routes.teamsPage),
                                      icon: const Icon(
                                          Icons.arrow_back_outlined),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 33,
                                      child: Padding(
                                        padding: const EdgeInsets.all(25),
                                        child: OpponentGameConfiguration(
                                          atHome: state.atHome,
                                          opponentNameController:
                                              opponentNameController,
                                        ),
                                      ),
                                    ),
                                    StartGameAndParameters(
                                      opponentNameController:
                                          opponentNameController,
                                    ),
                                    Expanded(
                                      flex: 33,
                                      child: Padding(
                                        padding: const EdgeInsets.all(25),
                                        child: RightSideWidget(
                                          teamPlayers: state.teamPlayers,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─── Panneau central ────────────────────────────────────────────────────────

class StartGameAndParameters extends StatelessWidget {
  const StartGameAndParameters({
    super.key,
    required this.opponentNameController,
  });

  final TextEditingController opponentNameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: RectangleAnimatedButton(
            onPressed: () {},
            text: 'Paramètres du match',
            visible: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: RectangleAnimatedButton(
            onPressed: () {},
            text: 'Statistiques avancées',
            visible: false,
          ),
        ),
        const Spacer(),
        CircularButton(
          onPressed: () =>
              context.read<MatchCubit>().beginMatch(opponentNameController.text),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: RectangleAnimatedButton(
            onPressed: () {},
            text: 'Paramètres du match',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: RectangleAnimatedButton(
            onPressed: () {},
            text: 'Statistiques avancées',
          ),
        ),
      ],
    );
  }
}

// ─── Panneau gauche : configuration adversaire ──────────────────────────────

class OpponentGameConfiguration extends StatelessWidget {
  final bool atHome;
  final TextEditingController opponentNameController;

  const OpponentGameConfiguration({
    super.key,
    required this.atHome,
    required this.opponentNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(
                fillColor: AppColors.grey,
                filled: true,
                border: OutlineInputBorder(),
                hintText: "Nom de l'équipe adverse",
              ),
              controller: opponentNameController,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SideSelectionButton(
                      onPressed: () =>
                          context.read<MatchCubit>().updateAtHome(),
                      text: 'Domicile',
                      isSelected: atHome,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SideSelectionButton(
                      onPressed: () =>
                          context.read<MatchCubit>().updateAtHome(),
                      text: 'Extérieur',
                      isSelected: !atHome,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Panneau droit : sélection des joueurs ───────────────────────────────────

class RightSideWidget extends StatelessWidget {
  final List<Player> teamPlayers;

  const RightSideWidget({super.key, required this.teamPlayers});

  @override
  Widget build(BuildContext context) {
    final selectedCount = teamPlayers.where((p) => p.selected).length;
    final maxReached = selectedCount >= 5;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 16, bottom: 8, left: 24, right: 24),
        child: Column(
          children: [
            // Header : titre + compteur
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mes joueurs',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: maxReached
                        ? AppColors.orange
                        : AppColors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$selectedCount / 5',
                    style: TextStyle(
                      color: maxReached ? Colors.white : AppColors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Grille joueurs + bouton ajout
            Flexible(
              child: teamPlayers.isEmpty
                  ? _emptyState(context)
                  : GridView.count(
                      primary: false,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      children: [
                        ...teamPlayers.map((player) {
                          final disabled = maxReached && !player.selected;
                          return PlayerSelectionWidget(
                            isSelected: player.selected,
                            playerName: player.name,
                            playerNumber: player.number,
                            disabled: disabled,
                            onPressed: () {
                              if (player.selected) {
                                context
                                    .read<MatchCubit>()
                                    .unselectPlayer(player);
                              } else {
                                context
                                    .read<MatchCubit>()
                                    .selectPlayer(player);
                              }
                            },
                          );
                        }),
                        _AddPlayerTile(
                          onAdd: (name, number) =>
                              context.read<MatchCubit>().addPlayer(name, number),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.group_add, color: AppColors.fontGrey, size: 40),
          const SizedBox(height: 8),
          const Text(
            'Aucun joueur',
            style: TextStyle(color: AppColors.fontGrey, fontSize: 14),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (_) => _AddPlayerDialog(
                onConfirm: (name, number) =>
                    context.read<MatchCubit>().addPlayer(name, number),
              ),
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.orange, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '+ Ajouter un joueur',
                style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddPlayerTile extends StatelessWidget {
  final Future<void> Function(String name, int number) onAdd;

  const _AddPlayerTile({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.orangeBackground,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: AppColors.orange,
        onTap: () => showDialog(
          context: context,
          builder: (_) => _AddPlayerDialog(onConfirm: onAdd),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.orange, width: 2),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.orange, size: 28),
              SizedBox(height: 4),
              Text(
                'Ajouter',
                style: TextStyle(color: AppColors.fontGrey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPlayerDialog extends StatefulWidget {
  final Future<void> Function(String name, int number) onConfirm;

  const _AddPlayerDialog({required this.onConfirm});

  @override
  State<_AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<_AddPlayerDialog> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final name = _nameController.text.trim();
    final number = int.tryParse(_numberController.text.trim()) ?? 0;
    if (name.isEmpty) return;

    setState(() => _saving = true);
    await widget.onConfirm(name, number);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nouveau joueur', style: AppFontStyle.anton),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              fillColor: AppColors.grey,
              filled: true,
              border: OutlineInputBorder(),
              hintText: 'Nom du joueur',
            ),
            controller: _nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 15),
          TextField(
            decoration: const InputDecoration(
              fillColor: AppColors.grey,
              filled: true,
              border: OutlineInputBorder(),
              hintText: 'Numéro de maillot',
            ),
            controller: _numberController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Annuler',
            style: TextStyle(color: AppColors.redBtn),
          ),
        ),
        TextButton(
          onPressed: _saving ? null : _confirm,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(
                  'Valider',
                  style: TextStyle(
                      color: AppColors.blue, fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}

// ─── Widget de sélection joueur ───────────────────────────────────────────────

class PlayerSelectionWidget extends StatelessWidget {
  final bool isSelected;
  final String playerName;
  final int playerNumber;
  final VoidCallback onPressed;
  final bool disabled;

  const PlayerSelectionWidget({
    super.key,
    required this.isSelected,
    required this.playerName,
    required this.playerNumber,
    required this.onPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color btnColor =
        isSelected ? AppColors.blue : AppColors.grey;
    final Color txtColor =
        isSelected ? Colors.white : disabled ? AppColors.fontGrey : AppColors.blue;

    return Opacity(
      opacity: disabled ? 0.45 : 1.0,
      child: Material(
        color: btnColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: disabled ? Colors.transparent : AppColors.orange,
          onTap: disabled ? null : onPressed,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  playerName,
                  style: TextStyle(fontSize: 14, color: txtColor),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      '#$playerNumber',
                      style: const TextStyle(
                          color: AppColors.blue, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Boutons utilitaires ─────────────────────────────────────────────────────

class CircularButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CircularButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.orange,
      borderRadius: BorderRadius.circular(57.5),
      child: InkWell(
        borderRadius: BorderRadius.circular(57.5),
        splashColor: Colors.deepOrange,
        onTap: onPressed,
        child: SizedBox(
          width: 115,
          height: 115,
          child: Center(
            child: Text(
              'GO !',
              style: GoogleFonts.anton(
                textStyle: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RectangleAnimatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool visible;
  final double width;
  final double height;

  const RectangleAnimatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.visible = true,
    this.width = 160,
    this.height = 45,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return Container(width: width, height: height, color: Colors.transparent);
    }
    return Material(
      color: AppColors.orange,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.deepOrange,
        onTap: onPressed,
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.anton(
                textStyle: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SideSelectionButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onPressed;

  const SideSelectionButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color btnColor = isSelected ? AppColors.blue : AppColors.grey;
    final Color txtColor = isSelected ? Colors.white : AppColors.blue;

    return Material(
      color: btnColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: AppColors.orange,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: txtColor),
            ),
          ),
        ),
      ),
    );
  }
}
