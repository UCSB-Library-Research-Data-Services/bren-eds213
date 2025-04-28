

-- How to export a database

-- Exporting the entire database, including schema!! This is a DuckDB feature though
   EXPORT DATABASE 'export_adsn'; 
   
-- Export an entire table
   COPY Species TO 'output.csv' (HEADER, DELIMITER ',');
   
-- Export a specific query
   COPY (SELECT * FROM Species) TO 'species_db.csv' (HEADER, DELIMITER ',');
   

Managing Data

-- inserting data
SELECT * FROM Species;
.maxrows 8
INSERT INTO Species VALUES ('abcd', 'thing', 'scientific name', NULL);
SELECT * FROM Species;
-- you can explicitly label the columns
INSERT INTO Species (Common_name, Scientific_name, Code, Relevance)
  VALUES ('thing 2', 'another scientific name', 'efgh', NULL);
-- take advantage of default values
INSERT INTO Species (Common_name, Code) VALUES ('thing 3', 'ijkl');
SELECT * FROM Species;
.nullvalue -NULL-
-- UPDATE and DELETE
UPDATE Species SET Relevance = 'not sure yet' WHERE Relevance IS NULL;
SELECT * FROM Species;
DELETE FROM Species WHERE Relevance = 'not sure yet';
SELECT * FROM Species;
-- safe delete practice #1
SELECT * FROM Species WHERE Relevance = 'Study species';
-- after confirming, then edit the statement
DELETE FROM Species WHERE Relevance = 'Study species';
-- incomplete statement
-- leave of "DELETE", then add it after visual confirmation
DELETE FROM Species WHERE ....