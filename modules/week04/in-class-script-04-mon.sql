First review item: tri-value logic
Expressions can have a value (if Boolean, TRUE or FALSE), but they can also be NULL
In selecting rows, NULL doesn't cut it, NULL doesn't count as TRUE

SELECT COUNT(*) FROM Bird_nests
  WHERE floatAge < 7 OR floatAge >= 7;

SELECT COUNT(*) FROM Bird_nests
  WHERE floatAge IS NULL;

Review item: relational algebra
Everthing is a table!  Every operation returns a table!
Even a simple COUNT(*) returns a table

SELECT COUNT(*) FROM Bird_nests;

We looked at one example of nesting SELECTs

SELECT Scientific_name
  FROM Species
  WHERE Code NOT IN ( SELECT DISTINCT Species FROM Bird_nests );

Let's pretend that SQL didn't have a HAVING clause.  Could we somehow get the same functionality?
Let's go back to the example where we used a HAVING clause

SELECT Location, MAX(Area) AS Max_area
  FROM Site
  WHERE Location LIKE '%Canada'
  GROUP BY Location
  HAVING Max_area > 200;

  As a reminder, the Site table:
  SELECT * FROM Site LIMIT 5;

SELECT * FROM
      (SELECT Location, MAX(Area) AS Max_area
      FROM Site
      WHERE Location LIKE '%Canada'
      GROUP BY Location)
    WHERE Max_area > 200;

REVIEW AND CONTINUING DISCUSSION OF JOINS

What is a join?  Conceptually, the database performs a "Cartesian product" of the tables, then
matches up rows based on some kind of join condition

In some databases, to do a Cartesian product you would just do a JOIN without a condition, e.g.,
SELECT * FROM A JOIN B;
**But** in DuckDB, you have to say:
SELECT * FROM A CROSS JOIN B;
SELECT * FROM A;
SELECT * FROM B;

Here's what the Cartesian product looks like:
SELECT * FROM A CROSS JOIN B;

Let's a join condition, which can be *any* expression!

SELECT * FROM A JOIN B ON acol1 < bcol1;

This is what's referred to as an INNER JOIN
SELECT * FROM A INNER JOIN B ON acol1 < bcol1;

Outer join: we're adding rows from one table that never got matched.

SELECT * FROM A RIGHT JOIN B ON acol1 < bcol1;

SELECT * FROM A LEFT JOIN B On acol1 < bcol1;

Just for completeness (this is way more rare that you would want to do this):
SELECT * FROM A FULL OUTER JOIN B ON acol1 < bcol1;

Now, joining on a foreign key relationship is way more common
.schema

SELECT * FROM House;
SELECT * FROM Student;

Typical thing to do:

SELECT * FROM Student S JOIN House H ON S.House_ID = H.House_ID;

As an aside, without aliases:
SELECT * FROM Student JOIN House ON Student.House_ID = House.House_ID

One nice benefit of joining on a column that has the same name (i.e., House_ID here)
is you can use USING clause

SELECT * FROM Student JOIN House USING (House_ID);

Meanwhile, back in the bird database:

SELECT COUNT(*) FROM Bird_eggs;

For better viewing:
.mode line

SELECT * FROM Bird_eggs LIMIT 1;
SELECT * FROM Bird_eggs JOIN Bird_nests USING (Nest_ID) LIMIT 1;
SELECT COUNT(*) FROM Bird_eggs JOIN Bird_nests USING (Nest_ID);
.mode duckbox

Import point!!!  Ordering is assuredly lost doing a JOIN.  So don't say this:
Ordering should always and only be the very last thing

SELECT * FROM
  (SELECT * FROM Bird_eggs ORDER BY Width)
  JOIN Bird_nests
  USING (Nest_ID);

Gotcha with DuckDB... it's not as smart as some other databases

SELECT Nest_ID, COUNT(*)
  FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
  GROUP BY Nest_ID;

Some databases allow you to say:

SELECT Nest_ID, Species, COUNT(*)
  FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
  GROUP BY Nest_ID;

Workarounds:

SELECT Nest_ID, ANY_VALUE(Species), COUNT(*)
  FROM Bird_eggs JOIN Bird_nests USING (Nest_ID)
  GROUP BY Nest_ID;

SELECT Nest_ID, Species, COUNT(*)
  FROM Bird_eggs JOIN Bird_nests USING (Nest_ID)
  GROUP BY Nest_ID, Species;

SELECT Nest_ID, Species, Egg_num, Width, Length FROM
  Bird_eggs JOIN Bird_nests USING (Nest_ID)
  ORDER BY Nest_ID, Egg_num
  LIMIT 10;

Can two species inhabit the same nest?
.table Bird_nests

ANY_VALUE literally returns any value
SELECT Nest_ID, ANY_VALUE(Width)
  FROM Bird_eggs
  GROUP BY Nest_ID;