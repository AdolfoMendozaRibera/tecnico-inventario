-- 1. Desactivamos RLS en tienda y tecnico para que el app pueda gestionarlos
ALTER TABLE public.tienda DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.tecnico DISABLE ROW LEVEL SECURITY;

-- 2. Aseguramos que la Tienda Central exista
INSERT INTO public.tienda (id, nombre) 
VALUES ('00000000-0000-0000-0000-000000000001', 'Taller Electrónico Central')
ON CONFLICT DO NOTHING;

-- 3. Aseguramos que los repuestos de prueba existan
INSERT INTO public.repuesto (nombre, categoria, estado, tienda_id) VALUES
('Placa Base Asus B550', 'Placas', 'disponible', '00000000-0000-0000-0000-000000000001'),
('Pantalla LCD 15.6 FHD', 'Pantallas', 'disponible', '00000000-0000-0000-0000-000000000001'),
('Batería Dell Inspiron', 'Baterías', 'disponible', '00000000-0000-0000-0000-000000000001'),
('Memoria RAM 16GB DDR4', 'Memorias', 'disponible', '00000000-0000-0000-0000-000000000001'),
('Disco SSD 1TB NVMe', 'Almacenamiento', 'disponible', '00000000-0000-0000-0000-000000000001')
ON CONFLICT DO NOTHING;

-- 4. Creamos un técnico automáticamente para tu cuenta actual
INSERT INTO public.tecnico (id, nombre, tienda_id)
SELECT id, email, '00000000-0000-0000-0000-000000000001'
FROM auth.users
ON CONFLICT DO NOTHING;
