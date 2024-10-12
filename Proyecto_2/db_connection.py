import psycopg2

def get_connection():
    try:
        conn = psycopg2.connect(
            host="localhost",
            dbname="proyecto_2",
            user="postgres",
            password="3125"
        )
        conn.set_client_encoding('UTF8')
        return conn
    except psycopg2.Error as e:
        print(f"No se pudo conectar a la base de datos: {e}")
        return None
