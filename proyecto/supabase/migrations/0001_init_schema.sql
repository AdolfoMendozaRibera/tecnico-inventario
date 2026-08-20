-- Tablas iniciales para la Gestión de Repuestos Reservados

CREATE TABLE public.tienda (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL
);

CREATE TABLE public.tecnico (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL,
    tienda_id UUID NOT NULL REFERENCES public.tienda(id) ON DELETE CASCADE
);

CREATE TABLE public.repuesto (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL,
    categoria TEXT NOT NULL,
    estado TEXT NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'reservado')),
    tienda_id UUID NOT NULL REFERENCES public.tienda(id) ON DELETE CASCADE,
    equipo_destino TEXT,
    motivo TEXT,
    reservado_por UUID REFERENCES public.tecnico(id) ON DELETE SET NULL,
    fecha_reserva TIMESTAMP WITH TIME ZONE
);
