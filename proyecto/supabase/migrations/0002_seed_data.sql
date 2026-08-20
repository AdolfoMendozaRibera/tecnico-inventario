-- Insertar una Tienda por defecto para pruebas del MVP
INSERT INTO public.tienda (id, nombre) 
VALUES ('00000000-0000-0000-0000-000000000001', 'Taller Electrónico Central')
ON CONFLICT DO NOTHING;

-- Insertar componentes electrónicos de prueba
INSERT INTO public.repuesto (nombre, categoria, estado, tienda_id) VALUES
('Placa Base Asus B550', 'Placas', 'disponible', '00000000-0000-0000-0000-000000000001'),
('Pantalla LCD 15.6 FHD', 'Pantallas', 'disponible', '00000000-0000-0000-0000-000000000001'),
('Batería Dell Inspiron', 'Baterías', 'disponible', '00000000-0000-0000-0000-000000000001'),
('Memoria RAM 16GB DDR4', 'Memorias', 'disponible', '00000000-0000-0000-0000-000000000001'),
('Disco SSD 1TB NVMe', 'Almacenamiento', 'disponible', '00000000-0000-0000-0000-000000000001');
