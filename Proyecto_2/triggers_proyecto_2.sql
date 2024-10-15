CREATE OR REPLACE FUNCTION bloquear_mesa_por_reserva()
RETURNS TRIGGER AS $$
BEGIN

    UPDATE mesa
    SET disponibilidad = FALSE
    WHERE mesa.mesa_id = NEW.mesa_id AND NEW.estado_reserva = 'VIGENTE';


    RAISE NOTICE 'La mesa con el id está ocupada: mesa_id = %', NEW.mesa_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER bloquear_mesa_por_reserva
AFTER INSERT ON reserva
FOR EACH ROW
EXECUTE FUNCTION bloquear_mesa_por_reserva();

CREATE OR REPLACE FUNCTION desbloquear_mesa_por_finalizacion()
RETURNS TRIGGER AS $$
DECLARE
    accion_personalizada TEXT; 
BEGIN
    -- Verifica si el estado de la reserva cambió a 'FINALIZADA'
    IF NEW.estado = 'FINALIZADA' THEN
    UPDATE mesa
    SET disponibilidad = TRUE
    WHERE mesa.mesa_id = NEW.mesa_id;

    accion_personalizada := 'Mesa desbloqueada por finalización de reserva: ' || NEW.mesa_id;
    INSERT INTO public.bitacora(accion, fecha_accion, tabla_afectada)
    VALUES (accion_personalizada, now(), 'mesa');
	END IF;
    
    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;


-- Definición del trigger para que se ejecute después de la actualización
CREATE TRIGGER desbloquear_mesa_por_finalizacion
AFTER UPDATE ON reserva
FOR EACH ROW
EXECUTE FUNCTION desbloquear_mesa_por_finalizacion(); 




CREATE OR REPLACE FUNCTION bloquear_mesa_por_pedido()
RETURNS TRIGGER AS $$
DECLARE
    accion_personalizada TEXT;
BEGIN

    UPDATE mesa
    SET disponibilidad = FALSE
    WHERE mesa.mesa_id = NEW.mesa_id;

    RAISE NOTICE 'La mesa con el id está ocupada: mesa_id = %', NEW.mesa_id;


    accion_personalizada := 'Mesa bloqueada por pedido: ' || NEW.pedido_id || ', Mesa ID: ' || NEW.mesa_id;


    INSERT INTO public.bitacora(accion, fecha_accion, tabla_afectada)
    VALUES (accion_personalizada, now(), 'mesa');

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER bloquear_mesa_por_pedido
AFTER INSERT ON pedido
FOR EACH ROW
EXECUTE FUNCTION bloquear_mesa_por_pedido();


CREATE OR REPLACE FUNCTION insertar_bitacora_finalizacion_reserva()
RETURNS TRIGGER AS $audit$
declare
accion_personalizada text;
BEGIN
	if new.estado = 'FINALIZADA' then 
	accion_personalizada := 'Reserva finalizada: ' || new.reserva_id;
	INSERT INTO public.bitacora(accion, fecha_accion, tabla_afectada)
	VALUES (accion_personalizada, now(), 'reserva'); 
    END IF;
RETURN new;
END;
$audit$ LANGUAGE plpgsql;


CREATE TRIGGER insertar_bitacora_finalizacion_reserva
AFTER update ON reserva
FOR EACH ROW
EXECUTE FUNCTION insertar_bitacora_finalizacion_reserva();


-- trigger para actualizar cantidad de insumos. 
	
CREATE OR REPLACE FUNCTION actualizar_insumos()
RETURNS TRIGGER AS $$
DECLARE
    insumo_record RECORD;
    nueva_cantidad INTEGER;
BEGIN

    FOR insumo_record IN (SELECT i.insumo_id, i.cantidad_disponible
                          FROM Insumo i
                          JOIN Insumo_Plato ip ON i.insumo_id = ip.insumo_id
                          WHERE ip.plato_id = NEW.plato_id)
    LOOP
        -- Calculamos la nueva cantidad disponible
        nueva_cantidad := insumo_record.cantidad_disponible - 1;

        -- Actualizamos la cantidad disponible en la tabla Insumo
        UPDATE Insumo
        SET cantidad_disponible = nueva_cantidad
        WHERE insumo_id = insumo_record.insumo_id;

        -- Verificamos si la nueva cantidad es menor que 16
        IF nueva_cantidad < 16 THEN
            UPDATE Insumo
            SET alerta_stock_bajo = TRUE
            WHERE insumo_id = insumo_record.insumo_id;

            RAISE NOTICE 'Alerta: El insumo % está por debajo de 16 unidades de stock', insumo_record.insumo_id;
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



-- bitacora insert insumos

CREATE OR REPLACE FUNCTION trigger_bitacora_insumos()
RETURNS TRIGGER AS $audit$
declare
accion_personalizada text;
BEGIN
	if (new.cantidad_disponible > old.cantidad_disponible) then 
	accion_personalizada := 'Cantidad de insumos actualizado insumo_id: ' || new.insumo_id;
	INSERT INTO public.bitacora(accion, fecha_accion, tabla_afectada)
	VALUES (accion_personalizada, now(), 'insumo'); 
    END IF;
RETURN new;
END;
$audit$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_bitacora_insumos
AFTER Update ON insumo
FOR EACH ROW
EXECUTE FUNCTION trigger_bitacora_insumos();




CREATE OR REPLACE FUNCTION desbloquear_mesa_por_pedido()
RETURNS TRIGGER AS $$
DECLARE
    accion_personalizada TEXT;
BEGIN

    accion_personalizada := 'Mesa desbloqueada, Mesa ID: ' || NEW.mesa_id;


    INSERT INTO public.bitacora(accion, fecha_accion, tabla_afectada)
    VALUES (accion_personalizada, now(), 'mesa');

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER trigger_desbloquear_mesa
AFTER UPDATE OF disponibilidad ON mesa
FOR EACH ROW
WHEN (NEW.disponibilidad = TRUE)
EXECUTE FUNCTION desbloquear_mesa_por_pedido();


