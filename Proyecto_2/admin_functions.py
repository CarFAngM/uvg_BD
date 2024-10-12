import psycopg2

from auth import get_sucursal_para_usuario
from db_connection import get_connection

conn = get_connection()
cur = conn.cursor() if conn else None


def gestion_de_insumos():
    while True:
        print('1. Registrar nuevos insumos para la sucursal')
        print('2. Visualizar todos insumos de la sucursal')
        print('3. Ver insumos cuyo stock está bajo')
        print('4. Salir')

        d2 = input('Ingrese su decisión: ')

        if d2 == '1':
            sucursal_id = get_sucursal_para_usuario()
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
            sucursal_id = get_sucursal_para_usuario()
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
            sucursal_id = get_sucursal_para_usuario()
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
