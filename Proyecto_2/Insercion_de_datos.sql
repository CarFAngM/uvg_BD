INSERT INTO Sucursal (nombre_sucursal, ubicacion) VALUES
('Sucursal Centro', 'Zona 1'),
('Sucursal Norte', 'Zona 4'),
('Sucursal Sur', 'Zona 12');

-- Inserts de usuarios
INSERT INTO Usuario (nombre, rol, correo, contrasena) VALUES
('Juan', 'Gerente', 'juan@sucursal.com', 'contrasena1'),
('Pedro', 'Administrador', 'pedro@sucursal.com', 'contrasena2'),
('Carlos', 'Mesero', 'carlos@sucursal.com', 'contrasena3');

-- Relación Sucursal-Usuario
INSERT INTO Sucursal_Usuario (sucursal_id, usuario_id) VALUES
(1, 1), -- Gerente asignado a Sucursal Centro
(2, 3), -- Mesero asignado a Sucursal Norte
(1, 2), (2, 2), (3, 2); -- Administrador tiene acceso a las 3 sucursales

-- Inserts de mesas para cada sucursal

-- Inserts de mesas con la misma capacidad para cada sucursal (capacidad = 4)
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 1);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 1);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 1);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 1);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 1);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 1);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 1);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 1);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 1);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 1);

INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 2);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 2);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 2);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 2);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 2);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 2);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 2);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 2);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 2);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 2);

INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 3);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 3);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 3);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 3);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 3);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 3);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 3);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 3);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 3);
INSERT INTO Mesa (capacidad, disponibilidad, sucursal_id) VALUES (4, TRUE, 3);

-- Inserts de insumos
INSERT INTO Insumo (nombre, cantidad_disponible, fecha_caducidad, alerta_stock_bajo, sucursal_id) VALUES
('Tomato Sauce', 85, '2024-12-31', FALSE, 1),
('Mozzarella', 90, '2024-12-31', FALSE, 1),
('Basil', 40, '2024-11-15', FALSE, 1),
('Bread', 95, '2024-12-31', FALSE, 1),
('Pepperoni', 85, '2024-12-01', FALSE, 1),
('BBQ Sauce', 20, '2024-10-31', TRUE, 1),
('Grilled Chicken', 87, '2024-10-15', FALSE, 1),
('Red Onions', 88, '2024-10-05', FALSE, 1),
('Bell Peppers', 80, '2024-09-30', FALSE, 1),
('Olives', 50, '2024-11-20', FALSE, 1),
('Ham', 90, '2024-11-30', FALSE, 1),
('Pineapple', 85, '2024-11-05', FALSE, 1),
('Cheddar', 82, '2024-12-15', FALSE, 1),
('Parmesan', 87, '2024-12-10', FALSE, 1),
('Blue Cheese', 15, '2024-11-01', TRUE, 1),
('Sausage', 90, '2024-12-31', FALSE, 1),
('Bacon', 92, '2024-12-25', FALSE, 1),
('Buffalo Sauce', 70, '2024-10-30', FALSE, 1),
('Ground Beef', 50, '2024-11-10', FALSE, 1),
('Jalapeños', 88, '2024-10-25', FALSE, 1),
('Spinach', 20, '2024-09-28', TRUE, 1),
('Feta Cheese', 40, '2024-11-05', FALSE, 1),
('Truffle Oil', 85, '2025-01-01', FALSE, 1),
('Mushrooms', 95, '2024-10-15', FALSE, 1),
('Pesto Sauce', 50, '2024-11-20', FALSE, 1),
('Sun-Dried Tomatoes', 80, '2024-12-01', FALSE, 1),
('Salsa', 92, '2024-11-25', FALSE, 1),
('Shrimp', 87, '2024-10-10', FALSE, 1),
('Scallops', 40, '2024-10-15', FALSE, 1),
('Garlic', 90, '2024-10-25', FALSE, 1);

