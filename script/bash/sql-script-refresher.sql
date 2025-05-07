-- Monday 2024 4 15


-- This is a comment
-- This is documenting what we're writing in the terminal, so we have it for later

-- Make sure your working directory is this folder
-- Activate duckdb
-- Activate database.db

-- selecting all columns '*' from species table
SELECT * FROM Species;
.tables

-- limiting rows
.maxrows 10
SELECT * FROM Species;

-- essentially head() 
SELECT * FROM Species LIMIT 5;

-- Used in standard web servers 
SELECT * FROM Species LIMIT 5 OFFSET 5;

-- SQL is case-insensitive
select * from species;

-- How many rows in all columns?
SELECT COUNT(*) FROM Species;

-- How many non-NULL values?
-- it appears there are 2
SELECT COUNT(Scientific_name) FROM Species;

-- How many distinct values occur?
SELECT DISTINCT Species FROM Bird_nests;

-- Select which columns to return by naming them
SELECT * FROM Species;
SELECT Code, Common_name FROM Species;
SELECT Species FROM Bird_nests;
SELECT DISTINCT Species FROM Bird_nests;

-- Get distinct combinations?
SELECT DISTINCT Species, Observer FROM Bird_nests;

-- Ordering of results
-- Remember, there's no real order. The database is an engine with its own brain, so it changes every time
SELECT DISTINCT Species FROM Bird_nests ORDER BY Species;

-- Exercise what distinct locaitons occur in the site table Order them
-- also limit to 3 results
SELECT DISTINCT Location FROM Site ORDER BY Location LIMIT 3;


.maxrow 6
SELECT Location FROM Site;
SELECT * FROM Site WHERE Area < 200;
SELECT * FROM SITE WHERE Area < 200 AND Location LIKE '%USA';
SELECT * FROM SITE WHERE Area < 200 AND Location ILIKE '%usa';


-- Expressions
SELECT Site_name, Area FROM Site;
SELECT Site_name, Area*2.47 FROM Site;
SELECT Site_name, Area*2.47 AS Area_acres FROM Site;

-- Concatonate
SELECT Site_name || 'foo' FROM Site;

-- Aggregation 
-- these can produce NULL values
SELECT COUNT(*) FROM Site;
SELECT COUNT(*) AS num_rows FROM_SITE;

.help mode
.mode box
SELECT Site_name, Area*2.47 AS Area_acres FROM Site;

.mode duckbox
SELECT COUNT(Scientific_name) FROM Species;
SELECT DISTINCT Relevance FROM Species;
SELECT COUNT(DISTINCT Relevance) FROM Species;

-- MIN, MAX, AVG
SELECT AVG(Area) FROM Site;

-- Grouping & Collapsing w/ Aggregation
SELECT * FROM Site;
SELECT Location, MAX(Area) 
    FROM Site
    GROUP BY Location;
-- 
SELECT Location, COUNT(*)
    FROM Site
    GROUP BY Location;
-- Counts NULLS 
SELECT FROM Species;
SELECT Relevance, COUNT(Scientific_name)
    FROM Species
    GROUP BY Relevance;

-- Adding WHERE Clause
SELECT Location, MAX(Area)
    FROM Site
    GROUP BY Location;

SELECT Location, MAX(AREA)
    FROM Site
    WHERE Location LIKE "%Canada"
    GROUP BY Location;

SELECT Location, MAX(Area) AS Max_area
    FROM Site
    WHERE Location LIKE '%Canada'
    GROUP BY Location
    HAVING Max_area > 200;


    -- Relational Algebra Peeks Through
    SELECT COUNT(*) FROM Site;

    SELECT COUNT(*) FROM (SELECT COUNT(*) FROM Site);

    SELECT * FROM Bird_nests LIMIT 3;


    -- permanently create table inside database
    -- this is essentially a join without directly using join
    CREATE TABLE t_perm AS
        SELECT * FROM Species WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests):
    SELECT * FROM t;
    SELECT * FROM t_perm;
    -- remove table
    DROP TABLE t_perm;

    -- NULL Processing 
    -- these are different amounts bc of tri-value outputs
    SELECT COUNT(*) FROM Bird_nests
        WHERE floatAge > 5;
    -- tri-value outputs here (true, false, or NULL)
    SELECT COUNT(*) FROM Bird_nests
        WHERE floatAge <= 5;
    SELECT COUNT(*) FROM Bird_nests
    -- This wont tell us what's null
    SELECT COUNT(*) FROM Bird_nests WHERE floatAge = NULL;
    -- THIS WILL
    SELECT COUNT(*) FROM Bird_nests WHERE floatAge IS NULL;

