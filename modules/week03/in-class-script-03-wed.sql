.table
# recap from Monday
# keywords are ALL CAPS, we did queries such as
SELECT DISTINCT Location
   FROM Site
   ORDER BY Location
   LIMIT 3;

-- FILTERING
-- looks just like in R or Python
SELECT * FROM Site WHERE Area < 200;
SELECT * FROM Site WHERE Area < 200 AND Latitude > 60;
-- older-style operators
SELECT * FROM Site WHERE Code != 'iglo';
SELECT * FROM Site WHERE Code <> 'iglo'; -- older style
-- expression: the usual operators, plus lots functions like regex

## EXPRESSIONS
SELECT Site_name, Area*2.47 FROM Site;
-- very handy to give a name to columns
SELECT Site_name, Area*2.47 AS Area_acres FROM Site;

-- string concatenation
-- old-style operator: ||
SELECT Site_name || ', ' || Location AS Full_name FROM Site;
-- there are probably other operators, let's see
SELECT Site_name + Location FROM Site;

-- BTW, you have another fancy calculator!
SELECT 2+2;

-- adding "AS ..." needs to come right after the thing you want to name
SELECT Site_name AS some_other_name FROM Site LIMIT 1;

## AGGREGATION & GROUPING

-- How many rows are in this table?
SELECT COUNT(*) FROM Bird_nests;
-- the "*" in the above means, just count rows
-- We can also ask, how non-NULL values are there?
SELECT COUNT(*) FROM Species;
SELECT COUNT(Scientific_name) FROM Species;

-- Very handy to count number of distinct things
SELECT COUNT(*) FROM Site; -- just an idiom, it doesn't make much sense
SELECT COUNT(DISTINCT Location) FROM Site; -- number of distinct locations
SELECT COUNT(Location) FROM SITE; -- number of non-NULL locations
-- reminder from Monday:
SELECT DISTINCT Location FROM Site;

-- The usual aggregation functions
SELECT AVG(Area) FROM Site;
SELECT MIN(Area) FROM Site;

-- This won't work, but suppose we want to list the 7 locations
-- that occur in the Site table, along with the average areas
SELECT Location, AVG(Area) FROM Site;

-- enter grouping
SELECT Location, AVG(Area) FROM Site GROUP BY Location;
-- similar for counting
SELECT Location, COUNT(*) FROM Site GROUP BY Location;
-- for comparison
-- Site %>% group_by(Location) %>% summarize(count=n())

-- We can site have WHERE clauses!
SELECT Location, COUNT(*)
  FROM Site
  WHERE Location LIKE '%Canada' -- old-style patter-matching, NOT full regex, just wildcard (%)
  GROUP BY Location;

-- the order of the clauses reflect the order of the processing
-- But, what if you want to do some filtering on your groups, i.e., *after* you've done the grouping?
SELECT Location, MAX(Area) AS Max_area
  FROM Site
  WHERE Location LIKE '%Canada'
  GROUP BY Location
  HAVING Max_area > 200
  ORDER BY Max_area DESC;

## RELATIONAL ALGEBRA
-- Everything is a table
-- Every query, every statement actually, returns a table
SELECT COUNT(*) FROM Site;
-- you can save tables, you can nest queries
SELECT COUNT(*) FROM (  SELECT COUNT(*) FROM Site  );

-- you can nest queries
SELECT DISTINCT Species FROM Bird_nests;
SELECT Code FROM Species
  WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);

## NULL processing
-- NULL is infectious
-- In a table, NULL means no data, the absence of a value
-- In an expression, NULL means unknown
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod = 'float';
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod <> 'float';

-- This won't work, but you will try it by accident anyway
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod = NULL;
-- THE ONLY WAY
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod IS NULL;
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod IS NOT NULL;
-- so-called "tri-value" logic

-- JOINS
-- 90% of the time, we'll join tables based on a foreign key relationship
SELECT * FROM Camp_assignment;
SELECT * FROM Camp_assignment JOIN Personnel
  ON Observer = Abbreviation
  LIMIT 10;

-- join is a very general operation, can be applied to any tables, with any expression joining them
-- fundamentally, joins always start from Cartesian product of the table
-- CROSS JOIN = Cartesian product
SELECT * FROM Site CROSS JOIN Species;
SELECT COUNT(*) FROM Site;
SELECT COUNT(*) FROM Species;
SELECT 99*16;

-- *any* condition can be expression, we have complete freedom here

-- But when there *is* a foreign key relationship, then
-- what happens?
-- the result is the same as as the table with the foreign, but augmented with additional columns 
SELECT * FROM Bird_nests BN JOIN Species S
  ON BN.Species = S.Code
  LIMIT 5;
SELECT COUNT(*) FROM Bird_nests BN JOIN Species s
  ON BN.Species = S.Code;

-- Table aliases
-- Sometimes, if column names are ambiguous where they're coming from,
-- need qualify them
SELECT * FROM Bird_nests JOIN Species
  ON Bird_nests.Species = Species.Code;
-- same, using a table alias
SELECT * FROM Bird_nests AS BN JOIN Species AS S
  ON BN.Species = S.Code;
-- even more compact, leave out the "AS"