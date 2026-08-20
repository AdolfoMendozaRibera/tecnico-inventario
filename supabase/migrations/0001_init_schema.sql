-- =============================================================================
-- MIGRACIÓN 0001: Esquema Inicial de Tablas (SRS v0.2 - Sección 6)
-- Proyecto: Técnico-Inventario (IHC 2026)
-- =============================================================================

-- 1. Tabla: Tienda
CREATE TABLE IF NOT EXISTS tienda (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Tabla: Tecnico
CREATE TABLE IF NOT EXISTS tecnico (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL,
    tienda_id UUID NOT NULL REFERENCES tienda(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. Tabla: Repuesto
CREATE TABLE IF NOT EXISTS repuesto (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL,
    categoria TEXT NOT NULL,
    estado TEXT NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'reservado')),
    tienda_id UUID NOT NULL REFERENCES tienda(id) ON DELETE CASCADE,
    equipo_destino TEXT NULL,
    motivo TEXT NULL,
    reservado_por UUID NULL REFERENCES tecnico(id) ON DELETE SET NULL,
    fecha_reserva TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- =============================================================================
-- RLS (Row Level Security) - Habilitación + Políticas temporales de Lectura (Paso 3)
-- =============================================================================

ALTER TABLE tienda ENABLE ROW LEVEL SECURITY;
ALTER TABLE tecnico ENABLE ROW LEVEL SECURITY;
ALTER TABLE repuesto ENABLE ROW LEVEL SECURITY;

-- ⚠️ POLÍTICAS TEMPORALES DE SOLO LECTURA (SELECT) ⚠️
-- Motivo: Permitir que el cliente Flutter (Marco) pueda consultar datos durante
-- el desarrollo visual sin ser bloqueado por RLS.
-- Serán reemplazadas por políticas estrictas por taller/técnico antes del despliegue.

CREATE POLICY "Permitir lectura publica temporal en tienda"
    ON tienda FOR SELECT
    TO anon, authenticated
    USING (true);

CREATE POLICY "Permitir lectura publica temporal en tecnico"
    ON tecnico FOR SELECT
    TO anon, authenticated
    USING (true);

CREATE POLICY "Permitir lectura publica temporal en repuesto"
    ON repuesto FOR SELECT
    TO anon, authenticated
    USING (true);
