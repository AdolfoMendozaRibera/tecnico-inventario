---
title: "03. Formulario de Reserva, Stepper Interactivo y Pulso Háptico"
date: 2026-09-18
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - formulario
  - stepper
  - haptic-feedback
  - validacion
  - anti-double-submit
---

# 03. Formulario de Reserva, Stepper Interactivo y Pulso Háptico (`ReservarScreen`)

> **Archivo Analizado:** [`proyecto/lib/features/reservas/presentation/screens/reservar_screen.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/reservas/presentation/screens/reservar_screen.dart)  
> **Líneas Clave:** `36` a `52` (Lógica del Stepper), `62` a `116` (`_ejecutarReserva`), `320` a `435` (Widget de Stepper interactivo)

---

## 1. 🎯 Propósito General

`ReservarScreen` es la interfaz donde el técnico especifica el **Equipo de Destino** (obligatorio), el **Motivo/Orden de Trabajo** (opcional) y la **Cantidad requerida** (con límite mínimo de 1).

Garantiza integridad en los datos de entrada, previene errores de digitación de cantidades inválidas o ceros, evita envíos duplicados hacia el servidor mediante **Anti-Double Submit** y proporciona confirmación física táctil mediante el motor de vibración del dispositivo (**Feedback Háptico**).

---

## 2. ⚙️ Funciones y Componentes Clave

### A. Stepper / Contador Interactivo Híbrido
Permite dos modalidades de uso en una sola interfaz: toque rápido en botones `+` / `-` o digitación manual directa en el teclado numérico.

```dart
int get _currentCantidad => int.tryParse(_cantidadController.text.trim()) ?? 1;

void _incrementCantidad() {
  final current = int.tryParse(_cantidadController.text.trim()) ?? 0;
  final next = current + 1;
  _cantidadController.text = next.toString();
  setState(() {});
}

void _decrementCantidad() {
  final current = int.tryParse(_cantidadController.text.trim()) ?? 1;
  if (current > 1) {
    final next = current - 1;
    _cantidadController.text = next.toString();
    setState(() {});
  }
}
```

#### Formateadores en tiempo real (`inputFormatters`):
```dart
inputFormatters: [
  FilteringTextInputFormatter.digitsOnly, // Bloquea caracteres no numéricos
  TextInputFormatter.withFunction((oldValue, newValue) {
    if (newValue.text.isEmpty) return newValue;
    final n = int.tryParse(newValue.text);
    if (n == null || n < 1) return oldValue; // Impide escribir ceros o números < 1
    return newValue;
  }),
]
```

---

### B. Ejecución de la Reserva (`_ejecutarReserva`)
```dart
Future<void> _ejecutarReserva() async {
  final equipo = _equipoController.text.trim();
  if (equipo.isEmpty) {
    setState(() {
      _errorMessage = 'Debes ingresar el equipo de destino para completar la reserva.';
    });
    return;
  }

  final motivo = _motivoController.text.trim();
  final cantidadStr = _cantidadController.text.trim();
  final cantidadNum = int.tryParse(cantidadStr);
  if (cantidadNum == null || cantidadNum < 1) {
    setState(() {
      _errorMessage = 'La cantidad debe ser un número entero mayor o igual a 1.';
    });
    return;
  }
  final cantidad = cantidadNum.toString();

  setState(() {
    _isSubmitting = true;
    _errorMessage = null;
  });

  final provider = context.read<RepuestosProvider>();
  final exito = await provider.reservarRepuesto(
    widget.repuestoId,
    equipo,
    motivo,
  );

  if (!mounted) return;

  if (exito) {
    // Pulso háptico suave: confirma físicamente al técnico antes del cambio de pantalla
    HapticFeedback.lightImpact();

    final user = SupabaseService.client.auth.currentUser;
    final tecnicoNombre = user?.email?.split('@').first ?? 'Carlos';

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ReservaConfirmadaScreen(
          repuestoNombre: widget.repuestoNombre,
          equipoDestino: equipo,
          motivo: motivo.isNotEmpty ? motivo : null,
          cantidad: cantidad,
          tecnicoNombre: tecnicoNombre,
        ),
      ),
    );
  } else {
    setState(() {
      _errorMessage = provider.lastError ??
          'No se pudo completar la reserva. Revisa tu conexión e inténtalo de nuevo.';
      _isSubmitting = false;
    });
  }
}
```

---

## 3. 🎓 Preguntas de Examen (Defensa de Código)

### Pregunta 1: *"¿Por qué se usa `pushReplacement` en lugar de `push` al navegar a `ReservaConfirmadaScreen`?"*
> **Respuesta recomendada:**  
> *"Por ergonomía de navegación y prevención de duplicados en el historial de rutas. Si usáramos `push`, al presionar el botón 'Atrás' del sistema operativo Android o el gesto de retroceso en iOS, el técnico volvería al formulario con los datos viejos y podría volver a pulsar 'Confirmar Reserva'. `pushReplacement` destruye el formulario del stack de navegación y lo sustituye por el comprobante de éxito."*

### Pregunta 2: *"¿Qué papel cumple `HapticFeedback.lightImpact()` y qué estándar de la arquitectura de la app satisface?"*
> **Respuesta recomendada:**  
> *"Cumple con la sección 2.3 de nuestras Buenas Prácticas Móviles (Anti-Double Submit y Retroalimentación Táctil). En entornos de taller con ruido o distracciones, el pulso háptico del motor háptico del teléfono brinda certeza física inmediata al técnico de que su orden fue procesada con éxito antes de que los píxeles de la pantalla terminen de repintarse."*

### Pregunta 3: *"¿Cómo se implementó el Anti-Double Submit en el botón de confirmar?"*
> **Respuesta recomendada:**  
> *"El botón 'Confirmar Reserva' evalúa la bandera booleana `_isSubmitting`: mientras la llamada a red está en progreso, el callback `onPressed` se asigna a `null` (deshabilitando el botón) y se renderiza un `CircularProgressIndicator` animado. Esto impide peticiones duplicadas hacia el backend aunque el usuario presione varias veces rápidamente."*

---

## 4. 📱 Cómo demostrarlo en vivo en la pantalla

1. **Abrir el formulario:** Entrar a reservar cualquier repuesto disponible.
2. **Probar el Stepper:**
   - Presionar `+` para subir a 2, 3...
   - Presionar `-` hasta llegar a 1 y mostrar cómo el botón `-` se deshabilita visualmente impidiendo bajar a 0.
   - Tocar el número directamente y escribir `5`.
3. **Validación de campo vacío:** Dejar el campo "Equipo de Destino" vacío y pulsar "Confirmar Reserva" para mostrar el banner de advertencia reactivo.
4. **Confirmar:** Completar el equipo (ej: `Laptop Dell XPS 15`) y pulsar "Confirmar Reserva", apreciando la transición fluida y la vibración háptica.
