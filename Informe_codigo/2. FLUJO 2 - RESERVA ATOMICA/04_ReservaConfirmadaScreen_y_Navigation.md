---
title: "04. Pantalla de Confirmación y Enrutamiento Reactivo con NavigationProvider"
date: 2026-09-18
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - confirmacion
  - enrutamiento
  - navigation-provider
  - figma-design
  - clean-architecture
---

# 04. Pantalla de Confirmación y Enrutamiento Reactivo (`ReservaConfirmadaScreen` & `NavigationProvider`)

> **Archivos Analizados:**  
> - [`proyecto/lib/features/reservas/presentation/screens/reserva_confirmada_screen.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/reservas/presentation/screens/reserva_confirmada_screen.dart) (Líneas 245–287)  
> - [`proyecto/lib/features/home/providers/navigation_provider.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/home/providers/navigation_provider.dart) (Líneas 1–20)

---

## 1. 🎯 Propósito General

Una vez que la mutación atómica en la base de datos concluye satisfactoriamente, el técnico necesita:
1. **Comprobante visual inmediato:** Un resumen claro de lo que acaba de reservar (Nombre de la pieza, Cantidad, Equipo Destino, Motivo y Técnico responsable), fiel al diseño de Figma (`Reserva Confirmada 1.png`).
2. **Caminos de salida claros (Call to Actions / CTAs):** 
   - *"Ver en Mis Reservas"* $\rightarrow$ Navega directo a la pestaña 2 del taller para gestionar o dar seguimiento a la pieza.
   - *"Volver al Inventario"* $\rightarrow$ Navega directo a la pestaña 1 para seguir buscando o apartando otras piezas.

Para lograr esto sin romper el historial de rutas ni dejar pantallas flotantes, se implementó `NavigationProvider` desacoplando el estado del `BottomNavigationBar` del ciclo de vida de los widgets individuales.

---

## 2. ⚙️ Funciones y Componentes Clave

### A. Provider Global de Navegación (`NavigationProvider`)
* **Ubicación:** `lib/features/home/providers/navigation_provider.dart`

```dart
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
```
* **Mapeo de pestañas:**
  - `0`: Inicio (Dashboard / Resumen del taller)
  - `1`: Repuestos (Inventario / Catálogo disponible y reservado)
  - `2`: Reservas (Mis Reservas activas)

---

### B. Botones de Acción y Limpieza de Pila (`popUntil`)
* **Ubicación:** `lib/features/reservas/presentation/screens/reserva_confirmada_screen.dart` (Líneas 245–287).

```dart
// Botón Primario: "Ver en Mis Reservas"
ElevatedButton(
  onPressed: () {
    // Cambia el tab activo a 'Mis Reservas' (tab 2) y regresa a la raíz
    context.read<NavigationProvider>().setTab(2);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      context.go('/', extra: {'tab': 2});
    }
  },
  child: Text('Ver en Mis Reservas'),
)

// Botón Secundario: "Volver al Inventario"
OutlinedButton(
  onPressed: () {
    // Cambia el tab activo al catálogo de 'Repuestos' (tab 1) y regresa a la raíz
    context.read<NavigationProvider>().setTab(1);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      context.go('/', extra: {'tab': 1});
    }
  },
  child: Text('Volver al Inventario'),
)
```

### 🔍 ¿Qué hace el código internamente?
1. **Mutación de Estado Global:** Invoca `context.read<NavigationProvider>().setTab(...)`. `MainScreen` está escuchando este provider con `context.watch<NavigationProvider>().currentIndex`, por lo que el `NavigationBar` y el body de la app cambian instantáneamente de pestaña en memoria.
2. **Remoción de Pantallas Imperativas (`popUntil`):** `Navigator.of(context).popUntil((route) => route.isFirst)` elimina de golpe la pantalla de confirmación y cualquier modal previo del stack de navegación de Flutter, dejando a la vista la pantalla raíz (`MainScreen`).
3. **Fallback Resiliente:** Si por alguna razón la pantalla se abrió vía deep-link aislado sin rutas previas en el navigator (`!canPop()`), utiliza `context.go('/', extra: ...)` garantizando que nunca falle la transición.

---

## 3. 🎓 Preguntas de Examen (Defensa de Código)

### Pregunta 1: *"¿Por qué `context.go('/')` por sí solo no funcionaba antes para salir de la pantalla de confirmación y cómo lo resolvieron?"*
> **Respuesta recomendada:**  
> *"Porque la pantalla de confirmación fue abierta mediante un `Navigator.push` imperativo encima de la ruta raíz `/` de GoRouter. Cuando se ejecutaba `context.go('/')`, GoRouter detectaba que ya se encontraba en la ruta `/` y no realizaba ninguna transición ni desmontaba las pantallas hijas del Navigator nativo. Lo resolvimos extrayendo el estado de la pestaña activa hacia un `NavigationProvider` y combinándolo con `Navigator.of(context).popUntil((route) => route.isFirst)`, lo cual garantiza que la pantalla modal se cierre físicamente y `MainScreen` pinte la pestaña correspondiente de forma reactiva."*

### Pregunta 2: *"¿Qué principio de Clean Architecture y SOLID se aplica al crear `NavigationProvider` en lugar de guardar el índice de pestaña en el estado local de `MainScreen`?"*
> **Respuesta recomendada:**  
> *"Aplica el principio de Responsabilidad Única (SRP) y UI Tonta / Lógica Ciega de nuestras reglas de arquitectura. La interfaz de `MainScreen` no debe ser la dueña absoluta de la decisión de enrutamiento interno. Al externalizar el control en `NavigationProvider`, cualquier pantalla del árbol de widgets (como la pantalla de confirmación o futuras notificaciones push) puede solicitar un cambio de pestaña sin acoplarse directamente a la implementación interna de `MainScreen`."*

---

## 4. 📱 Cómo demostrarlo en vivo en la pantalla

1. **Completar una reserva:** Tras confirmar, observar la pantalla de comprobante con el ícono de verificación verde, la cantidad, el equipo y el técnico.
2. **Probar botón "Ver en Mis Reservas":** Presionar el botón azul/oscuro principal $\rightarrow$ Verificar que la pantalla se cierra y la app se posiciona automáticamente en la pestaña **"Reservas"** (Tab 2) mostrando la tarjeta recién creada.
3. **Probar botón "Volver al Inventario":** Hacer otra reserva y presionar el botón secundario "Volver al Inventario" $\rightarrow$ Verificar que la pantalla se cierra y regresa al catálogo **"Repuestos"** (Tab 1).
