# Sistema de Gestión para Balbinos Pizzeria 

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)

Sistema de gestión para la cadena de restaurantes **Balbinos Pizzeria**, desarrollado con Python y PostgreSQL para optimizar reservas, inventario, pedidos y reportes.

## Características Principales

- ** Gestión de clientes** (registro, historial, preferencias)
- ** Reservas de mesas** (creación, finalización, disponibilidad automática)
- ** Control de inventario** (alertas de stock bajo y caducidad)
- ** Pedidos** (registro, asociación con mesas/clientes)
- ** Reportes** (platos más vendidos, clientes frecuentes)
- ** Bitácora** (registro de acciones para auditoría)

##  Roles de Usuario

| Rol            | Funcionalidades                                                                 |
|----------------|---------------------------------------------------------------------------------|
| **Administrador** | Gestión de insumos, historial de clientes, reportes avanzados, control de cambios |
| **Gerente**      | ABM de clientes, pedidos, reservas, reportes por sucursal                        |
| **Mesero**       | Registro de clientes, toma de pedidos, gestión básica de reservas                |

## Tecnologías Utilizadas

- **Python 3.x** + **psycopg2** (conexión a PostgreSQL)
- **PostgreSQL** (base de datos relacional)
- **GitHub** (control de versiones)

## Diseño relacion en el archivo 

![Diagrama de Base de Datos](/Proyecto_2/mermaid-diagram-2024-10-16-225230.png)

## Requisitos:

- instalar la libreria

``` bash
bash pip install psycopg2
```

Configuración DB:

- Restaurar backup de PostgreSQL incluido
- Actualizar credenciales en config.py

Ejecución:

```bash
python main.py
```

## Archivos Clave

| Archivo                  | Descripción                                  |
|--------------------------|---------------------------------------------|
| `Creación_tablas.sql`    | Script SQL para estructura de la base de datos |
| `triggers_proyecto2.sql` | Triggers para automatización de procesos    |
| `Indices_proyecto2.sql`  | Índices para optimización de consultas      |

## Notas Adicionales
- Triggers para auto-gestión de mesas
- Reportes periódicos automatizados
- Índices estratégicos para optimización de busquedas. 

## Desarrolladores

• Carlos Magaña  (CarFAngM)
• Jorge Chupina  (yosemm)
• Derick Delva  
• Jose Alejandro Anton (Anton17303)


