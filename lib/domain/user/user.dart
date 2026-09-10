class UserPreferences {
  final String id;
  final String? mainTeamId;
  final String? secondTeamId;
  final List<String> followedTeamIds;
  final String locale; // 'es' | 'en'
  final String themeMode; // 'light' | 'dark' | 'system'
  final String? selectedSportId;
  final bool onboardingCompleted;

  const UserPreferences({
    required this.id,
    this.mainTeamId,
    this.secondTeamId,
    this.followedTeamIds = const [],
    this.locale = 'es',
    this.themeMode = 'light',
    this.selectedSportId,
    this.onboardingCompleted = false,
  });

  UserPreferences copyWith({
    String? id,
    String? mainTeamId,
    String? secondTeamId,
    List<String>? followedTeamIds,
    String? locale,
    String? themeMode,
    String? selectedSportId,
    bool? onboardingCompleted,
    bool clearSecondTeam = false,
  }) {
    return UserPreferences(
      id: id ?? this.id,
      mainTeamId: mainTeamId ?? this.mainTeamId,
      secondTeamId: clearSecondTeam ? null : (secondTeamId ?? this.secondTeamId),
      followedTeamIds: followedTeamIds ?? this.followedTeamIds,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      selectedSportId: selectedSportId ?? this.selectedSportId,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mainTeamId': mainTeamId,
      'secondTeamId': secondTeamId,
      'followedTeamIds': followedTeamIds,
      'locale': locale,
      'themeMode': themeMode,
      'selectedSportId': selectedSportId,
      'onboardingCompleted': onboardingCompleted,
    };
  }

  factory UserPreferences.fromMap(Map<dynamic, dynamic> map) {
    return UserPreferences(
      id: map['id'] as String? ?? 'local_user',
      mainTeamId: map['mainTeamId'] as String?,
      secondTeamId: map['secondTeamId'] as String?,
      followedTeamIds: (map['followedTeamIds'] as List?)?.cast<String>() ?? const [],
      locale: map['locale'] as String? ?? 'es',
      themeMode: map['themeMode'] as String? ?? 'light',
      selectedSportId: map['selectedSportId'] as String?,
      onboardingCompleted: map['onboardingCompleted'] as bool? ?? false,
    );
  }
}
