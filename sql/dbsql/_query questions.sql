-- помимо модели и цены принтера, требуется еще вывести максимальную и минимальную цену по всему множеству принтеров.
-- #1
SELECT model, price,
  (SELECT MIN(price) FROM comp.printer) min_price,
  (SELECT MAX(price) FROM comp.printer) max_price
FROM comp.printer;
-- #2
SELECT model, price, min_price, max_price FROM comp.printer
  CROSS JOIN
  (SELECT MIN(price) min_price, MAX(price) max_price FROM comp.printer) X;
-- #3 МОЁ - Если select из агрегатных функций вернёт несколько строк (добавив GROUP BY) то кросс-джоин будет таким: одна строка из первого селекта и всё 3 строки из агрег.селекта. Поэтому такой пример можно использовать только для вычислений агрег.ф-ий по всей таблице, когда агрег.select вернёт только 1 строку.
SELECT model, type, price, min_price, max_price FROM comp.printer
CROSS JOIN
(SELECT MIN(price) min_price, MAX(price) max_price FROM comp.printer GROUP BY type) X
 ORDER BY type;


-- Вывести номер модели и цену принтера, а также максимальную и минимальную цену на принтеры того же типа.
-- #1
SELECT model, price, type,
  (SELECT MIN(price) FROM comp.printer P1 WHERE P1.type=P.type) min_price,
  (SELECT MAX(price) FROM comp.printer P1 WHERE P1.type=P.type) max_price
FROM comp.printer P ORDER BY type;
-- #2 аналогично но с оконными функциями
SELECT model, price, type, 
  min(price) OVER (PARTITION BY type) min_price,
  max(price) OVER (PARTITION BY type) max_price
FROM comp.printer;

-- использование NULL и проверка на NULL
-- SELECT * FROM comp.pc ORDER BY price DESC
-- SELECT model FROM comp.pc WHERE price IS NOT NULL ORDER BY price DESC;
-- #1
SELECT model FROM (
  SELECT DISTINCT model, price FROM comp.pc
    WHERE price IS NOT NULL ORDER BY price DESC LIMIT 1) X;
-- #2 aggregate func + subquery
-- SELECT * FROM comp.pc WHERE price = 350
SELECT DISTINCT model,price FROM comp.pc
WHERE price = (SELECT MIN(price) FROM comp.pc);
-- #3
SELECT DISTINCT model FROM comp.pc
WHERE price = (SELECT price FROM comp.pc WHERE price IS NOT NULL ORDER BY price LIMIT 1);
-- в PostgreSQL при сортировке можно указать, где будут выводиться NULL-значения - в начале или в конце результирующего набора
SELECT * FROM comp.pc ORDER BY price DESC NULLS LAST;
-- в PostgreSQL при сортировке по возрастанию NULL-значения идут в конце результирующего рабора
-- #4 Идея решения cостоит в ранжировании (функция RANK) строк по возрастанию цены и выборке (уникальных) строк, для которых ранг равен 1.
-- SELECT model, price, Rank() OVER (ORDER BY price) rn FROM comp.pc WHERE price IS NOT NULL
SELECT DISTINCT model FROM
  (SELECT model, Rank() OVER (ORDER BY price) rn
    FROM comp.pc WHERE price IS NOT NULL) X
WHERE rn=1;

-- Найти максимальное значение среди средних цен ПК, посчитанных для каждого производителя отдельно.
-- http://www.sql-tutorial.ru/ru/book_aggregate_function_to_aggregate_function.html
-- SELECT maker,  AVG(price) avg_price FROM comp.product P JOIN comp.pc PC ON P.model = PC.model GROUP BY maker;
-- #1 по-старому с подзапросом
SELECT MAX(avg_price) FROM
(SELECT maker,  AVG(price) avg_price FROM comp.product P JOIN comp.pc PC ON P.model = PC.model GROUP BY maker) x;
-- #2 новые оконные функции
SELECT DISTINCT MAX(AVG(price)) OVER () max_avg_price
FROM comp.product P JOIN comp.pc PC ON P.model = PC.model
GROUP BY maker;
-- #3 по-старому с сортировкой и выбором верхнего значения
SELECT maker, AVG(price) avg_price FROM comp.product P JOIN comp.pc PC ON P.model = PC.model
GROUP BY maker ORDER BY avg_price DESC LIMIT 1;

