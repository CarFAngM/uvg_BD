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
BEGIN
    IF NEW.estado_reserva = 'FINALIZADA' THEN
        UPDATE mesa
        SET disponibilidad = TRUE
        WHERE mesa.mesa_id = NEW.mesa_id;
        RAISE NOTICE 'La mesa con el id está desbloqueada: mesa_id = %', NEW.mesa_id;
    END IF;

    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER desbloquear_mesa_por_finalizacion
AFTER UPDATE ON reserva
FOR EACH ROW
EXECUTE FUNCTION desbloquear_mesa_por_finalizacion();

