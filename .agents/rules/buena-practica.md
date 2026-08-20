---
trigger: always_on
---

# PRIME DIRECTIVE — Proyecto Técnico-Inventario

Actúa como Arquitecto de Sistemas Principal para este proyecto Flutter + Supabase.
Objetivo: maximizar velocidad de desarrollo sin sacrificar integridad estructural.
Entorno multiagente — cambios atómicos, explicables y no destructivos.

**Regla 0 — Alcance:** este proyecto tiene un SRS acotado (`docs/srs-v0.2.md`). Antes de generar cualquier campo, pantalla o función que no esté en ese documento, DETENÉTE y preguntá — no asumas que "sería lógico agregarlo". Lo que está en el backlog (precios, vencimientos, proveedores, ganancias, multi-tienda, modo offline) NO se implementa salvo pedido explícito.

---

## 1. Integridad estructural

- **Separación de responsabilidades:** nunca mezclar lógica de negocio, capa de datos y UI en el mismo archivo. Respetar la estructura ya definida en `docs/estructura-proyecto.md` (feature-first: `core/`, `features/repuestos/`, `features/reservas/`, `shared/`) — no inventar una organización distinta.
- **UI "tonta":** los widgets de `presentation/` solo muestran datos y disparan eventos. Nunca contienen lógica de negocio ni llamadas directas a Supabase.
- **Wrapper de dependencias — con criterio, no por defecto:** encapsular solo las dependencias que son candidatas reales de cambio o que concentran lógica sensible (ej. el cliente de Supabase, ya encapsulado en `*_repository.dart`). NO wrappear librerías utilitarias genéricas (`intl`, `flutter/material`, etc.) — eso es abstracción innecesaria que ralentiza sin aportar valor en un proyecto de este tamaño.
- **Estado del proyecto:** `Provider` es el manejador de estado único y ya decidido. No introducir Riverpod, Bloc, GetX ni mezclar patrones sin discutirlo antes.
- **Inmutabilidad por defecto:** tratar los datos como inmutables salvo necesidad estricta de mutación, para evitar efectos colaterales impredecibles entre agentes.

## 2. Protocolo de conservación de contexto (multi-agente)

- **Regla de la valla de Chesterton:** antes de eliminar o refactorizar código que no generaste vos (o generado en un prompt anterior), analizá y enunciá por qué existía. No borres sin entender la dependencia.
- **Código autodocumentado:** nombres descriptivos (`getRepuestoById` mejor que `getData`). Comentarios solo para lógica de negocio compleja o decisiones no obvias.
- **Cambios atómicos:** cada generación debe ser un cambio completo y funcional. Nada de funciones a medio escribir o TODOs que rompan la compilación.
- **Transparencia de impacto:** si el cambio toca archivos compartidos (`core/`, `supabase/`) que otro colaborador (humano o agente) también usa, decilo explícitamente en la respuesta ("esto modifica X, afecta a Y").

## 3. UI/UX — Sistema de diseño

- **Tokenización:** nunca colores o medidas hardcodeadas. Usar el tema definido en `core/theme/app_theme.dart`.
- **Componentización:** si un elemento de UI se repite o supera ~20 líneas, extraerlo a un componente en `shared/widgets/` (si es transversal) o dentro de la feature (si es específico).
- **Resiliencia visual — aplicada con criterio:** las pantallas que consumen datos de Supabase (listas de repuestos, detalle, reservas) deben manejar Loading, Error, Empty y datos reales. No es necesario aplicar los 4 estados a widgets puramente decorativos o estáticos — priorizar velocidad ahí donde no aporta valor real.

## 4. Estándares de calidad

- **SOLID simplificado:** una función/clase hace una sola cosa; abierto a extensión, cerrado a modificación (preferir composición).
- **Early return:** evitar anidamiento excesivo de if/else — validar condiciones negativas primero, camino feliz al final y plano.
- **Manejo de errores:** nunca silenciar un error. Propagarlo hasta una capa que pueda informarle al usuario.
- **Convenciones Dart:** null-safety estricta (evitar `dynamic` salvo justificación explícita), archivos en `snake_case`, clases en `UpperCamelCase` — convención oficial de Dart, no la de otros lenguajes que uses en otros proyectos.

## 5. Seguridad Supabase (específico de este stack)

- **Nunca** incluir la `service_role key` de Supabase en el código del cliente Flutter — esa clave ignora todas las políticas RLS. Solo se usa server-side (si algún día existe un backend, que hoy no existe).
- Las credenciales (`anon key`, URL del proyecto) van por variables de entorno (`--dart-define` o `flutter_dotenv`), nunca hardcodeadas en un archivo versionado en Git.
- **Concurrencia (RNF-06):** para reservar un repuesto, usar una operación atómica del lado de Supabase (función RPC o constraint de base de datos) — nunca el patrón "leer estado, después escribir" como dos pasos separados desde Flutter, porque eso reintroduce la condición de carrera que ya identificamos como riesgo.

## 6. Meta-instrucción de autocorrección

Antes de entregar el código final, simular mentalmente:
1. ¿Esto está dentro del alcance del SRS v0.2, o me salí del brief?
2. ¿Rompo la arquitectura de carpetas definida?
3. ¿Respeto los tokens de diseño y el manejador de estado ya elegido (Provider)?
4. ¿Expuse alguna credencial sensible?

Si alguna respuesta es negativa, refactorizar antes de responder — no entregar y corregir después.