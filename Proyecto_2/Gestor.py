import psycopg2

continue1 = True

conn = None  

try:
    conn = psycopg2.connect("host=localhost dbname=proyecto_2 user=postgres password=Liceojavier2")
  
    conn.set_client_encoding('UTF8')

    cur = conn.cursor()
except psycopg2.Error as e:
    print(f"No se pudo conectar a la base de datos {e}")

def agregar_cliente(): 
    nombre = input('Ingrese su nombre: ')
    correo = input('Ingrese su correo: ')
    telefono = input('Ingrese su teléfono: ')
    plato_favorito = input('Ingrese su plato favorito: ')

    try:
        insert_cliente_query = """
        INSERT INTO cliente (nombre, correo, telefono, plato_favorito) 
        VALUES (%s, %s, %s, %s);
        """
        cur.execute(insert_cliente_query, (nombre, correo, telefono, plato_favorito))

        conn.commit()
        print("Cliente registrado con éxito.")
    
    except psycopg2.Error as e:
        print(f"Error al registrar el cliente: {e}")
        conn.rollback() 

def agregar_pedido(): 
    fecha = input('Ingrese la fecha del pedido')
    cliente_id = input('Ingrese el id del cliente')
    sucursal_id = input('Ingrese el id de la sucursal')
    mesa_id = input('Ingrese la mesa de la sucursal que desea. Si no desea mesa ingrese NULL')
    cantidad = input('Ingrese la cantidad de platos que desea')
    total_pedido = input('Ingrese el monto del pedido')
 
    try:
        insert_pedido_query = """
        INSERT INTO pedido (fecha, total_pedido, cliente_id, sucursal_id, mesa_id) 
        VALUES (%s, %s, %s, %s, %s);
        """
        cur.execute(insert_pedido_query, (fecha, total_pedido, cliente_id, sucursal_id,mesa_id ))

        conn.commit()
        print("pedido registrado con éxito.")
    
    except psycopg2.Error as e:
        print(f"Error al registrar el pedido: {e}")
        conn.rollback() 

def sign_in():
    print("Sign in ")
    correo = input("write your email: ")
    contraseña = input("write your password:")

    try:
        query = "SELECT rol FROM usuario WHERE correo = %s AND contrasena = %s"
        cur.execute(query, (correo, contraseña))
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
    if rol == 'Mesero': 
        continuar3 = True
        while continuar3: 
            print ('1. Agregar cliente')
            print ('2. Agregar pedido')
            print ('3. Gestionar reserva')
            print ('4. Realizar reserva')
            print ('5. Gestionar mesas')
            print ('6. Visualizar clientes de la sucursal')
            print ('7. salir')
            y = input('Ingrese que desea realizar hoy') 

            if y == '1': 
                agregar_cliente() 

            elif y == '2': 
                pass 

            elif y == '3': 
                pass

            elif y == '4': 
                pass

            elif y == '5': 
                pass

            elif y == '6': 
                pass

            elif y == '7': 
                continuar3 = False

            else:
                print('Ingrese una decision correcta')

    if rol == 'Administrador': 
        pass

    if rol == 'Gerente': 
        pass

def log_in(): 
    nombre = input('Ingrese su nombre: ')
    correo = input('Ingrese su correo: ')
    contrasena = input('Ingrese su contraseña: ')
    rol = input('Ingrese su rol (Mesero, Administrador, Gerente): ')

    while rol not in ['Mesero', 'Administrador', 'Gerente']:
        print("Error: El rol ingresado no es válido. Debe ser 'Mesero', 'Administrador' o 'Gerente'.")
        rol = input('Ingrese su rol (Mesero, Administrador, Gerente): ')

    sucursal = None

    if rol != 'Administrador':
        sucursal = input('Ingrese su sucursal: ')

    try:
        insert_usuario_query = """
            INSERT INTO Usuario (nombre, rol, correo, contrasena) 
            VALUES (%s, %s, %s, %s) RETURNING usuario_id;
        """
        cur.execute(insert_usuario_query, (nombre, rol, correo, contrasena))
        usuario_id = cur.fetchone()[0]  
        
        if rol == 'Administrador':
            insert_usuario_sucursal_query = """
                INSERT INTO Sucursal_Usuario (sucursal_id, usuario_id) 
                VALUES (1, %s), (2, %s), (3, %s);
            """
            cur.execute(insert_usuario_sucursal_query, (usuario_id, usuario_id, usuario_id))
        else:
            insert_usuario_sucursal_query = """
                INSERT INTO Sucursal_Usuario (sucursal_id, usuario_id) 
                VALUES (%s, %s);
            """
            cur.execute(insert_usuario_sucursal_query, (sucursal, usuario_id))
        
        conn.commit()
        print("\n Registro exitoso. Has sido registrado correctamente. \n")
    
    except psycopg2.Error as e:
        print(f"Error al registrar el usuario: {e}")
        conn.rollback()  



def Crear_usuario():
    pass

def Realizar_pedido():
    pass

def customer_history():
    pass

def gestionar_reservas():
    pass

def reporteria():
    pass 

try:
    while continue1:
        print('Bienvenido al sistema gestor de balbinos')
        print('1. Sign in')
        print('2. log in')
        print('3. exit')
        x = input('ingrese su decision')
        if x == '1': 
            sign_in()
        elif x == '2': 
            log_in()
        elif x == '3': 
            continue1 = False
        else: 
            print('escribe un numero entre 1 y 3')

except Exception as e:
    print(f"ha ocurrido un error {e}")

finally:
    if conn:
        cur.close()
        conn.close()
