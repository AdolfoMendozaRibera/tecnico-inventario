class Repuesto {
  final String id;
  final String nombre;
  final String categoria;
  final String estado;
  final String tiendaId;
  final String? equipoDestino;
  final String? motivo;
  final String? reservadoPor;

  Repuesto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.estado,
    required this.tiendaId,
    this.equipoDestino,
    this.motivo,
    this.reservadoPor,
  });

  factory Repuesto.fromJson(Map<String, dynamic> json) {
    return Repuesto(
      id: json['id'],
      nombre: json['nombre'],
      categoria: json['categoria'],
      estado: json['estado'],
      tiendaId: json['tienda_id'],
      equipoDestino: json['equipo_destino'],
      motivo: json['motivo'],
      reservadoPor: json['reservado_por'],
    );
  }
}
