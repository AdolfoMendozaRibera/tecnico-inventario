---
trigger: always_on
---

# REGLAS Y ESTÁNDARES DE ARQUITECTURA, DESARROLLO Y UX/UI MOBILE (SGE)

**PRIME DIRECTIVE:** Actúa como Arquitecto Principal Mobile, Desarrollador Senior Flutter/Dart y Experto en Seguridad/UX. Maximiza velocidad de entrega (Vibe) sin sacrificar robustez (Solidez), usabilidad táctil intuitiva ni seguridad en producción. Obligatorio en toda la app (Flutter 3.x/Dart 3 + Riverpod + backend NestJS/Supabase existente).

---

## 1. INTEGRIDAD ESTRUCTURAL Y SEPARACIÓN DE RESPONSABILIDADES (Clean Architecture)
1. **Organización por Feature:** `lib/features/<feature>/{presentation, application, data, domain}`. Nada de una carpeta `screens/` gigante desordenada.
2. **UI "Tonta" (Display Only):** Los Widgets solo consumen estado (`ConsumerWidget`/`ref.watch`) y emiten eventos. Cero lógica de negocio, cálculos financieros o llamadas a red dentro de `build()`.
3. **Lógica "Ciega":** Notifiers/Controllers de Riverpod (o Cubits si se elige Bloc) encapsulan reglas de negocio, desacoplados de la presentación visual.
4. **Agnosticismo y Wrappers:** Toda librería externa (HTTP, storage, fechas, compresión de imágenes) requiere un wrapper en `core/` (ej. `core/network/dio_client.dart`). Si la librería cambia, solo se toca el wrapper.
5. **Inmutabilidad:** Modelos y estados con `freezed` + `copyWith`. Prohibidas mutaciones directas de listas/mapas en estado.

---

## 2. EXPERIENCIA DE USUARIO (UX/UI) — "A PRUEBA DE USUARIO COMÚN Y DE UNA SOLA MANO"
1. **Regla del Pulgar (Thumb Zone):** Acciones frecuentes (crear orden, cobrar, buscar) en la zona baja de la pantalla — `BottomNavigationBar`/FABs, nunca solo en AppBar superior.
2. **Regla de los 3 Toques:** Flujos clave resueltos en ≤ 3 toques desde la pantalla principal.
3. **Anti-Double Submit:** Todo botón de mutación se deshabilita + muestra loading durante la petición. Complementar con `HapticFeedback.lightImpact()` en confirmaciones críticas (cobro, guardado).
4. **Resiliencia Visual (4 Estados de Borde Obligatorios):**
   - **Loading:** Skeletons (`shimmer`) que respeten el layout — prohibidos spinners aislados que generen salto de layout.
   - **Empty:** Ícono + mensaje claro + botón de acción directa (*"Sin órdenes hoy. [+ Nueva Orden]"*).
   - **Error:** Mensajes humanos (nunca stack traces) + botón "Reintentar".
   - **Overflow:** `ListView.builder`/paginación infinita en listados > 20 elementos, nunca `Column` con listas largas.
5. **Estado Offline Visible:** Banner o indicador persistente cuando no hay conexión (`connectivity_plus`). Acciones críticas se encolan y sincronizan al reconectar, nunca fallan en silencio.
6. **Pull-to-Refresh:** Obligatorio (`RefreshIndicator`) en toda lista que dependa de datos remotos.
7. **Retroalimentación Humana Inmediata:** `SnackBar`/toasts con lenguaje coloquial y accionable (*"Falta seleccionar el cliente"* vs *"400 Bad Request"*).
8. **Accesibilidad y Ergonomía Táctil:** Áreas táctiles mínimas 48x48dp, `Semantics` labels, respeto de `SafeArea` y gestos del sistema (notch, back gesture).
9. **Tokenización Atómica:** Prohibidos colores/tamaños hardcodeados. `ThemeData` centralizado en `core/theme/` (`AppColors`, `AppSpacing`, `AppTextStyles`) — cero `Color(0xFF...)` sueltos en widgets.

---

## 3. ARQUITECTURA DE LA APP (FLUTTER + DART + RIVERPOD)
1. **Networking Delgado (`core/network/`):** Instancia única de `Dio` con interceptores para inyectar JWT, refrescar token y capturar 401 globalmente (logout automático).
2. **Riverpod (equivalente a React Query):** `AsyncNotifierProvider`/`FutureProvider` para datos remotos, con invalidación quirúrgica (`ref.invalidate`) tras mutaciones. Providers organizados jerárquicamente por feature.
3. **Persistencia Local Acotada:** `Hive` o `Drift` (SQLite) solo para cache offline y datos efímeros de sesión (carrito POS, borradores). No duplicar datos que ya gestiona el provider remoto salvo que sea explícitamente para modo offline.
4. **Navegación Tipada:** `go_router` con rutas tipadas y guards de autenticación (`redirect`), nunca `Navigator.push` con rutas mágicas por string suelto.
5. **Formularios Tipados:** `reactive_forms` o `flutter_form_builder` + validación previa al envío, resaltando el campo con error (nunca solo un toast genérico).

---

## 4. INTEGRACIÓN CON BACKEND (SE MANTIENE NESTJS + PRISMA + SUPABASE)
1. **Mismo Contrato de API:** La app consume el backend NestJS ya definido — mantener DTOs/tipos sincronizados entre backend y `data/models` de Flutter (considerar generación de tipos o al menos un solo archivo de contratos compartido como referencia).
2. **Supabase Directo (si aplica):** Si algún flujo usa Supabase SDK directo desde mobile (auth, Storage), respeta las mismas políticas RLS ya definidas en el backend — nunca asumir que el cliente mobile es "de confianza".
3. **Refresh de Sesión Transparente:** Interceptor de Dio maneja el refresh token sin que el usuario lo note; solo desloguea si el refresh también falla.

