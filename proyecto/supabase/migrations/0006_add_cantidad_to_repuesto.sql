-- Flujo v0.3 — Soporte de cantidades para gestión parcial de reservas
--
-- 1. Agregar columna cantidad a la tabla repuesto
--    DEFAULT 1 → todos los repuestos existentes parten con 1 unidad
--    CHECK (cantidad >= 0) → no puede haber stock negativo
ALTER TABLE public.repuesto
  ADD COLUMN IF NOT EXISTS cantidad INTEGER NOT NULL DEFAULT 1 CHECK (cantidad >= 0);

-- 2. Actualizar el CHECK de estado para incluir 'uso'
--    (el estado 'usado' es necesario para marcar repuestos consumidos)
ALTER TABLE public.repuesto
  DROP CONSTRAINT IF EXISTS repuesto_estado_check;

ALTER TABLE public.repuesto
  ADD CONSTRAINT repuesto_estado_check
    CHECK (estado IN ('disponible', 'reservado', 'usado'));
