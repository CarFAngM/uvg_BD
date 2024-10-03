import psycopg2

continue1 = True

conn = None  

try:
    
    conn = psycopg2.connect("host=localhost dbname=proyecto_2 user=postgres password=Liceojavier2")

  
    conn.set_client_encoding('UTF8')

    cur = conn.cursor()
except psycopg2.Error as e:
    print(f"Unable to connect to the database: {e}")


def sign_in():
    print("Sign in ")
    email = input("write your email: ")
    password = input("write your password:")

    try:
        query = "SELECT rol FROM usuarios WHERE correo = %s AND contrasena = %s"
        cur.execute(query, (correo, contrasena))
        resultado = cur.fetchone()
        
        if resultado is None:
            print("Error: Correo o contraseña incorrectos.")
        else:
            rol = resultado[0]
            print(f"Iniciaste sesión correctamente como {rol}.")
            desplegar_menu_por_rol(rol)
    
    except psycopg2.Error as e:
        print(f"Error al ejecutar la consulta: {e}")

def desplegar_menu_por_rol(rol): 
    if rol == 'empleado': 
        pass

    if rol == 'gerente': 
        pass

    if rol == 'trabajador': 
        pass

def log_in(): 
    print('Log in')

def reservation_management():
    print("Reservation management ")

def inventory_management():
    print("Inventory management ")

def customer_history():
    print("Customer history ")

def change_control():
    print("Change control ")

try:
    while continue1:
        print('Welcome to the management system of Balbinos')
        print('1. Sign in')
        print('2. log in')
        print('3. exit')
        x = input('choose your option:')
        if x == '1': 
            sign_in()
        elif x == '2': 
            log_in()
        elif x == '3': 
            continue1 = False
        else: 
            print('write a numbrer between 1 and 3')


except Exception as e:
    print(f"An error occurred: {e}")

finally:
    if conn:
        cur.close()
        conn.close()
