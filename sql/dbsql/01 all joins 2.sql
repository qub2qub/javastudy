-- INNER JOIN
SELECT maker, comp.product.model AS prod_mod, comp.pc.model AS pc_mod, price
FROM comp.product INNER JOIN comp.pc ON comp.pc.model = comp.product.model
ORDER BY maker, prod_mod;

-- LEFT/right JOIN
SELECT maker, comp.product.model AS model_1, comp.pc.model AS model_2, price
FROM comp.product LEFT JOIN comp.pc ON comp.pc.model = comp.product.model
ORDER BY maker, model_1;
-- WHERE type = 'PC' ORDER BY maker, comp.pc.model;
-- right JOIN даст те же результаты, что и внутреннее соединение, поскольку в правой таблице (PC) нет таких моделей, которые отсутствовали бы в левой таблице (Product), что вполне естественно для типа связи «один ко многим», которая имеется между таблицами PC и Product.

-- UNION JOIN
-- Найти производителей, которые выпускают принтеры, но не ПК, или выпускают ПК, но не принтеры. 
SELECT m_pc.maker m1, m_printer.maker m2  FROM
  (SELECT maker FROM comp.product WHERE type='PC') m_pc
  FULL JOIN
  (SELECT maker FROM comp.product WHERE type='Printer') m_printer
    ON m_pc.maker = m_printer.maker
EXCEPT
SELECT * FROM
  (SELECT maker FROM comp.product WHERE type='PC') m_pc
  INNER JOIN
  (SELECT maker FROM comp.product WHERE type='Printer') m_printer
    ON m_pc.maker = m_printer.maker;

-- или 2-й вариант, т.к. в full join-е у непарных строк в противополжном столбце будут стоять null
SELECT * FROM
  (SELECT DISTINCT maker FROM comp.product WHERE type='PC') m_pc
  FULL JOIN
  (SELECT DISTINCT maker FROM comp.product WHERE type='Printer') m_printer
    ON m_pc.maker = m_printer.maker
WHERE m_pc.maker IS NULL OR m_printer.maker IS NULL;

--#1 чтобы получить план, близкий по стоимости FULL JOIN, нужно избавиться от сортировки. Например, использовать UNION ALL, но в одном из объединяемых запросов исключить строки, соответствующие внутреннему соединению:
SELECT * FROM Income_o I LEFT JOIN Outcome_o O 
      ON I.point = O.point AND I.date = O.date 
UNION ALL
SELECT NULL, NULL, NULL,* FROM Outcome_o O 
WHERE NOT EXISTS (SELECT 1 FROM Income_o I 
                  WHERE I.point = O.point AND I.date = O.date);
-- #2 Обратите внимание, что заведомо отсутствующие значения, которые появлялись в правом соединении решения (2), здесь формируются явным заданием NULL-значений. Если по каким-то причинам, явное задание NULL вместо соединения вам не подходит, можно оставить соединение, но это даст более дорогой план, хотя и он будет дешевле плана с сортировкой (2):
    SELECT * FROM Income_o I LEFT JOIN Outcome_o O 
          ON I.point = O.point AND I.date = O.date 
    UNION ALL
    SELECT * FROM Income_o I RIGHT JOIN Outcome_o O 
          ON I.point = O.point AND I.date = O.date
    WHERE NOT EXISTS (SELECT 1 FROM Income_o I 
                      WHERE I.point = O.point AND I.date = O.date);

-- Найти номера моделей и цены ПК и портативных компьютеров
SELECT model, price FROM comp.pc
UNION
SELECT model, price FROM comp.laptop 
ORDER BY price DESC;

-- (с помощью UNION ALL) Найти все имеющиеся единицы продукции производителя 'B'. Вывести номер модели и тип.
SELECT p.model, p.type FROM comp.pc JOIN comp.product p ON comp.pc.model=p.model WHERE maker='B'
UNION ALL
SELECT p.model, p.type FROM comp.printer pr JOIN comp.product p ON pr.model=p.model WHERE maker='B'
UNION ALL
SELECT p.model, p.type FROM comp.laptop lp JOIN comp.product p ON lp.model=p.model WHERE maker='B';
-- (с помощью UNION) (тот же запрос выше решает другую задачу)  Выяснить, какие модели производителя 'B' имеются в наличии. Вывести номер модели и тип. 
