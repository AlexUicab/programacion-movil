class Tarea {
  final int id;
  final String titulo;
  final bool completada;
  final DateTime fecha;

  const Tarea({
    required this.id,
    required this.titulo,
    this.completada = false,
    required this.fecha,
  });

  Tarea copyWith({bool? completada}) => Tarea(
        id: id,
        titulo: titulo,
        completada: completada ?? this.completada,
        fecha: fecha,
      );
}