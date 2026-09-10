class Team {
  final String id;
  final String sportId;
  final String name;
  final String shortName;
  final String city;
  final String abbreviation;
  final String conferenceId;
  final String divisionId;
  final String primaryColor; // hex e.g. #00338D
  final String secondaryColor;
  final String? tertiaryColor;
  final String logoAsset;

  const Team({
    required this.id,
    required this.sportId,
    required this.name,
    required this.shortName,
    required this.city,
    required this.abbreviation,
    required this.conferenceId,
    required this.divisionId,
    required this.primaryColor,
    required this.secondaryColor,
    this.tertiaryColor,
    required this.logoAsset,
  });

  String get conferenceAndDivision {
    final conf = conferenceId.toUpperCase();
    final div = divisionId.split('_').last;
    return '$conf • ${div[0].toUpperCase()}${div.substring(1)}';
  }
}