-- Joins
SELECT * FROM Camp_assignment;
SELECT * FROM Personnel;

.mode csv
SELECT * FROM Camp_assignment JOIN Personnel
-- use db table to see this connection
    ON Observer = Abbreviation
    LIMIT 3;
-- duckdb reserves the word "end" so we have to quote it
-- this is a denormalized table because we have a ton of duplicates
SELECT Name, Year, Site, Start, "End"
    FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation
    LIMIT 3;

-- this is what to do when it's ambiguous what table ur referring to
.mode duckbox
SELECT * FROM Camp_assignment JOIN Personnel
    ON Camp_assignment.Observer = Personnel.Abbreviation;
-- same query, but we can qualify columns with table names & abbreviations
SELECT * FROM Camp_assignment AS ca JOIN Personnel permanently 
    ON ca.Observer = p.Abbreviation;


-- multiway joins
-- Conceptually, we now get columns from all three tables to make a mega table
SELECT * FROM Camp_assignment ca JOIN Personnel p
    ON ca.Observer = p.Abbreviation
    JOIN Site sameON ca.site = s.Code 
    LIMIT 3;

-- order the results at the very end of the query or they will be overwritten
SELECT * FROM Camp_assignment ca JOIN Personnel p
    ON ca.Observer = p.Abbreviation
    JOIN Site s
    ON ca.Site = s.Code
    WHERE ca.observer = 'lmckinnon' 
    LIMIT 3;

-- order by: at end
-- THIS IS AN OVERWRITTING EXAMPLE: I.E. BAD EXAMPLE, DON'T USE
SELECT * FROM Camp_assignment ca JOIN (
    SELECT * FROM Personnel ORDER BY Abbreviation
) p
    ON ca.Observer = p.Abbreviation
    JOIN Site s
    ON ca.Site = s.Code
    WHERE ca.observer = 'lmckinnon' 
    LIMIT 3;

-- more on grouping
SELECT Nest_ID, COUNT(*) FROM Bird_eggs GROUP BY Nest_ID;


-- to exit
cntrl + D 

SELECT Nest_ID, COUNT(*) FROM Bird_eggs,
GROUP BY Nest_ID;
.maxrows 8
SELECT Species FROM Bird_nests WHERE Site = 'nome';
SELECT Species, COUNT(*) AS Nest_count
    FROM Bird_nests
    WHERE SITE = 'nome'
    GROUP BY Species
    ORDER BY Species
    LIMIT 2;

-- We can nest things!
SELECT Scientific_name, Nest_count FROM
    (SELECT Nest_ID, COUNT(*) FROM Bird_eggs,
    GROUP BY Nest_ID;
    SELECT Species FROM Bird_nests WHERE Site = 'nome'
    SELECT Species, COUNT(*) AS Nest_count
    FROM Bird_nests
    WHERE SITE = 'nome'
    GROUP BY Species
    ORDER BY Species) JOIN Species ON Species = Code;



-- Outer join
CREATE TEMP TABLE a (cola INTEGER, common INTEFER);
INSERT INTO A VALUES (1,1), (2,2), (3,3);
SELECT * FROM a;
CREATE TEMP TABLE b (common INTEGER, colb INTEGER);
INSERT INTO b VALUES (2,2), (3,3), (4,4), (5,5);
SELECT * FROM b;
-- inner join
SELECT * FROM a JOIN b USING (common);
SELECT * FROM a INNER JOIN b USING (common);
-- Left or right outer join
SELECT * FROM a LEFT JOIN b USING (common);

.nullvalue -NULL-

SELECT * FROM a RIGHT JOIN b USING (common);

-- What species do not have any nest data
SELECT * FROM Species 
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);

-- Answer same question with outer join


SELECT * FROM Species LEFT JOIN Bird_nests ON Code = Species;
SELECT * FROM Species RIGHT JOIN Bird_nests ON Code = Species;
SELECT * FROM Species OUT JOIN Bird_nests ON Code = Species;


-- Added extra rows and included NULL values for observations without bird nest observations
SELECT Code, Scientific_name, Nest_ID, Species, Year
    FROM Species LEFT JOIN Bird_nests ON Code = Species;
