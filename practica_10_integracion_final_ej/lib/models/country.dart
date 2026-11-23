/// País obtenido de la API REST Countries.
class Country {
  final String name;
  final String capital;
  final int population;
  final double latitude;
  final double longitude;
  final String flag;

  const Country({
    required this.name,
    required this.capital,
    required this.population,
    required this.latitude,
    required this.longitude,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> j) {
    final caps = (j['capital'] as List?)?.cast<String>() ?? const <String>[];
    final ll = (j['latlng'] as List?)
            ?.map((e) => (e as num).toDouble())
            .toList() ??
        const <double>[];
    return Country(
      name: (j['name'] as Map<String, dynamic>)['common'] as String,
      capital: caps.isNotEmpty ? caps.first : '—',
      population: (j['population'] as num?)?.toInt() ?? 0,
      latitude: ll.length >= 2 ? ll[0] : 0,
      longitude: ll.length >= 2 ? ll[1] : 0,
      flag: (j['flag'] as String?) ?? '🏳️',
    );
  }
}
