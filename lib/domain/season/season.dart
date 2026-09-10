class Season {
  final String id;
  final String competitionId;
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;

  const Season({
    required this.id,
    required this.competitionId,
    required this.name,
    this.startDate,
    this.endDate,
    this.isActive = false,
  });
}