-- Найти производителей, средняя цена на ПК у которых не меньше, чем средние цены у КАЖДОГО из производителей ПК
-- #1
SELECTmaker, avg_price
FROM (SELECT maker, AVG(price) avg_price
      FROM comp.product P JOIN comp.pc PC ON P.model=PC.model
      GROUP BY maker) X
WHERE avg_price >= ALL(SELECT AVG(price) avg_price
      FROM comp.product P JOIN comp.pc PC ON P.model=PC.model
      GROUP BY maker);
-- #2 the same with CTE
WITH cte(maker, avg_price) AS (SELECT maker, AVG(price) avg_price
    FROM comp.product P JOIN comp.pc PC ON P.model=PC.model GROUP BY maker)
SELECT * FROM cte
WHERE  avg_price>= ALL(SELECT avg_price FROM cte);
-- #3 соединяем подзапрос, определяющий производителей и средние цены на их ПК, с подзапросом, в котором определяется максимальная средняя цена.
SELECT maker, avg_price
FROM (SELECT maker, AVG(price) avg_price FROM comp.product P
           JOIN comp.pc PC ON P.model=PC.model GROUP BY maker
  ) X  JOIN
  (SELECT MAX(avg_price) max_price FROM (SELECT maker, AVG(price) avg_price
         FROM comp.product P JOIN comp.pc PC ON P.model=PC.model GROUP BY maker) X
  ) Y ON avg_price = max_price;
-- #4 Использование предиката ALL в предложении HAVING
SELECT maker, AVG(price) avg_price FROM comp.product P
  JOIN comp.pc PC ON P.model=PC.model GROUP BY maker
HAVING AVG(price) >= ALL(SELECT AVG(price) FROM comp.product P
  JOIN comp.pc PC ON P.model=PC.model GROUP BY maker);

-- Пронумеровать все рейсы из таблицы Trip в порядке возрастания их номеров. Выполнить сортировку по {id_comp, trip_no}
SELECT row_number() over(ORDER BY trip_no) Row_Num, trip_no, id_comp
FROM air.trip WHERE ID_comp < 3 ORDER BY id_comp, trip_no

-- Пронумеровать рейсы каждой компании отдельно в порядке возрастания номеров рейсов.
SELECT row_number() OVER (PARTITION BY id_comp ORDER BY id_comp,trip_no) num,
  trip_no, id_comp FROM air.trip WHERE ID_comp < 3 ORDER BY id_comp, trip_no

-- RANK (следующая строка по счету) и DENSE_RANK (следующий номер ранга по порядку)
SELECT type, ROW_NUMBER() OVER(ORDER BY type) rownum,
RANK() OVER(ORDER BY type) rank,
DENSE_RANK() OVER(ORDER BY type) rank_dense
FROM comp.printer

-- Пример с PARTITION BY в разных функциях
SELECT *, ROW_NUMBER() OVER(PARTITION BY type ORDER BY price) rownum,
  RANK() OVER(PARTITION BY color ORDER BY code) rank,
  DENSE_RANK() OVER(PARTITION BY type ORDER BY price) rank_dense
FROM comp.printer

--выбрать самые дешевые модели в каждой категории
--SELECT *, RANK() OVER(PARTITION BY type ORDER BY price) rnk FROM comp.printer
SELECT model, color, type, price FROM (
       SELECT *, RANK() OVER(PARTITION BY type ORDER BY price) rnk
       FROM comp.printer ) Ranked_models WHERE rnk = 1

-- Найти производителей, которые производят более 2-х моделей PC
-- #1 традиционное решение через агрегатные функции
SELECT maker FROM comp.product WHERE type = 'PC'
GROUP BY maker HAVING COUNT(*) > 2
-- #2 ранжировать модели каждого производителя по уникальному ключу
-- и выбрать только тех производителей, модели которых достигают ранга 3
-- SELECT maker, model, RANK() OVER(PARTITION BY maker ORDER BY model) rnk FROM comp.product WHERE type = 'PC'7
--упорядочивание в последнем случае должно быть выполнено по уникальной комбинации столбцов, т.к.,
-- в противном случае, моделей может быть больше трех, а ранг меньше (например, 1, 2, 2,...)
SELECT maker FROM (
       SELECT maker, RANK() OVER(PARTITION BY maker ORDER BY model) rnk
       FROM comp.product WHERE type = 'PC' ) Ranked_makers
