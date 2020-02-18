*************************************************************************
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'university_professors' 
AND table_schema = 'public';
*************************************************************************
SELECT * 
FROM university_professors 
LIMIT 5;
*************************************************************************
CREATE TABLE universities (
university_shortname text,
university text,
university_city text);

-- Print the contents of this table
SELECT * 
FROM universities
*************************************************************************
ALTER TABLE professors
ADD COLUMN university_shortname text;

-- Print the contents of this table
SELECT * 
FROM professors
*************************************************************************
ALTER TABLE affiliations
RENAME COLUMN organisation TO organization;
*************************************************************************
ALTER TABLE affiliations
DROP COLUMN university_shortname;
*************************************************************************
INSERT INTO professors 
SELECT DISTINCT firstname, lastname, university_shortname 
FROM university_professors;

-- Doublecheck the contents of professors
SELECT * 
FROM professors;
*************************************************************************
INSERT INTO affiliations 
SELECT DISTINCT firstname, lastname, function, organization 
FROM university_professors;

-- Doublecheck the contents of affiliations
SELECT * 
FROM affiliations;
*************************************************************************
DROP TABLE university_professors;
*************************************************************************
SELECT transaction_date, amount + CAST(fee AS integer) AS net_amount 
FROM transactions;
*************************************************************************
SELECT transaction_date, CAST(fee AS integer) AS fee
FROM transactions;
*************************************************************************
ALTER TABLE professors
ALTER COLUMN university_shortname
TYPE char(3);
*************************************************************************
ALTER TABLE professors
ALTER COLUMN firstname
TYPE varchar(64);
*************************************************************************
ALTER TABLE professors 
ALTER COLUMN firstname 
TYPE varchar(16)
USING SUBSTRING(firstname FROM 1 FOR 16)
*************************************************************************
ALTER TABLE professors
ALTER COLUMN lastname SET NOT NULL
*************************************************************************
ALTER TABLE universities
ADD CONSTRAINT university_shortname_unq UNIQUE(university_shortname);
*************************************************************************
ALTER TABLE organizations
ADD CONSTRAINT organization_unq UNIQUE(organization);
*************************************************************************
SELECT COUNT(DISTINCT(university_city)) 
FROM universities;
*************************************************************************
SELECT COUNT(DISTINCT(university_shortname)) 
FROM professors;
*************************************************************************
SELECT COUNT(DISTINCT(firstname, lastname)) 
FROM professors;
*************************************************************************
ALTER TABLE universities
RENAME COLUMN university_shortname TO id;


-- Make id a primary key
ALTER TABLE universities
ADD CONSTRAINT university_pk PRIMARY KEY (id);
*************************************************************************
ALTER TABLE professors 
ADD COLUMN id SERIAL;
*************************************************************************
ALTER TABLE professors 
ADD COLUMN id serial;

-- Make id a primary key
ALTER TABLE professors 
ADD CONSTRAINT professors_pkey PRIMARY KEY(id);
*************************************************************************
-- Add the new column to the table
ALTER TABLE professors 
ADD COLUMN id serial;

-- Make id a primary key
ALTER TABLE professors 
ADD CONSTRAINT professors_pkey PRIMARY KEY (id);

-- Have a look at the first 10 rows of professors
SELECT * 
FROM professors
LIMIT 10;
*************************************************************************
SELECT COUNT(DISTINCT(make, model))
FROM cars;
*************************************************************************
SELECT COUNT(DISTINCT(make, model)) 
FROM cars;

-- Add the id column
ALTER TABLE cars
ADD COLUMN id varchar(128);
*************************************************************************
SELECT COUNT(DISTINCT(make, model)) 
FROM cars;

-- Add the id column
ALTER TABLE cars
ADD COLUMN id varchar(128);

-- Update id with make + model
UPDATE cars
SET id = CONCAT(make, model);
*************************************************************************
-- Count the number of distinct rows with columns make, model
SELECT COUNT(DISTINCT(make, model)) 
FROM cars;

-- Add the id column
ALTER TABLE cars
ADD COLUMN id varchar(128);

-- Update id with make + model
UPDATE cars
SET id = CONCAT(make, model);

-- Make id a primary key
ALTER TABLE cars
ADD CONSTRAINT id_pk PRIMARY KEY(id);

