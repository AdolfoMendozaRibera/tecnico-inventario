---
trigger: always_on
---

# REGLAS Y ESTÁNDARES — LANDING PAGE DE DESCARGA DE APK (HTML + CSS + JS + Vercel)

**PRIME DIRECTIVE:** Actúa como Desarrollador Frontend Senior y Experto en Performance/SEO. Esta es una página estática simple (NO una SPA, NO necesita framework ni build step complejo) cuyo único objetivo es que un visitante entienda qué es la app en segundos y descargue el APK con confianza. Prioriza velocidad de carga y claridad sobre cualquier efecto visual.

---

## 1. ALCANCE (para no sobre-ingenierizar)
1. **Vanilla primero:** HTML + CSS + JS plano. Nada de React/Vue/frameworks de build para esto — es una página de 1-2 pantallas, un framework sería matar una mosca a cañonazos.
2. **JS mínimo e intencional:** Solo para interactividad puntual (contador de descargas, copiar hash, smooth scroll, toggle de FAQ). Si una sección no necesita JS, no lo lleva.
3. **Estructura de archivos plana:**
   ```
   /
   ├── index.html
   ├── /css/styles.css
   ├── /js/main.js
   ├── /assets/ (imágenes, ícono, capturas de pantalla)
   └── vercel.json (solo si necesitas headers custom)
   ```

---

## 2. UX/UI — "DESCARGAR EN 1 CLIC, ENTENDER EN 5 SEGUNDOS"
1. **CTA de descarga above the fold:** El botón de descarga principal debe verse sin scrollear, en desktop y mobile. Nada de obligar a bajar para encontrarlo.
2. **Información de confianza junto al botón:** versión actual, peso del APK (MB), fecha de última actualización, y requisito mínimo de Android (ej. "Android 8.0+"). El usuario no debería tener que adivinar si el archivo es reciente o pesado.
3. **Guía de instalación visible:** como no viene de Play Store, incluye un bloque corto y claro explicando cómo habilitar "orígenes desconocidos" — sin esto, buena parte de los usuarios se va a frustrar o va a abandonar.
4. **Mobile-first real:** la mayoría de quienes entren a bajar un APK lo harán desde el celular. Diseña primero para 375px de ancho, no adaptes desde desktop.
5. **Capturas de pantalla / demo:** un carrusel simple o grid de 3-4 screenshots reales de la app — nada de texto vendiendo funciones sin mostrarlas.
6. **Estado durante la descarga:** si el archivo pesa varios MB, da feedback (icono de descarga cambia, o mensaje "Descargando…") para que el usuario sepa que el clic funcionó.
7. **Nunca pedir datos personales** (email, teléfono) como condición para descargar, salvo que sea una decisión de negocio explícita — cada campo extra es una razón para que el usuario se vaya.

---

## 3. PERFORMANCE (acá Lighthouse sí es la vara real — a diferencia de tu Flutter debug web)
1. **Cero frameworks JS pesados.** Sin ellos, deberías estar por defecto en verde en Performance — no lo arruines con librerías innecesarias (jQuery, animaciones pesadas de terceros).
2. **Imágenes optimizadas:** capturas de pantalla y el ícono de la app en WebP, con `width`/`height` explícitos (evita Cumulative Layout Shift) y `loading="lazy"` en todo lo que esté fuera del primer viewport.
3. **Fuentes:** usa fuentes del sistema (`font-family: system-ui, -apple-system, sans-serif`) o, si necesitas una fuente custom, un solo peso vía `font-display: swap` — nunca cargues 4-5 pesos de Google Fonts para una landing de una página.
4. **CSS/JS minificados** antes del deploy (o usa un build mínimo en Vercel — `vercel.json` con un paso de minificación si lo prefieres automático).
5. **El APK no se sirve como asset de la página en el sentido de "cargar junto con el HTML"** — es un link de descarga (`<a href="..." download>`), no algo que se precargue ni se incluya en el bundle inicial.
6. **Meta de Core Web Vitals:** LCP < 2.5s, TBT < 200ms, CLS < 0.1 — con esta arquitectura son metas totalmente alcanzables, si no las cumples es señal real de algo mal (imagen sin optimizar, script bloqueante), no un artefacto de debug como en Flutter web.

---

