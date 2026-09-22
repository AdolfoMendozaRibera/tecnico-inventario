# Reporte de Mejora Visual (Jerarquía, Layout y Espaciado)

**Pantallas evaluadas:** Inicio y Mis Reservas

## Antes
En la versión inicial, la información carecía de una estructura clara. Los textos tenían tamaños muy similares y no había un margen o espaciado consistente. Esto hacía que, al ver la pantalla de "Mis Reservas", fuera difícil distinguir rápidamente qué repuesto estaba reservado, para qué cliente, y cuál era el botón exacto para liberar o marcar como usado, aumentando la carga cognitiva del técnico.

## Cambio
Se aplicó un sistema de diseño utilizando una escala base de **8px** (con paddings de 8, 16, 24 y 32 px) tanto en el wireframe de Figma como en el código de Flutter (`inicio_screen.dart` y `mis_reservas_screen.dart`). 
- **Jerarquía:** Se aumentó el tamaño y peso de la tipografía para el nombre del repuesto (lo más importante) y los títulos de pantalla. 
- **Layout:** Se agrupó la información de cada reserva en tarjetas individuales (Cards) con bordes ligeros, separando claramente la información descriptiva (motivo, equipo) de las acciones (botones de "Liberar / Marcar Usado") por 24px. Además, se añadió una etiqueta naranja para resaltar el estado de reserva "Activa".

## Después
Para comprobar el cambio, le pedí a un compañero que usara la pantalla de "Mis Reservas" y le di la instrucción: *"Encuentra la pantalla de Samsung y libérala"*. Sin explicarle cómo funcionaba la interfaz, logró completar la tarea en menos de 3 segundos. Comentó que fue fácil porque "la caja de la reserva estaba separada y el botón se veía directo abajo". No buscó en lugares equivocados ni se confundió con el resto del texto.

## Siguiente
La prueba fue exitosa, por lo que **conservaremos** el uso de las tarjetas (Cards) con separación interior de 16px y el sistema de espaciado basado en 8px. Como siguiente paso, investigaremos cómo aplicar esta misma jerarquía visual a la lista general de repuestos para que los estados ("Disponible" vs "Agotado") sean igual de fáciles de reconocer con un simple escaneo visual.
