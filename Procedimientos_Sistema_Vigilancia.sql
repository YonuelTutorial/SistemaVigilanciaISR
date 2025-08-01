
-- ================================================
-- PROCEDIMIENTOS ALMACENADOS - SISTEMA VIGILANCIA
-- ================================================

DELIMITER $$
CREATE PROCEDURE asignar_equipo_a_vigilante (
    IN p_id_equipo INT,
    IN p_id_vigilante INT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM AsignacionEquipo
        WHERE id_equipo = p_id_equipo AND fecha_devolucion IS NULL
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Este equipo ya está asignado y no ha sido devuelto';
    ELSE
        INSERT INTO AsignacionEquipo (id_equipo, id_vigilante, fecha_asignacion, id_estado_equipo)
        VALUES (p_id_equipo, p_id_vigilante, NOW(), 1);
    END IF;
END$$
DELIMITER ;

-- 2. Registrar evento de servicio
DELIMITER $$
CREATE PROCEDURE registrar_evento_servicio (
    IN p_id_servicio INT,
    IN p_id_vigilante INT,
    IN p_id_tipo_evento INT,
    IN p_descripcion TEXT
)
BEGIN
    INSERT INTO EventoServicio (id_servicio, id_vigilante, fecha_evento, id_tipo_evento, descripcion)
    VALUES (p_id_servicio, p_id_vigilante, NOW(), p_id_tipo_evento, p_descripcion);
END$$
DELIMITER ;

-- 3. Registrar acción específica dentro de un evento
DELIMITER $$
CREATE PROCEDURE registrar_accion_evento (
    IN p_id_evento INT,
    IN p_id_tipo_accion INT,
    IN p_id_equipo INT,
    IN p_cantidad INT,
    IN p_descripcion TEXT
)
BEGIN
    INSERT INTO AccionEvento (id_evento, id_tipo_accion, id_equipo, cantidad_usos, descripcion)
    VALUES (p_id_evento, p_id_tipo_accion, p_id_equipo, p_cantidad, p_descripcion);
END$$
DELIMITER ;

-- 4. Auditar uso de equipo posterior al evento
DELIMITER $$
CREATE PROCEDURE auditar_uso_equipo (
    IN p_id_evento INT,
    IN p_id_equipo INT,
    IN p_observacion TEXT
)
BEGIN
    INSERT INTO AuditoriaUsoEquipo (id_evento, id_equipo, observacion)
    VALUES (p_id_evento, p_id_equipo, p_observacion);
END$$
DELIMITER ;

-- 5. Consultar historial de asignación de equipo
DELIMITER $$
CREATE PROCEDURE consultar_historial_equipo (
    IN p_id_equipo INT
)
BEGIN
    SELECT * FROM AsignacionEquipo
    WHERE id_equipo = p_id_equipo
    ORDER BY fecha_asignacion DESC;
END$$
DELIMITER ;

-- 6. Consultar historial de acciones en evento
DELIMITER $$
CREATE PROCEDURE consultar_acciones_por_evento (
    IN p_id_evento INT
)
BEGIN
    SELECT ae.*, te.nombre AS tipo_accion, eq.nombre AS equipo
    FROM AccionEvento ae
    JOIN TipoAccion te ON ae.id_tipo_accion = te.id_tipo_accion
    JOIN Equipo eq ON ae.id_equipo = eq.id_equipo
    WHERE ae.id_evento = p_id_evento;
END$$
DELIMITER ;
