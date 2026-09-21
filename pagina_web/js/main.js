/**
 * VaultTecno — main.js
 * JS Vanilla mínimo e intencional (SRS §6 y §3.3)
 * Módulos: tema, menú, copiar credenciales, descarga feedback,
 *          barra flotante móvil, acordeones FAQ/técnico
 */

'use strict';

document.addEventListener('DOMContentLoaded', () => {
  initTheme();
  initMobileMenu();
  initCopyButtons();
  initDownloadFeedback();
  initFloatingBar();
  initAccordions();
});

/* ------------------------------------------------------------------
   1. TEMA CLARO / OSCURO
   ------------------------------------------------------------------ */
function initTheme() {
  const btn  = document.getElementById('theme-toggle');
  const root = document.documentElement;

  // Restaurar preferencia guardada
  const saved = getStoredTheme();
  if (saved) root.setAttribute('data-theme', saved);

  if (!btn) return;

  btn.addEventListener('click', () => {
    // Detectar tema activo actual
    const current = root.getAttribute('data-theme') ||
      (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    const next = current === 'dark' ? 'light' : 'dark';

    root.setAttribute('data-theme', next);
    setStoredTheme(next);
  });
}

function getStoredTheme() {
  try { return localStorage.getItem('vt-theme'); } catch { return null; }
}

function setStoredTheme(val) {
  try { localStorage.setItem('vt-theme', val); } catch { /* silencioso */ }
}

/* ------------------------------------------------------------------
   2. MENÚ MÓVIL HAMBURGUESA (accesible con ARIA)
   ------------------------------------------------------------------ */
function initMobileMenu() {
  const toggle = document.getElementById('menu-toggle');
  const nav    = document.getElementById('primary-nav');
  if (!toggle || !nav) return;

  toggle.addEventListener('click', () => {
    const open = toggle.getAttribute('aria-expanded') === 'true';
    toggle.setAttribute('aria-expanded', String(!open));
    nav.classList.toggle('nav--open', !open);
  });

  // Cerrar al hacer clic en cualquier enlace del menú
  nav.querySelectorAll('a[href]').forEach(link => {
    link.addEventListener('click', () => {
      toggle.setAttribute('aria-expanded', 'false');
      nav.classList.remove('nav--open');
    });
  });

  // Cerrar con Escape
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape' && nav.classList.contains('nav--open')) {
      toggle.setAttribute('aria-expanded', 'false');
      nav.classList.remove('nav--open');
      toggle.focus();
    }
  });
}

/* ------------------------------------------------------------------
   3. BOTONES DE COPIAR (Clipboard API + fallback execCommand)
   ------------------------------------------------------------------ */
function initCopyButtons() {
  // Selector unificado: cubre btn-copy y btn-inline-copy
  document.querySelectorAll('[data-copy-target]').forEach(btn => {
    btn.addEventListener('click', () => copyValue(btn));
  });
}

async function copyValue(btn) {
  const targetId = btn.getAttribute('data-copy-target');
  const target   = document.getElementById(targetId);
  if (!target) return;

  const text = (target.innerText || target.textContent).trim();
  const prevHTML = btn.innerHTML;

  try {
    if (navigator.clipboard && window.isSecureContext) {
      await navigator.clipboard.writeText(text);
    } else {
      // Fallback para entornos sin HTTPS (localhost)
      const ta = Object.assign(document.createElement('textarea'), {
        value: text,
        style: 'position:fixed;opacity:0;',
      });
      document.body.appendChild(ta);
      ta.focus();
      ta.select();
      document.execCommand('copy');
      document.body.removeChild(ta);
    }
    showCopiedFeedback(btn, prevHTML);
  } catch (err) {
    console.warn('[VaultTecno] No se pudo copiar al portapapeles:', err);
  }
}

function showCopiedFeedback(btn, prevHTML) {
  const isIconOnly = btn.classList.contains('btn-inline-copy');

  if (isIconOnly) {
    btn.classList.add('is-copied');
    setTimeout(() => btn.classList.remove('is-copied'), 2000);
    return;
  }

  // Botón con texto
  btn.classList.add('is-copied');
  btn.innerHTML = `
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
         stroke="currentColor" stroke-width="2.5" aria-hidden="true">
      <polyline points="20 6 9 17 4 12"/>
    </svg>
    ¡Copiado!
  `;
  btn.disabled = true;

  setTimeout(() => {
    btn.innerHTML = prevHTML;
    btn.classList.remove('is-copied');
    btn.disabled  = false;
  }, 2200);
}

/* ------------------------------------------------------------------
   4. FEEDBACK DE DESCARGA (toast)
   ------------------------------------------------------------------ */
function initDownloadFeedback() {
  const toast = document.getElementById('download-toast');
  if (!toast) return;

  document.querySelectorAll('.js-download-btn').forEach(btn => {
    btn.addEventListener('click', () => showToast(toast));
  });
}

function showToast(toast) {
  toast.classList.add('toast--visible');
  clearTimeout(toast._toastTimer);
  toast._toastTimer = setTimeout(() => {
    toast.classList.remove('toast--visible');
  }, 4000);
}

/* ------------------------------------------------------------------
   5. BARRA FLOTANTE MÓVIL (RF-14)
   Ocultar cuando el Hero o la sección #descargar están en viewport
   ------------------------------------------------------------------ */
function initFloatingBar() {
  const bar  = document.getElementById('mobile-floating-cta');
  const hero = document.getElementById('hero');
  const dl   = document.getElementById('descargar');
  if (!bar) return;

  if (!('IntersectionObserver' in window)) return;

  let isHeroVisible = true;
  let isDlVisible   = false;

  const updateBarVisibility = () => {
    if (isHeroVisible || isDlVisible) {
      bar.classList.add('mobile-bar--hidden');
    } else {
      bar.classList.remove('mobile-bar--hidden');
    }
  };

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.target === hero) {
        isHeroVisible = entry.isIntersecting;
      } else if (entry.target === dl) {
        isDlVisible = entry.isIntersecting;
      }
    });
    updateBarVisibility();
  }, { threshold: 0.15 });

  if (hero) observer.observe(hero);
  if (dl)   observer.observe(dl);
}

/* ------------------------------------------------------------------
   6. ACORDEONES FAQ + TÉCNICO (accesibles, aria-expanded / hidden)
   ------------------------------------------------------------------ */
function initAccordions() {
  document.querySelectorAll('.accordion__btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const open    = btn.getAttribute('aria-expanded') === 'true';
      const panelId = btn.getAttribute('aria-controls');
      const panel   = document.getElementById(panelId);
      if (!panel) return;

      btn.setAttribute('aria-expanded', String(!open));
      panel.hidden = open;
    });
  });
}
