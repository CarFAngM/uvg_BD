import psycopg2

from credenciales_base_datos import conectar_base_de_datos

conn = conectar_base_de_datos()
cur = conn.cursor() if conn else None


# Funcion para gestionar los insumos de una sucursal que seleccione el administrador

def gestion_de_insumos_administrador():
    try:
        # Obtener todas las sucursales disponibles
        query_sucursales = '''
            SELECT sucursal_id, nombre_sucursal FROM Sucursal;
        '''
        cur.execute(query_sucursales)
        sucursales = cur.fetchall()
        print("Seleccione la sucursal que desea modificar:")
        for sucursal in sucursales:
            print(f"{sucursal[0]}. {sucursal[1]}")
        sucursal_id = int(input("Ingrese el ID de la sucursal: "))
    except psycopg2.Error as e:
        print(f"Error al obtener las sucursales: {e}")
        return

    while True:
        print('1. Registrar nuevos insumos para la sucursal')
        print('2. Visualizar todos insumos de la sucursal')
        print('3. Ver insumos cuyo stock está bajo')
        print('4. Salir')

        d2 = input('Ingrese su decisión: ')

        if d2 == '1':
            insumo_id = input('Ingrese el id del insumo: ')
            cantidad_nueva = int(input('Ingrese la cantidad nueva de insumos comprados: '))

            try:
                query_update_insumos = '''
                    UPDATE insumo
                    SET cantidad_disponible = cantidad_disponible + %s
                    WHERE insumo_id = %s and sucursal_id = %s;
                '''
                cur.execute(query_update_insumos, (cantidad_nueva, insumo_id, sucursal_id))
                conn.commit()
                if cur.rowcount > 0:
                    print('Cantidad de insumos actualizada correctamente.')
                else:
                    print('No se encontró ningún insumo con ese ID.')

            except psycopg2.Error as e:
                print(f"Error al actualizar los insumos: {e}")
                conn.rollback()

        elif d2 == '2':
            try:
                query_select_insumos = '''
                    SELECT * FROM insumo WHERE sucursal_id = %s;
                '''
                cur.execute(query_select_insumos, (sucursal_id,))
                insumos = cur.fetchall()
                if insumos:
                    for insumo in insumos:
                        print(insumo)
                else:
                    print('No se encontraron insumos para esta sucursal.')

            except psycopg2.Error as e:
                print(f"Error al obtener los insumos: {e}")

        elif d2 == '3':
            try:
                query_low_stock = '''
                    SELECT * FROM insumo WHERE sucursal_id = %s AND cantidad_disponible < 10;
                '''
                cur.execute(query_low_stock, (sucursal_id,))
                insumos_bajo_stock = cur.fetchall()
                if insumos_bajo_stock:
                    for insumo in insumos_bajo_stock:
                        print(insumo)
                else:
                    print('No hay insumos con stock bajo en esta sucursal.')

            except psycopg2.Error as e:
                print(f"Error al obtener los insumos con stock bajo: {e}")

        elif d2 == '4':
            break

        else:
            print('Ingrese una decisión correcta.')

