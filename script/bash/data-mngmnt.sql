-- Import the data
COPY Snow_cover FROM 'snow_cover_fixedman_JB.csv' (header TRUE);

-- Update the 0 for that site
UPDATE Snow_cover SET Snow_cover = 



-- Exporting 
-- Create a csv file and save it 
COPY Species TO 'species_fixed.csv' (HEADER, DELIMITER ',');

SELECT * FROM Species 
WHERE Relevance IS NULL;

-- STEP 1 create table
CREATE TABLE Snow_cover (
    Plot VARCHAR, -- SOME NULL DATA
    Location VARCHAR NOT NULL,
    Snow_cover INTEGER CHECK (Snow_cover > -1 AND Snow_cover < 101),
    OBserver VARCHAR
);

-- STEP 2 load data into table
-- IMPORT CSV using filepath
COPY Snow_cover 
FROM 'snow_cover_fixedman_JB.csv'(HEADER TRUE);


-- Triggers 