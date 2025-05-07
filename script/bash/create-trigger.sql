-- Sofia Ingersoll
-- WK5 Q2
-- 2024 / 5 / 10

-- Part 1
-- create a trigger that will fire an UPDATE statement 
-- that will fill in a value for Egg_num in either situation below.
.nullvalue -NULL-
SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01';

.nullvalue -NULL-
SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01';


-- the UPDATE statement must be terminated by a semicolon,
-- and the CREATE TRIGGER statement must be terminated by a semicolon.

-- What column(s) to update?
-- Well that’s easy, it’s just Egg_num.

-- What row(s) to modify. 
-- Well, you want to modify just one row, the row that was just inserted.

-- Use SELECT statement to return new.Nest_ID 
-- this is bc it's the nests that contain the eggs

-- What WHERE clause could you use to identify this brand-new row? It has a unique signature.
-- Nest_ID = new.Nest_ID


-- try out your trigger by creating it, doing an INSERT,
-- and then seeing what the rows for that particular nest look like. 
-- If your trigger doesn’t work for some reason, 
-- you may need to DROP TRIGGER egg_filler; before creating it again.


-- activate sqlite
sqlite3 database.sqlite 

--- Creating a trigger to fill egg_num for new inserts

CREATE TRIGGER egg_filler
AFTER INSERT ON Bird_eggs
FOR EACH ROW
BEGIN
    UPDATE Bird_eggs
    SET Egg_num = (
        -- ensuring it's one greater than the current maximum value
        -- or starts from 1 if there are no existing eggs.
        SELECT COALESCE(MAX(Egg_num), 0) + 1
        FROM Bird_eggs
        WHERE Nest_ID = new.Nest_ID
    )
    WHERE ROWID = new.ROWID;
END;

-- just a quick investigation to make sure 
-- doing an INSERT
INSERT INTO Bird_eggs
    (Book_page, Year, Site, Nest_ID, Length, Width)
    VALUES ('b14.6', 2014, 'eaba', '14eabaage01', 12.34, 56.78);

-- and peeking at the newly inserted row
SELECT * FROM Bird_eggs WHERE ROWID = last_insert_rowid();

-- SWEET! Egg_num is 4!!!
b14.6|2014|eaba|14eabaage01|4|12.34|56.78
-- let's drop it and move forward!
DROP TRIGGER egg_filler;



-- Part 2 + Part 3 Unofficial
-- Let's turn up the heat and fire off a bunch of triggers!
-- The goal is to automate filling in new data using the Nest_ID
-- Using Nest_ID, we can auto-fill Book_page, Year, Site
-- I personally think including year is dangerous 
-- unless every site has a specified year for sampling

CREATE TRIGGER egg_filler
AFTER INSERT ON Bird_eggs
FOR EACH ROW
BEGIN
    UPDATE Bird_eggs
    SET Egg_num = (
        SELECT COALESCE(MAX(Egg_num), 0) + 1
        FROM Bird_eggs
        WHERE Nest_ID = new.Nest_ID
    )
    WHERE ROWID = new.ROWID;

    UPDATE Bird_eggs
    SET Book_page = (
        SELECT Book_page
        FROM Bird_nests
        WHERE Nest_ID = new.Nest_ID
    )
    WHERE ROWID = new.ROWID;

    UPDATE Bird_eggs
    SET Year = (
        SELECT Year
        FROM Bird_nests
        WHERE Nest_ID = new.Nest_ID
    )
    WHERE ROWID = new.ROWID;

    UPDATE Bird_eggs
    SET Site = (
        SELECT Site
        FROM Bird_nests
        WHERE Nest_ID = new.Nest_ID
    )
    WHERE ROWID = new.ROWID;
END;


-- just a quick investigation to make sure 
-- doing an INSERT
INSERT INTO Bird_eggs (Nest_ID, Length, Width)
VALUES ('14eabaage01', 12.34, 56.78);

-- given that you can reference new.Nest_ID, new.Length, and new.Width,
-- what SELECT statements could you use to find the correct values for Book_page, Year, and Nest_ID
SELECT * FROM Bird_eggs WHERE ROWID = last_insert_rowid();

-- zoooooweee! nice
b14.6|2014|eaba|14eabaage01|5|12.34|56.78