-- INNER JOIN
﻿select u.nick, p.name
 from jojo.places as p
   inner join jojo.users as u on u.id = p.userid;

-- LEFT JOIN
﻿select p.name as "place",  u.nick
 from jojo.places as p
   left join jojo.users as u on u.id = p.userid;

-- RIGHT JOIN
﻿select p.name as "place",  u.nick
 from jojo.places as p
   right join jojo.users as u on u.id = p.userid;

-- FULL JOIN
-- т.е. будут все общие строки(совпадающие по предикату), 
-- и все несовпадающие как из первой таблицы так и из второй.
﻿select p.name as "place",  u.nick
 from jojo.places as p
   full join jojo.users as u on u.id = p.userid;
-- или то же самое через юнион
(select p.name,  u.nick  from jojo.places as p right join jojo.users as u on u.id = p.userid)
UNION
(select p.name,  u.nick from jojo.places as p left join jojo.users as u on u.id = p.userid);
-- по умолчанию UNION фильтрует дубликаты.

-- CROSS JOIN
﻿select p.name as "place",  u.nick
 from jojo.places as p, jojo.users as u;
-- перемножение всех со всеми, будет n^2 сочетаний

-- UNION JOIN -- не работает
﻿(select p.name as "place",  u.nick
from jojo.places as p
full join jojo.users as u on u.id = p.userid)
except
(select p.name as "place",  u.nick
from jojo.places as p
inner join jojo.users as u on u.id = p.userid);

-- UNION / ALL
SELECT model, price, 'PC' as thirdColumn FROM comp.pc
UNION ALL
SELECT model, price, 'Laptop' FROM comp.laptop
UNION ALL
SELECT model, price, 'Printer' as type3 FROM comp.printer
ORDER BY price;

-- UNION ALL PLUS INNER JOIN FOR TYPE
SELECT pr.type, cpc.model, price
FROM comp.pc cpc
  INNER JOIN comp.product pr ON cpc.model = pr.model
UNION ALL
SELECT comp.product.type, comp.laptop.model, price
FROM comp.laptop
  INNER JOIN comp.product ON comp.laptop.model = comp.product.model
ORDER BY price DESC;