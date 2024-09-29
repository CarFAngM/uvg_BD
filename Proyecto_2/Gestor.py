import psycopg2

continue1 = True

conn = None  

try:
    
    conn = psycopg2.connect("host=localhost dbname=proyecto_2 user=postgres password=Liceojavier2")

  
    conn.set_client_encoding('UTF8')

    cur = conn.cursor()
except psycopg2.Error as e:
    print(f"Unable to connect to the database: {e}")


def sign_in_or_login():
    print("Sign in or log in function goes here.")

def reservation_management():
    print("Reservation management function goes here.")

def inventory_management():
    print("Inventory management function goes here.")

def customer_history():
    print("Customer history function goes here.")

def change_control():
    print("Change control function goes here.")

try:
    while continue1:
        print('Welcome to the management system of Balbinos')
        print('1. Sign in or login')
        print('2. Reservation Management')
        print('3. Inventory Management')
        print('4. Customer History')
        print('5. Change Control')
        print('6. Exit')
        
        x = input('What do you want to do today? \n')

        if x == '1':
            sign_in_or_login()

        elif x == '2':
            reservation_management()

        elif x == '3':
            inventory_management()

        elif x == '4':
            customer_history()

        elif x == '5':
            change_control()

        elif x == '6':
            continue1 = False  # Sale del ciclo while
            print('Exiting the system. Goodbye!')

        else:
            print('Invalid option. Please select a number between 1 and 6.')

except Exception as e:
    print(f"An error occurred: {e}")

finally:
    if conn:
        cur.close()
        conn.close()
