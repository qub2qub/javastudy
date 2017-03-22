-- INNER JOIN
SELECT maker, comp.product.model AS prod_mod, comp.pc.model AS pc_mod, price
FROM comp.product INNER JOIN comp.pc ON comp.pc.model = comp.product.model
ORDER BY maker, prod_mod;

-- LEFT/right JOIN
SELECT maker, pr.model AS leftMod_1, cpc.model AS rightMod_2, price
FROM comp.product pr
  LEFT JOIN comp.pc cpc ON cpc.model =pr.model
ORDER BY maker, leftMod_1;
-- WHERE type = 'PC' ORDER BY maker DESC, cpc.model;
-- right JOIN даст те же результаты, что и внутреннее соединение,
-- поскольку в правой таблице (PC) нет таких моделей,
-- которые отсутствовали бы в левой таблице (Product),
-- что вполне естественно для типа связи «один ко многим»,
-- которая имеется между таблицами PC и Product.

-- UNION JOIN
-- Найти производителей, которые выпускают принтеры, но не ПК,
-- или выпускают ПК, но не принтеры.
-- сначала выбираем все комбинации производителей ПК и принтеров
-- DISTINCT покажет только уникальные сочетание, без их повторений
SELECT DISTINCT m_pc.maker m1_pc, m_printer.maker m2_printer
FROM (SELECT maker FROM comp.product WHERE type='PC') m_pc
  FULL JOIN
    (SELECT maker FROM comp.product WHERE type='Printer') m_printer
      ON m_pc.maker = m_printer.maker
EXCEPT
  -- из них удаляем те, который производят и ПК и принтеры
SELECT DISTINCT *
 FROM (SELECT maker FROM comp.product WHERE type='PC') m_pc
  INNER JOIN
    (SELECT maker FROM comp.product WHERE type='Printer') m_printer
      ON m_pc.maker = m_printer.maker;

-- или 2-й вариант, т.к. в full join-е у непарных строк в противополжном столбце будут стоять null
SELECT  m_pc.maker m1_pc, m_printer.maker m2_printer
FROM (SELECT DISTINCT maker FROM comp.product WHERE type='PC') m_pc
  FULL JOIN
    (SELECT DISTINCT maker FROM comp.product WHERE type='Printer') m_printer
      ON m_pc.maker = m_printer.maker
-- WHERE m_pc.maker IS NULL OR m_printer.maker IS NULL
ORDER BY m2_printer;

-- FULL JOIN
﻿select p.name as "place",  u.nick
 from jojo.places as p
   full join jojo.users as u on u.id = p.userid;
-- или то же самое через юнион:
-- т.е. будут все общие строки(совпадающие по предикату),
-- и все непарные как из первой таблицы так и из второй.
(select p.name,  u.nick  from jojo.places as p right join jojo.users as u on u.id = p.userid)
UNION
(select p.name,  u.nick from jojo.places as p left join jojo.users as u on u.id = p.userid);
-- по умолчанию UNION фильтрует дубликаты.

--#1 чтобы получить план, близкий по стоимости FULL JOIN, нужно избавиться от сортировки.
-- Например, использовать UNION ALL, но в одном из объединяемых запросов исключить строки,
-- соответствующие внутреннему соединению:
SELECT * FROM Income_o I
  LEFT JOIN Outcome_o O
    ON I.point = O.point AND I.date = O.date
UNION ALL
SELECT NULL, NULL, NULL,*
FROM Outcome_o O
  WHERE NOT EXISTS
    (SELECT 1 FROM Income_o I WHERE I.point = O.point AND I.date = O.date);
-- #2 Обратите внимание, что заведомо отсутствующие значения,
-- которые появлялись в правом соединении решения (2),
-- здесь формируются явным заданием NULL-значений.
-- Если по каким-то причинам, явное задание NULL вместо соединения вам не подходит,
-- можно оставить соединение, но это даст более дорогой план,
-- хотя и он будет дешевле плана с сортировкой (2):
SELECT * FROM Income_o I LEFT JOIN Outcome_o O
    ON I.point = O.point AND I.date = O.date
UNION ALL
SELECT * FROM Income_o I RIGHT JOIN Outcome_o O
    ON I.point = O.point AND I.date = O.date
WHERE NOT EXISTS (SELECT 1 FROM Income_o I
WHERE I.point = O.point AND I.date = O.date);

-- Найти номера моделей и цены ПК и портативных компьютеров
SELECT model, price, 'PC' as ttype FROM comp.pc
UNION
SELECT model, price, 'LAP' FROM comp.laptop
ORDER BY price DESC;

-- (с помощью UNION ALL ответим на вопрос):
-- Найти все имеющиеся единицы продукции производителя 'B'. Вывести номер модели и тип.
SELECT p.model, p.type, code, maker, cpc.cd as "info"
  FROM comp.pc cpc JOIN comp.product p ON cpc.model=p.model WHERE maker='B'
UNION ALL
SELECT p.model, p.type, code, maker, pr.type
  FROM comp.printer pr JOIN comp.product p ON pr.model=p.model WHERE maker='B'
UNION ALL
SELECT p.model, p.type, code, maker, lp.screen::TEXT
  FROM comp.laptop lp JOIN comp.product p ON lp.model=p.model WHERE maker='B';
-- (с помощью UNION) (тот же запрос выше решает другую задачу):
-- Выяснить, какие модели производителя 'B' имеются в наличии. Вывести номер модели и тип.
-- если выводит колонку code, то резултат будет как и в примере выше. это неправильно.
SELECT p.model, p.type, maker, cpc.cd as "info"
FROM comp.pc cpc JOIN comp.product p ON cpc.model=p.model WHERE maker='B'
UNION
SELECT p.model, p.type, maker, pr.type
FROM comp.printer pr JOIN comp.product p ON pr.model=p.model WHERE maker='B'
UNION
SELECT p.model, p.type, maker, lp.screen::TEXT
FROM comp.laptop lp JOIN comp.product p ON lp.model=p.model WHERE maker='B';