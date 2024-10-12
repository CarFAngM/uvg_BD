import psycopg2

from db_connection import get_connection

conn = get_connection()
cur = conn.cursor() if conn else None

current_branch = None


def get_sucursal_para_usuario():
    global current_branch
    if current_branch:
        return current_branch
    else:
        return input('Ingrese el id de la sucursal (Administrador): ')


def sign_in():
    global current_branch
    correo = input("Escriba su correo: ")
    contrasena = input("Escriba su contraseña: ")

    try:
        query = """
            SELECT rol, sucursal_id
            FROM usuario
            JOIN sucursal_usuario ON usuario.usuario_id = sucursal_usuario.usuario_id
            WHERE correo = %s AND contrasena = %s
        """
        cur.execute(query, (correo, contrasena))
        resultado = cur.fetchone()

        if resultado is None:
            print("Error: Correo o contraseña incorrectos.")
            return None
        else:
            rol, sucursal_id = resultado
            current_branch = sucursal_id
            print(f"Iniciaste sesión correctamente como {rol} en la sucursal {current_branch}.")
            return rol

    except psycopg2.Error as e:
        print(f"Error al ejecutar la consulta: {e}")
        return None


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
