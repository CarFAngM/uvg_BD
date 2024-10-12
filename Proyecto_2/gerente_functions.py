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
                        print(
                            f"ID: {insumo[0]}, Nombre: {insumo[1]}, C_D: {insumo[2]}, F_D_C: {insumo[3]}, "
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
                        print(
                            f"ID: {insumo[0]}, Nombre: {insumo[1]}, C_D: {insumo[2]}, F_D_C: {insumo[3]}, "
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
