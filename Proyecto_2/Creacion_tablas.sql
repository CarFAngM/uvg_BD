-- Crear la tabla Sucursal
CREATE TABLE Sucursal (
    sucursal_id SERIAL PRIMARY KEY,
    nombre_sucursal VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(50) NOT NULL
);

-- Crear la tabla Usuario
CREATE TABLE Usuario (
    usuario_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    rol VARCHAR(50) NOT NULL,
    correo VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(80) NOT NULL,
    sucursal_id INT,
    FOREIGN KEY (sucursal_id) REFERENCES Sucursal(sucursal_id) ON DELETE CASCADE
);

-- Crear la tabla Cliente
CREATE TABLE Cliente (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    correo VARCHAR(50) NOT NULL UNIQUE,
    telefono VARCHAR(15)
);

-- Crear la tabla Mesa
CREATE TABLE Mesa (
    mesa_id SERIAL PRIMARY KEY,
    capacidad INT NOT NULL,
    ubicacion VARCHAR(50),
    disponibilidad BOOLEAN NOT NULL,
    sucursal_id INT,
    FOREIGN KEY (sucursal_id) REFERENCES Sucursal(sucursal_id) ON DELETE CASCADE
);

-- Crear la tabla Reserva
CREATE TABLE Reserva (
    reserva_id SERIAL PRIMARY KEY,
    fecha_reserva DATE NOT NULL,
    hora_reserva TIME NOT NULL,
    mesa_id INT,
    cliente_id INT,
    estado_reserva VARCHAR(50) NOT NULL,
    sucursal_id INT,
    FOREIGN KEY (mesa_id) REFERENCES Mesa(mesa_id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id) ON DELETE CASCADE,
    FOREIGN KEY (sucursal_id) REFERENCES Sucursal(sucursal_id) ON DELETE CASCADE
);

-- Crear la tabla Plato
CREATE TABLE Plato (
    plato_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    precio FLOAT NOT NULL CHECK (precio >= 0),
    descripcion VARCHAR(50)
);

-- Crear la tabla Insumo
CREATE TABLE Insumo (
    insumo_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    cantidad_disponible INT NOT NULL CHECK (cantidad_disponible >= 0),
    fecha_caducidad DATE,
    alerta_stock_bajo BOOLEAN NOT NULL,
    sucursal_id INT,
    FOREIGN KEY (sucursal_id) REFERENCES Sucursal(sucursal_id) ON DELETE CASCADE
);

-- Crear la tabla Ingrediente_Plato
CREATE TABLE Ingrediente_Plato (
    plato_id INT,
    insumo_id INT,
    cantidad_necesaria FLOAT NOT NULL CHECK (cantidad_necesaria > 0),
    PRIMARY KEY (plato_id, insumo_id),
    FOREIGN KEY (plato_id) REFERENCES Plato(plato_id) ON DELETE CASCADE,
    FOREIGN KEY (insumo_id) REFERENCES Insumo(insumo_id) ON DELETE CASCADE
);

-- Crear la tabla Pedido
CREATE TABLE Pedido (
    pedido_id SERIAL PRIMARY KEY,
    fecha_pedido DATE NOT NULL,
    total_pedido FLOAT NOT NULL,
    cliente_id INT,
    sucursal_id INT,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id) ON DELETE CASCADE,
    FOREIGN KEY (sucursal_id) REFERENCES Sucursal(sucursal_id) ON DELETE CASCADE
);

-- Crear la tabla Bitacora
CREATE TABLE Bitacora (
    bitacora_id SERIAL PRIMARY KEY,
    accion VARCHAR(50) NOT NULL,
    fecha_accion DATE NOT NULL,
    tabla_afectada VARCHAR(50) NOT NULL,
    usuario_id INT,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id) ON DELETE CASCADE
);