.nullvalue -NULL-

SELECT Count(*) FROM Bird_nests WHERE Species = 'ruff';

-- What species have nests?
SELECT Code, Scientific_name, Nest_ID, Species, Year
    FROM Species LEFT JOIN Bird_nests ON Code = Species
    WHERE Nest_ID IS NULL;


-- Grouping 'GOTCHA!'
SELECT * FROM Bird_eggs LIMIT 3;

-- This shows us that there are 3 duplicate rows called from the difference in egg_number input from bird_nests
SELECT * FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    WHERE Nest_ID = '14eabaage01';

SELECT Nest_ID, COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    WHERE Nest_ID = '14eabaage01'
    GROUP BY Nest_ID;

-- but what about this ERROR?
-- it does not blend the data bases and your asking for something that doesn't make sense
SELECT Nest_ID, COUNT(*), Length 
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    WHERE Nest_ID = '14eabaage01'
    GROUP BY Nest_ID;

-- Check this FUNK output out
-- This data base is able to do this command but it will provide duplicates
SELECT Nest_ID, COUNT(*), 
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    WHERE Nest_ID = '14eabaage01'
    GROUP BY Nest_ID;

-- work around #1
SELECT Nest_ID, COUNT(*), 
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    WHERE Nest_ID = '14eabaage01'
    GROUP BY Nest_ID, Species;

-- work around #2
SELECT Nest_ID, COUNT(*), 
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    WHERE Nest_ID = '14eabaage01'
    GROUP BY Nest_ID;

-- View
-- This is an alias to preview the data rather than storing it as an actual set table like a temp table
CREATE VIEW v AS
SELECT * FROM Camp_assignment;
SELECT Year, Site, Name, Start, "End"
    FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation;

-- to use this
SELECT * FROM v;


-- More views
CREATE VIEW v2 AS SELECT COUNT(*) FROM Species;
SELECT * FROM v2;

-- Set operations: UNION, INTERSECT, EXCEPT
SELECT Book_page, Nest_ID, Egg_num, Length, Width FROM Bird_eggs;
-- corrects length and width
SELECT Book_page, Nest_ID, Egg_num, Length*25.4, Width*25.4 FROM Bird_eggs
    WHERE Book_page = 'b14.6'
    UNION
-- this does not consider nulls
SELECT Book_page, Nest_ID, Egg_num, Length, Width, FROM Bird_eggs
    WHERE Book_page != 'b14.6';

-- Mashes tables together, so it can get really messy when you're playing around
-- not everything is related if db is able to generate request

-- Third way: which species have no nest data
SELECT Code FROM Species
    EXCEPT SELECT DISTINCT Species FROM Bird_nests;


-- To remove an entire thing use the word DROP 
-- this will allow us to remove an old preview configuration and write over it
DROP VIEW v;


-- Monday Week 5 April 29

-- inserting data
-- We don't want to do it this way bc it's not explicit
SELECT * FROM Species;
.maxrows 8
INSERT INTO Species VALUES ('abcd','thing','scientific name', NULL);

SELECT * FROM Species;


-- you can explicitly label columns
INSERT INTO Species (Common_name, Scientific_name, Code, Relevance)
    -- this will match the column order
    VALUES ('thing 2', 'another_scientific name', 'efgh', NULL);

-- take advantage of default values
INSERT INTO Species (Common_name, Code) 
VALUES ('thing3', 'ijkl');

SELECT * FROM Species;
.nullvalue -NULL-



-- UPDATE & DELETE 
-- CAUTION: THESE ARE VERY DANGEROUS COMMANDS
-- VERY POWERFULL
--  E.G. DELETE FROM Species (without a where clause) will remove the entire table
-- since we don't start with the WHERE clause, we need a safety net
-- here are some examples


-- confirm the rows you want to delete first
SELECT * FROM Species
WHERE Relevance = 'Study species';

-- now that i've confirmed these are the rows I want
-- let's edit the previous clause
DELETE * FROM Species
WHERE Relevance = 'Study species';



-- incomplete statement 
FROM Species WHERE ...

-- Then after checking add delete
DELETE FROM Species WHERE 


-- update instances 
UPDATE Species SET Relevance = 'not sure yet' 
WHERE Relevance IS NULL;

SELECT * FROM Species;

-- remove instances
DELETE Species
DELETE FROM Species 
WHERE Relevance = 'not sure yet';

-- check

SELECT * FROM Species


