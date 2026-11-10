class Tarea {
  final int? id;
  final String titulo;
  final String descripcion;
  final bool completada;
  final int actualizadoEn; // epoch ms para resolver conflictos futuros

  Tarea({
    this.id,
    required this.titulo,
    required this.descripcion,
    this.completada = false,
    required this.actualizadoEn,
  });

  Tarea copyWith({
    int? id,
    String? titulo,
    String? descripcion,
    bool? completada,
    int? actualizadoEn,
  }) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      completada: completada ?? this.completada,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'titulo': titulo,
        'descripcion': descripcion,
        'completada': completada ? 1 : 0,
        'actualizado_en': actualizadoEn,
      };

  factory Tarea.fromMap(Map<String, dynamic> m) => Tarea(
        id: m['id'] as int?,
        titulo: m['titulo'] as String? ?? '',
        descripcion: m['descripcion'] as String? ?? '',
        completada: (m['completada'] as int? ?? 0) == 1,
        actualizadoEn: m['actualizado_en'] as int? ?? 0,
      );
}