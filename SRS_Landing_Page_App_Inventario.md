# SRS: Landing Page de Distribución de la App de Gestión e Inventario de Repuestos

| Campo | Valor |
|---|---|
| Versión del documento | 1.0 |
| Tipo de proyecto | Sitio web estático (landing page) |
| Contexto | Proyecto académico, exposición final. El docente actúa como cliente |
| Estado | Borrador para trabajar con IA. Los campos `[COMPLETAR]` los llena el autor |

---

## 0. Cómo usar este documento (instrucciones para la IA)

Este documento es la fuente de verdad para construir la página. Sigue estas reglas:

1. **Lee todo el documento antes de escribir código.**
2. **No inventes información.** Si un dato aparece como `[COMPLETAR]`, deja un marcador visible tipo `[COMPLETAR: nombre de la app]` en el HTML y avísame al final qué campos quedaron pendientes. Nunca rellenes con datos falsos (clientes, testimonios, cifras de usuarios, logos de empresas).
3. **Respeta la sección 9 (Restricciones de honestidad).** Es obligatoria.
4. **Entrega un solo proyecto estático**, sin frameworks ni paso de compilación (sección 6).
5. **Trabaja por etapas** (sección 12) y confirma conmigo al terminar cada una.
6. Cada requisito tiene un ID (por ejemplo `RF-03`). Al terminar, entrega una tabla que indique qué requisitos cumpliste y cuáles quedaron pendientes.
7. Si algo es ambiguo, elige la opción más simple, anótalo en una lista de "Decisiones tomadas" y sigue. No te detengas a preguntar por detalles menores.

---

## 1. Introducción

### 1.1 Propósito
Definir los requisitos de una landing page pública que presente la aplicación móvil de gestión e inventario de repuestos como si fuera un producto comercial, y que permita descargar el APK e iniciar una demo sin ayuda.

### 1.2 Alcance
La página **incluye**: presentación del producto, explicación de los 5 flujos, video demo, descarga del APK, guía de instalación, credenciales demo, resumen técnico y modelo de negocio propuesto.

La página **no incluye**: registro de usuarios, login, panel de administración, base de datos propia, pagos, formularios con backend ni analítica avanzada (ver sección 10).

### 1.3 Contexto del producto
La app es una herramienta **interna para empleados** (talleres o tiendas de repuestos). No tiene registro público: un administrador crea las cuentas y los empleados solo inician sesión. Esta decisión es de seguridad y de producto, y la página debe comunicarla como tal.

Los 5 flujos de la app:
1. Gestión de usuarios (el administrador crea, edita y desactiva empleados y asigna roles)
2. Exploración de inventario
3. Reserva de repuestos en tiempo real
4. Mis reservas
5. Administración de stock

### 1.4 Definiciones
| Término | Significado |
|---|---|
| APK | Archivo de instalación de una app Android |
| Landing page | Página de una sola vista con scroll, enfocada en una acción principal |
| CTA | Llamada a la acción (botón principal "Descargar APK") |
| Demo | Versión de la app conectada a una base de datos separada, con datos de ejemplo |

---

## 2. Usuarios y escenarios de uso

### 2.1 Perfiles
| Perfil | Descripción | Qué busca |
|---|---|---|
| **Cliente evaluador (principal)** | El docente, que actúa como dueño de un negocio de repuestos | Entender el valor del producto, ver que funciona, descargarlo y probarlo |
| **Compañeros de clase (secundario)** | Asisten a la exposición, no puntúan | Descargar y curiosear rápido |
| **Perfil técnico (terciario)** | El mismo docente al revisar decisiones técnicas | Confirmar stack, seguridad y arquitectura |

### 2.2 Escenario principal
El expositor termina su presentación y muestra un **código QR**. La persona lo escanea con el celular, la página abre en pocos segundos, entiende qué es la app, descarga el APK, lo instala siguiendo la guía, entra con una cuenta demo y explora la app **sin pedir ayuda a nadie**.

### 2.3 Principio de diseño
La página debe entenderse en **5 segundos** y ser utilizable por una persona sin conocimientos técnicos. El lenguaje se dirige a un **dueño de negocio**, no a un programador. Lo técnico va en un bloque secundario.

---

## 3. Requisitos funcionales

### 3.1 Estructura de secciones (orden obligatorio)

