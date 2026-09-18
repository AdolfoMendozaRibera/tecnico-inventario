class Repuesto {
  final String id;
  final String nombre;
  final String categoria;
  final String estado;
  final String tiendaId;

  /// Número de unidades del repuesto. Permite reservas y liberaciones parciales.
  /// DEFAULT 1 en BD — nunca puede ser negativo.
  final int cantidad;

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
    this.cantidad = 1,
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
      cantidad: (json['cantidad'] as int?) ?? 1,
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

  /// Obtiene la ubicación física parseada o el valor por defecto del taller
  String get parsedUbicacion {
    if (descripcion == null || descripcion!.isEmpty) {
      return 'Estantería A3 — Nivel 2';
    }
    for (final line in descripcion!.split('\n')) {
      if (line.toLowerCase().startsWith('ubicación:') || line.toLowerCase().startsWith('ubicacion:')) {
        final val = line.substring(line.indexOf(':') + 1).trim();
        if (val.isNotEmpty) return val;
      }
    }
    // Si no contiene formato clave-valor pero tiene texto, retornar la descripción
    if (!descripcion!.contains(':')) {
      return descripcion!;
    }
    return 'Estantería A3 — Nivel 2';
  }

  /// Obtiene el SKU parseado si existe en los metadatos
  String? get parsedSku {
    if (descripcion == null) return null;
    for (final line in descripcion!.split('\n')) {
      if (line.toUpperCase().startsWith('SKU:')) {
        final val = line.substring(4).trim();
        if (val.isNotEmpty) return val;
      }
    }
    return null;
  }

  /// Obtiene el estado de la pieza ('Nuevo' | 'Usado / Recupero')
  String get parsedEstadoPieza {
    if (descripcion == null) return 'Nuevo';
    for (final line in descripcion!.split('\n')) {
      if (line.toLowerCase().startsWith('estado de pieza:')) {
        final val = line.substring(line.indexOf(':') + 1).trim();
        if (val.isNotEmpty) return val;
      }
    }
    return 'Nuevo';
  }

  /// Obtiene las notas o compatibilidad si existen
  String? get parsedNotas {
    if (descripcion == null) return null;
    final buffer = StringBuffer();
    bool isCollectingNotes = false;
    for (final line in descripcion!.split('\n')) {
      if (line.toLowerCase().startsWith('notas:')) {
        isCollectingNotes = true;
        final val = line.substring(line.indexOf(':') + 1).trim();
        if (val.isNotEmpty) buffer.writeln(val);
      } else if (isCollectingNotes) {
        buffer.writeln(line);
      }
    }
    final res = buffer.toString().trim();
    return res.isNotEmpty ? res : null;
  }

  /// Copia con campos modificados, útil para actualizaciones locales de estado.
  Repuesto copyWith({
    String? id,
    String? nombre,
    String? categoria,
    String? estado,
    String? tiendaId,
    int? cantidad,
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
      cantidad: cantidad ?? this.cantidad,
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
