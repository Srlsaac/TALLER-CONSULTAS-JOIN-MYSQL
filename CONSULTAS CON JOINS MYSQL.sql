--- 16. SISTEMA DE GESTIÓN PARA SERVICIOS FINANCIEROS "BANKSYS"---

--- 1. Utiliza INNER JOIN con WHERE para encontrar todas las cuentas con saldo superior a cierto valor cuyos titulares tienen determinado nivel de riesgo.---

SELECT * FROM cuenta;
SELECT * FROM cliente;

SELECT c.nombre, c.nivel_riesgo,cu.numero, cu.saldo
FROM cliente c
INNER JOIN cuenta cu ON cu.id_cliente= c.id_cliente 
WHERE cu.saldo> 5000000 AND c.nivel_riesgo='bajo';

--- 2. Aplica LEFT JOIN con ORDER BY para listar todos los clientes y sus productos contratados (si los tienen) ordenados por patrimonio estimado.---

SELECT * FROM producto;
SELECT * FROM cliente;

SELECT c.nombre, c.patrimonio, p.nombre
FROM cliente c 
LEFT JOIN solicitud s ON c.id_cliente=s.id_cliente
LEFT JOIN producto p ON p.id_producto=s.id_producto
ORDER BY c.patrimonio;

--- 3. Usa RIGHT JOIN con GROUP BY y HAVING para encontrar productos crediticios con más de 50 solicitudes mensuales y calcular la tasa de aprobación. ---
 SELECT * FROM producto;
SELECT * FROM solicitud;

 SELECT p.nombre, COUNT(s.id_solicitud) AS total_solicitudes
 FROM producto p 
 RIGHT JOIN solicitud s ON p.id_producto=s.id_producto
 GROUP BY p.nombre 
 HAVING COUNT(s.id_solicitud) > 1
 
 --- 4. Implementa INNER JOIN múltiple con BETWEEN para listar transacciones realizadas en un período específico junto con los datos de la cuenta, cliente y canal utilizado.---
 
 SELECT t.codigo,t.fecha_hora,t.canal,t.monto,cu.numero,c.nombre
 FROM transaccion t
 INNER JOIN cuenta cu ON t.id_cuenta_origen= cu.id_cuenta
 INNER JOIN cliente c ON cu.id_cliente = c.id_cliente
 WHERE t.fecha_hora BETWEEN '2026-03-01' AND '2026-03-15';
 
 --- 5. Combina LEFT JOIN con IS NULL para identificar clientes que no tienen ningún producto de inversión contratado.---
 
 SELECT c.nombre, p.nombre
 FROM cliente c
 LEFT JOIN solicitud s ON s.id_cliente= c.id_cliente
 LEFT JOIN producto p ON p.id_producto=s.id_producto 
 AND p.tipo = 'empresarial'
 WHERE p.id_producto IS NULL;
 
 --- 6. Utiliza INNER JOIN con IN para encontrar empleados que han autorizado transacciones de ciertos montos específicos.---

SELECT em.nombres, t.monto 
FROM empleado em
INNER JOIN transaccion t  ON em.id_empleado=t.id_empleado
WHERE t.monto IN (500000,2000000) 

--- 7. Aplica JOIN con función de agregación SUM y GROUP BY para calcular el volumen total de transacciones por sucursal y tipo.---
 
 SELECT s.nombre,t.tipo,SUM(t.monto) AS total 
 FROM transaccion t
 INNER JOIN cuenta c ON t.id_cuenta_origen = c.id_cuenta
 INNER JOIN sucursal s ON s.id_sucursal= c.id_sucursal
 GROUP BY s.nombre, t.tipo;
 
 -- 8. Usa INNER JOIN con LIKE para encontrar clientes con ciertos patrones en su dirección, junto con sus cuentas asociadas. ---

 SELECT c.nombre, c.direccion,cu.numero,cu.tipo,cu.saldo
 FROM cliente c 
 INNER JOIN cuenta cu ON c.id_cliente=cu.id_cliente 
 WHERE c.direccion LIKE 'calle%';
 
 --- 9. Implementa JOIN múltiple con subconsulta para identificar las sucursales con volumen de créditos superior al promedio para su zona geográfica. ---
 
 SELECT s.nombre,s.latitud, SUM(cr.monto) AS total_creditos
 FROM sucursal s
 INNER JOIN cuenta cu ON s.id_sucursal= cu.id_sucursal
 INNER JOIN solicitud so ON so.id_cliente=cu.id_cliente
 INNER JOIN credito cr ON cr.id_solicitud=so.id_solicitud
 GROUP BY s.nombre, s.latitud
 HAVING SUM(cr.monto) > (SELECT AVG(monto) FROM credito)
 
 --- 10. Combina LEFT JOIN con función de fecha para listar créditos con vencimiento de cuota en los próximos 15 días junto con los datos del cliente, incluso si no tienen ---
 
SELECT cr.numero,cr.proximo_vencimiento,cr.estado,c.nombre,c.telefono,c.correo
from credito cr 
LEFT JOIN solicitud so ON cr.id_solicitud=so.id_solicitud
LEFT JOIN cliente c ON so.id_cliente=c.id_cliente
WHERE cr.proximo_vencimiento >= '2026-04-01' AND cr.proximo_vencimiento <= '2026-04-16'
