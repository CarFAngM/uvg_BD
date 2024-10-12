from credenciales_base_datos import *

conn = conectar_base_de_datos()
cur = conn.cursor() if conn else None
global current_branch


# Funcion para obtener la sucursal de un usuario segun su correo

def get_sucursal_para_usuario(correo):
    try:
        query = ("SELECT sucursal_id FROM Sucursal_Usuario WHERE usuario_id = "
                 "(SELECT usuario_id FROM Usuario WHERE correo = %s LIMIT 1)")
        cur.execute(query, (correo,))
        resultado = cur.fetchone()
        if resultado:
            return resultado[0]
        else:
            print(f"No se encontró la sucursal para el usuario con correo: {correo}.")
            return None
    except psycopg2.Error as e:
        print(f"Error al obtener la sucursal para el usuario con correo {correo}: {e}")
        return None


# Funcion para iniciar sesion y obtener el rol del usuario

def log_in():
    correo = input("Escriba su correo: ")
    contrasena = input("Escriba su contraseña: ")

    try:
        query = """
            SELECT rol
            FROM usuario
            WHERE correo = %s AND contrasena = %s
        """
        cur.execute(query, (correo, contrasena))
        resultado = cur.fetchone()

        if resultado is None:
            print("Error: Correo o contraseña incorrectos.")
            return None
        else:
            rol = resultado[0]
            current_branch = get_sucursal_para_usuario(correo)
            if current_branch:
                print(f"Iniciaste sesión correctamente como {rol} en la sucursal {current_branch}.")
                return rol
            else:
                print("Error: No se pudo obtener la sucursal para el usuario.")
                return None

    except psycopg2.Error as e:
        print(f"Error al ejecutar la consulta: {e}")
        return None


# Funcion para registrar un nuevo usuario

def sign_up():
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


# Funcion para cerrar la conexion a la base de datos

def cerrar_conexion():
    if cur:
        cur.close()
    if conn:
        conn.close()