WHERE rnk = 3

-- Найти второе по величине значение цены в таблице PC
-- begin test
SELECT  price, DENSE_RANK() OVER(ORDER BY price DESC) Dense_rank,
               RANK() OVER(ORDER BY price DESC) Rank,
               ROW_NUMBER() OVER(ORDER BY price DESC) RowNum
FROM comp.pc ORDER BY price DESC;
-- #1 working sample SQL-92 (ИСКЛЮЧАЕТ NULL ЗНАЧЕНИЯ)
SELECT MAX(price) "2nd_price"  FROM comp.pc
WHERE price < (SELECT MAX(price) FROM comp.pc);
-- #2 третья максимальная цена
SELECT MAX(price) "3rd_price" FROM comp.pc
WHERE price < (
  SELECT MAX(price) FROM comp.pc
  WHERE price < (SELECT MAX(price) FROM comp.pc)
);
-- #3 как найти N-е значение цены?
SELECT DISTINCT price FROM (
  SELECT DENSE_RANK() OVER(ORDER BY price DESC NULLS LAST) rnk, price FROM comp.pc
) X WHERE rnk=2;

-- Распределить баллончики по 3-м группам поровну. Группы заполняются в порядке возрастания v_id.
SELECT *, NTILE(3) OVER(PARTITION BY vcolor ORDER BY vid)
FROM paint.balon ORDER BY vcolor, vid;

-- ОКОННЫЕ ФУННКЦИИ
SELECT type, price, avg(price) OVER (PARTITION BY type) FROM comp.printer
-- #1 здесь если задать ORDER BY то порядок подсчёта и результ отличаются
SELECT model, type, price, avg(price) OVER (PARTITION BY type ORDER BY model) FROM comp.printer
-- #2 фрейм окна состоит из ВСЕХ строк таблицы (т.е. сумма будет одинаковая для всех, и все строки просуммированы сразу)
SELECT model, type, price, sum(price) OVER () FROM comp.printer
-- #3 фрейм окна расширяется по порядку из ORDER BY (у каждой следующей строки будет своя сумма)
-- фрейм расширяется от первой строки, +след строка, +след.., полная сумма будет только у послденей строки в результ наборе
SELECT model, type, price, sum(price) OVER (ORDER BY model) FROM comp.printer
-- #4 задать ОФ имя и ис-ть его как алиас
SELECT model, type, price, sum(price) OVER w, avg(price) OVER w  FROM comp.printer
WINDOW w AS (PARTITION BY type);

-- СТРАННОЕ РАЗБИНИЕ НА ГРУППЫ ОТ NTILE
SELECT *, ntile(3) OVER (PARTITION BY type ORDER BY price) FROM comp.printer

-- Есть группы однотипных конфет, надо собрать новогодний мешок, где будет по 1 конфете каждого типа
SELECT *, rank() OVER (PARTITION BY type ORDER BY code) rnk FROM comp.printer ORDER BY rnk, type;
-- чуть сложнее и наверно неправильно
SELECT *, ntile(3) OVER (ORDER BY rnk) package FROM
  (SELECT *, rank() OVER (PARTITION BY type ORDER BY code) rnk FROM comp.printer) X ;

-- нужно вывести, наряду с детализированными данными, общее число строк (или число страниц) и номер страницы для каждой записи, возвращаемой запросом.
-- http://www.sql-tutorial.ru/ru/book_paging.html
-- столбец, содержащий общее число строк в таблице
SELECT *, COUNT(*) OVER() AS total FROM comp.laptop
-- посчитать число страниц
SELECT *, CASE WHEN total % 2 = 0 THEN total/2 ELSE total/2 + 1 END AS num_of_pages
FROM ( SELECT *, COUNT(*) OVER() AS total FROM comp.laptop) X;
-- получить номер строки (для страницы) с помощью ранжирующей функции ROW_NUMBER, выполнив требуемую по условию сортировку по цене
SELECT *,
  CASE WHEN num % 2 = 0 THEN num/2 ELSE num/2 + 1 END AS page_num,
  CASE WHEN total % 2 = 0 THEN total/2 ELSE total/2 + 1 END AS num_of_pages
FROM ( SELECT *,
         ROW_NUMBER() OVER(ORDER BY price DESC) AS num,
         COUNT(*) OVER() AS total
       FROM comp.laptop) X;

-- paging NO

