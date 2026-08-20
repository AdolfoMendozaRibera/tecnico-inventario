-- =============================================================================
-- SEED DATA (Paso 4: Datos de Prueba para la UI)
-- Proyecto: Técnico-Inventario
-- =============================================================================

-- 1. Insertar Tienda de prueba
INSERT INTO tienda (id, nombre)
VALUES ('11111111-1111-1111-1111-111111111111', 'Taller Central - Casa Matriz')
ON CONFLICT (id) DO NOTHING;

-- 2. Insertar Técnicos de prueba
INSERT INTO tecnico (id, nombre, tienda_id)
VALUES 
    ('22222222-2222-2222-2222-222222222222', 'Carlos (Técnico Principal)', '11111111-1111-1111-1111-111111111111'),
    ('33333333-3333-3333-3333-333333333333', 'Marco (Técnico Ayudante)', '11111111-1111-1111-1111-111111111111')
ON CONFLICT (id) DO NOTHING;

-- 3. Insertar Repuestos de prueba (Disponibles y Reservados para probar UI)
INSERT INTO repuesto (id, nombre, categoria, estado, tienda_id, equipo_destino, motivo, reservado_por, fecha_reserva)
VALUES 
    (
        'a1111111-1111-1111-1111-111111111111',
        'Pantalla OLED Samsung A52',
        'Pantallas',
        'disponible',
        '11111111-1111-1111-1111-111111111111',
        NULL,
        NULL,
        NULL,
        NULL
    ),
    (
        'b2222222-2222-2222-2222-222222222222',
        'Batería iPhone 11 3110mAh',
        'Baterías',
        'reservado',
        '11111111-1111-1111-1111-111111111111',
        'iPhone 11 Negro - Cliente Juan Perez',
        'Cambio por inflado grave',
        '22222222-2222-2222-2222-222222222222',
        NOW() - INTERVAL '2 hours'
    ),
    (
        'c3333333-3333-3333-3333-333333333333',
        'Módulo Pin de Carga Motorola G8',
        'Módulos Carga',
        'disponible',
        '11111111-1111-1111-1111-111111111111',
        NULL,
        NULL,
        NULL,
        NULL
    ),
    (
        'd4444444-4444-4444-4444-444444444444',
        'Flex de Encendido Redmi Note 10',
        'Flex',
        'reservado',
        '11111111-1111-1111-1111-111111111111',
        'Redmi Note 10 Azul - Reparación urgente',
        'Botonera dañada',
        '33333333-3333-3333-3333-333333333333',
        NOW() - INTERVAL '1 day'
    );
