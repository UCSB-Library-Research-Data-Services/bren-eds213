-- Let's first to try to import the snow survey data in a new database
-- from the ASDN folder run:
-- duckdb import_test.duckdb 

CREATE TABLE Snow_surveys (
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
COPY Snow_surveys FROM 'snow_survey_fixed.csv' (header TRUE);

-- Adding it to the real database from the database folder this time
-- duckdb database.db

CREATE TABLE Snow_surveys (
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
-- Nope
COPY Snow_surveys FROM 'snow_survey_fixed.csv' (header TRUE);
-- Yep
COPY Snow_surveys FROM '../ASDN_csv/snow_survey_fixed.csv' (header TRUE);

SELECT * from Personnel WHERE Abbreviation ILIKE '%jz%';

-- jzamuido vs jzamudio (typos)!!!


-- Exporting the entire databse
EXPORT DATABASE 'export_adsn';