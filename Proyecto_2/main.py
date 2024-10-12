from funciones_autenticacion import *
from menu_principal import desplegar_menu_por_rol

continue1 = True

# Inicio del programa
try:
    while continue1:
        print('Bienvenido al sistema gestor de Balbinos')
        print('1. Iniciar sesión')
        print('2. Registrar nuevo usuario')
        print('3. Salir')
        x = input('Ingrese su decisión: ')

        if x == '1':
            rol = log_in()
            if rol:
                desplegar_menu_por_rol(rol)
            else:
                print("Error: No se pudo iniciar sesión.")
        elif x == '2':
            sign_up()
        elif x == '3':
            continue1 = False
        else:
            print('Escriba un número entre 1 y 3.')

except Exception as e:
    print(f"Ha ocurrido un error: {e}")

finally:
    print("Cerrando la conexión a la base de datos...")
    cerrar_conexion()
    print("Gracias por usar el sistema gestor de Balbinos.")
