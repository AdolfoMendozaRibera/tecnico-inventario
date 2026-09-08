class Repuesto {
  final String id;
  final String nombre;
  final String categoria;
  final String estado;
  final String tiendaId;
  final String? equipoDestino;
  final String? motivo;
  final String? reservadoPor;
  /// Nombre legible del técnico que realizó la reserva.
  /// Viene del JOIN con la tabla `tecnico` en el query del provider.
  final String? reservadoPorNombre;
  final DateTime? fechaReserva;
  final DateTime? createdAt;

  const Repuesto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.estado,
    required this.tiendaId,
    this.equipoDestino,
    this.motivo,
    this.reservadoPor,
    this.reservadoPorNombre,
    this.fechaReserva,
    this.createdAt,
  });

  factory Repuesto.fromJson(Map<String, dynamic> json) {
    // El JOIN devuelve el técnico como un mapa anidado: { "tecnico": { "nombre": "..." } }
    final tecnicoData = json['tecnico'];
    final nombreTecnico = tecnicoData is Map ? tecnicoData['nombre'] as String? : null;

    return Repuesto(
      id: json['id'],
      nombre: json['nombre'],
      categoria: json['categoria'],
      estado: json['estado'],
      tiendaId: json['tienda_id'],
      equipoDestino: json['equipo_destino'],
      motivo: json['motivo'],
      reservadoPor: json['reservado_por'],
      reservadoPorNombre: nombreTecnico,
      fechaReserva: json['fecha_reserva'] != null
          ? DateTime.tryParse(json['fecha_reserva'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}
