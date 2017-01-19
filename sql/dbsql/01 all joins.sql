-- INNEER JOIN
﻿select u.nick, p.name
from jojo.places as p
inner join jojo.users as u on u.id = p.userid

-- LEFT JOIN
﻿select p.name,  u.nick
from jojo.places as p
left join jojo.users as u on u.id = p.userid

-- RIGHT JOIN
﻿select p.name,  u.nick
from jojo.places as p
right join jojo.users as u on u.id = p.userid

-- FULL JOIN
﻿select p.name,  u.nick
from jojo.places as p
full join jojo.users as u on u.id = p.userid
-- или то же самое через юнион
(select p.name,  u.nick  from jojo.places as p right join jojo.users as u on u.id = p.userid)
UNION
(select p.name,  u.nick from jojo.places as p left join jojo.users as u on u.id = p.userid)

-- CROSS JOIN
﻿select p.name,  u.nick
from jojo.places as p, jojo.users as u

-- UNION JOIN
﻿(select p.name,  u.nick
from jojo.places as p
full join jojo.users as u on u.id = p.userid)
except
(select p.name,  u.nick
from jojo.places as p
inner join jojo.users as u on u.id = p.userid)

-- UNION / ALL
SELECT model, price, 'PC' as typeout FROM comp.pc
UNION ALL
SELECT model, price, 'Laptop' FROM comp.laptop
UNION ALL
SELECT model, price, 'Printer' as type3 FROM comp.printer
ORDER BY price;

-- UNION ALL PLUS INNER JOIN FOR TYPE
SELECT comp.product.type, comp.pc.model, price FROM comp.pc 
INNER JOIN comp.product ON comp.pc.model = comp.product.model
UNION ALL
SELECT comp.product.type, comp.laptop.model, price FROM comp.laptop 
INNER JOIN comp.product ON comp.laptop.model = comp.product.model
ORDER BY price DESC;