| ID | Sección | Prioridad |
|---|---|---|
| RF-01 | Barra de navegación | Alta |
| RF-02 | Hero | Alta |
| RF-03 | El problema | Alta |
| RF-04 | Cómo funciona (5 flujos) | Alta |
| RF-05 | Video demo | Alta |
| RF-06 | Descarga e instalación | **Crítica** |
| RF-07 | Credenciales demo | **Crítica** |
| RF-08 | Beneficios para el negocio | Media |
| RF-09 | Decisiones técnicas | Media |
| RF-10 | Modelo de negocio propuesto | Baja (opcional) |
| RF-11 | Preguntas frecuentes | Media |
| RF-12 | Footer | Alta |

### 3.2 Detalle por sección

#### RF-01 Barra de navegación
- Logo o nombre de la app a la izquierda y enlaces de ancla a: Cómo funciona, Descargar, Detalles técnicos.
- Botón "Descargar" siempre visible.
- En móvil, menú colapsable (hamburguesa) accesible con teclado.
- Barra fija al hacer scroll, con fondo sólido o translúcido legible.

#### RF-02 Hero
Debe caber en la primera pantalla sin hacer scroll (móvil y escritorio).
- Nombre de la app: `[COMPLETAR: nombre]`
- Titular de valor (máx. 12 palabras): `[COMPLETAR]`. Sugerencia base: *"Sabe qué repuestos tienes, al instante y sin llamadas"*
- Subtítulo (máx. 25 palabras) que diga para quién es y qué resuelve.
- **CTA principal:** botón grande "Descargar APK", con el tamaño del archivo al lado (`[COMPLETAR: X MB]`) y la versión (`v1.0`).
- CTA secundario: "Ver cómo funciona" (ancla a RF-04).
- Texto pequeño bajo el botón: "Solo Android · Versión demo".
- Una captura de la app dentro de un mockup de celular.

#### RF-03 El problema
- Título y 3 tarjetas cortas con ícono, una frase cada una. Ideas base (ajustar a la realidad de la app): reservas por llamada, stock desactualizado, viajes en vano por repuestos agotados.
- Lenguaje simple, sin jerga.

#### RF-04 Cómo funciona (los 5 flujos)
- 5 tarjetas o bloques alternados (imagen y texto).
- Cada uno lleva: número, título corto, una frase de beneficio, una captura de pantalla (`[COMPLETAR: imagen]`).
- Títulos sugeridos (ajustables):
  1. Gestión de usuarios: "Tú decides quién entra y con qué permisos"
  2. Exploración de inventario: "Encuentra cualquier repuesto en segundos"
  3. Reserva en tiempo real: "Reserva y todo el equipo lo ve al instante"
  4. Mis reservas: "Cada empleado controla lo que reservó"
  5. Administración de stock: "Stock siempre al día, con alertas visuales"
- Las imágenes deben usar carga diferida (`loading="lazy"`), excepto las del hero.

#### RF-05 Video demo
- Reproductor del video de pantalla dividida (Figma a un lado, app funcionando al otro).
- Preferido: archivo `.mp4` local con `controls`, `preload="metadata"` y un póster.
- Alternativa: incrustar un enlace de YouTube no listado (`[COMPLETAR: URL]`). Si se usa, respetar la política de seguridad de contenido y cargar el iframe de forma diferida.
- Debe entenderse sin sonido. Si hay subtítulos, incluirlos.
- Texto de apoyo de una línea con la duración del video.

#### RF-06 Descarga e instalación (sección crítica)
Debe permitir que alguien que **nunca instaló un APK** lo logre.
- Botón de descarga repetido (mismo estilo que el del hero) apuntando a `/downloads/[COMPLETAR: nombre-archivo].apk` con el atributo `download`.
- Datos junto al botón: versión, tamaño, requisito mínimo de Android `[COMPLETAR]`.
- **Guía numerada de 4 pasos**, cada uno con una captura o ilustración:
  1. Descargar el archivo
  2. Abrirlo desde las descargas del teléfono
  3. Permitir "Instalar aplicaciones de fuentes desconocidas" cuando Android lo pida
  4. Abrir la app e iniciar sesión con una cuenta demo
- **Aviso claro y tranquilizador** (caja destacada): Android puede mostrar una advertencia de seguridad porque la app se distribuye directamente y no por Play Store. Es un comportamiento normal para apps fuera de la tienda.
- Enlace de ayuda a la sección de preguntas frecuentes (RF-11).
- Bloque "¿No tienes Android?": indicar que por ahora solo hay versión Android.
- Opcional: código QR de la propia página para pasar la descarga a otro dispositivo.

