-- sqlite3 database/database.sqlite


CREATE TABLE Species (
    Code TEXT PRIMARY KEY,
    Common_name TEXT UNIQUE NOT NULL,
    Scientific_name TEXT, -- can't make NOT NULL, missing data in some rows
    Relevance TEXT
);

CREATE TRIGGER Update_species
AFTER INSERT ON Species
FOR EACH ROW
BEGIN
   UPDATE Species
   SET Scientific_name = NULL
   WHERE Code = new.Code AND Scientific_name = '';
   UPDATE something else...;
END;


.import --csv --skip 1 species.csv Species
