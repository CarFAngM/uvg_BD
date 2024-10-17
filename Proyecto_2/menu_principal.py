from funciones_administrador import *
from funciones_gerente import *
from funciones_mesero import *


# Funcion para mostrar un menu de opciones segun el rol del usuario.

def desplegar_menu_por_rol(rol):
    if rol == 'Mesero':
        continuar = True
        while continuar:
            print('1. Agregar cliente')
            print('2. Agregar pedido')
            print('3. Gestionar reserva')
            print('4. Gestionar mesas')
            print('5. Visualizar clientes')
            print('6. Salir')
            opcion = input('Ingrese qué desea realizar hoy: ')

            if opcion == '1':
                agregar_cliente()
            elif opcion == '2':
                agregar_pedido()
            elif opcion == '3':
                gestionar_reservas()
            elif opcion == '4':
                gestionar_mesas()
            elif opcion == '5':
                visualizar_clientes()
            elif opcion == '6':
                continuar = False
            else:
                print('Ingrese una opción correcta.')

    elif rol == 'Administrador':
        continuar = True
        while continuar:
            print('1. Gestionar los insumos de una sucursal')
            print('2. Ver un reporte de una sucursal')
            print('3. Ver un control de cambios de una sucursal')
            print('4. Salir')
            opcion = input('Ingrese qué desea realizar hoy: ')

            if opcion == '1':
                gestion_de_insumos_administrador()
            elif opcion == '2':
                reporteria_administrador()
            elif opcion == '3':
                control_de_cambios_administrador()
            elif opcion == '4':
                continuar = False
            else:
                print('Ingrese una opción correcta.')

    elif rol == 'Gerente':
        continuar = True
        while continuar:
            print('1. Agregar cliente')
            print('2. Agregar pedido')
            print('3. Gestionar reserva')
            print('4. Gestionar mesas')
            print('5. Visualizar clientes')
            print('6. Gestión de insumos de su sucursal')
            print('7. Control de cambios de su sucursal')
            print('8. Generar reporte de su sucursal')
            print('9. Salir')
            opcion = input('Ingrese qué desea realizar hoy: ')

            if opcion == '1':
                agregar_cliente()
            elif opcion == '2':
                agregar_pedido()
            elif opcion == '3':
                gestionar_reservas()
            elif opcion == '4':
                gestionar_mesas()
            elif opcion == '5':
                visualizar_clientes()
            elif opcion == '6':
                gestion_de_insumos_gerente()
            elif opcion == '7':
                control_de_cambios_gerente()
            elif opcion == '8':
                reporteria_gerente()
            elif opcion == '9':
                continuar = False
            else:
                print('Ingrese una opción correcta.')
