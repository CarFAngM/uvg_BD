from db_connection import get_connection
from auth import get_sucursal_para_usuario
import psycopg2

conn = get_connection()
cur = conn.cursor() if conn else None

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

# Otras funciones para mesero
