import '../../domain/competition/competition.dart';
import '../../domain/competition/conference.dart';
import '../../domain/competition/division.dart';
import '../../domain/season/season.dart';
import 'nfl_teams.dart';

class NflData {
  static const competition = Competition(
    id: 'nfl',
    sportId: 'american_football',
    name: 'National Football League',
    type: CompetitionType.official,
  );

  static const season2026 = Season(
    id: 'nfl_2026',
    competitionId: 'nfl',
    name: '2026 Season',
    isActive: true,
  );

  static const afc = Conference(
    id: 'afc',
    seasonId: 'nfl_2026',
    name: 'American Football Conference',
    shortName: 'AFC',
  );

  static const nfc = Conference(
    id: 'nfc',
    seasonId: 'nfl_2026',
    name: 'National Football Conference',
    shortName: 'NFC',
  );

  static const conferences = [afc, nfc];

  static const divisions = [
    Division(id: 'afc_east', conferenceId: 'afc', name: 'East'),
    Division(id: 'afc_north', conferenceId: 'afc', name: 'North'),
    Division(id: 'afc_south', conferenceId: 'afc', name: 'South'),
    Division(id: 'afc_west', conferenceId: 'afc', name: 'West'),
    Division(id: 'nfc_east', conferenceId: 'nfc', name: 'East'),
    Division(id: 'nfc_north', conferenceId: 'nfc', name: 'North'),
    Division(id: 'nfc_south', conferenceId: 'nfc', name: 'South'),
    Division(id: 'nfc_west', conferenceId: 'nfc', name: 'West'),
  ];

  static List get teams => NflTeams.all;
}