-- sucursal 2
INSERT INTO Insumo (nombre, cantidad_disponible, fecha_caducidad, alerta_stock_bajo, sucursal_id) VALUES
('Tomato Sauce', 70, '2024-12-31', FALSE, 2),
('Mozzarella', 65, '2024-12-31', FALSE, 2),
('Basil', 25, '2024-11-15', FALSE, 2),
('Bread', 80, '2024-12-31', FALSE, 2),
('Pepperoni', 75, '2024-12-01', FALSE, 2),
('BBQ Sauce', 18, '2024-10-31', TRUE, 2),
('Grilled Chicken', 60, '2024-10-15', FALSE, 2),
('Red Onions', 65, '2024-10-05', FALSE, 2),
('Bell Peppers', 70, '2024-09-30', FALSE, 2),
('Olives', 45, '2024-11-20', FALSE, 2),
('Ham', 80, '2024-11-30', FALSE, 2),
('Pineapple', 65, '2024-11-05', FALSE, 2),
('Cheddar', 62, '2024-12-15', FALSE, 2),
('Parmesan', 65, '2024-12-10', FALSE, 2),
('Blue Cheese', 12, '2024-11-01', TRUE, 2),
('Sausage', 70, '2024-12-31', FALSE, 2),
('Bacon', 75, '2024-12-25', FALSE, 2),
('Buffalo Sauce', 60, '2024-10-30', FALSE, 2),
('Ground Beef', 40, '2024-11-10', FALSE, 2),
('Jalapeños', 70, '2024-10-25', FALSE, 2),
('Spinach', 18, '2024-09-28', TRUE, 2),
('Feta Cheese', 30, '2024-11-05', FALSE, 2),
('Truffle Oil', 75, '2025-01-01', FALSE, 2),
('Mushrooms', 85, '2024-10-15', FALSE, 2),
('Pesto Sauce', 45, '2024-11-20', FALSE, 2),
('Sun-Dried Tomatoes', 70, '2024-12-01', FALSE, 2),
('Salsa', 85, '2024-11-25', FALSE, 2),
('Shrimp', 75, '2024-10-10', FALSE, 2),
('Scallops', 35, '2024-10-15', FALSE, 2),
('Garlic', 80, '2024-10-25', FALSE, 2);

-- Sucursal 3
INSERT INTO Insumo (nombre, cantidad_disponible, fecha_caducidad, alerta_stock_bajo, sucursal_id) VALUES
('Tomato Sauce', 90, '2024-12-31', FALSE, 3),
('Mozzarella', 95, '2024-12-31', FALSE, 3),
('Basil', 45, '2024-11-15', FALSE, 3),
('Bread', 100, '2024-12-31', FALSE, 3),
('Pepperoni', 95, '2024-12-01', FALSE, 3),
('BBQ Sauce', 22, '2024-10-31', TRUE, 3),
('Grilled Chicken', 95, '2024-10-15', FALSE, 3),
('Red Onions', 92, '2024-10-05', FALSE, 3),
('Bell Peppers', 85, '2024-09-30', FALSE, 3),
('Olives', 55, '2024-11-20', FALSE, 3),
('Ham', 95, '2024-11-30', FALSE, 3),
('Pineapple', 90, '2024-11-05', FALSE, 3),
('Cheddar', 90, '2024-12-15', FALSE, 3),
('Parmesan', 92, '2024-12-10', FALSE, 3),
('Blue Cheese', 18, '2024-11-01', TRUE, 3),
('Sausage', 95, '2024-12-31', FALSE, 3),
('Bacon', 98, '2024-12-25', FALSE, 3),
('Buffalo Sauce', 75, '2024-10-30', FALSE, 3),
('Ground Beef', 55, '2024-11-10', FALSE, 3),
('Jalapeños', 92, '2024-10-25', FALSE, 3),
('Spinach', 25, '2024-09-28', TRUE, 3),
('Feta Cheese', 50, '2024-11-05', FALSE, 3),
('Truffle Oil', 90, '2025-01-01', FALSE, 3),
('Mushrooms', 100, '2024-10-15', FALSE, 3),
('Pesto Sauce', 55, '2024-11-20', FALSE, 3),
('Sun-Dried Tomatoes', 90, '2024-12-01', FALSE, 3),
('Salsa', 95, '2024-11-25', FALSE, 3),
('Shrimp', 95, '2024-10-10', FALSE, 3),
('Scallops', 45, '2024-10-15', FALSE, 3),
('Garlic', 95, '2024-10-25', FALSE, 3);



-- Inserts para la tabla Insumo_Plato (relación entre insumos y platos)