def customer_history():
    cliente_id = input('Ingrese el ID del cliente: ')

    try:
        query_cliente = '''
            SELECT nombre, correo, telefono, plato_favorito
            FROM Cliente
            WHERE cliente_id = %s;
        '''
        cur.execute(query_cliente, (cliente_id,))
        cliente_info = cur.fetchone()

        if not cliente_info:
            print('No se encontró ningún cliente con ese ID.')
            return

        print(f"Historial del Cliente: {cliente_info[0]}")
        print(f"Correo: {cliente_info[1]}")
        print(f"Teléfono: {cliente_info[2]}")
        print(f"Plato Favorito: {cliente_info[3]}")
        print("\nReservas:")

        # Mostrar reservas del cliente
        query_reservas = '''
            SELECT R.fecha_reserva, M.mesa_id, R.estado_reserva, S.nombre_sucursal
            FROM Reserva R
            JOIN Mesa M ON R.mesa_id = M.mesa_id
            JOIN Sucursal S ON R.sucursal_id = S.sucursal_id
            WHERE R.cliente_id = %s;
        '''
        cur.execute(query_reservas, (cliente_id,))
        reservas = cur.fetchall()

        if reservas:
            for reserva in reservas:
                print(f"Fecha: {reserva[0]}, Mesa ID: {reserva[1]}, Estado: {reserva[2]}, Sucursal: {reserva[3]}")
        else:
            print('No se encontraron reservas para este cliente.')

        print("\nPedidos:")

        # Mostrar pedidos del cliente
        query_pedidos = '''
            SELECT P.fecha_pedido, P.total_pedido, S.nombre_sucursal
            FROM Pedido P
            JOIN Sucursal S ON P.sucursal_id = S.sucursal_id
            WHERE P.cliente_id = %s;
        '''
        cur.execute(query_pedidos, (cliente_id,))
        pedidos = cur.fetchall()

        if pedidos:
            for pedido in pedidos:
                print(f"Fecha: {pedido[0]}, Total: {pedido[1]}, Sucursal: {pedido[2]}")
        else:
            print('No se encontraron pedidos para este cliente.')

    except psycopg2.Error as e:
        print(f"Error al obtener el historial del cliente: {e}")


# Funcion para generar un reporte de la sucursal que seleccione el administrador

def reporteria_administrador():
    try:
        # Mostrar todas las sucursales disponibles
        query_sucursales = '''
            SELECT sucursal_id, nombre_sucursal
            FROM Sucursal;
        '''
        cur.execute(query_sucursales)
        sucursales = cur.fetchall()

        if not sucursales:
            print("No hay sucursales disponibles.")
            return

        print("Sucursales disponibles:")
        for sucursal in sucursales:
            print(f"ID: {sucursal[0]}, Nombre: {sucursal[1]}")

        sucursal_id = input("Ingrese el ID de la sucursal para ver el reporte: ")

        # Top 10 de los platos más vendidos en la sucursal seleccionada
        query_top_platos = '''
            SELECT P.nombre, COUNT(PP.plato_id) AS cantidad_vendida
            FROM Pedido_Plato PP
            JOIN Plato P ON PP.plato_id = P.plato_id
            JOIN Pedido PD ON PP.pedido_id = PD.pedido_id
            WHERE PD.sucursal_id = %s
            GROUP BY P.nombre
            ORDER BY cantidad_vendida DESC
            LIMIT 10;
        '''
        cur.execute(query_top_platos, (sucursal_id,))
        top_platos = cur.fetchall()
        print("Top 10 de los platos más vendidos:")
        for plato in top_platos:
            print(f"Plato: {plato[0]}, Cantidad Vendida: {plato[1]}")

        # Top 10 de los clientes más frecuentes en la sucursal seleccionada
        query_top_clientes = '''
            SELECT C.nombre, COUNT(R.cliente_id) AS cantidad_visitas
            FROM Reserva R
            JOIN Cliente C ON R.cliente_id = C.cliente_id
            WHERE R.sucursal_id = %s
            GROUP BY C.nombre
            ORDER BY cantidad_visitas DESC
            LIMIT 10;
        '''
        cur.execute(query_top_clientes, (sucursal_id,))
        top_clientes = cur.fetchall()
        print("\nTop 10 de los clientes más frecuentes:")
        for cliente in top_clientes:
            print(f"Cliente: {cliente[0]}, Cantidad de Visitas: {cliente[1]}")

        # Top 5 de los clientes con mayores reservas y su preferencia de platos en la sucursal seleccionada
        query_top_reservas = '''
            SELECT C.nombre, COUNT(R.reserva_id) AS cantidad_reservas, C.plato_favorito
            FROM Reserva R
            JOIN Cliente C ON R.cliente_id = C.cliente_id
            WHERE R.sucursal_id = %s
            GROUP BY C.nombre, C.plato_favorito
            ORDER BY cantidad_reservas DESC
            LIMIT 5;
        '''
        cur.execute(query_top_reservas, (sucursal_id,))
        top_reservas = cur.fetchall()
        print("\nTop 5 de los clientes con mayores reservas y su preferencia de platos:")
        for reserva in top_reservas:
            print(f"Cliente: {reserva[0]}, Cantidad de Reservas: {reserva[1]}, Plato Favorito: {reserva[2]}")

        # Reporte mensual de insumos a punto de terminarse o caducar en la sucursal seleccionada
        query_insumos = '''
            SELECT nombre, cantidad_disponible, fecha_caducidad
            FROM Insumo
            WHERE sucursal_id = %s AND (cantidad_disponible < 10 OR fecha_caducidad < NOW() + INTERVAL '1 month');
        '''
        cur.execute(query_insumos, (sucursal_id,))
        insumos = cur.fetchall()
        print("\nReporte mensual de insumos a punto de terminarse o caducar:")
        for insumo in insumos:
            print(f"Insumo: {insumo[0]}, Cantidad Disponible: {insumo[1]}, Fecha de Caducidad: {insumo[2]}")

        # Comportamiento de la sucursal que tiene la mayor cantidad de reservas y ventas
        query_sucursal = '''
            SELECT S.nombre_sucursal, COUNT(R.reserva_id) AS cantidad_reservas, SUM(P.total_pedido) AS total_ventas
            FROM Sucursal S
            LEFT JOIN Reserva R ON S.sucursal_id = R.sucursal_id
            LEFT JOIN Pedido P ON S.sucursal_id = P.sucursal_id
            WHERE S.sucursal_id = %s
            GROUP BY S.nombre_sucursal
            ORDER BY cantidad_reservas DESC, total_ventas DESC;
        '''
        cur.execute(query_sucursal, (sucursal_id,))
        sucursal = cur.fetchone()
        print("\nComportamiento de la sucursal con mayor cantidad de reservas y ventas:")
        if sucursal:
            print(f"Sucursal: {sucursal[0]}, Cantidad de Reservas: {sucursal[1]}, Total de Ventas: {sucursal[2]}")
        else:
            print("No se encontraron datos para la sucursal seleccionada.")

    except psycopg2.Error as e:
        print(f"Error al generar los reportes: {e}")


