enum CompetitionType {
  official,
  custom,
}

class Competition {
  final String id;
  final String sportId;
  final String name;
  final CompetitionType type;

  const Competition({
    required this.id,
    required this.sportId,
    required this.name,
    required this.type,
  });
}
