import '../../domain/team/team.dart';

class NflTeams {
  NflTeams._();

  static const String sportId = 'american_football';

  // ─── AFC EAST ───────────────────────────────────────────
  static const buffaloBills = Team(
    id: 'buf_bills',
    sportId: sportId,
    name: 'Buffalo Bills',
    shortName: 'Bills',
    city: 'Buffalo',
    abbreviation: 'BUF',
    conferenceId: 'afc',
    divisionId: 'afc_east',
    primaryColor: '#00338D',
    secondaryColor: '#C60C30',
    logoAsset: 'assets/images/teams/nfl/afc/east/Buffalo_Bills_logo.png',
  );

  static const miamiDolphins = Team(
    id: 'mia_dolphins',
    sportId: sportId,
    name: 'Miami Dolphins',
    shortName: 'Dolphins',
    city: 'Miami',
    abbreviation: 'MIA',
    conferenceId: 'afc',
    divisionId: 'afc_east',
    primaryColor: '#008E97',
    secondaryColor: '#FC4C02',
    logoAsset: 'assets/images/teams/nfl/afc/east/Miami_Dolphins_logo.png',
  );

  static const newEnglandPatriots = Team(
    id: 'ne_patriots',
    sportId: sportId,
    name: 'New England Patriots',
    shortName: 'Patriots',
    city: 'New England',
    abbreviation: 'NE',
    conferenceId: 'afc',
    divisionId: 'afc_east',
    primaryColor: '#002244',
    secondaryColor: '#C60C30',
    logoAsset: 'assets/images/teams/nfl/afc/east/New_England_Patriots_logo.png',
  );

  static const newYorkJets = Team(
    id: 'ny_jets',
    sportId: sportId,
    name: 'New York Jets',
    shortName: 'Jets',
    city: 'New York',
    abbreviation: 'NYJ',
    conferenceId: 'afc',
    divisionId: 'afc_east',
    primaryColor: '#125740',
    secondaryColor: '#FFFFFF',
    logoAsset: 'assets/images/teams/nfl/afc/east/New_York_Jets_logo.png',
  );

  // ─── AFC NORTH ──────────────────────────────────────────
  static const baltimoreRavens = Team(
    id: 'bal_ravens',
    sportId: sportId,
    name: 'Baltimore Ravens',
    shortName: 'Ravens',
    city: 'Baltimore',
    abbreviation: 'BAL',
    conferenceId: 'afc',
    divisionId: 'afc_north',
    primaryColor: '#241773',
    secondaryColor: '#9E7C0C',
    logoAsset: 'assets/images/teams/nfl/afc/north/Baltimore_Ravens_logo.png',
  );

  static const cincinnatiBengals = Team(
    id: 'cin_bengals',
    sportId: sportId,
    name: 'Cincinnati Bengals',
    shortName: 'Bengals',
    city: 'Cincinnati',
    abbreviation: 'CIN',
    conferenceId: 'afc',
    divisionId: 'afc_north',
    primaryColor: '#FB4F14',
    secondaryColor: '#000000',
    logoAsset: 'assets/images/teams/nfl/afc/north/Cincinnati_Bengals_logo.png',
  );

  static const clevelandBrowns = Team(
    id: 'cle_browns',
    sportId: sportId,
    name: 'Cleveland Browns',
    shortName: 'Browns',
    city: 'Cleveland',
    abbreviation: 'CLE',
    conferenceId: 'afc',
    divisionId: 'afc_north',
    primaryColor: '#311D00',
    secondaryColor: '#FF3C00',
    logoAsset: 'assets/images/teams/nfl/afc/north/Cleveland_Browns_logo.png',
  );

  static const pittsburghSteelers = Team(
    id: 'pit_steelers',
    sportId: sportId,
    name: 'Pittsburgh Steelers',
    shortName: 'Steelers',
    city: 'Pittsburgh',
    abbreviation: 'PIT',
    conferenceId: 'afc',
    divisionId: 'afc_north',
    primaryColor: '#FFB612',
    secondaryColor: '#101820',
    logoAsset: 'assets/images/teams/nfl/afc/north/Pittsburgh_Steelers_logo.png',
  );

  // ─── AFC SOUTH ──────────────────────────────────────────
  static const houstonTexans = Team(
    id: 'hou_texans',
    sportId: sportId,
    name: 'Houston Texans',
    shortName: 'Texans',
    city: 'Houston',
    abbreviation: 'HOU',
    conferenceId: 'afc',
    divisionId: 'afc_south',
    primaryColor: '#03202F',
    secondaryColor: '#A71930',
    logoAsset: 'assets/images/teams/nfl/afc/south/Houston_Texans_logo.png',
  );

