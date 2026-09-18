---
title: "Defensa de Código: RepuestosListScreen (Interfaz de Consulta y Búsqueda)"
date: 2026-09-17
author: Preparación de Examen / Defensa
tags:
  - defensa-codigo
  - ui
  - flutter
  - tabs
  - debounce
  - flujo-1
---

# `RepuestosListScreen` — Pantalla Principal del Inventario

> **Ubicación del Archivo:** [`proyecto/lib/features/repuestos/presentation/screens/repuestos_list_screen.dart`](file:///e:/desarrollador/Interaccion-computador/Tecnico-inventario/proyecto/lib/features/repuestos/presentation/screens/repuestos_list_screen.dart)

---

## 1. Propósito General: ¿Qué problema resuelve y por qué es esencial?

Es la **pantalla central** del Flujo 1. Su objetivo es brindar una experiencia fluida e instantánea para explorar y buscar repuestos en el taller sin bloqueos visuales (*jank*).

Sin este archivo:
- No habría una interfaz organizada por pestañas para separar lo que está disponible para uso inmediato de lo que ya está apartado para reparaciones en curso.
- Las búsquedas serían pesadas y lentas al escribir cada letra.
- El usuario vería pantallas en blanco o spinners que saltan bruscamente al cargar o fallar.

`RepuestosListScreen` orquesta la navegación por pestañas (`Disponibles` y `Reservados`), el filtrado instantáneo con **debounce de 220ms** y el intercambio limpio entre los **4 estados de borde** (Loading con Skeletons, Error con Reintentar, Empty State contextual y Listado Virtualizado).

---

## 2. Funciones y Métodos Clave (Para señalar en pantalla)

### 🔹 Conmutación Reactiva de Estados de Borde (Líneas 91-113)
- **Dónde señalar:** El `body` dentro del `Consumer<RepuestosProvider>`.
- **Qué hace:** Evalúa de forma declarativa qué debe ver el usuario:
  1. Si `provider.isLoading == true`: Renderiza una lista de 5 `RepuestoSkeletonCard` animados con efecto Shimmer.
  2. Si `provider.lastError != null`: Muestra el banner `InventarioErrorState` con el botón para invocar `fetchRepuestos()`.
  3. Si todo está correcto: Carga el `TabBarView` con las dos listas correspondientes.

### 🔹 Búsqueda con Debounce de 220ms: `_onSearchChanged()` (Líneas 144-157)
- **Dónde señalar:** Método en `_ListaDisponiblesState`.
- **Qué hace:**
  - Cancela cualquier temporizador activo previo (`_debounceTimer?.cancel()`).
  - Activa la bandera `_isDebouncing = true` para mostrar un spinner diminuto en el input y skeletons momentáneos.
  - Inicia un timer de 220 ms. Solo cuando el usuario deja de teclear por 220ms, actualiza `_searchQuery` y ejecuta el filtro en memoria.

### 🔹 Filtrado Inmutable en Memoria (Líneas 160-166)
- **Dónde señalar:** Inicio del método `build` de `_ListaDisponibles`.
- **Qué hace:**
  - Si `_searchQuery.isEmpty`, retorna la lista completa sin mutarla.
  - Si hay texto, filtra por coincidencia insensible a mayúsculas/minúsculas tanto en el **nombre** como en la **categoría** del repuesto (`nombre.contains(query) || categoria.contains(query)`).

### 🔹 Manejo del Estado Vacío Guiado (Líneas 255-276)
- **Dónde señalar:** Condición `filtered.isEmpty` en `_ListaDisponibles`.
- **Qué hace:**
  - Si el usuario escribió un texto que no existe: Muestra `RepuestoEmptyState` con un botón de acción directa *"Registrar este Repuesto"*, pre-cargando el nombre buscado.
  - Si el taller está vacío (sin repuestos): Muestra `TallerVacioState` con el botón *"Agregar primer repuesto"*.

### 🔹 Lista Virtualizada con Pull-to-Refresh (Líneas 281-303)
- **Dónde señalar:** Bloque `RefreshIndicator` + `ListView.builder`.
- **Qué hace:** Permite arrastrar la pantalla hacia abajo para refrescar los datos desde Supabase y renderiza las tarjetas de forma perezosa (*lazy loading*).

---

## 3. Preguntas de Examen (Defensa de Código en Vivo)

### ❓ Pregunta 1 del Docente:
> *“¿Qué es un Debounce, en qué línea de este archivo está implementado y por qué es importante para el rendimiento de la aplicación?”*

📍 **Qué señalar en pantalla:**
Ve a las **Líneas 144 a 157 (`_onSearchChanged`)**:
```dart
_debounceTimer = Timer(const Duration(milliseconds: 220), () {
  if (!mounted) return;
  setState(() {
    _searchQuery = val.trim();
    _isDebouncing = false;
  });
});
```
🗣️ **Qué responder textualmente:**
> *"El Debounce es un patrón de optimización que retrasa la ejecución de una acción costosa hasta que el usuario termina de escribir. Aquí en la línea 150 usamos un `Timer` de 220 milisegundos. Si el usuario escribe rápido 'PANTALLA', no ejecutamos 8 filtros sucesivos en cada letra, sino uno solo al finalizar la palabra. Esto ahorra ciclos de CPU, evita micro-congelamientos de la pantalla (*jank*) y mantiene los 60 FPS estables."*

---

### ❓ Pregunta 2 del Docente:
> *“¿Por qué es fundamental cancelar los timers y controllers en el método `dispose()`?”*

📍 **Qué señalar en pantalla:**
Ve a las **Líneas 137 a 142 (`dispose`)**:
```dart
@override
void dispose() {
  _debounceTimer?.cancel();
  _searchController.dispose();
  super.dispose();
}
```
🗣️ **Qué responder textualmente:**
> *"Si el usuario sale de esta pantalla mientras el timer de 220ms o el `TextEditingController` siguen activos, estos objetos quedarían retenidos en memoria sin poder ser recolectados por el Garbage Collector de Dart, generando una fuga de memoria (*Memory Leak*). En `dispose()` cancelamos explícitamente el timer y liberamos el controlador para garantizar un ciclo de vida limpio."*

---

### ❓ Pregunta 3 del Docente:
> *“¿Por qué utilizas `ListView.builder` en lugar de un `SingleChildScrollView` con un `Column`?”*

📍 **Qué señalar en pantalla:**
Ve a las **Líneas 284 a 302 (`ListView.builder`)**.
🗣️ **Qué responder textualmente:**
> *"`ListView.builder` implementa virtualización de elementos (renderizado perezoso o *lazy rendering*). Solo crea y mantiene en memoria los widgets de las tarjetas que actualmente son visibles en la pantalla. Si el inventario del taller creciera a 500 repuestos, un `Column` intentaría renderizar los 500 a la vez colapsando la RAM del móvil; `ListView.builder` mantiene el consumo de memoria constante sin importar cuántos repuestos existan."*
