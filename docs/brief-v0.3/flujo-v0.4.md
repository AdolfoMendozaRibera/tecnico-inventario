---
artefacto: Flujo v0.4
proyecto: Gestión de objetos reservados en inventario de taller técnico
materia: IHC
persona: Carlos (técnico)
tarea: Registrar e ingresar un nuevo repuesto al inventario del taller
complementa: Flujo v0.1 (consultar estado)
---

# Flujo v0.4 — Agregar un nuevo repuesto al inventario

## Camino principal

```
Tocar "+ Nuevo Repuesto" → Ingresar datos (Paso 1: Formulario) → Revisar en Preview (Paso 2: Vista previa) → Confirmar guardado → Ver confirmación e ítem destacado (Paso 3: Éxito)
```

## Detalle por paso

**Inicio**
¿Qué hace que Carlos entre a este flujo? → Llega un nuevo repuesto al taller o Carlos encuentra una pieza física que no está registrada en el sistema, y necesita darla de alta rápidamente para que todo el equipo sepa que está disponible.

**Acción**
¿Qué debe hacer en cada paso?
1. Desde la pantalla principal del inventario, tocar el botón **"+ Nuevo Repuesto"**.
2. **Paso 1: Formulario de Registro (`Paso 1/3`)**
   - Ingresar el **nombre del repuesto** (campo obligatorio, validación contra campos vacíos o muy cortos).
   - Seleccionar la **categoría** mediante chips interactivos de selección rápida (*Pantallas*, *Baterías*, *Cables*, *Memorias*, *Otros*).
   - Opcionalmente, agregar una **descripción** o notas técnicas adicionales (campo multilínea opcional).
   - Tocar **"Continuar a revisión"**.
3. **Paso 2: Revisar Repuesto / Vista Previa (`Paso 2/3`)**
   - El sistema presenta la tarjeta de vista previa fiel a cómo se verá el repuesto:
     - Etiqueta *"Vista Previa"*.
     - Nombre del repuesto centrado y destacado.
     - Píldoras de Categoría y Estado *"Disponible"*.
     - Descripción técnica (si fue ingresada).
   - El sistema informa que el repuesto ingresará inmediatamente como **Disponible**.
   - Si necesita corregir algo, tocar **"Volver a editar"** (conserva los campos intactos).
   - Si los datos son correctos, tocar **"Guardar en Inventario"**.
4. **Paso 3: Confirmación y Éxito (`Paso 3/3`)**
   - El sistema almacena atómicamente el repuesto en Supabase.
   - Ver el banner animado de confirmación: *"¡Repuesto ingresado!"*.
   - Ver la lista de repuestos disponibles donde la pieza recién ingresada aparece destacada con borde y etiqueta *"Nuevo"*.
   - Tocar **"Listo"** o **"Ver inventario completo"** para limpiar el estado y retornar a la vista principal del inventario.

**Resultado**
¿Cómo sabe que terminó? → El repuesto queda inmediatamente registrado en la base de datos de Supabase con estado `disponible`. Carlos ve la confirmación en pantalla con el ítem resaltado en la lista y cualquier técnico del taller ya puede consultarlo y reservarlo.

---

## Resultado esperado
Carlos puede dar de alta un componente en el inventario en menos de un minuto mediante un flujo guiado de 3 pasos con indicador visual de progreso (`_StepIndicator`). Se minimiza la posibilidad de registrar datos erróneos gracias al paso de revisión previa, asegurando que el catálogo del taller se mantenga actualizado.

## Relación con los otros flujos
- **Cierra el ciclo del Flujo v0.1:** Responde a la pregunta pendiente de *¿qué pasa si Carlos no encuentra el repuesto en la búsqueda?*, permitiéndole crearlo en el acto.
- **Habilita el Flujo v0.2:** Al registrarse como `disponible`, el nuevo repuesto queda inmediatamente listo para ser reservado para un equipo en reparación.

## Pregunta pendiente
¿Se requerirá en el futuro soporte para captura de código de barras / QR o foto del repuesto para agilizar el llenado de este formulario? (Funcionalidad identificada para futuras versiones del sistema).
