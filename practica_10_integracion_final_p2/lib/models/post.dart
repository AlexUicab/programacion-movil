/// Modelo simple para los datos de la API REST (JSONPlaceholder).
class Post {
  final int id;
  final String title;
  final String body;

  const Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as int,
        title: (json['title'] as String).trim(),
        body: (json['body'] as String).trim(),
      );
}