  static const indianapolisColts = Team(
    id: 'ind_colts',
    sportId: sportId,
    name: 'Indianapolis Colts',
    shortName: 'Colts',
    city: 'Indianapolis',
    abbreviation: 'IND',
    conferenceId: 'afc',
    divisionId: 'afc_south',
    primaryColor: '#002C5F',
    secondaryColor: '#A2AAAD',
    logoAsset: 'assets/images/teams/nfl/afc/south/Indianapolis_Colts_logo.png',
  );

  static const jacksonvilleJaguars = Team(
    id: 'jax_jaguars',
    sportId: sportId,
    name: 'Jacksonville Jaguars',
    shortName: 'Jaguars',
    city: 'Jacksonville',
    abbreviation: 'JAX',
    conferenceId: 'afc',
    divisionId: 'afc_south',
    primaryColor: '#006778',
    secondaryColor: '#D7A22A',
    logoAsset: 'assets/images/teams/nfl/afc/south/Jacksonville_Jaguars_logo.png',
  );

  static const tennesseeTitans = Team(
    id: 'ten_titans',
    sportId: sportId,
    name: 'Tennessee Titans',
    shortName: 'Titans',
    city: 'Tennessee',
    abbreviation: 'TEN',
    conferenceId: 'afc',
    divisionId: 'afc_south',
    primaryColor: '#0C2340',
    secondaryColor: '#4B92DB',
    logoAsset: 'assets/images/teams/nfl/afc/south/Tennessee_Titans_Logo.png',
  );

  // ─── AFC WEST ───────────────────────────────────────────
  static const denverBroncos = Team(
    id: 'den_broncos',
    sportId: sportId,
    name: 'Denver Broncos',
    shortName: 'Broncos',
    city: 'Denver',
    abbreviation: 'DEN',
    conferenceId: 'afc',
    divisionId: 'afc_west',
    primaryColor: '#FB4F14',
    secondaryColor: '#002244',
    logoAsset: 'assets/images/teams/nfl/afc/west/Denver_Broncos_logo.png',
  );

  static const kansasCityChiefs = Team(
    id: 'kc_chiefs',
    sportId: sportId,
    name: 'Kansas City Chiefs',
    shortName: 'Chiefs',
    city: 'Kansas City',
    abbreviation: 'KC',
    conferenceId: 'afc',
    divisionId: 'afc_west',
    primaryColor: '#E31837',
    secondaryColor: '#FFB81C',
    logoAsset: 'assets/images/teams/nfl/afc/west/Kansas_City_Chiefs_logo.png',
  );

  static const lasVegasRaiders = Team(
    id: 'lv_raiders',
    sportId: sportId,
    name: 'Las Vegas Raiders',
    shortName: 'Raiders',
    city: 'Las Vegas',
    abbreviation: 'LV',
    conferenceId: 'afc',
    divisionId: 'afc_west',
    primaryColor: '#000000',
    secondaryColor: '#A5ACAF',
    logoAsset: 'assets/images/teams/nfl/afc/west/Las_Vegas_Raiders_logo.png',
  );

  static const losAngelesChargers = Team(
    id: 'lac_chargers',
    sportId: sportId,
    name: 'Los Angeles Chargers',
    shortName: 'Chargers',
    city: 'Los Angeles',
    abbreviation: 'LAC',
    conferenceId: 'afc',
    divisionId: 'afc_west',
    primaryColor: '#0080C6',
    secondaryColor: '#FFC20E',
    logoAsset: 'assets/images/teams/nfl/afc/west/Los_Angeles_Chargers_logo.png',
  );

  // ─── NFC EAST ───────────────────────────────────────────
  static const dallasCowboys = Team(
    id: 'dal_cowboys',
    sportId: sportId,
    name: 'Dallas Cowboys',
    shortName: 'Cowboys',
    city: 'Dallas',
    abbreviation: 'DAL',
    conferenceId: 'nfc',
    divisionId: 'nfc_east',
    primaryColor: '#003594',
    secondaryColor: '#869397',
    logoAsset: 'assets/images/teams/nfl/nfc/east/Dallas_Cowboys_logo.png',
  );

