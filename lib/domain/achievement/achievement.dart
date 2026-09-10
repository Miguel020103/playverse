class Achievement {
  final String id;
  final String name;
  final String nameEs;
  final String description;
  final String descriptionEs;
  final String category; // progress | performance | competition
  final String icon; // material icon key

  const Achievement({
    required this.id,
    required this.name,
    required this.nameEs,
    required this.description,
    required this.descriptionEs,
    required this.category,
    required this.icon,
  });
}

class UnlockedAchievement {
  final String achievementId;
  final String? teamId;
  final DateTime unlockedAt;

  const UnlockedAchievement({
    required this.achievementId,
    this.teamId,
    required this.unlockedAt,
  });

  Map<String, dynamic> toMap() => {
        'achievementId': achievementId,
        'teamId': teamId,
        'unlockedAt': unlockedAt.toIso8601String(),
      };

  factory UnlockedAchievement.fromMap(Map<dynamic, dynamic> map) {
    return UnlockedAchievement(
      achievementId: map['achievementId'] as String,
      teamId: map['teamId'] as String?,
      unlockedAt: DateTime.tryParse(map['unlockedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