#### RF-07 Credenciales demo
- Dos tarjetas: **Administrador** y **Empleado**.
- Cada una muestra: usuario, contraseña (`[COMPLETAR]`), una línea de qué puede hacer ese rol.
- **Botón "Copiar"** por cada dato, con confirmación visual ("¡Copiado!") y accesible por teclado.
- Aviso: "Cuenta de demostración con datos de ejemplo. Puedes probarla libremente."
- Texto que explique por qué no hay registro: *"El acceso es por invitación: en un negocio real, el administrador crea las cuentas de su equipo."*

#### RF-08 Beneficios para el negocio
- 3 a 4 beneficios formulados como resultado para el dueño (menos llamadas, menos pérdida de ventas, control por roles, información al instante).
- No usar cifras inventadas. Si se incluyen números, deben ser `[COMPLETAR]` y demostrables, o no incluirse.

#### RF-09 Decisiones técnicas
- Bloque **desplegable** (acordeón accesible) para no estorbar al usuario común.
- Contenido: tecnología de la app `[COMPLETAR]`, backend `[COMPLETAR]`, cómo funciona el tiempo real `[COMPLETAR]`, control de acceso por roles, por qué el acceso es por invitación, estrategia de distribución por APK.
- Explicación breve y clara de las diferencias entre prototipo en Figma y app final (manejo de errores, alertas, validaciones): `[COMPLETAR]`.
- Lenguaje claro, con una frase de "por qué" por cada decisión.

#### RF-10 Modelo de negocio propuesto (opcional)
- 2 o 3 tarjetas de planes (por ejemplo por número de empleados o de repuestos), con nombres y límites `[COMPLETAR]`.
- **Debe rotularse explícitamente** como "Modelo de negocio propuesto (ejercicio académico)".
- El botón de cada plan **no debe simular una compra**. Puede llevar a la sección de descarga (RF-06) con el texto "Probar la demo".
- Si se decide no incluirla, omitir la sección completa sin dejar huecos en la navegación.

#### RF-11 Preguntas frecuentes
Acordeón con al menos estas preguntas (respuestas cortas):
- ¿Por qué Android me muestra una advertencia al instalar?
- ¿Es segura la app?
- ¿Por qué no puedo registrarme?
- ¿Funciona en iPhone?
- ¿Los datos de la demo son reales?
- ¿Por qué no está en Play Store?
  - Respuesta base: *"Optamos por distribución directa por APK porque publicar en Play Store implica costos y tiempos de revisión que no aportaban a validar el producto en esta etapa."*

#### RF-12 Footer
- Nombre de la app, texto "Versión demo · Proyecto académico".
- Contacto del autor `[COMPLETAR: correo]`, año y créditos mínimos.
- Sin enlaces a redes sociales o páginas que no existan.

### 3.3 Comportamiento transversal
| ID | Requisito |
|---|---|
| RF-13 | Navegación por anclas con scroll suave, respetando `prefers-reduced-motion` |
| RF-14 | Botón de descarga **fijo en la parte inferior en móvil** (barra "Descargar APK"), que se oculta cuando la sección RF-06 está en pantalla |
| RF-15 | Botones "Copiar" funcionan con la API del portapapeles y tienen una alternativa (seleccionar texto) si falla |
| RF-16 | Modo claro y oscuro automáticos según el sistema, con interruptor manual opcional |
| RF-17 | Si el archivo del APK no está disponible, la página sigue funcionando y no muestra errores rotos |

---

## 4. Requisitos de diseño y UX

### 4.1 Principios
1. **Mobile-first.** Se diseña primero para 360 px de ancho y luego se amplía.
2. **Una acción principal**: la descarga. Ningún elemento debe competir visualmente con ella.
3. **Mostrar más que explicar**: capturas y video antes que párrafos.
4. **Texto corto**: párrafos de máximo 3 líneas en móvil.
5. **Guiar paso a paso** en la instalación.

### 4.2 Estilo visual
- Apariencia de **producto SaaS comercial**: limpio, con mucho espacio en blanco, jerarquía tipográfica clara y una sola paleta coherente.
- Paleta: un color primario de marca `[COMPLETAR: hex, o tomar el de la app]`, un color de acento, neutros y colores semánticos para estados de stock (verde: disponible, ámbar: stock bajo, rojo: agotado), coherentes con la app.
- Definir colores, radios, sombras y espaciados como **variables CSS** en `:root`.
- Tipografía: una fuente legible (Google Fonts permitido, con pila de respaldo). Tamaño base ≥ 16 px.
- Los mockups de celular deben usar las capturas reales de la app (`[COMPLETAR]`).
- Íconos en SVG en línea (sin librerías externas de íconos).
- Evitar el aspecto de plantilla genérica: cuidar el titular, el espaciado y el contraste.

