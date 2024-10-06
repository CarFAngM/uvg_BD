import psycopg2

conn = None  

try:
    conn = psycopg2.connect("host=localhost dbname=proyecto_2 user=postgres password=Liceojavier2")
    conn.set_client_encoding('UTF8')
    cur = conn.cursor()
except psycopg2.Error as e:
    print(f"No se pudo conectar a la base de datos: {e}")

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
    fecha = input('Ingrese la fecha del pedido: ')
    cliente_id = input('Ingrese el id del cliente: ')
    sucursal_id = input('Ingrese el id de la sucursal: ')
    mesa_id = input('Ingrese la mesa de la sucursal que desea. Si no desea mesa ingrese NULL: ')
    cantidad = input('Ingrese la cantidad de platos que desea: ')
    total_pedido = input('Ingrese el monto del pedido: ')

    try:
        insert_pedido_query = """
        INSERT INTO pedido (fecha, total_pedido, cliente_id, sucursal_id, mesa_id) 
        VALUES (%s, %s, %s, %s, %s);
        """
        cur.execute(insert_pedido_query, (fecha, total_pedido, cliente_id, sucursal_id, mesa_id))
        conn.commit()
        print("Pedido registrado con éxito.")
    
    except psycopg2.Error as e:
        print(f"Error al registrar el pedido: {e}")
        conn.rollback()

def sign_in():
    correo = input("Escriba su correo: ")
    contraseña = input("Escriba su contraseña: ")

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
        print("Registro exitoso. Has sido registrado correctamente.")
    
    except psycopg2.Error as e:
        print(f"Error al registrar el usuario: {e}")
        conn.rollback()

def gestionar_reservas():
    continuar4 = True 

    while continuar4: 
        print('1. Crear reserva')
        print('2. Finalizar reserva')
        print('3. Salir')
        x2 = input('Ingrese su decisión: ')

        if x2 == '1':
            sucursal_id = input('Ingrese el ID de la sucursal: ')
            try:
                query_mesas_disponibles = """
                    SELECT mesa_id 
                    FROM mesa 
                    WHERE disponibilidad = TRUE and sucursal_id = %s ;
                """
                cur.execute(query_mesas_disponibles, (sucursal_id))
                mesas_disponibles = cur.fetchall()

                if mesas_disponibles:
                    print("Mesas disponibles:")
                    for mesa in mesas_disponibles:
                        print(f"Mesa ID: {mesa[0]}")
                else:
                    print("No hay mesas disponibles en este momento.")
                    continue  
            
            except psycopg2.Error as e:
                print(f"Error al obtener mesas disponibles: {e}")
                continue  

            fecha_reserva = input('Ingrese la fecha en la que desea reservar: ')
            mesa_id = input('Ingrese el ID de la mesa que desea reservar: ')
            cliente_id = input('Ingrese el ID del cliente: ')

            try:
                insert_reserva_query = """
                    INSERT INTO reserva (fecha_reserva, mesa_id, cliente_id, estado_reserva, sucursal_id) 
                    VALUES (%s, %s, %s, 'VIGENTE', %s) RETURNING reserva_id;
                """
                cur.execute(insert_reserva_query, (fecha_reserva, mesa_id, cliente_id, sucursal_id))
                conn.commit()
                print("Reserva creada exitosamente. ID de reserva:", cur.fetchone()[0])
            
            except psycopg2.Error as e:
                print(f"Error al registrar la reserva: {e}")
                conn.rollback()
            
        elif x2 == '2': 
            try:
                id_reserva = int(input('Ingrese el ID de la reserva: '))   
                sucursal_id = int(input('Ingrese su sucursal: '))
                
                update_reserva_query = """
                    UPDATE reserva
                    SET estado_reserva = 'FINALIZADA'
                    WHERE id_reserva = %s AND sucursal_id = %s;
                """
                cur.execute(update_reserva_query, (id_reserva, sucursal_id))
                conn.commit()
                print("Reserva finalizada correctamente.")

            except ValueError:
                print("Por favor, ingrese un número válido para el ID de reserva y sucursal.")
            except psycopg2.Error as e: 
                print(f"Error al finalizar la reserva: {e}")
                conn.rollback()

        elif x2 == '3': 
            continuar4 = False
        else: 
            print('Ingrese números del 1 al 3.')


def gestionar_mesas():
    print("Funcionalidad de gestionar mesas aún no implementada.")

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

def reporteria():
    print("Funcionalidad de reportería aún no implementada.")

def customer_history():
    print("Funcionalidad de historial de cliente aún no implementada.")

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
        print("Menú de Administrador aún no implementado.")


    elif rol == 'Gerente':
        print("Menú de Gerente aún no implementado.")