-- Найти максимальную сумму прихода/расхода среди всех 4-х таблиц базы данных "Вторсырье", а также тип операции, дату и пункт приема, когда и где она была зафиксирована. 
    SELECT max_sum, type, date, point 
    FROM (
    SELECT MAX(inc) over() AS max_sum, *
    FROM (
      SELECT inc, 'inc' type, date, point FROM Income 
      UNION ALL 
      SELECT inc, 'inc' type, date, point FROM Income_o 
      UNION ALL 
      SELECT out, 'out' type, date, point FROM Outcome_o 
      UNION ALL 
      SELECT out, 'out' type, date, point FROM Outcome 
    ) X 
    ) Y
    WHERE inc = max_sum;

-- Для каждого ПК из таблицы PC найти разность между его ценой и средней ценой на модели с таким же значением скорости ЦП.
SELECT *, price - AVG(price) OVER(PARTITION BY speed) AS dprice FROM comp.pc ORDER BY speed;
-- #2 Другое решение с помощью коррелирующего подзапроса.
SELECT *, price - (SELECT AVG(price) 
FROM comp.pc AS PC1 WHERE PC1.speed = pc.speed) AS dprice 
FROM comp.pc ORDER BY speed;

-- выводящего коды (code) принтеров вместе с кодами из предыдущей и следующей строк
-- порядок, в котором выбираются следующие и предыдущие строки задаётся  предложением ORDER BY в предложении OVER, а не сортировкой, используемой в запросе
SELECT  code,
  LAG(code) OVER(ORDER BY code) prev_code,
  LEAD(code) OVER(ORDER BY code) next_code
FROM comp.printer ORDER BY code DESC;
-- lag и lead решает след.задачи: Самосоединение
SELECT p1.code,p3.code,p2.code
FROM comp.printer p1 LEFT JOIN comp.printer p2 ON p1.code=p2.code-1
  LEFT JOIN comp.printer p3 ON p1.code=p3.code+1;
-- Коррелирующий подзапрос
SELECT p1.code,
  (SELECT MAX(p3.code) FROM comp.printer p3 WHERE p3.code < p1.code) prev_code,
  (SELECT MIN(p2.code) FROM comp.printer p2 WHERE p2.code > p1.code) next_code
FROM comp.printer p1;

-- функция CONCAT, которая выполняет конкатенацию, неявно преобразуя типы аргументов к строковому типу данных.
SELECT CONCAT(hd, ' Gb') as volume FROM comp.pc WHERE model='1232';

-- Для каждого производителя из таблицы Product определить число моделей каждого типа продукции. 
SELECT maker,
    SUM(CASE type WHEN 'PC' THEN 1 ELSE 0 END) PC
  , SUM(CASE type WHEN 'Laptop' THEN 1 ELSE 0 END) Laptop
  , SUM(CASE type WHEN 'Printer' THEN 1 ELSE 0 END) Printer
FROM comp.product GROUP BY maker ORDER BY maker;

-- Посчитать среднюю цену на ноутбуки в зависимости от размера экрана. 
SELECT screen, AVG(price) avg_ FROM comp.laptop GROUP BY screen ORDER BY screen;

-- Пассажиров рейса 7772 от 11 ноября 2005 года требуется отправить другим ближайшим рейсом, вылетающим позже в тот же день в тот же пункт назначения. 
WITH Trip_for_replace AS ( SELECT * FROM air.psg_trip WHERE trip_no=7772 AND date='20051129' ),
Trip_7772 AS ( SELECT * FROM air.trip WHERE trip_no=7772 ),
flight_replace AS ( SELECT air.trip.* FROM air.trip, Trip_7772
WHERE concat(air.trip.town_from,air.trip.town_to) = concat(Trip_7772.town_from,Trip_7772.town_to)
      AND air.trip.time_out > Trip_7772.time_out )
SELECT * FROM flight_replace;

--#2 предпоследний шаг
WITH Trip_for_replace AS ( SELECT * FROM air.psg_trip WHERE trip_no=7772 AND date='20051129' ),
Trip_7772 AS ( SELECT * FROM air.trip WHERE trip_no=7772 ),
next_flights AS ( SELECT air.trip.* FROM air.trip, Trip_7772
WHERE concat(air.trip.town_from,air.trip.town_to) = concat(Trip_7772.town_from,Trip_7772.town_to)
      AND air.trip.time_out > Trip_7772.time_out ),
