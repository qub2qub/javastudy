-- столбец "printer.type" должен фигурировать в предложении GROUP BY или использоваться в агрегатной функции
-- столбец "printer.price" должен фигурировать в предложении GROUP BY или использоваться в агрегатной функции,
-- но не стоять сам по себе, как type: SELECT type, price, avg(price)... <-- error
SELECT type, avg(price) FROM comp.printer GROUP BY type ORDER BY type;

SELECT 'ALL PRINTERS' AS ALL_TABLE, avg(price) FROM comp.printer;

SELECT type, avg(price) avgp FROM comp.printer GROUP BY type
HAVING avg(price) > 300 ORDER BY avgp DESC ;

