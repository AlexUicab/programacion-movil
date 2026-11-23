class Incident {
  final int? id;
  final String title;
  final String description;
  final String category;
  final String photoPath;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final bool synced;

  const Incident({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.photoPath,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.synced = false,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'photo_path': photoPath,
        'latitude': latitude,
        'longitude': longitude,
        'created_at': createdAt.toIso8601String(),
        'synced': synced ? 1 : 0,
      };

  factory Incident.fromMap(Map<String, Object?> m) => Incident(
        id: m['id'] as int?,
        title: m['title'] as String,
        description: m['description'] as String,
        category: m['category'] as String,
        photoPath: m['photo_path'] as String,
        latitude: (m['latitude'] as num).toDouble(),
        longitude: (m['longitude'] as num).toDouble(),
        createdAt: DateTime.parse(m['created_at'] as String),
        synced: (m['synced'] as int) == 1,
      );
}
