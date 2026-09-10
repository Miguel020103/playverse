import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/teams/teams_provider.dart';
import '../../../application/user/user_provider.dart';
import '../../../core/utils/color_utils.dart';
import '../../../domain/team/team.dart';
import '../../widgets/onboarding_progress.dart';

class TeamSelectionScreen extends ConsumerStatefulWidget {
  final bool selectingSecondTeam;

  const TeamSelectionScreen({
    super.key,
    this.selectingSecondTeam = false,
  });

  @override
  ConsumerState<TeamSelectionScreen> createState() =>
      _TeamSelectionScreenState();
}

class _TeamSelectionScreenState extends ConsumerState<TeamSelectionScreen> {
  String? selectedConference;

  @override
  Widget build(BuildContext context) {
    final allTeams = ref.watch(allNflTeamsProvider);
    final mainTeam = ref.watch(mainTeamProvider);

    final teams = selectedConference == null
        ? <Team>[]
        : allTeams
            .where((t) => t.conferenceId == selectedConference)
            .where((t) => !widget.selectingSecondTeam || t.id != mainTeam?.id)
            .toList();

    final step = widget.selectingSecondTeam ? 3 : 2;

    final headline = widget.selectingSecondTeam
        ? 'Añade un segundo\nequipo'
        : 'Elige tu equipo\nprincipal';

    final subtitle = widget.selectingSecondTeam
        ? 'Opcional. Aparecerá en tu Home con menor prioridad que el principal.'
        : 'Definirá la identidad de tu experiencia: Home, calendario y logros.';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OnboardingProgress(step: step),
                  const SizedBox(height: 28),
                  if (widget.selectingSecondTeam) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'OPCIONAL',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: Colors.white.withOpacity(0.55),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  Text(
                    headline,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.9,
                      height: 1.08,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Colors.white.withOpacity(0.45),
                    ),
                  ),
                  if (widget.selectingSecondTeam && mainTeam != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16161A),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                      ),
                      child: Row(
                        children: [
                          _MiniLogo(team: mainTeam),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mainTeam.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Equipo principal ya elegido',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle_rounded,
                              size: 18, color: Colors.greenAccent.withOpacity(0.85)),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _ConferenceChip(
                          label: 'AFC',
                          selected: selectedConference == 'afc',
                          onTap: () => setState(() => selectedConference = 'afc'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ConferenceChip(
                          label: 'NFC',
                          selected: selectedConference == 'nfc',
                          onTap: () => setState(() => selectedConference = 'nfc'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: selectedConference == null
                  ? Center(
                      child: Text(
                        'Selecciona AFC o NFC',
                        style: TextStyle(color: Colors.white.withOpacity(0.3)),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.92,
                      ),
                      itemCount: teams.length,
                      itemBuilder: (context, index) {
                        final team = teams[index];
                        return _TeamCard(
                          team: team,
                          onTap: () => _onTeamSelected(team),
                        );
                      },
                    ),
            ),
            if (widget.selectingSecondTeam)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () async {
                      await ref
                          .read(userPreferencesProvider.notifier)
                          .completeOnboarding();
                      if (context.mounted) context.go('/home');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(0.15)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Continuar sin segundo equipo',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTeamSelected(Team team) async {
    final notifier = ref.read(userPreferencesProvider.notifier);
    if (widget.selectingSecondTeam) {
      await notifier.setSecondTeam(team.id);
      await notifier.completeOnboarding();
      if (mounted) context.go('/home');
    } else {
      await notifier.setMainTeam(team.id);
      if (mounted) context.go('/select-team?second=true');
    }
  }
}

class _MiniLogo extends StatelessWidget {
  final Team team;
  const _MiniLogo({required this.team});

  @override
  Widget build(BuildContext context) {
    final primary = parseHexColor(team.primaryColor);
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: Image.asset(
        team.logoAsset,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.sports_football, size: 18, color: primary),
      ),
    );
  }
}

class _ConferenceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ConferenceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : const Color(0xFF16161A),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: selected
                ? null
                : Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: selected ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final Team team;
  final VoidCallback onTap;

  const _TeamCard({required this.team, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = parseHexColor(team.primaryColor);

    return Material(
      color: const Color(0xFF16161A),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  team.logoAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.sports_football, color: primary, size: 28),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                team.shortName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                team.conferenceAndDivision,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.35),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
