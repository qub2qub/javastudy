   CREATE OR REPLACE FUNCTION paging(in recCount integer, in pageNum integer)
	RETURNS setof comp.laptop AS $$
SELECT yy.code, yy.model, yy.speed, yy.ram, yy.hd, yy.screen, yy.price
FROM (SELECT *,
     CASE WHEN num % recCount = 0
	THEN num/recCount ELSE num/recCount + 1
	END AS page_num,
     CASE WHEN total % recCount = 0
	THEN total/recCount ELSE total/recCount + 1
	END AS num_of_pages
   FROM (SELECT *,
        ROW_NUMBER() OVER(ORDER BY price DESC) AS num,
        COUNT(*) OVER() AS total FROM comp.laptop
        ) xx
  ) yy
WHERE page_num = pageNum;
$$ LANGUAGE SQL;

-- 2 var
-- Function increments the input value by 1
   CREATE OR REPLACE FUNCTION paging(integer, integer)
	RETURNS setof comp.laptop AS $$
SELECT yy.code, yy.model, yy.speed, yy.ram, yy.hd, yy.screen, yy.price
FROM (SELECT *,
     CASE WHEN num % $1 = 0
	THEN num/$1 ELSE num/$1 + 1
	END AS page_num,
     CASE WHEN total % $1 = 0
	THEN total/$1 ELSE total/$1 + 1
	END AS num_of_pages
   FROM (SELECT *,
        ROW_NUMBER() OVER(ORDER BY price DESC) AS num,
        COUNT(*) OVER() AS total FROM comp.laptop
        ) xx
  ) yy
WHERE page_num = $2;
$$ LANGUAGE SQL;

-- var 3
    CREATE PROC paging
      @n int =2 -- число записей на страницу, по умолчанию 2
    , @p int =1 -- номер страницы, по умолчанию - первая
    AS
    SELECT * FROM Laptop
    ORDER BY price DESC OFFSET @n*(@p-1) ROWS FETCH NEXT @n ROWS ONLY;
