-- =============================================================================
-- MIGRACION 0002: Agregar estado 'usado' a tabla Repuesto (SRS v0.3 - Flujo 3)
-- Permite diferenciar entre devolver al taller ('disponible') y consumido ('usado')
-- =============================================================================

ALTER TABLE repuesto 
DROP CONSTRAINT IF EXISTS repuesto_estado_check;

ALTER TABLE repuesto 
ADD CONSTRAINT repuesto_estado_check 
CHECK (estado IN ('disponible', 'reservado', 'usado'));
