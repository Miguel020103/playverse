/// Placeholder for future MY ARENA feature.
/// A custom competition created by the user.
class MyArena {
  final String id;
  final String ownerUserId;
  final String competitionId;
  final Map<String, dynamic> configuration;

  const MyArena({
    required this.id,
    required this.ownerUserId,
    required this.competitionId,
    this.configuration = const {},
  });
}