flight_replace AS( SELECT * FROM next_flights WHERE time_out <= ALL(SELECT time_out FROM next_flights) )
SELECT * FROM flight_replace;

-- непосредственно update не заработал.
WITH Trip_for_replace AS ( SELECT * FROM air.psg_trip WHERE trip_no=7772 AND date='20051129' ),
Trip_7772 AS ( SELECT * FROM air.trip WHERE trip_no=7772 ),
next_flights AS ( SELECT air.trip.* FROM air.trip, Trip_7772
    WHERE concat(air.trip.town_from,air.trip.town_to) = concat(Trip_7772.town_from,Trip_7772.town_to)
  AND air.trip.time_out > Trip_7772.time_out ),
flight_replace AS( SELECT * FROM next_flights WHERE time_out <= ALL(SELECT time_out FROM next_flights) )
UPDATE Trip_for_replace SET trip_no = (SELECT trip_no FROM flight_replace);

-- Рассмотрим задачу получения алфавита, т.е. таблицы алфавитных символов - прописных латинских букв.
    ;WITH Letters AS(
    SELECT ASCII('A') code, CHAR(ASCII('A')) letter
    UNION ALL
    SELECT code+1, CHAR(code+1) FROM Letters
    WHERE code+1 <= ASCII('Z')
    )
    SELECT letter FROM Letters;

-- Найти номер модели и производителя ПК, имеющих цену менее $600
SELECT DISTINCT comp.pc.model, maker FROM comp.pc, comp.product
WHERE pc.model = product.model AND price < 600;

-- Вывести пары моделей, имеющих одинаковые цены
SELECT DISTINCT A.model AS model_1, B.model AS model_2, A.price
FROM comp.pc AS A, comp.pc B WHERE A.price = B.price-- AND A.model < B.model
ORDER BY price;

-- то же самое с подзапросом.
SELECT DISTINCT comp.pc.model, maker FROM comp.pc,
  (SELECT maker, model FROM comp.product ) AS Prod
WHERE comp.pc.model = Prod.model AND price < 600;

-- Найти корабли, которые присутствуют как в таблице Ships, так и в таблице Outcomes. 
-- EXCEPT = есть в ships, но нет в outcomes;
SELECT name FROM ships.ships INTERSECT SELECT ship FROM ships.outcomes;
SELECT ship FROM ships.outcomes INTERSECT SELECT name FROM ships.ships;

-- SELECT ship FROM ships.outcomes EXCEPT SELECT name FROM ships.ships WHERE name <> 'California';
-- SELECT * FROM ships.ships ORDER BY name;
-- SELECT * FROM ships.outcomes ORDER BY ship;
-- Сколько будет дубликатов 'California' в результ.наб.: 2-1 = 1шт.
SELECT ship FROM ships.outcomes EXCEPT ALL SELECT name FROM ships.ships;
-- Сколько будет дубликатов 'California' в результ.наб.: 2-0 = 2шт. 
-- SELECT ship FROM ships.outcomes EXCEPT ALL SELECT name FROM ships.ships WHERE name <> 'California';

-- #1  Найти производителей, которые выпускают не менее двух моделей ПК и не менее двух моделей принтеров.
SELECT maker FROM (
SELECT maker FROM comp.product WHERE type='PC'
INTERSECT ALL
SELECT maker FROM comp.product WHERE type ='Printer'
) X GROUP BY maker HAVING COUNT(*)>1;
-- INTERSECT ALL в подзапросе этого решения оставит минимальное число дубликатов, т.е. если производитель выпускает 2 модели ПК и одну модель принтера (или наоборот), то он будет присутствовать в результирующем наборе один раз. Далее мы выполняем группировку по производителю, оставляя только тех из них, кто присутствует в результатах подзапроса более одного раза.

-- #2 Конечно, мы можем решить эту задачу, не используя явно операцию пересечения. Например, одним подзапросом найдем производителей, которые выпускают не менее 2-х моделей ПК, другим - тех, кто выпускает не менее 2-х моделей принтеров. Решение задачи даст внутреннее соединение этих подзапросов. Ниже этот алгоритм реализован на основе еще одного стандартного типа соединений - естественного соединения:
SELECT PC.maker FROM (
SELECT maker FROM comp.product WHERE type='PC' GROUP BY maker HAVING COUNT(*)>1) PC
  NATURAL JOIN (
SELECT maker FROM comp.product WHERE type='Printer' GROUP BY maker HAVING COUNT(*)>1) Pr;
-- Естественное соединение (NATURAL JOIN) – это эквисоединение по столбцам с одинаковыми именами. 