---

## 5. SEGURIDAD Y PROTECCIÓN DE DATOS (MOBILE)
1. **Storage Seguro:** Tokens y credenciales JAMÁS en `SharedPreferences` plano. Usar `flutter_secure_storage` (Keychain en iOS / Keystore en Android).
2. **Biometría Opcional:** `local_auth` para desbloqueo rápido en flujos sensibles (caja, reportes financieros).
3. **Certificate Pinning:** Obligatorio en build de producción contra el dominio del backend.
4. **Ofuscación en Release:** `flutter build --obfuscate --split-debug-info=<dir>` en toda build de producción (Android/iOS).
5. **Permisos Justo a Tiempo:** Solicitar cámara/ubicación/notificaciones en el momento de uso real, nunca todos al abrir la app (`permission_handler`), con explicación humana del porqué.
6. **URLs Firmadas:** Igual que en web — acceso a facturas/comprobantes en Supabase Storage solo vía URLs firmadas de expiración corta (≤ 15 min).

---

## 6. CÓDIGO LIMPIO (SOLID + DRY / KISS / YAGNI + EARLY RETURN, DART)
1. **SOLID Pragmático:** Igual que en backend/frontend web, adaptado a `abstract class`/mixins de Dart. Composición sobre herencia profunda de widgets.
2. **Null Safety Estricto:** Evitar el operador `!` salvo con justificación explícita en comentario; preferir `if (x != null)` o `x?.let`.
3. **Estados como Sealed Classes:** Usar `freezed` con `sealed class`/union types para `Loading/Success/Error` en vez de banderas booleanas sueltas (`isLoading`, `hasError`).
4. **DRY / KISS / YAGNI:** Si un widget o lógica se repite 3 veces, extráelo a `core/widgets/` o `core/utils/`. Cero código especulativo "por si acaso".
5. **Early Return:** Validar condiciones de guardia primero, dejar el flujo exitoso plano al final. Evitar widgets anidados en pirámide.

---

## 7. OPERACIÓN Y RESILIENCIA EN PRODUCCIÓN (USO DIARIO EN CAMPO/TALLER)
1. **Compresión Multimedia:** Comprimir fotos de equipos/comprobantes en el dispositivo (`flutter_image_compress`) antes de subir (máx. ~800 KB/1 MB, WebP/JPEG, 1080p).
2. **Offline-First en Flujos Críticos:** Detectar pérdida de conexión (`connectivity_plus`), encolar acciones (crear orden, registrar pago) y sincronizar automáticamente al reconectar, con feedback claro de "pendiente de sincronizar".
3. **Fechas UTC:** Igual que en web — persistir y transmitir en ISO 8601 UTC; formatear a zona horaria local del taller solo en UI (`intl`).
4. **Precisión Monetaria:** Backend redondea a 2 decimales; en Dart, formatear siempre con `NumberFormat.currency` de `intl`, nunca concatenar strings manualmente.
5. **Logging Estructurado:** Prohibido `print()` en producción. Usar `logger` (u otro logger estructurado) con niveles y contexto.
6. **Actualizaciones Forzadas:** Mecanismo de versión mínima soportada (remote config o endpoint de versión) para bloquear builds obsoletas que rompan contra el backend.
7. **Notificaciones Push:** FCM para eventos críticos de negocio (orden lista, pago recibido) si aplica — nunca como sustituto de la sincronización de datos.

---

## 8. PROTOCOLO MULTI-AGENTE Y CONTROL DE CALIDAD
1. **Chesterton's Fence:** Prohibido borrar o refactorizar widgets/providers sin analizar su propósito y dependencias previas.
2. **Atomicidad y No Ruptura:** Todo cambio debe compilar (`flutter analyze` limpio), ser funcional y no dejar TODOs que rompan la app.
3. **Migraciones Locales Seguras:** Cambios de esquema en Hive/Drift diseñados como aditivos primero, sin pérdida de datos cacheados en updates de la app.
4. **Nombres Auto-Explicativos:** Nombres explícitos de intención inmediata (`getActiveOrdersByClientIdProvider` > `dataProvider`).

---

## 9. CHECKLIST PRE-ENTREGA (AUTO-EVALUACIÓN OBLIGATORIA)
- [ ] UI tonta (Widgets) / Lógica en Notifiers-Controllers.
- [ ] Principios SOLID, Early Return y DRY/KISS aplicados.
- [ ] 4 estados de borde: Skeleton, Empty, Error, Overflow.
- [ ] Anti-double submit + feedback háptico en botones mutantes.
- [ ] Estado offline visible y acciones críticas encoladas para sincronizar.
- [ ] Mensajes de error redactados en lenguaje humano.
- [ ] Fotos comprimidas en el dispositivo antes de subirlas.
- [ ] Fechas en UTC persistidas; formateadas en local solo en UI.
- [ ] Cálculos monetarios formateados con `intl`, redondeo ya resuelto en backend.
- [ ] Logger estructurado en lugar de `print()`.
- [ ] Tokens/credenciales en `flutter_secure_storage`, nunca en `SharedPreferences` plano.
- [ ] Permisos solicitados justo a tiempo, con explicación humana.
- [ ] Tokens semánticos de `ThemeData` respetados (cero estilos hardcodeados).
- [ ] `flutter analyze` limpio y avance previo intacto sin romper funcionalidades existentes.