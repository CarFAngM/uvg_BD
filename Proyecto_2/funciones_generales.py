#  CONEXION BASES DE DATOS.
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
    contraseña = input("Escriba su contraseña: ")

    try:
        query = ("SELECT rol, sucursal_id FROM usuario JOIN sucursal_usuario ON usuario.usuario_id = "
                 "sucursal_usuario.usuario_id WHERE correo = %s AND contrasena = %s")
        cur.execute(query, (correo, contraseña))
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
        continuar3 = True
        while continuar3:
            print('1. Agregar cliente')
            print('2. Agregar pedido')
            print('3. Gestionar reserva')
            print('4. Gestionar mesas')
            print('5. Visualizar clientes')
            print('6. Salir')
            y = input('Ingrese qué desea realizar hoy: ')

            if y == '1':
                agregar_cliente()

            elif y == '2':
                agregar_pedido()

            elif y == '3':
                gestionar_reservas()

            elif y == '4':
                gestionar_mesas()

            elif y == '5':
                visualizar_clientes()

            elif y == '6':
                continuar3 = False

            else:
                print('Ingrese una opción correcta.')

    elif rol == 'Administrador':
        continuar5 = True
        while continuar5:
            print('1. Gestion de insumos basados en la sucursal')
            print('2. Reporteria')
            print('3. Control de cambios')
            print('4. Salir')
            x2 = input('Ingrese qué desea realizar hoy: ')

            if x2 == '1':
                agregar_cliente()

            elif x2 == '2':
                agregar_pedido()

            elif x2 == '3':
                gestionar_reservas()

            elif x2 == '4':
                gestionar_mesas()

            elif x2 == '5':
                visualizar_clientes()

            elif x2 == '6':
                continuar5 = False

            else:
                print('Ingrese una opción correcta.')

    elif rol == 'Gerente':
        continuar5 = True
        while continuar5:
            print('1. Agregar cliente')
            print('2. Agregar pedido')
            print('3. Gestionar reserva')
            print('4. Gestionar mesas')
            print('5. Visualizar clientes')
            print('6. Gestion de insumos de la sucursal a la que pertenece')
            print('7. Control de cambios de la sucursal')
            print('8. Salir')
            z = input('Ingrese qué desea realizar hoy: ')

            if z == '1':
                agregar_cliente()

            elif z == '2':
                agregar_pedido()

            elif z == '3':
                gestionar_reservas()

            elif z == '4':
                gestionar_mesas()

            elif z == '5':
                visualizar_clientes()

            elif z == '6':
                gestion_de_insumos()

            elif z == '7':
                visualizar_clientes()

            elif z == '8':
                continuar5 = False

            else:
                print('Ingrese una opción correcta.')