-- Порядок выполнения операторов UNION, EXCEPT, INTERSECT 
-- 3 ПО 2 ПРИМЕРА
--Модели и типы продукции производителя B
SELECT model, type FROM comp.product WHERE maker='B';
--Модели ноутбуков
SELECT model, type FROM comp.product WHERE type='Laptop';
--Модели ПК
SELECT model, type FROM comp.product WHERE type='PC';
-- #1.1
SELECT model, type FROM comp.product WHERE maker='B'
UNION
SELECT model, type FROM comp.product WHERE type='Laptop'
EXCEPT
SELECT model, type FROM comp.product WHERE type='PC';
-- #1.2
(SELECT model, type FROM comp.product WHERE maker='B'
UNION
SELECT model, type FROM comp.product WHERE type='Laptop')
EXCEPT
SELECT model, type FROM comp.product WHERE type='PC';
-- 2.1
SELECT model, type FROM comp.product WHERE type='Laptop'
EXCEPT
SELECT model, type FROM comp.product WHERE type='PC'
UNION
SELECT model, type FROM comp.product WHERE maker='B';
-- 2.2
(SELECT model, type FROM comp.product WHERE type='Laptop'
EXCEPT
SELECT model, type FROM comp.product WHERE type='PC')
UNION
SELECT model, type FROM comp.product WHERE maker='B';
-- 3.1
SELECT model, type FROM comp.product WHERE maker='B'
UNION
SELECT model, type FROM comp.product WHERE type='Laptop'
INTERSECT
SELECT model, type FROM comp.product WHERE type='PC';
-- 3.2
(SELECT model, type FROM comp.product WHERE maker='B'
UNION
SELECT model, type FROM comp.product WHERE type='Laptop')
INTERSECT
SELECT model, type FROM comp.product WHERE type='PC';

-- (Пример на пересечение) Найти тех производителей портативных компьютеров, которые также производят принтеры #1
-- SELECT maker FROM comp.product as prin1 WHERE type = 'Printer' GROUP BY maker ORDER BY maker;
SELECT DISTINCT maker FROM comp.product AS lap_product 
WHERE type = 'Laptop' AND EXISTS 
(SELECT maker FROM comp.product WHERE type = 'Printer' AND maker = lap_product.maker);
-- #2 то же самое, но для типа PC
SELECT DISTINCT maker FROM comp.product AS lap_product
WHERE type = 'Laptop' AND EXISTS
(SELECT maker FROM comp.product AS lapm1 WHERE type = 'PC' AND lapm1.maker = lap_product.maker);

-- (Пример на разность) Найти производителей портативных компьютеров, которые не производят принтеров #1
SELECT DISTINCT maker FROM comp.product AS lap_product
WHERE type = 'Laptop' AND NOT EXISTS (
SELECT maker FROM comp.product as prin1 WHERE type = 'Printer' AND prin1.maker = lap_product.maker);

-- Определить производителей, которые выпускают модели всех типов (схема "Компьютерная фирма")
-- #1 Группировка
-- можем выполнить группировку по производителю и подсчитать количество уникальных типов
SELECT maker FROM comp.product GROUP BY maker HAVING
  COUNT(DISTINCT type) = (SELECT COUNT(DISTINCT type) FROM comp.product);