  static const newYorkGiants = Team(
    id: 'ny_giants',
    sportId: sportId,
    name: 'New York Giants',
    shortName: 'Giants',
    city: 'New York',
    abbreviation: 'NYG',
    conferenceId: 'nfc',
    divisionId: 'nfc_east',
    primaryColor: '#0B2265',
    secondaryColor: '#A71930',
    logoAsset: 'assets/images/teams/nfl/nfc/east/New_York_Giants_logo.png',
  );

  static const philadelphiaEagles = Team(
    id: 'phi_eagles',
    sportId: sportId,
    name: 'Philadelphia Eagles',
    shortName: 'Eagles',
    city: 'Philadelphia',
    abbreviation: 'PHI',
    conferenceId: 'nfc',
    divisionId: 'nfc_east',
    primaryColor: '#004C54',
    secondaryColor: '#A5ACAF',
    logoAsset: 'assets/images/teams/nfl/nfc/east/Philadelphia_Eagles_logo.png',
  );

  static const washingtonCommanders = Team(
    id: 'was_commanders',
    sportId: sportId,
    name: 'Washington Commanders',
    shortName: 'Commanders',
    city: 'Washington',
    abbreviation: 'WAS',
    conferenceId: 'nfc',
    divisionId: 'nfc_east',
    primaryColor: '#5A1414',
    secondaryColor: '#FFB612',
    logoAsset: 'assets/images/teams/nfl/nfc/east/Washington_Commanders_logo.png',
  );

  // ─── NFC NORTH ──────────────────────────────────────────
  static const chicagoBears = Team(
    id: 'chi_bears',
    sportId: sportId,
    name: 'Chicago Bears',
    shortName: 'Bears',
    city: 'Chicago',
    abbreviation: 'CHI',
    conferenceId: 'nfc',
    divisionId: 'nfc_north',
    primaryColor: '#0B162A',
    secondaryColor: '#C83803',
    logoAsset: 'assets/images/teams/nfl/nfc/north/Chicago_Bears_logo.png',
  );

  static const detroitLions = Team(
    id: 'det_lions',
    sportId: sportId,
    name: 'Detroit Lions',
    shortName: 'Lions',
    city: 'Detroit',
    abbreviation: 'DET',
    conferenceId: 'nfc',
    divisionId: 'nfc_north',
    primaryColor: '#0076B6',
    secondaryColor: '#B0B7BC',
    logoAsset: 'assets/images/teams/nfl/nfc/north/Detroit_Lions_logo.png',
  );

  static const greenBayPackers = Team(
    id: 'gb_packers',
    sportId: sportId,
    name: 'Green Bay Packers',
    shortName: 'Packers',
    city: 'Green Bay',
    abbreviation: 'GB',
    conferenceId: 'nfc',
    divisionId: 'nfc_north',
    primaryColor: '#203731',
    secondaryColor: '#FFB612',
    logoAsset: 'assets/images/teams/nfl/nfc/north/Green_Bay_Packers_logo.png',
  );

  static const minnesotaVikings = Team(
    id: 'min_vikings',
    sportId: sportId,
    name: 'Minnesota Vikings',
    shortName: 'Vikings',
    city: 'Minnesota',
    abbreviation: 'MIN',
    conferenceId: 'nfc',
    divisionId: 'nfc_north',
    primaryColor: '#4F2683',
    secondaryColor: '#FFC62F',
    logoAsset: 'assets/images/teams/nfl/nfc/north/Minnesota_Vikings_logo.png',
  );

  // ─── NFC SOUTH ──────────────────────────────────────────
  static const atlantaFalcons = Team(
    id: 'atl_falcons',
    sportId: sportId,
    name: 'Atlanta Falcons',
    shortName: 'Falcons',
    city: 'Atlanta',
    abbreviation: 'ATL',
    conferenceId: 'nfc',
    divisionId: 'nfc_south',
    primaryColor: '#A71930',
    secondaryColor: '#000000',
    logoAsset: 'assets/images/teams/nfl/nfc/south/Atlanta_Falcons_logo.png',
  );

  static const carolinaPanthers = Team(
    id: 'car_panthers',
    sportId: sportId,
    name: 'Carolina Panthers',
    shortName: 'Panthers',
    city: 'Carolina',
    abbreviation: 'CAR',
    conferenceId: 'nfc',
    divisionId: 'nfc_south',
    primaryColor: '#0085CA',
    secondaryColor: '#101820',
    logoAsset: 'assets/images/teams/nfl/nfc/south/Carolina_Panthers_logo.png',
  );

