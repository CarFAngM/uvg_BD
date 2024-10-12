import psycopg2

from auth import get_sucursal_para_usuario
from db_connection import get_connection

conn = get_connection()
cur = conn.cursor() if conn else None


# Funcion para visualizar clientes en la base de datos
def visualizar_clientes():
    nombre = input('Ingrese el nombre del cliente: ')
    correo = input('Ingrese el correo del cliente: ')

    try:

        query1 = "SELECT * FROM cliente WHERE nombre = %s AND correo = %s"
        cur.execute(query1, (nombre, correo))

        resultado = cur.fetchone()

        if resultado:
            print("Datos del cliente:", resultado)
        else:
            print("No se encontró ningún cliente con ese nombre y correo.")

    except psycopg2.Error as e:
        print(f"Error al ejecutar la consulta: {e}")


# Funcion para visualizar y actualizar los insumos en la base de datos
def gestion_de_insumos():
    while True:
        print('1. Registrar nuevos insumos para la sucursal ')
        print('2. Visualizar todos insumos de la sucursal')
        print('3. Ver insumos cuyo stock esta bajo basados en sucursal')
        print('4. salir')

        d2 = input('ingrese su decision: ')

        if d2 == '1':
            sucursal_id = get_sucursal_para_usuario()
            insumo_id = input('Ingrese el id del insumo')
            cantidad_nueva = int(input('Ingrese la cantidad nueva de insumos comprados: '))

            try:
                query_update_insumos = '''
                    UPDATE insumo 
                    SET cantidad_disponible = cantidad_disponible + %s
                    WHERE insumo_id = %s and sucursal_id = %s;
                '''
                cur.execute(query_update_insumos, (cantidad_nueva, insumo_id, sucursal_id,))
                conn.commit()
                if cur.rowcount > 0:
                    print('Cantidad de insumos actualizada correctamente.')
                else:
                    print('No se encontró ningún insumo con ese ID.')

            except psycopg2.Error as e:
                print(f"Error al actualizar los insumos: {e}")
                conn.rollback()

        elif d2 == '2':
            sucursal_id = get_sucursal_para_usuario()
            try:
                query_visualizacion_insumos = '''
                    SELECT * 
                    FROM insumo 
                    WHERE sucursal_id = %s;    
                '''
                cur.execute(query_visualizacion_insumos, (sucursal_id,))
                insumos = cur.fetchall()

                if insumos:
                    for insumo in insumos:
                        print(f"ID: {insumo[0]}, Nombre: {insumo[1]}, C_D: {insumo[2]}, F_D_C: {insumo[3]}, "
                              f"Stock_Bajo: {'Sí' if insumo[4] else 'No'}")
                else:
                    print('No se encontró ningún insumo con stock bajo en esa sucursal')

            except psycopg2.Error as e:
                print(f"Error al visualizar los insumos: {e}")
                conn.rollback()

        elif d2 == '3':
            sucursal_id = get_sucursal_para_usuario()
            try:
                query_visualizacion_insumos_stock_bajo = '''
                    SELECT * 
                    FROM insumo 
                    WHERE sucursal_id = %s and cantidad_disponible < 16;    
                '''
                cur.execute(query_visualizacion_insumos_stock_bajo, (sucursal_id,))
                insumos = cur.fetchall()

                if insumos:
                    for insumo in insumos:
                        print(f"ID: {insumo[0]}, Nombre: {insumo[1]}, C_D: {insumo[2]}, F_D_C: {insumo[3]}, "
                              f"Cantidad: {insumo[4]}")
                else:
                    print('No hay insumos con stock bajo en esta sucursal')

            except psycopg2.Error as e:
                print(f"Error al visualizar los insumos: {e}")
                conn.rollback()

        elif d2 == '4':
            break

        else:
            print('Ingrese una decision correcta.')


# Funcion para generar reportes de todas las sucursales para el gerente
def reporteria_gerente():
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

        # Comportamiento de la sucursal seleccionada con mayor cantidad de reservas y ventas
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