-- #2.1 Разность
-- Если взять операцию разности ВСЕХ имеющихся типов моделей и типов у конкретного производителя, то результирующая выборка не должна содержать строк.
SELECT DISTINCT maker FROM comp.product Pr1 WHERE 0 = (
SELECT COUNT(*) FROM (SELECT type FROM comp.product EXCEPT
SELECT type FROM comp.product Pr2 WHERE Pr2.maker = Pr1.maker ) X );
-- #2.2 Этот запрос можно написать короче, если воспользоваться тем свойством, что истинностное значение предиката ALL есть TRUE, если подзапрос не возвращает строк
SELECT DISTINCT maker FROM comp.product Pr1 WHERE type = ALL
(SELECT type FROM comp.product EXCEPT
SELECT type FROM comp.product Pr2 WHERE Pr2.maker = Pr1.maker);
-- Для искомых производителей список типов в предикате ALL будет пуст (предикат равен TRUE). В остальных случаях он будет содержать типы моделей, отсутствующие у производителя из внешнего запроса, поэтому операция сравнения (равенство "=") для всех его моделей даст FALSE
-- #3 Существование
-- Не должно существовать такого типа продукции, которого бы не было у искомого производителя.
SELECT DISTINCT maker FROM comp.product Pr1 WHERE NOT EXISTS
(SELECT type FROM comp.product WHERE type NOT IN
(SELECT type FROM comp.product Pr2 WHERE Pr1.maker = Pr2.maker));
-- Следует также отметить, что решение с группировкой не подойдет для случая, когда требуется выполнить деление не на все множество имеющихся типов, а на некоторое их подмножество. Например, если требуется найти производителей, у которых множество типов включает в себя (или совпадает) множество типов, определяемое некоторыми критериями. Другие же приемы можно адаптировать для решения подобной задачи.

-- Найти поставщиков компьютеров, моделей которых нет в продаже (то есть модели этих поставщиков отсутствуют в таблице PC)
SELECT DISTINCT maker FROM comp.product WHERE type = 'PC' AND
NOT model = ANY (SELECT model FROM comp.pc);
-- вернет значение TRUE, если модель, определяемая полем model основного запроса, найдется в списке моделей таблицы РС (возвращаемом подзапросом). Поскольку предикат используется в запросе с отрицанием NOT, то значение TRUE будет получено, если модели не окажется в списке. Этот предикат проверяется для каждой записи основного запроса, которыми являются все модели ПК (предикат type = 'pc') из таблицы Product. Результирующий набор состоит из одного столбца — имени производителя. Чтобы один производитель не выводился несколько раз (что может случиться, если он производит несколько моделей, отсутствующих в таблице РС), используется служебное слово DISTINCT, исключающее дубликаты.

-- Найти модели и цены портативных компьютеров, стоимость которых превышает стоимость любого ПК 
SELECT DISTINCT model, price FROM comp.laptop WHERE price > ALL (SELECT price FROM comp.pc)

-- Найти модели и цены ПК, стоимость которых превышает минимальную стоимость портативных компьютеров:
SELECT DISTINCT model, price FROM comp.pc 
WHERE price > (SELECT MIN(price) FROM comp.laptop);

-- ОШИБКА «Подзапрос вернул более одного значения. Это НЕ допускается в тех случаях, когда подзапрос следует после =, !=, <, <=, >, >= или когда подзапрос используется в качестве выражения»
SELECT DISTINCT model, price FROM comp.pc
WHERE price = (SELECT price FROM comp.laptop);

-- Вывести производителя, тип, модель и частоту процессора для Портативных компьютеров, частота процессора которых превышает 600 МГц
SELECT prod.maker, lap.* FROM (SELECT 'Laptop' AS type, model, speed FROM comp.laptop WHERE speed > 600) AS lap 
INNER JOIN (SELECT maker, model FROM comp.product ) AS prod ON lap.model = prod.model;

-- Найти разницу между средними значениями цены портативных компьютеров и ПК, то есть насколько в среднем портативный компьютер стоит дороже, чем ПК
SELECT (SELECT AVG(price) FROM comp.laptop ) -
(SELECT AVG(price) FROM comp.pc) AS dif_price;

--Определить средний год спуска на воду кораблей из таблицы Ships
-- SELECT 'Средняя цена = ' as title, CAST(AVG(price) AS CHAR(15)) FROM comp.laptop
-- SELECT AVG(launched) FROM ships.ships;
SELECT CAST(AVG(launched*1.0) AS NUMERIC(6,2)) FROM ships.ships;

-- требуется вывести список всех моделей ПК с указанием их цены. При этом если модель отсутствует в продаже (ее нет в таблице РС), то вместо цены вывести текст «Нет в наличии»
SELECT DISTINCT comp.product.model, price FROM comp.product LEFT JOIN
comp.pc ON comp.product.model = comp.pc.model WHERE product.type = 'PC';
-- #2
SELECT DISTINCT comp.product.model, CASE WHEN price IS NULL THEN 'Нет в наличии'
ELSE CAST(price AS CHAR(20)) END price FROM comp.product LEFT JOIN
comp.pc ON comp.product.model = comp.pc.model WHERE product.type = 'PC';