## 4. SEO Y METADATA
1. `<title>` y `<meta name="description">` descriptivos y específicos (no "Inicio" ni "App").
2. Open Graph (`og:title`, `og:description`, `og:image`) para que el link se vea bien al compartirse en WhatsApp/redes — esto es clave si vas a difundir el link de descarga.
3. Favicon consistente con el ícono de la app.
4. `<html lang="es">` explícito (o el idioma que corresponda).
5. `robots.txt`/`sitemap.xml` solo si te interesa indexación en buscadores; si es una página privada de distribución interna, puedes incluso bloquear indexación con `<meta name="robots" content="noindex">`.

---

## 5. SEGURIDAD Y CONFIANZA (crítico para distribución de APK fuera de Play Store)
1. **HTTPS obligatorio** (Vercel lo da por defecto — no lo desactives).
2. **Publica el hash SHA-256 del APK** junto al botón de descarga, para que el usuario pueda verificar que el archivo no fue alterado. Es un detalle chico que genera mucha confianza en distribución sideload.
3. **Control de versión del archivo:** nombra el APK con versión explícita (`app-v1.2.0.apk`), no `app.apk` a secas sobreescrito en cada release — evita que un link compartido viejo apunte silenciosamente a una versión distinta.
4. **No alojes el APK en servicios que puedan cambiar de URL sin aviso** (Drive público, etc.) si depende de tu control — mejor en el propio repo/CDN de Vercel o en un storage propio con URL estable.
5. **Cache-Control apropiado:** el HTML de la landing puede cachearse corto (para que actualizaciones de contenido se vean rápido); el APK versionado puede cachearse agresivo (el nombre de archivo ya cambia por versión).

---

## 6. VERCEL — ESPECÍFICOS DE DEPLOYMENT
1. **Deploy estático simple:** sin `package.json`/build step si es HTML puro — Vercel sirve el directorio tal cual. Si agregas un mini build (minificación), sí necesitas `package.json` con el script de build.
2. **`vercel.json` solo si necesitas:**
   - Forzar descarga con headers (`Content-Disposition: attachment`) si el navegador intenta abrir el APK en vez de descargarlo.
   - Redirects/rewrites (ej. `/download` → apunta siempre al último APK sin cambiar el link público).
3. **Preview deployments:** usa las preview URLs de Vercel para revisar cada cambio antes de promover a producción — no edites directo en producción.
4. **Dominio propio (si aplica):** conecta un dominio custom en vez de depender solo del `*.vercel.app` por defecto, para que el link de descarga se vea profesional y estable en el tiempo.

---

## 7. CÓDIGO LIMPIO (VANILLA JS/CSS)
1. **Separación estricta:** sin `style=""` inline ni `<script>` inline salvo cosas triviales de una línea. CSS en su archivo, JS en el suyo.
2. **Nombres de clases consistentes** (BEM o similar simple: `.download-btn`, `.download-btn--loading`) — evita clases genéricas tipo `.box1`, `.div2`.
3. **JS defensivo mínimo:** si usas `fetch` para algo (ej. contador de descargas), maneja el error con un mensaje o fallback silencioso, nunca dejes una promesa sin `catch`.
4. **Sin dependencias que no necesitas.** Si la tentación es meter un framework "por si después crece", no — la regla YAGNI aplica más que nunca en una landing de una sola página.

---

## 8. CHECKLIST PRE-ENTREGA
- [ ] Botón de descarga visible sin scroll, en mobile y desktop.
- [ ] Versión, peso y fecha del APK visibles junto al botón.
- [ ] Guía corta de instalación (orígenes desconocidos) incluida.
- [ ] Capturas de pantalla reales de la app.
- [ ] Imágenes en WebP con lazy loading y dimensiones explícitas.
- [ ] Sin frameworks JS innecesarios; CSS/JS minificados.
- [ ] Meta tags Open Graph + favicon + `lang` configurado.
- [ ] Hash SHA-256 del APK publicado.
- [ ] APK versionado por nombre de archivo, no sobreescrito silenciosamente.
- [ ] HTTPS activo (por defecto en Vercel).
- [ ] Probado en una preview de Vercel antes de promover a producción.
- [ ] Lighthouse corrido sobre la página YA DESPLEGADA (no en local sin optimizar) — acá el resultado sí refleja la realidad.