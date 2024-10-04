CREATE TABLE Usuario (
    usuario_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    rol VARCHAR(50),
    correo VARCHAR(50) UNIQUE,
    contrasena VARCHAR(50)
);

CREATE TABLE Bitacora (
    bitacora_id SERIAL PRIMARY KEY,
    accion VARCHAR(50),
    fecha_accion DATE,
    tabla_afectada VARCHAR(50),
    usuario_id INT REFERENCES Usuario(usuario_id)
);

CREATE TABLE Sucursal (
    sucursal_id SERIAL PRIMARY KEY,
    nombre_sucursal VARCHAR(50),
    ubicacion VARCHAR(50)
);

CREATE TABLE Sucursal_Usuario (
    sucursal_id INT REFERENCES Sucursal(sucursal_id),
    usuario_id INT REFERENCES Usuario(usuario_id),
    PRIMARY KEY (sucursal_id, usuario_id)
);

CREATE TABLE Cliente (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    correo VARCHAR(50) UNIQUE, 
    telefono VARCHAR(50),
    plato_favorito VARCHAR(50)
);

CREATE TABLE Mesa (
    mesa_id SERIAL PRIMARY KEY,
    capacidad INT,
    disponibilidad BOOLEAN,
    sucursal_id INT REFERENCES Sucursal(sucursal_id)
);

CREATE TABLE Reserva (
    reserva_id SERIAL PRIMARY KEY,
    fecha_reserva DATE,
    mesa_id INT REFERENCES Mesa(mesa_id),
    cliente_id INT REFERENCES Cliente(cliente_id),
    estado_reserva VARCHAR(50),
    sucursal_id INT REFERENCES Sucursal(sucursal_id)
);

CREATE TABLE Pedido (
    pedido_id SERIAL PRIMARY KEY,
    fecha_pedido DATE,
    total_pedido FLOAT,
    cliente_id INT REFERENCES Cliente(cliente_id),
    sucursal_id INT REFERENCES Sucursal(sucursal_id)
);

CREATE TABLE Plato (
    plato_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    precio FLOAT CHECK (precio >= 0),
    descripcion VARCHAR(50)
);

CREATE TABLE Pedido_Plato (
    pedido_id INT REFERENCES Pedido(pedido_id),
    plato_id INT REFERENCES Plato(plato_id),
    PRIMARY KEY (pedido_id, plato_id)
);

CREATE TABLE Insumo (
    insumo_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    cantidad_disponible INT,
    fecha_caducidad DATE,
    alerta_stock_bajo BOOLEAN,
    sucursal_id INT REFERENCES Sucursal(sucursal_id)
);

CREATE TABLE Insumo_Plato (
    insumo_id INT REFERENCES Insumo(insumo_id),
    plato_id INT REFERENCES Plato(plato_id),
    PRIMARY KEY (insumo_id, plato_id)
);

