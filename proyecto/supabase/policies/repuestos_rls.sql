-- Habilitar Row Level Security en las tablas
ALTER TABLE public.tienda ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tecnico ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.repuesto ENABLE ROW LEVEL SECURITY;

-- Políticas para repuestos: Los técnicos solo pueden ver y editar los repuestos de su tienda.
-- NOTA: Estas políticas asumen que el ID de la tienda está disponible en el JWT (ej. a través de un campo customizado al hacer login) o que cruzamos con el usuario de auth.users.
-- Por simplicidad para el MVP, asumimos que auth.uid() está mapeado al id del técnico.

CREATE POLICY "Ver repuestos de la misma tienda" ON public.repuesto
    FOR SELECT USING (
        tienda_id = (SELECT tienda_id FROM public.tecnico WHERE id = auth.uid())
    );

CREATE POLICY "Actualizar repuestos de la misma tienda" ON public.repuesto
    FOR UPDATE USING (
        tienda_id = (SELECT tienda_id FROM public.tecnico WHERE id = auth.uid())
    );

-- Restricción anti-condición-de-carrera (RNF-06):
-- Evitar que dos técnicos reserven un repuesto ya reservado simultáneamente
-- Podemos usar una función de trigger o asegurar que el UPDATE requiere que el estado sea 'disponible'

CREATE OR REPLACE FUNCTION check_repuesto_disponible()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.estado = 'reservado' AND OLD.estado = 'reservado' AND OLD.reservado_por IS DISTINCT FROM NEW.reservado_por THEN
        RAISE EXCEPTION 'El repuesto ya ha sido reservado por otro técnico';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_double_reservation
    BEFORE UPDATE ON public.repuesto
    FOR EACH ROW
    EXECUTE FUNCTION check_repuesto_disponible();
