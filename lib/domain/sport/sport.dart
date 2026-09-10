enum SportType {
  americanFootball,
  soccer,
  basketball,
}

class Sport {
  final String id;
  final SportType type;
  final String name;
  final String nameEs;
  final String subtitle;
  final String subtitleEs;
  final bool available;

  const Sport({
    required this.id,
    required this.type,
    required this.name,
    required this.nameEs,
    required this.subtitle,
    required this.subtitleEs,
    required this.available,
  });
}

const kSports = [
  Sport(
    id: 'american_football',
    type: SportType.americanFootball,
    name: 'NFL',
    nameEs: 'NFL',
    subtitle: 'National Football League',
    subtitleEs: 'Liga Nacional de Fútbol Americano',
    available: true,
  ),
  Sport(
    id: 'soccer',
    type: SportType.soccer,
    name: 'Soccer',
    nameEs: 'Fútbol',
    subtitle: 'Coming soon',
    subtitleEs: 'Próximamente',
    available: false,
  ),
  Sport(
    id: 'basketball',
    type: SportType.basketball,
    name: 'Basketball',
    nameEs: 'Baloncesto',
    subtitle: 'Coming soon',
    subtitleEs: 'Próximamente',
    available: false,
  ),
];