### 4.3 Botones y toques
- Área táctil mínima de 48 × 48 px.
- El CTA principal tiene el mayor peso visual de toda la página.
- Estados visibles: hover, foco, activo y deshabilitado.

### 4.4 Feedback
- Confirmación visual al copiar credenciales.
- Indicador claro cuando se inicia la descarga ("Descargando… revisa tus notificaciones").

---

## 5. Requisitos no funcionales

| ID | Categoría | Requisito |
|---|---|---|
| RNF-01 | Rendimiento | La primera pantalla carga en menos de 3 s en 4G. Puntuación Lighthouse móvil ≥ 90 en rendimiento |
| RNF-02 | Peso | Página sin contar APK ni video < 2 MB. Imágenes en WebP o AVIF, con dimensiones adecuadas |
| RNF-03 | Accesibilidad | Cumplir WCAG 2.1 AA: contraste mínimo 4.5:1, navegación por teclado, `alt` en imágenes, etiquetas ARIA en acordeones y menú, orden de foco lógico |
| RNF-04 | Responsive | Sin scroll horizontal entre 320 px y 1920 px |
| RNF-05 | Compatibilidad | Chrome, Edge, Firefox y Safari en sus versiones recientes. Chrome en Android como prioridad |
| RNF-06 | SEO básico | `<title>`, `meta description`, Open Graph (título, descripción, imagen para vista previa al compartir el enlace), `lang="es"` |
| RNF-07 | Seguridad | Sin claves, tokens ni URLs de backend privados en el código de la página. HTTPS (lo aporta el hosting) |
| RNF-08 | Mantenibilidad | Código comentado en secciones, sin duplicación innecesaria, todo el texto editable fácilmente |
| RNF-09 | Idioma | Español neutro, sin errores ortográficos |

---

## 6. Restricciones técnicas

- **Tecnología:** HTML5, CSS3 y JavaScript vanilla. **Sin frameworks, sin TypeScript, sin paso de compilación, sin dependencias npm.**
- **Sin base de datos ni backend.** La página es 100 % estática.
- Se permiten únicamente como recursos externos: Google Fonts (si se usa). Todo lo demás debe ir local.
- JavaScript solo para: menú móvil, acordeones, botón copiar, barra de descarga fija, tema claro/oscuro y scroll suave.
- No usar `localStorage` para nada crítico. Si se guarda la preferencia de tema, envolver el acceso en `try/catch`.

### 6.1 Estructura de archivos esperada

```
/
├── index.html
├── css/
│   └── styles.css
├── js/
│   └── main.js
├── assets/
│   ├── img/            # capturas, mockups, íconos (WebP/SVG)
│   ├── video/          # demo.mp4 y póster (si se aloja localmente)
│   └── favicon.svg
├── downloads/
│   └── inventario-v1.0.apk    # [COMPLETAR: nombre real, sin espacios]
├── vercel.json         # opcional, cabeceras del APK
└── README.md           # cómo editar y desplegar
```

---

## 7. Despliegue

- **Hosting:** Vercel (repositorio en GitHub, despliegue automático). Sin configuración de build; el directorio raíz se publica tal cual.
- El APK pesa menos de 100 MB, por lo que se sirve desde `/downloads/`.
- Si el navegador no descarga el APK correctamente, agregar en `vercel.json` las cabeceras:
  - `Content-Type: application/vnd.android.package-archive`
  - `Content-Disposition: attachment`
- Entregar un `README.md` con: cómo reemplazar textos e imágenes, cómo actualizar el APK y cómo desplegar en Vercel paso a paso.
- Generar (o indicar cómo generar) un **código QR** que apunte a la URL final para la última diapositiva.

---

## 8. Contenido pendiente por completar (checklist del autor)

| Campo | Estado |
|---|---|
| Nombre de la app | `[COMPLETAR]` |
| Propuesta de valor en una frase | `[COMPLETAR]` |
| Logo / ícono | `[COMPLETAR]` |
| Color primario | `[COMPLETAR]` |
| Capturas de los 5 flujos | `[COMPLETAR]` |
| Video demo (archivo o URL) | `[COMPLETAR]` |
| Nombre del APK, versión y peso | `[COMPLETAR]` |
| Versión mínima de Android | `[COMPLETAR]` |
| Credenciales demo (admin y empleado) | `[COMPLETAR]` |
| Stack técnico y backend | `[COMPLETAR]` |
| Textos de decisiones técnicas | `[COMPLETAR]` |
| Planes del modelo de negocio (si se incluye) | `[COMPLETAR]` |
| Correo de contacto | `[COMPLETAR]` |