-- Inserts para la tabla Plato
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Margherita', 8.99, 'Tomato Sauce, Mozzarella, Basil, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Pepperoni', 9.99, 'Tomato Sauce, Mozzarella, Pepperoni, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('BBQ Chicken', 10.99, 'BBQ Sauce, Grilled Chicken, Red Onions, Mozzarella, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Veggie', 9.49, 'Tomato Sauce, Mozzarella, Bell Peppers, Onions, Olives, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Hawaiian', 10.49, 'Tomato Sauce, Mozzarella, Ham, Pineapple, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Four Cheese', 11.49, 'Tomato Sauce, Mozzarella, Cheddar, Parmesan, Blue Cheese, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Meat Lover’s', 12.99, 'Tomato Sauce, Mozzarella, Pepperoni, Sausage, Ham, Bacon, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Buffalo Chicken', 10.99, 'Buffalo Sauce, Grilled Chicken, Mozzarella, Red Onions, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Mexican Pizza', 11.49, 'Salsa, Mozzarella, Ground Beef, Jalapeños, Red Onions, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Spinach & Feta', 9.99, 'White Sauce, Mozzarella, Spinach, Feta Cheese, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Caprese', 9.49, 'Tomato Sauce, Mozzarella, Fresh Tomato Slices, Basil, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Truffle Mushroom', 12.49, 'White Sauce, Mozzarella, Truffle Oil, Mushrooms, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Pesto Chicken', 11.49, 'Pesto Sauce, Grilled Chicken, Mozzarella, Sun-Dried Tomatoes, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Greek Pizza', 10.49, 'Tomato Sauce, Mozzarella, Feta Cheese, Olives, Red Onions, Bread');
INSERT INTO Plato (nombre, precio, descripcion) VALUES ('Seafood Delight', 13.99, 'White Sauce, Mozzarella, Shrimp, Scallops, Garlic, Bread');





-- Margherita
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (1, 1); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 1); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (3, 1); -- Basil
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 1); -- Bread

-- Pepperoni
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (1, 2); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 2); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (5, 2); -- Pepperoni
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 2); -- Bread

-- BBQ Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (6, 3); -- BBQ Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (7, 3); -- Grilled Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (8, 3); -- Red Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 3); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 3); -- Bread

-- Veggie
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (1, 4); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 4); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (9, 4); -- Bell Peppers
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (8, 4); -- Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (10, 4); -- Olives
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 4); -- Bread

-- Hawaiian
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (1, 5); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 5); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (11, 5); -- Ham
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (12, 5); -- Pineapple
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 5); -- Bread

-- Four Cheese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (1, 6); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 6); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (13, 6); -- Cheddar
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (14, 6); -- Parmesan
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (15, 6); -- Blue Cheese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 6); -- Bread

-- Meat Lover’s
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (1, 7); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 7); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (5, 7); -- Pepperoni
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (16, 7); -- Sausage
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (11, 7); -- Ham
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (17, 7); -- Bacon
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 7); -- Bread

-- Buffalo Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (18, 8); -- Buffalo Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (7, 8); -- Grilled Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 8); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (8, 8); -- Red Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 8); -- Bread

-- Mexican Pizza
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (19, 9); -- Salsa
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 9); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (20, 9); -- Ground Beef
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (21, 9); -- Jalapeños
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (8, 9); -- Red Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 9); -- Bread

-- Spinach & Feta
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (22, 10); -- White Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 10); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (23, 10); -- Spinach
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (24, 10); -- Feta Cheese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 10); -- Bread

-- Caprese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (1, 11); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 11); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (25, 11); -- Fresh Tomato Slices
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (3, 11); -- Basil
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 11); -- Bread

-- Truffle Mushroom
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (22, 12); -- White Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 12); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (26, 12); -- Truffle Oil
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (27, 12); -- Mushrooms
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 12); -- Bread

-- Pesto Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (28, 13); -- Pesto Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (7, 13); -- Grilled Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 13); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (29, 13); -- Sun-Dried Tomatoes
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 13); -- Bread

-- Greek Pizza
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (1, 14); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (2, 14); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (24, 14); -- Feta Cheese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (10, 14); -- Olives
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (8, 14); -- Red Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (4, 14); -- Bread


-- SUCURSAL 2


-- Margherita
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (31, 1); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 1); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (33, 1); -- Basil
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 1); -- Bread

-- Pepperoni
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (31, 2); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 2); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (35, 2); -- Pepperoni
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 2); -- Bread

-- BBQ Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (36, 3); -- BBQ Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (37, 3); -- Grilled Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (38, 3); -- Red Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 3); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 3); -- Bread

