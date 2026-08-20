import 'package:flutter/foundation.dart';

// features/reservas/providers/reservas_provider.dart
//
// Responsabilidad: estado de la feature reservas para toda la app.
// Es el intermediario entre la UI y ReservaRepository.
//
// Estado a manejar:
//   - Lista de reservas del técnico logueado (RF-06)
//   - Estado de la operación en curso: idle | loading | success | error
//
// Métodos a implementar:
//   - reservar(String repuestoId, String equipoDestino, String motivo)
//       → RF-04, RF-05
//       → Delega a ReservaRepository.reservarRepuesto() — la atomicidad es responsabilidad del repo/BD
//   - liberar(String repuestoId)    → RF-07
//   - marcarUsado(String repuestoId) → RF-07
//   - cargarMisReservas()           → RF-06

class ReservasProvider extends ChangeNotifier {
  // TODO: Recibir ReservaRepository via constructor

  // TODO: Implementar métodos listados arriba
}
