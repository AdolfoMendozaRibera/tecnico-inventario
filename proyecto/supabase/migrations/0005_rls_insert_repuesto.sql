-- Flujo v0.4: Política RLS para que técnicos autenticados puedan
-- insertar repuestos nuevos en su misma tienda.
--
-- Condición: el tienda_id del nuevo repuesto debe coincidir con
-- el tienda_id del técnico que está haciendo el INSERT.

CREATE POLICY "Insertar repuestos en la misma tienda" ON public.repuesto
    FOR INSERT WITH CHECK (
        tienda_id = (SELECT tienda_id FROM public.tecnico WHERE id = auth.uid())
    );
