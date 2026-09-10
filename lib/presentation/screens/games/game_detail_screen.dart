import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/achievements/achievements_provider.dart';
import '../../../application/games/games_provider.dart';
import '../../../application/teams/teams_provider.dart';
import '../../../core/utils/color_utils.dart';
import '../../../data/services/espn_score_service.dart';
import '../../../domain/game/game.dart';
import '../../../domain/team/team.dart';
import '../../widgets/source_badge.dart';

class GameDetailScreen extends ConsumerStatefulWidget {
  final String gameId;

  const GameDetailScreen({super.key, required this.gameId});

  @override
  ConsumerState<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends ConsumerState<GameDetailScreen>
    with SingleTickerProviderStateMixin {
  OfficialResultSuggestion? _suggestion;
  bool _loadingEspn = true;
  bool _saving = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final _homeCtrl = TextEditingController();
  final _awayCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initControllers();
      _loadEspn();
    });
  }

  void _initControllers() {
    final game = _findGame();
    if (game?.result != null) {
      _homeCtrl.text = game!.result!.homeScore.toString();
      _awayCtrl.text = game.result!.awayScore.toString();
    }
  }

  Game? _findGame() {
    final games = ref.read(gamesLiveProvider);
    try {
      return games.firstWhere((g) => g.id == widget.gameId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _loadEspn() async {
    final game = _findGame();
    if (game == null) {
      setState(() => _loadingEspn = false);
      return;
    }

    try {
      final service = EspnScoreService();
      final suggestion = await service.getOfficialSuggestion(game);
      if (mounted) {
        setState(() {
          _suggestion = suggestion;
          _loadingEspn = false;
        });
      }
      service.dispose();
    } catch (_) {
      if (mounted) setState(() => _loadingEspn = false);
    }
  }

  Future<void> _saveResult({
    required int homeScore,
    required int awayScore,
    bool fromOfficial = false,
  }) async {
    setState(() => _saving = true);
    HapticFeedback.mediumImpact();

    await ref.read(saveGameResultProvider)(
      gameId: widget.gameId,
      homeScore: homeScore,
      awayScore: awayScore,
    );
    await ref.read(unlockedAchievementsProvider.notifier).evaluate();

    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            fromOfficial ? 'Resultado oficial guardado' : 'Resultado guardado',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _homeCtrl.dispose();
    _awayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = _findGame();
    if (game == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0C),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Text('Partido no encontrado', style: TextStyle(color: Colors.white54)),
        ),
      );
    }

    final home = ref.watch(teamByIdProvider(game.homeTeamId));
    final away = ref.watch(teamByIdProvider(game.awayTeamId));
    if (home == null || away == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A0C),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isLive = _suggestion?.isInProgress == true;
    final isFinal = game.isCompleted || (_suggestion?.isFinal == true);
    final homeColor = parseHexColor(home.primaryColor);
    final awayColor = parseHexColor(away.primaryColor);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      body: CustomScrollView(
        slivers: [
          // App bar con gradiente de equipos
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF0A0A0C),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      homeColor.withOpacity(0.45),
                      const Color(0xFF0A0A0C),
                      awayColor.withOpacity(0.45),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Estado del partido
                      if (isLive)
                        FadeTransition(
                          opacity: _pulseAnimation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, size: 8, color: Colors.redAccent),
                                SizedBox(width: 6),
                                Text(
                                  'EN VIVO',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (isFinal)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'FINAL',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            if (game.isCompleted) ...[
                              const SizedBox(width: 8),
                              SourceBadge(source: game.source, compact: true),
                            ],
                          ],
                        )
                      else
                        Text(
                          _formatDate(game.scheduledAt),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 13,
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Marcador grande
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _TeamBlock(team: home, color: homeColor, isHome: true),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              _displayScore(game, _suggestion, isHome: true) +
                                  '  -  ' +
                                  _displayScore(game, _suggestion, isHome: false),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          _TeamBlock(team: away, color: awayColor, isHome: false),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sugerencia oficial
                  if (_loadingEspn)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54),
                      ),
                    )
                  else if (_suggestion != null && _suggestion!.isFinal && !game.isCompleted)
                    _OfficialCard(
                      suggestion: _suggestion!,
                      onAccept: () => _saveResult(
                        homeScore: _suggestion!.homeScore,
                        awayScore: _suggestion!.awayScore,
                        fromOfficial: true,
                      ),
                      saving: _saving,
                    )
                  else if (isLive && _suggestion != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Marcador en vivo (ESPN)',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_suggestion!.homeScore}  -  ${_suggestion!.awayScore}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            _suggestion!.statusDetail,
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 8),
                  const Text(
                    'Registrar / Editar resultado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Inputs
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _homeCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                          decoration: _inputDecoration(home.abbreviation),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('—', style: TextStyle(color: Colors.white38, fontSize: 28)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _awayCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                          decoration: _inputDecoration(away.abbreviation),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Guardar
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _saving
                          ? null
                          : () {
                              final hs = int.tryParse(_homeCtrl.text.trim());
                              final as_ = int.tryParse(_awayCtrl.text.trim());
                              if (hs == null || as_ == null || hs < 0 || as_ < 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Introduce marcadores válidos')),
                                );
                                return;
                              }
                              _saveResult(homeScore: hs, awayScore: as_);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Guardar resultado',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                            ),
                    ),
                  ),

                  if (game.isCompleted) ...[
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          HapticFeedback.lightImpact();
                          await ref.read(clearGameResultProvider)(gameId: game.id);
                          await ref.read(unlockedAchievementsProvider.notifier).evaluate();
                          if (context.mounted) {
                            _homeCtrl.clear();
                            _awayCtrl.clear();
                            setState(() {});
                          }
                        },
                        child: const Text(
                          'Eliminar resultado',
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _displayScore(Game game, OfficialResultSuggestion? suggestion, {required bool isHome}) {
    if (game.result != null) {
      return isHome ? '${game.result!.homeScore}' : '${game.result!.awayScore}';
    }
    if (suggestion != null && (suggestion.isFinal || suggestion.isInProgress)) {
      return isHome ? '${suggestion.homeScore}' : '${suggestion.awayScore}';
    }
    return '—';
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  String _formatDate(DateTime d) {
    const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    const months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
    return '${days[(d.weekday - 1) % 7]} ${d.day} ${months[d.month - 1]} · ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}

class _TeamBlock extends StatelessWidget {
  final Team team;
  final Color color;
  final bool isHome;

  const _TeamBlock({required this.team, required this.color, required this.isHome});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            team.logoAsset,
            errorBuilder: (_, __, ___) => Icon(Icons.sports_football, color: color),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          team.abbreviation,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _OfficialCard extends StatelessWidget {
  final OfficialResultSuggestion suggestion;
  final VoidCallback onAccept;
  final bool saving;

  const _OfficialCard({
    required this.suggestion,
    required this.onAccept,
    required this.saving,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2E1A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.35)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, color: Colors.greenAccent, size: 18),
              SizedBox(width: 6),
              Text(
                'Resultado oficial ESPN',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${suggestion.homeScore}  -  ${suggestion.awayScore}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            suggestion.statusDetail,
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: saving ? null : onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Usar resultado oficial',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}