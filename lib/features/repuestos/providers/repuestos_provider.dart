import 'package:flutter/foundation.dart';

// features/repuestos/providers/repuestos_provider.dart
//
// Responsabilidad: estado de la feature repuestos para toda la app.
// Es el intermediario entre la UI y RepuestoRepository.
// La UI nunca accede al repositorio directamente — siempre via este provider.
//
// Estado a manejar:
//   - Lista de repuestos (filtrada/completa)
//   - Repuesto seleccionado (para detalle)
//   - Conteo disponibles/reservados (para InicioScreen — RF-08)
//   - Estado de carga / error

class RepuestosProvider extends ChangeNotifier {
  // TODO: Recibir RepuestoRepository via constructor

  // TODO: Implementar:
  //   - cargarRepuestos()        → llama a repository.listarRepuestos()
  //   - buscar(String query)     → RF-01
  //   - seleccionarRepuesto(id)  → RF-02, RF-03
  //   - iniciarRealtime()        → RNF-02
  //   - dispose() para cancelar suscripción Realtime
}
