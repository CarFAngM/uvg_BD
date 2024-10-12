import psycopg2

import connection as c
import auth as a
import admin_functions as af
import gerente_functions as gf
import mesero_functions as mf


continue1 = True

try:
    while continue1:
        print('Bienvenido al sistema gestor de Balbinos')
        print('1. Iniciar sesión (Sign in)')
        print('2. Registrarse (Log in)')
        print('3. Salir')
        x = input('Ingrese su decisión: ')

        if x == '1': 
            a.sign_in()
        elif x == '2': 
            a.log_in()
        elif x == '3': 
            continue1 = False
        else: 
            print('Escriba un número entre 1 y 3.')

except Exception as e:
    print(f"Ha ocurrido un error: {e}")

finally:
    print("Cerrando la conexión a la base de datos.")
