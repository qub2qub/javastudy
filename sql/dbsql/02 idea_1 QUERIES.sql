-- pc.title category, p.title, p.price, p.description
-- SELECT * FROM test.product p INNER JOIN test.category pc ON p.product_category_id = pc.id
-- select * from test.product where id not in (2, 3, 4) and price BETWEEN 400 and 999;
-- SELECT DISTINCT speed, ram, price FROM comp.pc WHERE price < '$500.00' ORDER BY ram DESC, speed ASC
-- SELECT * FROM comp.pc WHERE ram - 128 > 0
-- SELECT * FROM comp.printer WHERE color <> 'y'

-- for SELECT DISTINCT, ORDER BY expressions must appear in select list
-- SELECT DISTINCT model FROM comp.pc ORDER BY price

-- column "pc.price" must appear in the GROUP BY clause or be used in an aggregate function
-- SELECT model FROM comp.pc GROUP BY model ORDER BY price
-- SELECT model FROM comp.pc GROUP BY model ORDER BY MAX(price)
-- select date from ships.battles ORDER BY date
-- SELECT date, to_char(date, 'mm-dd') FROM ships.battles
-- select date from ships.battles ORDER BY to_char(date, 'mm-dd');
-- SELECT maker, model, type FROM comp.product
-- WHERE NOT type='PC'  AND maker='A'; --OR type='Printer';
-- WHERE type='PC'  AND maker='A' OR maker = 'B';
-- select * from comp.pc where
--   price between '$200.00' and '$400.00'
-- hd in (10, 20) and model in (SELECT model FROM comp.product p where maker = 'A')
-- SELECT ram AS Mb, hd Gb FROM comp.pc WHERE cd = '24x'
-- SELECT ram*1024 AS Kb, hd Gb FROM comp.pc WHERE cd = '24x'
-- SELECT ram, 'Mb' AS ram_units, hd, 'Gb' AS hd_units FROM comp.pc WHERE cd = '24x'
-- SELECT ram, 'SELECT' "SELECT", hd, 'Gb' hu FROM comp.pc WHERE cd = '24x'
-- SELECT * FROM ships.ships WHERE class LIKE '%o' AND class NOT LIKE '%go'

-- SELECT * FROM ships.outcomes o INNER JOIN ships.ships s ON o.ship = s.name
-- SELECT * FROM ships.ships --outcomes

-- SELECT min(price) minp, avg(price) avg, max(price) maxp FROM comp.pc
-- SELECT count(DISTINCT model) Qty_Maker_A FROM comp.pc
-- WHERE model IN (SELECT model FROM comp.product WHERE maker='A')
-- SELECT * FROM comp.pc ORDER BY model

-- SELECT model FROM comp.pc GROUP BY model;
-- SELECT DISTINCT model FROM comp.pc
-- SELECT model, COUNT(model) AS Qty_model, AVG(price) AS Avg_price FROM comp.pc GROUP BY model;
SELECT model, COUNT(model) AS Qty_model, AVG(price) AS Avg_price FROM comp.pc GROUP BY model;
SELECT COUNT(model) AS Qty_model, AVG(price) AS Avg_price FROM comp.pc;

SELECT model, COUNT(model) AS Qty_model, AVG(price) AS Avg_price
FROM comp.pc GROUP BY model;--HAVING AVG(price) < 800;

-- SELECT MIN(price) AS min_price, MAX(price) AS max_price, AVG(price) avg_price FROM comp.pc;
SELECT MIN(price) AS min_price, MAX(price) AS max_price, AVG(price) avg_price FROM comp.pc HAVING AVG(price) <= 600;

SELECT model, price, MIN(price) min_price, MAX(price) max_price FROM comp.printer GROUP BY model, price;