-- Veggie
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (31, 4); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 4); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (39, 4); -- Bell Peppers
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (38, 4); -- Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (40, 4); -- Olives
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 4); -- Bread

-- Hawaiian
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (31, 5); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 5); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (41, 5); -- Ham
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (42, 5); -- Pineapple
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 5); -- Bread

-- Four Cheese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (31, 6); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 6); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (43, 6); -- Cheddar
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (44, 6); -- Parmesan
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (45, 6); -- Blue Cheese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 6); -- Bread

-- Meat Lover’s
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (31, 7); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 7); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (35, 7); -- Pepperoni
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (46, 7); -- Sausage
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (41, 7); -- Ham
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (47, 7); -- Bacon
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 7); -- Bread

-- Buffalo Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (48, 8); -- Buffalo Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (37, 8); -- Grilled Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 8); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (38, 8); -- Red Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 8); -- Bread

-- Mexican Pizza
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (49, 9); -- Salsa
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 9); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (50, 9); -- Ground Beef
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (51, 9); -- Jalapeños
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (38, 9); -- Red Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 9); -- Bread

-- Spinach & Feta
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (52, 10); -- White Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 10); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (53, 10); -- Spinach
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (54, 10); -- Feta Cheese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 10); -- Bread

-- Caprese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (31, 11); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 11); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (55, 11); -- Fresh Tomato Slices
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (33, 11); -- Basil
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 11); -- Bread

-- Truffle Mushroom
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (52, 12); -- White Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 12); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (56, 12); -- Truffle Oil
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (57, 12); -- Mushrooms
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 12); -- Bread

-- Pesto Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (58, 13); -- Pesto Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (37, 13); -- Grilled Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 13); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (59, 13); -- Sun-Dried Tomatoes
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 13); -- Bread

-- Greek Pizza
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (31, 14); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (32, 14); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (54, 14); -- Feta Cheese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (40, 14); -- Olives
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (38, 14); -- Red Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (34, 14); -- Bread




-- SUCURSAL 3 

-- Margherita
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (61, 1); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 1); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (63, 1); -- Basil
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 1); -- Bread

-- Pepperoni
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (61, 2); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 2); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (65, 2); -- Pepperoni
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 2); -- Bread

-- BBQ Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (66, 3); -- BBQ Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (67, 3); -- Grilled Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (68, 3); -- Red Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 3); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 3); -- Bread

-- Veggie
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (61, 4); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 4); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (69, 4); -- Bell Peppers
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (68, 4); -- Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (70, 4); -- Olives
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 4); -- Bread

-- Hawaiian
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (61, 5); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 5); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (71, 5); -- Ham
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (72, 5); -- Pineapple
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 5); -- Bread

-- Four Cheese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (61, 6); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 6); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (73, 6); -- Cheddar
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (74, 6); -- Parmesan
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (75, 6); -- Blue Cheese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 6); -- Bread

-- Meat Lover’s
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (61, 7); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 7); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (65, 7); -- Pepperoni
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (76, 7); -- Sausage
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (71, 7); -- Ham
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (77, 7); -- Bacon
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 7); -- Bread

-- Buffalo Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (78, 8); -- Buffalo Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (67, 8); -- Grilled Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 8); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (68, 8); -- Red Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 8); -- Bread

-- Mexican Pizza
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (79, 9); -- Salsa
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 9); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (80, 9); -- Ground Beef
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (81, 9); -- Jalapeños
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (68, 9); -- Red Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 9); -- Bread

-- Spinach & Feta
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (82, 10); -- White Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 10); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (83, 10); -- Spinach
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (84, 10); -- Feta Cheese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 10); -- Bread

-- Caprese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (61, 11); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 11); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (85, 11); -- Fresh Tomato Slices
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (63, 11); -- Basil
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 11); -- Bread

-- Truffle Mushroom
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (82, 12); -- White Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 12); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (86, 12); -- Truffle Oil
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (87, 12); -- Mushrooms
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 12); -- Bread

-- Pesto Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (88, 13); -- Pesto Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (67, 13); -- Grilled Chicken
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 13); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (89, 13); -- Sun-Dried Tomatoes
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 13); -- Bread

-- Greek Pizza
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (61, 14); -- Tomato Sauce
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (62, 14); -- Mozzarella
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (84, 14); -- Feta Cheese
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (70, 14); -- Olives
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (68, 14); -- Red Onions
INSERT INTO Insumo_Plato (insumo_id, plato_id) VALUES (64, 14); -- Bread


