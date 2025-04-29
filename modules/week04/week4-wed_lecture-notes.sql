-- Let's first to try to import the snow survey data in a new database
-- from the ASDN folder run:
-- duckdb import_test.duckdb 

CREATE TABLE Snow_cover (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Date DATE NOT NULL,
    Plot VARCHAR NOT NULL,
    Location VARCHAR NOT NULL,
    Snow_cover REAL,
    Water_cover REAL,
    Land_cover REAL,
    Total_cover REAL,
    Observer VARCHAR NOT NULL,
    Notes VARCHAR,
    PRIMARY KEY (Site, Plot, Location, Date)
);
COPY Snow_cover FROM 'snow_survey_fixed.csv' (header TRUE);

-- Adding it to the real database from the database folder this time
-- duckdb database.db

CREATE TABLE Snow_cover (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Date DATE NOT NULL,
    Plot VARCHAR NOT NULL,
    Location VARCHAR NOT NULL,
    Snow_cover REAL,
    Water_cover REAL,
    Land_cover REAL,
    Total_cover REAL,
    Observer VARCHAR NOT NULL,
    Notes VARCHAR,
    PRIMARY KEY (Site, Plot, Location, Date),
    FOREIGN KEY (Site) REFERENCES Site (Code)
);

.tables

-- load the data
-- Nope
COPY Snow_cover FROM 'snow_survey_fixed.csv' (header TRUE);

-- Better But NAs!!
COPY Snow_cover FROM '../ASDN_csv/snow_survey_fixed.csv' (header TRUE);

-- Check how the table looks like
SELECT * FROM Snow_cover LIMIT 10;
DROP TABLE Snow_cover;

-- correct
COPY Snow_cover FROM '../ASDN_csv/snow_survey_fixed.csv' (header TRUE, nullstr "NA");

-- Check how the table looks like
SELECT * FROM Snow_cover LIMIT 10;



--------------------------------------------------------
-- Ask 1: What is the average snow cover at each site?
SELECT * FROM Snow_cover LIMIT 10;

SELECT Site, AVG(Snow_cover) FROM Snow_cover
  GROUP BY Site;

-- Ask 2: Order the result to get the top 3 snowy sites?
SELECT Site, AVG(Snow_cover) AS avg_snowcover FROM Snow_cover
  GROUP BY Site
  ORDER BY avg_snowcover DESC
  LIMIT 3;

-- Ask 3: Save your results into a view named  Site_avg_snowcover
CREATE VIEW Site_avg_snowcover AS (SELECT Site, AVG(Snow_cover) AS avg_snowcover FROM Snow_cover
  GROUP BY Site
  ORDER BY avg_snowcover DESC
  LIMIT 3);

-- Ask 4: How do I check the view was created?
.tables
SELECT * FROM Site_avg_snowcover;

-- Ask 5: Looking at the data, we have now a doubt about the meaning of the zero values... what if most of them where supposed to be NULL?! Does it matters? write a query that would check that?
SELECT Site, AVG(Snow_cover) AS avg_snowcover_nozero FROM Snow_cover
  WHERE Snow_cover > 0
  GROUP BY Site
  ORDER BY avg_snowcover_nozero DESC
  LIMIT 3;

-- Ask 6: Save your results into a  temporary table named  Site_avg_snowcover_nozeros
CREATE TEMP TABLE Site_avg_snowcover_nozeros AS (SELECT Site, AVG(Snow_cover) AS avg_snowcover_nozero FROM Snow_cover
  WHERE Snow_cover > 0 AND Site IN (SELECT DISTINCT Site FROM Site_avg_snowcover)
  GROUP BY Site
  ORDER BY avg_snowcover_nozero DESC
  );

.tables

-- Ask 7: Compute the difference between those two ways of computing average
SELECT Site, avg_snowcover_nozero - avg_snowcover AS avg_snowcover_diff FROM Site_avg_snowcover
  JOIN Site_avg_snowcover_nozeros USING (Site);

-- Ask 8: Which site would be the most impacted if zeros were not real zeros? Of Course we need a table for that :)
SELECT Site, avg_snowcover,  avg_snowcover_nozero, avg_snowcover_nozero - avg_snowcover AS avg_snowcover_diff FROM Site_avg_snowcover
  JOIN Site_avg_snowcover_nozeros USING (Site)
  ORDER BY avg_snowcover_diff DESC
  LIMIT 1;

-- Ask 9: So? Would it be time well spent to further look into the meaning of zeros?
YES!! 

-- We found out that actually at the plot `brw0` of the site barr, 0 means NULL... let's update our Snow_cover table
CREATE TABLE Snow_cover_backup AS SELECT * FROM Snow_cover; -- Create a copy of the table to be safe (and not cry a lot)

-- For Recall
SELECT * FROM Site_avg_snowcover;
SELECT * FROM Site_avg_snowcover_nozeros;
-- update the 0 for that site
UPDATE Snow_cover SET Snow_cover = NULL WHERE Plot = 'brw0' AND Snow_cover = 0; 
-- Check the update was succesful
SELECT * FROM Snow_cover WHERE Plot = 'brw0';
-- We should probably recompute the avg, let's check
SELECT * FROM Site_avg_snowcover;
-- What just happened!?