  static const newOrleansSaints = Team(
    id: 'no_saints',
    sportId: sportId,
    name: 'New Orleans Saints',
    shortName: 'Saints',
    city: 'New Orleans',
    abbreviation: 'NO',
    conferenceId: 'nfc',
    divisionId: 'nfc_south',
    primaryColor: '#D3BC8D',
    secondaryColor: '#101820',
    logoAsset: 'assets/images/teams/nfl/nfc/south/New_Orleans_Saints_logo.png',
  );

  static const tampaBayBuccaneers = Team(
    id: 'tb_buccaneers',
    sportId: sportId,
    name: 'Tampa Bay Buccaneers',
    shortName: 'Buccaneers',
    city: 'Tampa Bay',
    abbreviation: 'TB',
    conferenceId: 'nfc',
    divisionId: 'nfc_south',
    primaryColor: '#D50A0A',
    secondaryColor: '#FF7900',
    logoAsset: 'assets/images/teams/nfl/nfc/south/Tampa_Bay_Buccaneers_logo.png',
  );

  // ─── NFC WEST ───────────────────────────────────────────
  static const arizonaCardinals = Team(
    id: 'ari_cardinals',
    sportId: sportId,
    name: 'Arizona Cardinals',
    shortName: 'Cardinals',
    city: 'Arizona',
    abbreviation: 'ARI',
    conferenceId: 'nfc',
    divisionId: 'nfc_west',
    primaryColor: '#97233F',
    secondaryColor: '#000000',
    logoAsset: 'assets/images/teams/nfl/nfc/west/Arizona_Cardinals_logo.png',
  );

  static const losAngelesRams = Team(
    id: 'lar_rams',
    sportId: sportId,
    name: 'Los Angeles Rams',
    shortName: 'Rams',
    city: 'Los Angeles',
    abbreviation: 'LAR',
    conferenceId: 'nfc',
    divisionId: 'nfc_west',
    primaryColor: '#003594',
    secondaryColor: '#FFA300',
    logoAsset: 'assets/images/teams/nfl/nfc/west/LA_Rams_logo.png',
  );

  static const sanFrancisco49ers = Team(
    id: 'sf_49ers',
    sportId: sportId,
    name: 'San Francisco 49ers',
    shortName: '49ers',
    city: 'San Francisco',
    abbreviation: 'SF',
    conferenceId: 'nfc',
    divisionId: 'nfc_west',
    primaryColor: '#AA0000',
    secondaryColor: '#B3995D',
    logoAsset: 'assets/images/teams/nfl/nfc/west/San_Francisco_49ers_logo.png',
  );

  static const seattleSeahawks = Team(
    id: 'sea_seahawks',
    sportId: sportId,
    name: 'Seattle Seahawks',
    shortName: 'Seahawks',
    city: 'Seattle',
    abbreviation: 'SEA',
    conferenceId: 'nfc',
    divisionId: 'nfc_west',
    primaryColor: '#002244',
    secondaryColor: '#69BE28',
    logoAsset: 'assets/images/teams/nfl/nfc/west/Seattle_Seahawks_logo.png',
  );

  // ─── ALL ────────────────────────────────────────────────
  static const List<Team> all = [
    buffaloBills,
    miamiDolphins,
    newEnglandPatriots,
    newYorkJets,
    baltimoreRavens,
    cincinnatiBengals,
    clevelandBrowns,
    pittsburghSteelers,
    houstonTexans,
    indianapolisColts,
    jacksonvilleJaguars,
    tennesseeTitans,
    denverBroncos,
    kansasCityChiefs,
    lasVegasRaiders,
    losAngelesChargers,
    dallasCowboys,
    newYorkGiants,
    philadelphiaEagles,
    washingtonCommanders,
    chicagoBears,
    detroitLions,
    greenBayPackers,
    minnesotaVikings,
    atlantaFalcons,
    carolinaPanthers,
    newOrleansSaints,
    tampaBayBuccaneers,
    arizonaCardinals,
    losAngelesRams,
    sanFrancisco49ers,
    seattleSeahawks,
  ];

  static Team? byId(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<Team> byConference(String conferenceId) {
    return all.where((t) => t.conferenceId == conferenceId).toList();
  }

  static List<Team> byDivision(String divisionId) {
    return all.where((t) => t.divisionId == divisionId).toList();
  }
}