-- Have a look at the table
SELECT * FROM cars;
*************************************************************************
CREATE TABLE students (
  last_name varchar(128) NOT NULL,
  ssn integer PRIMARY KEY,
  phone_no char(12)
);
*************************************************************************
ALTER TABLE professors
RENAME COLUMN university_shortname TO university_id;
*************************************************************************
ALTER TABLE professors
ADD CONSTRAINT professors_fkey 
FOREIGN KEY (university_id) 
REFERENCES universities (id);
*************************************************************************
INSERT INTO professors (firstname, lastname, university_id)
VALUES ('Albert', 'Einstein', 'UZH');
*************************************************************************
SELECT professors.lastname, universities.id, universities.university_city
FROM professors
JOIN universities
ON professors.university_id = universities.id
WHERE universities.university_city = 'Zurich';
*************************************************************************
-- Add a professor_id column
ALTER TABLE affiliations
ADD COLUMN professor_id integer REFERENCES professors (id);
*************************************************************************
-- Rename the organization column to organization_id
ALTER TABLE affiliations
RENAME COLUMN organization TO organization_id;
*************************************************************************
ALTER TABLE affiliations
ADD CONSTRAINT affiliations_organization_fkey 
FOREIGN KEY (organization_id) 
REFERENCES organizations (id);
*************************************************************************
SELECT * 
FROM affiliations
LIMIT 10;
*************************************************************************
UPDATE affiliations
SET professor_id = professors.id
FROM professors
WHERE affiliations.firstname = professors.firstname 
AND affiliations.lastname = professors.lastname;
*************************************************************************
ALTER TABLE  affiliations
DROP COLUMN firstname;

-- Drop the lastname column
ALTER TABLE  affiliations
DROP COLUMN lastname;
*************************************************************************
SELECT constraint_name, table_name, constraint_type
FROM information_schema.table_constraints
WHERE constraint_type = 'FOREIGN KEY';
*************************************************************************
ALTER TABLE affiliations
DROP CONSTRAINT affiliations_organization_id_fkey;
*************************************************************************
-- Identify the correct constraint name
SELECT constraint_name, table_name, constraint_type
FROM information_schema.table_constraints
WHERE constraint_type = 'FOREIGN KEY';

-- Drop the right foreign key constraint
ALTER TABLE affiliations
DROP CONSTRAINT affiliations_organization_id_fkey;

-- Add a new foreign key constraint from affiliations to organizations which cascades deletion
ALTER TABLE affiliations
ADD CONSTRAINT affiliations_organization_id_fkey 
FOREIGN KEY (organization_id) 
REFERENCES organizations (id) ON DELETE CASCADE;

-- Delete an organization 
DELETE FROM organizations 
WHERE id = 'CUREM';

-- Check that no more affiliations with this organization exist
SELECT * FROM affiliations
WHERE organization_id = 'CUREM';
*************************************************************************
-- Count the total number of affiliations per university
SELECT COUNT(*), professors.university_id 
FROM affiliations
JOIN professors
ON affiliations.professor_id = professors.id
-- Group by the ids of professors
GROUP BY professors.university_id 
ORDER BY count DESC;
*************************************************************************
-- Join all tables
SELECT *
FROM affiliations
JOIN professors
ON affiliations.professor_id = professors.id
JOIN organizations
ON affiliations.organization_id = organizations.id
JOIN universities
ON professors.university_id = universities.id;
*************************************************************************
-- Group the table by organization sector, professor and university city
SELECT COUNT(*), organizations.organization_sector, 
professors.id, universities.university_city
FROM affiliations
JOIN professors
ON affiliations.professor_id = professors.id
JOIN organizations
ON affiliations.organization_id = organizations.id
JOIN universities
ON professors.university_id = universities.id
GROUP BY organizations.organization_sector, 
professors.id, universities.university_city;
*************************************************************************
-- Filter the table and sort it
SELECT COUNT(*), organizations.organization_sector, 
professors.id, universities.university_city
FROM affiliations
JOIN professors
ON affiliations.professor_id = professors.id
JOIN organizations
ON affiliations.organization_id = organizations.id
JOIN universities
ON professors.university_id = universities.id
WHERE organizations.organization_sector = 'Media & communication'
GROUP BY organizations.organization_sector, 
professors.id, universities.university_city
ORDER BY COUNT DESC;
*************************************************************************