-- COALESCE - для проверки на null
SELECT DISTINCT comp.product.model,
  COALESCE(CAST(price AS CHAR(20)),'Нет в наличии2') price
FROM comp.product LEFT JOIN
comp.pc ON comp.product.model = comp.pc.model WHERE product.type = 'PC';

--Вывести все имеющиеся модели ПК с указанием цены. Отметить самые дорогие и самые дешевые модели
SELECT DISTINCT model, price, CASE price
  WHEN (SELECT MAX(price) FROM comp.pc) THEN 'Самый дорогой'
  WHEN (SELECT MIN(price) FROM comp.pc) THEN 'Самый дешевый'
  ELSE 'Средняя цена' END my_comment
FROM comp.pc ORDER BY price;

-- Посчитать количество рейсов из Ростова в Москву, и количество рейсов, выполняемых в остальные города
SELECT flag, COUNT(*) qty FROM
  (SELECT CASE WHEN town_to ='Moscow' THEN 'Moscow' ELSE 'Other' END flag
   FROM air.trip WHERE town_from='Rostov' ) X GROUP BY flag;

-- Посчитать общее количество рейсов из Ростова и количество рейсов, пунктом назначения которых не является Москва
-- В этой задаче тоже требуется выполнить агрегацию по двум выборкам, при этом одна из выборок является подмножеством второй. Поэтому здесь напрямую не подойдёт вычисляемый столбец, по которому можно выполнить группировку.
-- Для решения данной задачи мы можем посчитать количество по всему множеству и использовать подзапрос для подсчета значений в подмножестве (второе обращение к таблице) или использовать CASE в сочетании с агрегатной функцией, чтобы избежать повторного чтения таблицы.
-- #1 Использование подзапроса
SELECT COUNT(*) total, (SELECT COUNT(*) FROM air.trip
WHERE town_from='Rostov' AND town_to <> 'Moscow') non_moscow
FROM air.trip WHERE town_from='Rostov';
-- #2 Использование CASE с агрегатной функцией
SELECT COUNT(*) total_qty, SUM(CASE WHEN town_to <>'Moscow' THEN 1 ELSE 0 END) non_moscow2
FROM air.trip WHERE town_from='Rostov';

-- SELECT * FROM comp.printer_inc;
-- INSERT INTO comp.printer_inc (model, color, type, price)
--   (SELECT model, color, type, price FROM comp.printer ORDER BY price);
-- VALUES (3111, 'y', 'laser', 599);

-- пример #1 ис-ия VALUES
INSERT INTO comp.items VALUES
  (1, 'A', 'Laptop', 12),
  (2, 'B', DEFAULT, NULL),
  (3, 'C', 'Printer', (SELECT CAST(model AS int) FROM comp.printer WHERE code=1)),
  (4, 'C', 'Printer', (SELECT CAST(model AS int) FROM comp.printer WHERE code=77));
SELECT * FROM comp.items;

-- пример #2 ис-ия VALUES
SELECT concat((SELECT MAX(model) FROM comp.product), 5*5*(a-1), 5*(b-1), c) AS num
FROM
  (VALUES(1),(2),(3),(4),(5)) x(a) CROSS JOIN
  (VALUES(1),(2),(3),(4),(5)) y(b)  CROSS JOIN
  (VALUES(1),(2),(3),(4),(5)) z(c)
WHERE 5*5*(a-1) + 5*(b-1) + c <= 100
ORDER BY 1;

-- Пусть требуется указать «No PC» (нет ПК) в столбце type для тех моделей ПК из таблицы Product, для которых нет соответствующих строк в таблице PC
UPDATE comp.product SET type = 'No PC'
WHERE type = 'PC' AND model NOT IN (SELECT model FROM comp.pc)
SELECT * FROM comp.product ORDER BY model DESC;

-- вернуть взад
-- UPDATE comp.product SET type='PC' WHERE type = 'No PC';
-- SELECT * FROM comp.product ORDER BY model DESC;
SELECT pr.maker, pr.type, pr.model prod_model, cc.model pc_model FROM comp.product pr
  LEFT JOIN comp.pc cc ON pr.model=cc.model
WHERE type = 'PC' AND cc.model IS NULL

-- INSERT INTO comp.trunc(val) VALUES (1),(2),(3);
-- SELECT * FROM comp.trunc;
-- DELETE FROM comp.trunc;
-- TRUNCATE TABLE comp.trunc RESTART IDENTITY ;