# Funcion para ver un control de cambios en la sucursal que seleccione.

def control_de_cambios_administrador():
    try:
        query_sucursales = '''
            SELECT sucursal_id, nombre_sucursal FROM Sucursal;
        '''
        cur.execute(query_sucursales)
        sucursales = cur.fetchall()
        print("Seleccione la sucursal para la que desea ver los cambios:")
        for sucursal in sucursales:
            print(f"{sucursal[0]}. {sucursal[1]}")
        sucursal_id = int(input("Ingrese el ID de la sucursal: "))
    except psycopg2.Error as e:
        print(f"Error al obtener las sucursales: {e}")
        return

    if sucursal_id:
        try:
            query_bitacora = '''
                SELECT accion, fecha_accion, tabla_afectada
                FROM Bitacora
                WHERE tabla_afectada IN (
                    'Sucursal', 'Cliente', 'Mesa', 'Reserva', 'Pedido', 'Plato', 'Insumo'
                )
                ORDER BY fecha_accion DESC;
            '''
            cur.execute(query_bitacora)
            cambios = cur.fetchall()
            if cambios:
                print("Cambios recientes en la sucursal:")
                for cambio in cambios:
                    print(f"Acción: {cambio[0]}, Fecha: {cambio[1]}, Tabla Afectada: {cambio[2]}")
            else:
                print("No se encontraron cambios recientes para esta sucursal.")
        except psycopg2.Error as e:
            print(f"Error al obtener los cambios: {e}")
    else:
        print("No se seleccionó ninguna sucursal.")
