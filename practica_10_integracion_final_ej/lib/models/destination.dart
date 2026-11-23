class Destination {
  final int? id;
  final String name;
  final String notes;
  final String category;
  final double budget;
  final DateTime visitDate;
  final double latitude;
  final double longitude;
  final bool visited;

  const Destination({
    this.id,
    required this.name,
    required this.notes,
    required this.category,
    required this.budget,
    required this.visitDate,
    required this.latitude,
    required this.longitude,
    this.visited = false,
  });

  Destination copyWith({bool? visited}) => Destination(
        id: id,
        name: name,
        notes: notes,
        category: category,
        budget: budget,
        visitDate: visitDate,
        latitude: latitude,
        longitude: longitude,
        visited: visited ?? this.visited,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'notes': notes,
        'category': category,
        'budget': budget,
        'visit_date': visitDate.toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
        'visited': visited ? 1 : 0,
      };

  factory Destination.fromMap(Map<String, Object?> m) => Destination(
        id: m['id'] as int?,
        name: m['name'] as String,
        notes: m['notes'] as String,
        category: m['category'] as String,
        budget: (m['budget'] as num).toDouble(),
        visitDate: DateTime.parse(m['visit_date'] as String),
        latitude: (m['latitude'] as num).toDouble(),
        longitude: (m['longitude'] as num).toDouble(),
        visited: (m['visited'] as int) == 1,
      );
}
