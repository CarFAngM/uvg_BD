#  CONEXION BASES DE DATOS.
from Proyecto_2.administrador_functions import *
from Proyecto_2.gerente_functions import *
from Proyecto_2.mesero_functions import *

conn = None

try:
    conn = psycopg2.connect("host=localhost dbname=proyecto_2 user=postgres password=Liceojavier2")
    conn.set_client_encoding('UTF8')
    cur = conn.cursor()
except psycopg2.Error as e:
    print(f"No se pudo conectar a la base de datos: {e}")


# FUNCIONES INICIO DE SESION: 

def get_sucursal_para_usuario():
    if current_branch:
        return current_branch
    else:
        return input('Ingrese el id de la sucursal (Administrador): ')


def sign_in():
    correo = input("Escriba su correo: ")
    contrasena = input("Escriba su contraseña: ")

    try:
        query = ("SELECT rol, sucursal_id FROM usuario JOIN sucursal_usuario ON usuario.usuario_id = "
                 "sucursal_usuario.usuario_id WHERE correo = %s AND contrasena = %s")
        cur.execute(query, (correo, contrasena))
        resultado = cur.fetchone()

        if resultado is None:
            print("Error: Correo o contraseña incorrectos.")
        else:
            rol, sucursal_id = resultado
            current_branch = sucursal_id
            print(f"Iniciaste sesión correctamente como {rol} en la sucursal {current_branch}.")
            desplegar_menu_por_rol(rol)

    except psycopg2.Error as e:
        print(f"Error al ejecutar la consulta: {e}")


# FUNCION PARA DESPLEGAR EL MENU POR ROL.

def desplegar_menu_por_rol(rol):
    if rol == 'Mesero':
        continuar = True
        while continuar:
            print('1. Agregar cliente')
            print('2. Agregar pedido')
            print('3. Gestionar reserva')
            print('4. Gestionar mesas')
            print('5. Visualizar clientes')
            print('6. Salir')
            opcion = input('Ingrese qué desea realizar hoy: ')

            if opcion == '1':
                agregar_cliente()
            elif opcion == '2':
                agregar_pedido()
            elif opcion == '3':
                gestionar_reservas()
            elif opcion == '4':
                gestionar_mesas()
            elif opcion == '5':
                visualizar_clientes()
            elif opcion == '6':
                continuar = False
            else:
                print('Ingrese una opción correcta.')

    elif rol == 'Administrador':
        continuar = True
        while continuar:
            print('1. Gestión de insumos basados en la sucursal')
            print('2. Reportería')
            print('3. Control de cambios de la sucursal')
            print('4. Salir')
            opcion = input('Ingrese qué desea realizar hoy: ')

            if opcion == '1':
                gestion_de_insumos()
            elif opcion == '2':
                reporteria_administrador()
            elif opcion == '3':
                control_de_cambios("Administrador")
            elif opcion == '4':
                continuar = False
            else:
                print('Ingrese una opción correcta.')

    elif rol == 'Gerente':
        continuar = True
        while continuar:
            print('1. Agregar cliente')
            print('2. Agregar pedido')
            print('3. Gestionar reserva')
            print('4. Gestionar mesas')
            print('5. Visualizar clientes')
            print('6. Gestión de insumos de la sucursal a la que pertenece')
            print('7. Control de cambios de una sucursal')
            print('8. Generar reporte de una sucursal')
            print('9. Salir')
            opcion = input('Ingrese qué desea realizar hoy: ')

            if opcion == '1':
                agregar_cliente()
            elif opcion == '2':
                agregar_pedido()
            elif opcion == '3':
                gestionar_reservas()
            elif opcion == '4':
                gestionar_mesas()
            elif opcion == '5':
                visualizar_clientes()
            elif opcion == '6':
                gestion_de_insumos()
            elif opcion == '7':
                control_de_cambios("Gerente")
            elif opcion == '8':
                reporteria_gerente()
            elif opcion == '9':
                continuar = False
            else:
                print('Ingrese una opción correcta.')


# Funcion para ver un control de cambios. Funcionalidad cambia segun administrador o gerente.

def control_de_cambios(rol):
    sucursal_id = None

    if rol == 'Administrador':
        sucursal_id = get_sucursal_para_usuario()
    elif rol == 'Gerente':
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
                    SELECT 'Sucursal' UNION ALL
                    SELECT 'Cliente' UNION ALL
                    SELECT 'Mesa' UNION ALL
                    SELECT 'Reserva' UNION ALL
                    SELECT 'Pedido' UNION ALL
                    SELECT 'Plato' UNION ALL
                    SELECT 'Insumo'
                )
                AND EXISTS (
                    SELECT 1 FROM Sucursal_Usuario
                    WHERE sucursal_id = %s AND usuario_id = %s
                )
                ORDER BY fecha_accion DESC;
            '''
            cur.execute(query_bitacora, (sucursal_id, get_sucursal_para_usuario()))
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
