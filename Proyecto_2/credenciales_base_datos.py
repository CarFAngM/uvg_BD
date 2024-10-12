import psycopg2


# Función para conectar a la base de datos utilizando credenciales

def conectar_base_de_datos():
    try:
        conn = psycopg2.connect(host="localhost", dbname="proyecto_2", user="postgres", password="3125")
        conn.set_client_encoding('UTF8')
        return conn
    except psycopg2.Error as e:
        print(f"No se pudo conectar a la base de datos: {e}")
        return None
