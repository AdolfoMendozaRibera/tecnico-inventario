-- Flujo v0.4: Agrega el campo descripcion a la tabla repuesto
-- Este campo es opcional y permite al técnico registrar detalles adicionales
-- como compatibilidad, número de parte o notas de uso.

ALTER TABLE public.repuesto
  ADD COLUMN IF NOT EXISTS descripcion TEXT;
