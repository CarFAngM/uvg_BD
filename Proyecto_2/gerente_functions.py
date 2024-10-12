from auth import get_sucursal_para_usuario
from db_connection import get_connection
import psycopg2

conn = get_connection()
cur = conn.cursor() if conn else None

def visualizar_clientes():
    nombre = input('Ingrese el nombre del cliente: ')
    correo = input('Ingrese el correo del cliente: ')

    try:
        query = "SELECT * FROM cliente WHERE nombre = %s AND correo = %s"
        cur.execute(query, (nombre, correo))
        resultado = cur.fetchone()

        if resultado:
            print("Datos del cliente:", resultado)
        else:
            print("No se encontró ningún cliente con ese nombre y correo.")
        
    except psycopg2.Error as e:
        print(f"Error al ejecutar la consulta: {e}")

# Otras funciones para gerente
