import '../../../core/constants/app_constants.dart';

/// Modelo de datos para la tabla `repuesto`.
///
/// Refleja la estructura definida en la sección 6 del SRS v0.2
/// y el esquema SQL `0001_init_schema.sql`.
class Repuesto {
  final String id;
  final String nombre;
  final String categoria;
  final String estado; // 'disponible' | 'reservado'
  final String tiendaId;
  final String? equipoDestino;
  final String? motivo;
  final String? reservadoPor;
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
    this.fechaReserva,
    this.createdAt,
  });

  /// Getters de conveniencia
  bool get esDisponible => estado == AppConstants.estadoDisponible;
  bool get esReservado => estado == AppConstants.estadoReservado;

  /// Construye un [Repuesto] a partir del JSON proveniente de Supabase.
  factory Repuesto.fromJson(Map<String, dynamic> json) {
    return Repuesto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      categoria: json['categoria'] as String,
      estado: json['estado'] as String? ?? AppConstants.estadoDisponible,
      tiendaId: json['tienda_id'] as String,
      equipoDestino: json['equipo_destino'] as String?,
      motivo: json['motivo'] as String?,
      reservadoPor: json['reservado_por'] as String?,
      fechaReserva: json['fecha_reserva'] != null
          ? DateTime.parse(json['fecha_reserva'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Convierte el [Repuesto] a JSON para enviar a Supabase.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'estado': estado,
      'tienda_id': tiendaId,
      'equipo_destino': equipoDestino,
      'motivo': motivo,
      'reservado_por': reservadoPor,
      'fecha_reserva': fechaReserva?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Permite crear una copia inmutable modificando solo los campos especificados.
  Repuesto copyWith({
    String? id,
    String? nombre,
    String? categoria,
    String? estado,
    String? tiendaId,
    String? equipoDestino,
    String? motivo,
    String? reservadoPor,
    DateTime? fechaReserva,
    DateTime? createdAt,
  }) {
    return Repuesto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      estado: estado ?? this.estado,
      tiendaId: tiendaId ?? this.tiendaId,
      equipoDestino: equipoDestino ?? this.equipoDestino,
      motivo: motivo ?? this.motivo,
      reservadoPor: reservadoPor ?? this.reservadoPor,
      fechaReserva: fechaReserva ?? this.fechaReserva,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
