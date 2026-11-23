class Usuario {
  final int id;
  final String nombre;
  final String correo;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
  });

  factory Usuario.fromJson(Map<String, dynamic> j) => Usuario(
        id: j['id'] as int,
        nombre: j['name'] as String,
        correo: j['email'] as String,
      );
}