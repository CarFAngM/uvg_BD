-- CREACION DE INDICES. 

-- indice por frecuencia de consultas al ver platos mas pedidos 
CREATE INDEX PEDIDO_PLATO_INDICE 
ON pedido_plato (plato_id);

-- indice para ver que tan frecuente pide un cliente en el restaurante ahorrando tiempo valioso
CREATE INDEX indx_pedido
ON pedido (cliente_id,sucursal_id);

-- indice para ver frecuencia de reservas
CREATE INDEX indx_reserva
ON reserva (cliente_id,sucursal_id);
