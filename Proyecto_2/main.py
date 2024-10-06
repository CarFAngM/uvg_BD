import psycopg2

import funciones as f

continue1 = True

try:
    while continue1:
        print('Bienvenido al sistema gestor de Balbinos')
        print('1. Iniciar sesión (Sign in)')
        print('2. Registrarse (Log in)')
        print('3. Salir')
        x = input('Ingrese su decisión: ')

        if x == '1': 
            f.sign_in()
        elif x == '2': 
            f.log_in()
        elif x == '3': 
            continue1 = False
        else: 
            print('Escriba un número entre 1 y 3.')

except Exception as e:
    print(f"Ha ocurrido un error: {e}")

finally:
    print("Cerrando la conexión a la base de datos.")
