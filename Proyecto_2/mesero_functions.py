import psycopg2

from auth import get_sucursal_para_usuario, current_branch
from db_connection import get_connection

conn = get_connection()
cur = conn.cursor() if conn else None


# Agregar nuevo cliente a la base de datos

def agregar_cliente():
    nombre = input('Ingrese su nombre: ')
    correo = input('Ingrese su correo: ')
    telefono = input('Ingrese su teléfono: ')
    plato_favorito = input('Ingrese su plato favorito: ')

    try:
        insert_cliente_query = """
        INSERT INTO cliente (nombre, correo, telefono, plato_favorito) 
        VALUES (%s, %s, %s, %s);
        """
        cur.execute(insert_cliente_query, (nombre, correo, telefono, plato_favorito))
        conn.commit()
        print("Cliente registrado con éxito.")

    except psycopg2.Error as e:
        print(f"Error al registrar el cliente: {e}")
        conn.rollback()


# Agregar nuevo pedido a la base de datos

def agregar_pedido():
    fecha = input('Ingrese la fecha del pedido (YYYY-MM-DD): ')
    cliente_id = input('Ingrese el id del cliente: ')
    sucursal_id = get_sucursal_para_usuario()
    total_pedido = input('Ingrese el monto del pedido: ')

    try:

        query_mesas_disponibles = """
            SELECT mesa_id 
            FROM mesa 
            WHERE disponibilidad = TRUE AND sucursal_id = %s;
        """
        cur.execute(query_mesas_disponibles, (current_branch,))
        mesas_disponibles = cur.fetchall()

        if mesas_disponibles:
            print("Mesas disponibles en la sucursal:")
            for mesa in mesas_disponibles:
                print(f"Mesa ID: {mesa[0]}")
        else:
            print("No hay mesas disponibles en este momento en la sucursal.")
            mesa_id = None

        mesa_id = input('Ingrese la mesa de la sucursal que desea. Si no desea mesa, ingrese NULL: ')

        insert_pedido_query = """
        INSERT INTO pedido (fecha_pedido, total_pedido, cliente_id, sucursal_id, mesa_id) 
        VALUES (%s, %s, %s, %s, %s) RETURNING pedido_id;
        """
        cur.execute(insert_pedido_query, (fecha, total_pedido, cliente_id, current_branch, mesa_id))

        pedido_id = cur.fetchone()[0]
        conn.commit()
        print("Pedido registrado con éxito. ID del pedido:", pedido_id)

        while True:
            plato_id = input('Ingrese el ID del plato que desea agregar al pedido (o "0" para finalizar): ')

            if plato_id == "0":
                break

            try:
                insert_pedido_plato_query = """
                INSERT INTO pedido_plato (pedido_id, plato_id)
                VALUES (%s, %s);
                """
                cur.execute(insert_pedido_plato_query, (pedido_id, plato_id))
                conn.commit()
                print(f"Plato con ID {plato_id} agregado al pedido {pedido_id} con éxito.")

            except psycopg2.Error as e:
                print(f"Error al agregar el plato {plato_id} al pedido: {e}")
                conn.rollback()

    except psycopg2.Error as e:
        print(f"Error al registrar el pedido: {e}")
        conn.rollback()


# Funcion para crear o finalizar reservas
def gestionar_reservas():
    continuar4 = True

    while continuar4:
        print('1. Crear reserva')
        print('2. Finalizar reserva')
        print('3. Salir')
        x2 = input('Ingrese su decisión: ')

        if x2 == '1':
            sucursal_id = get_sucursal_para_usuario()
            try:
                query_mesas_disponibles = """
                    SELECT mesa_id 
                    FROM mesa 
                    WHERE disponibilidad = TRUE and sucursal_id = %s;
                """
                cur.execute(query_mesas_disponibles, (sucursal_id,))
                mesas_disponibles = cur.fetchall()

                if mesas_disponibles:
                    print("Mesas disponibles:")
                    for mesa in mesas_disponibles:
                        print(f"Mesa ID: {mesa[0]}")
                else:
                    print("No hay mesas disponibles en este momento.")
                    continue

            except psycopg2.Error as e:
                print(f"Error al obtener mesas disponibles: {e}")
                continue

            fecha_reserva = input('Ingrese la fecha en la que desea reservar: ')
            mesa_id = input('Ingrese el ID de la mesa que desea reservar: ')
            cliente_id = input('Ingrese el ID del cliente: ')

            try:
                insert_reserva_query = """
                    INSERT INTO reserva (fecha_reserva, mesa_id, cliente_id, estado, sucursal_id) 
                    VALUES (%s, %s, %s, 'VIGENTE', %s) RETURNING reserva_id;
                """
                cur.execute(insert_reserva_query, (fecha_reserva, mesa_id, cliente_id, sucursal_id))
                conn.commit()
                print("Reserva creada exitosamente. ID de reserva:", cur.fetchone()[0])

            except psycopg2.Error as e:
                print(f"Error al registrar la reserva: {e}")
                conn.rollback()

        elif x2 == '2':
            try:
                reserva_id = int(input('Ingrese el ID de la reserva: '))
                sucursal_id = get_sucursal_para_usuario()

                update_reserva_query = """
                    UPDATE reserva
                    SET estado = 'FINALIZADA'
                    WHERE reserva_id = %s AND sucursal_id = %s;
                """
                cur.execute(update_reserva_query, (reserva_id, sucursal_id))
                conn.commit()
                print("Reserva finalizada correctamente.")

            except ValueError:
                print("Por favor, ingrese un número válido para el ID de reserva y sucursal.")
            except psycopg2.Error as e:
                print(f"Error al finalizar la reserva: {e}")
                conn.rollback()

        elif x2 == '3':
            continuar4 = False
        else:
            print('Ingrese números del 1 al 3.')


# Funcion para gestionar mesas
def gestionar_mesas():
    while True:
        print('1. Ver mesas ocupadas de la sucursal')
        print('2. Desbloquear mesa')
        print('3. Salir')
        d1 = input('Ingrese su decisión: ')

        if d1 == "1":
            try:
                sucursal_id = get_sucursal_para_usuario()
                ver_mesas_query = '''
                    SELECT mesa_id
                    FROM mesa
                    WHERE sucursal_id = %s AND disponibilidad = FALSE;
                '''
                cur.execute(ver_mesas_query, (sucursal_id,))
                mesas_ocupadas = cur.fetchall()

                if mesas_ocupadas:
                    print("Mesas disponibles:")
                    for mesa in mesas_ocupadas:
                        print(f"Mesa ID: {mesa[0]}")
                else:
                    print("No hay mesas disponibles en este momento.")
                    continue

            except psycopg2.Error as e:
                print(f"Error al actualizar la mesa: {e}")
                conn.rollback()

        elif d1 == "2":
            try:
                sucursal_id = get_sucursal_para_usuario()
                mesa_id = int(input('Ingrese el ID de la mesa: '))

                update_mesa_query = """
                    UPDATE mesa
                    SET disponibilidad = TRUE
                    WHERE sucursal_id = %s AND mesa_id = %s;
                """
                cur.execute(update_mesa_query, (sucursal_id, mesa_id))

                if cur.rowcount > 0:
                    conn.commit()
                    print("Mesa marcada como disponible correctamente.")
                else:
                    print("No se encontró la mesa o la sucursal especificada.")

            except ValueError:
                print("Por favor, ingrese un número válido para el ID de la sucursal y la mesa.")

            except psycopg2.Error as e:
                print(f"Error al actualizar la mesa: {e}")
                conn.rollback()

        elif d1 == "3":
            break

        else:
            print('Ingrese una decision correcta.')
