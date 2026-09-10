class Repuesto {
  final String id;
  final String nombre;
  final String categoria;
  final String estado;
  final String tiendaId;
  final String? descripcion;
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
    this.descripcion,
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
      descripcion: json['descripcion'] as String?,
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

  /// Copia con campos modificados, útil para actualizaciones locales de estado.
  Repuesto copyWith({
    String? id,
    String? nombre,
    String? categoria,
    String? estado,
    String? tiendaId,
    String? descripcion,
    String? equipoDestino,
    String? motivo,
    String? reservadoPor,
    String? reservadoPorNombre,
    DateTime? fechaReserva,
    DateTime? createdAt,
  }) {
    return Repuesto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      estado: estado ?? this.estado,
      tiendaId: tiendaId ?? this.tiendaId,
      descripcion: descripcion ?? this.descripcion,
      equipoDestino: equipoDestino ?? this.equipoDestino,
      motivo: motivo ?? this.motivo,
      reservadoPor: reservadoPor ?? this.reservadoPor,
      reservadoPorNombre: reservadoPorNombre ?? this.reservadoPorNombre,
      fechaReserva: fechaReserva ?? this.fechaReserva,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
