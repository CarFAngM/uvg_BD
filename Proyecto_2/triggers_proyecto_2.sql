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
declare
	accion_personalizada text; 
BEGIN
    IF NEW.estado_reserva = 'FINALIZADA' THEN
        UPDATE mesa
        SET disponibilidad = TRUE
        WHERE mesa.mesa_id = NEW.mesa_id;
        RAISE NOTICE 'La mesa con el id está desbloqueada: mesa_id = %', NEW.mesa_id; 

		accion_personalizada := 'Estado de la mesa:' || NEW.mesa_id ||  'cambió , ANTES: ' || OLD.disponibilidad || '
		AHORA: ' || NEW.disponibilidad;

		INSERT INTO public.bitacora(accion, fecha_accion, tabla_afectada)
		VALUES (accion_personalizada, now(), 'mesa'); 

    END IF;

    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER desbloquear_mesa_por_finalizacion
AFTER UPDATE ON reserva
FOR EACH ROW
EXECUTE FUNCTION desbloquear_mesa_por_finalizacion();

CREATE OR REPLACE FUNCTION bloquear_mesa_por_pedido()
RETURNS TRIGGER AS $$
BEGIN

    UPDATE mesa
    SET disponibilidad = FALSE
    WHERE mesa.mesa_id = NEW.mesa_id;

    RAISE NOTICE 'La mesa con el id está ocupada: mesa_id = %', NEW.mesa_id;

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


CREATE TRIGGER insertar_bitacora_finalizacion_reserva
AFTER update ON reserva
FOR EACH ROW
EXECUTE FUNCTION insertar_bitacora_finalizacion_reserva();


