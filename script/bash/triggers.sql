-- create trigger
CREATE TRIGGER Update_species
SET Scientific_name = NULL
WHERE Code = new.Code AND Scientific_name = '';-- <the row is the one just inserted>

-- Triggers using sqlite3
CREATE TABLE Species (
    Code TEXT PRIMARY KEY,
    Common_name TEXT UNIQUE NOT NULL,
    Scientific_name TEXT, -- csn't name NOT NULL, missing data in some rows
    Relevance TEXT
);


CREATE TRIGGER Update_species
AFTER INSERT ON Species
FOR EACH rowBEGIN
    UPDATE SpeciesSET Scientific_name = NULL
    WHERE Code = new.Code AND Scientific_name = '';
END;

.import --csv --skip 1 species.csv Species