---

## 9. Restricciones de honestidad (obligatorias)

La página debe poder defenderse por completo ante el docente. Por eso:

1. **Prohibido** escribir "Disponible en Google Play", "Próximamente en Google Play" o mostrar insignias de tiendas.
2. **Prohibido** inventar testimonios, reseñas, logos de empresas, contadores de usuarios o métricas.
3. **Prohibido** incluir un roadmap con fechas o promesas. Si se desea una sección de futuro, se llamará "Posibles evoluciones", sin fechas, con máximo 3 ideas (ejemplo: notificaciones push, reportes de stock, versión iOS).
4. Los planes de precios deben estar rotulados como **propuesta** y no simular pagos.
5. El footer debe decir **"Versión demo · Proyecto académico"**.
6. Toda afirmación técnica debe ser cierta respecto a la app real. Si no está en la sección 8 completada, no se afirma.

---

## 10. Fuera de alcance

- Registro o login de usuarios en la página.
- Formularios con envío de correo o backend.
- Pasarela de pagos o facturación.
- Panel de administración.
- Analítica, cookies o banners de consentimiento.
- Versión iOS o publicación en tiendas.
- Blog, multiidioma o CMS.

---

## 11. Criterios de aceptación

La página se considera terminada cuando se cumple **todo** lo siguiente:

- [ ] Una persona sin conocimientos técnicos entiende qué es la app en 5 segundos (probado con al menos 1 persona).
- [ ] Desde un celular Android distinto al del autor, con datos móviles, se puede: abrir el QR → descargar → instalar → iniciar sesión con la cuenta demo, **sin ayuda**.
- [ ] El botón de descarga entrega el APK correcto y el nombre del archivo es claro.
- [ ] Las 12 secciones están presentes en el orden indicado (o la RF-10 omitida limpiamente).
- [ ] No hay `[COMPLETAR]` visibles en la versión final.
- [ ] Sin scroll horizontal de 320 px a 1920 px.
- [ ] Modo claro y oscuro funcionan y ambos tienen contraste correcto.
- [ ] Lighthouse móvil: rendimiento ≥ 90, accesibilidad ≥ 90.
- [ ] Todos los elementos interactivos son operables con teclado.
- [ ] No existe ninguna afirmación prohibida por la sección 9.
- [ ] La vista previa al compartir el enlace (Open Graph) muestra título, descripción e imagen.
- [ ] El `README.md` permite a otra persona editar y desplegar la página.

---

## 12. Plan de trabajo sugerido (etapas para la IA)

| Etapa | Entregable                                                                                           | Confirmación |
| ----- | ---------------------------------------------------------------------------------------------------- | ------------ |
| 1     | Estructura de archivos, variables CSS, tipografía y esqueleto HTML semántico con todas las secciones | Sí           |
| 2     | Hero, barra de navegación, problema y beneficios, con diseño móvil completo                          | Sí           |
| 3     | Cómo funciona (5 flujos) y video demo                                                                | Sí           |
| 4     | Descarga e instalación, credenciales demo y botón copiar, barra fija móvil                           | Sí           |
| 5     | Decisiones técnicas, modelo de negocio, FAQ y footer                                                 | Sí           |
| 6     | Modo claro/oscuro, accesibilidad, optimización, SEO y Open Graph                                     | Sí           |
| 7     | `README.md`, `vercel.json`, lista de campos pendientes y tabla de cumplimiento de requisitos         | Final        |

---

## 13. Riesgos y mitigaciones

| Riesgo | Mitigación |
|---|---|
| El usuario abandona por la advertencia de Android | Aviso tranquilizador en RF-06 y respuesta en el FAQ |
| El APK se descarga con nombre o formato incorrecto | Cabeceras en `vercel.json` y prueba en dos dispositivos |
| Alguien altera datos de la demo | Base de datos demo separada, con datos restaurables y rol con permisos limitados |
| La página no abre en la exposición por falta de internet | Llevar el QR, un respaldo del video local y el APK en el teléfono del expositor |
| Preguntas técnicas sin respuesta | Sección RF-09 completa y solo con afirmaciones verificadas |

---

## 14. Entregables finales

1. Carpeta del proyecto completa según la sección 6.1.
2. `README.md` de edición y despliegue.
3. Lista de campos `[COMPLETAR]` pendientes.
4. Lista de "Decisiones tomadas" por la IA.
5. Tabla de cumplimiento de requisitos (`RF-xx` y `RNF-xx`).
