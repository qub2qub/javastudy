SELECT type, price, avg(price) FROM comp.printer ORDER BY type;

SELECT 'ALL PRINTERS' AS ALL_TABLE, avg(price) FROM comp.printer;

SELECT type, avg(price) FROM comp.printer GROUP BY type
HAVING avg(price) > 300;

