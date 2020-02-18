*************************************************************************
SELECT
country
FROM
eurovision

*************************************************************************
SELECT 
TOP (50) points 
FROM 
eurovision

*************************************************************************
SELECT 
DISTINCT country AS unique_country 
FROM 
eurovision;

*************************************************************************
SELECT 
country, 
event_year 
FROM 
eurovision

*************************************************************************
SELECT 
* 
FROM 
eurovision

*************************************************************************
SELECT 
top (50) percent * 
FROM 
eurovision

*************************************************************************
SELECT 
top (5) description, 
event_date 
FROM 
grid 
ORDER BY
event_date

*************************************************************************
SELECT 
TOP (20) description,
nerc_region,
event_date
FROM 
grid 
ORDER BY
nerc_region,
affected_customers,
event_date DESC

*************************************************************************
SELECT 
description, 
event_year 
FROM 
grid 
WHERE 
description = 'Vandalism'

*************************************************************************
SELECT 
nerc_region, 
demand_loss_mw 
FROM 
grid 
WHERE 
affected_customers >= 500000

*************************************************************************
SELECT 
description, 
affected_customers 
FROM 
grid December, 2013 
WHERE 
event_date = '2013-12-22'

*************************************************************************
SELECT 
description, 
affected_customers,
event_date
FROM 
grid 
WHERE 
affected_customers BETWEEN 50000
AND 150000 
ORDER BY 
event_date DESC

*************************************************************************
SELECT 
* 
FROM 
grid 
WHERE 
demand_loss_mw IS NULL

*************************************************************************
SELECT 
* 
FROM 
grid 
WHERE 
demand_loss_mw IS NULL

*************************************************************************
SELECT 
song, 
artist, 
release_year
FROM 
songlist 
WHERE 
release_year >= 1980 
AND release_year <= 1990 
ORDER BY 
artist, 
release_year;

*************************************************************************
SELECT 
artist, 
release_year, 
song 
FROM 
songlist 
WHERE 
(
artist LIKE 'B%' 
AND release_year = 1986
) 
OR release_year > 1990 
ORDER BY 
release_year

*************************************************************************



FUNCIONES DE AGREGACION



*************************************************************************
SELECT 
SUM(demand_loss_mw) AS MRO_demand_loss 
FROM 
grid 
WHERE
demand_loos_mw IS NOT NULL 
AND nerc_region = 'MRO'

*************************************************************************
SELECT 
COUNT(grid_id) AS grid_total 
FROM 
grid
*************************************************************************
SELECT 
  MIN(affected_customers) AS min_affected_customers 
FROM 
  grid
WHERE
  demand_loss_mw IS NOT NULL;
*************************************************************************
SELECT 
  MAX(affected_customers) AS max_affected_customers 
FROM 
  grid
WHERE 
  demand_loss_mw IS NOT NULL;
*************************************************************************
SELECT 
  AVG(affected_customers) AS avg_affected_customers 
FROM 
  grid
WHERE 
  demand_loss_mw IS NOT NULL;
*************************************************************************



STRINGS



*************************************************************************
SELECT 
  LEN (description) AS description_length 
FROM 
  grid;
*************************************************************************
SELECT 
  LEFT(description, 25) AS first_25_left 
FROM 
  grid;
*************************************************************************
SELECT 
  RIGHT(description, 25) AS last_25_right 
FROM 
  grid;
*************************************************************************
SELECT 
  description, 
  CHARINDEX('Weather', description) 
FROM 
  grid
WHERE description LIKE '%Weather%';
*************************************************************************
SELECT 
  description, 
  CHARINDEX('Weather', description) AS start_of_string,
  LEN('Weather') AS length_of_string 
FROM 
  grid
WHERE description LIKE '%Weather%'; 
*************************************************************************
SELECT TOP (10)
  description, 
  CHARINDEX('Weather', description) AS start_of_string, 
  LEN ('Weather') AS length_of_string, 
  SUBSTRING(
    description, 
    15, 
    LEN(description)
  ) AS additional_description 
FROM 
  grid
WHERE description LIKE '%Weather%';
*************************************************************************



AGRUPACIONES



*************************************************************************
SELECT 
  nerc_region,
  SUM(demand_loss_mw) AS demand_loss
FROM 
  grid
WHERE 
  demand_loss_mw IS NOT NULL
GROUP BY 
  nerc_region
ORDER BY 
  demand_loss DESC;
*************************************************************************
SELECT 
  nerc_region, 
  SUM (demand_loss_mw) AS demand_loss 
FROM 
  grid 
GROUP BY 
  nerc_region 
HAVING 
  SUM(demand_loss_mw) > 10000 
ORDER BY 
  demand_loss DESC;
*************************************************************************
SELECT 
  MIN(place) AS min_place, 
  MAX(place) AS max_place, 
  MIN(points) AS min_points, 
  MAX(points) AS max_points 
FROM 
  eurovision;
*************************************************************************
SELECT 
  MIN(place) AS min_place, 
  MAX(place) AS max_place,
  MIN(points) AS min_points, 
  MAX(points) AS max_points 
FROM 
  eurovision
GROUP BY
  country;
*************************************************************************
SELECT 
  COUNT(country) AS country_count, 
  country,  
  AVG(place) AS average_place, 
  AVG(points) AS avg_points, 
  MIN(points) AS min_points, 
  MAX(points) AS max_points 
FROM 
  eurovision 
GROUP BY 
  country;
*************************************************************************
SELECT 
  country, 
  COUNT (country) AS country_count, 
  AVG (place) AS avg_place, 
  AVG (points) AS avg_points, 
  MIN (points) AS min_points, 
  MAX (points) AS max_points 
FROM 
  eurovision 
GROUP BY 
  country 
HAVING 
  COUNT(country) > 5 
ORDER BY 
  avg_place DESC, 
  avg_points DESC;
*************************************************************************



JOIN DE TABLAS 



*************************************************************************
SELECT 
  track_id,
  name AS track_name,
  title AS album_title
FROM track
INNER JOIN album on album.album_id = track.album_id;
*************************************************************************
SELECT 
  album_id,
  title,
  name AS artist
FROM album
INNER JOIN artist on artist.artist_id = album.artist_id;
*************************************************************************
SELECT track_id,
  track.name AS track_name,
  title as album_title,
  artist.name AS artist_name
FROM track
INNER JOIN album on album.album_id = track.album_id
INNER JOIN artist on artist.artist_id = album.artist_id;
*************************************************************************
SELECT 
  invoiceline_id,
  unit_price, 
  quantity,
  billing_state
FROM invoice
LEFT JOIN invoiceline
ON invoiceline.invoice_id = invoice.invoice_id;
*************************************************************************
SELECT 
  album.album_id,
  title,
  album.artist_id,
  artist.name as artist
FROM album
INNER JOIN artist ON album.artist_id = artist.artist_id
LEFT JOIN track on track.album_id = album.album_id
WHERE album.album_id IN (213,214)
*************************************************************************



UNION DE TABLAS



*************************************************************************
SELECT 
  album_id AS ID,
  title AS description,
  'Album' AS Source
FROM
album
UNION
SELECT 
  artist_id AS ID,
  name AS description,
  'Artist'  AS Source
FROM artist;
*************************************************************************
SELECT 
  album_id AS ID,
  title AS description,
  'Album' AS Source
FROM
album
UNION ALL
SELECT 
  artist_id AS ID,
  name AS description,
  'Artist'  AS Source
FROM artist;
*************************************************************************



OPERACIONES CRUD



*************************************************************************
CREATE TABLE results (
	track VARCHAR(200),
	artist VARCHAR(120),
	album VARCHAR(160),
	track_length_mins INT,
	);

SELECT 
  track, 
  artist, 
  album, 
  track_length_mins 
FROM 
  results;
*************************************************************************
CREATE TABLE tracks(
  track VARCHAR(200), 
  album VARCHAR(160), 
  track_length_mins INT
); 

INSERT INTO tracks
(track, album, track_length_mins)
VALUES
  ('Basket Case', 'Dookie', 3);

SELECT 
  *
FROM 
  tracks;
*************************************************************************
SELECT 
  title 
FROM 
  album 
WHERE 
  album_id = 213;
-- UPDATE the album table
UPDATE 
  album
-- SET the new title    
SET 
  title = 'Pure Cult: The Best Of The Cult'
WHERE album_id = 213;
*************************************************************************
SELECT 
  * 
FROM 
  album 
  -- DELETE the record
DELETE FROM 
  album 
WHERE 
  album_id = 1 
  -- Run the query again
SELECT 
  * 
FROM 
  album;
*************************************************************************



VARIABLES



*************************************************************************
DECLARE @region VARCHAR(10)
SET @region = 'RFC'
*************************************************************************
-- Declare your variables
DECLARE @start DATE
DECLARE @stop DATE
DECLARE @affected INT;
-- SET the relevant values for each variable
SET @start = '2014-01-24'
SET @stop  = '2014-07-02'
SET @affected =  5000 ;

SELECT 
  description,
  nerc_region,
  demand_loss_mw,
  affected_customers
FROM 
  grid
-- Specify the date range of the event_date and the value for @affected
WHERE event_date BETWEEN @start AND @stop
AND affected_customers >= @affected;
*************************************************************************
SELECT  album.title AS album_title,
  artist.name as artist,
  MAX(track.milliseconds / (1000 * 60) % 60 ) AS max_track_length_mins
-- Name the temp table #maxtracks
INTO #maxtracks
FROM album
-- Join album to artist using artist_id
INNER JOIN artist ON album.artist_id = artist.artist_id
-- Join track to album using album_id
INNER JOIN track ON album.album_id = track.album_id
GROUP BY artist.artist_id, album.title, artist.name, album.album_id
-- Run the final SELECT query to retrieve the results from the temporary table
SELECT album_title, artist, max_track_length_mins
FROM  #maxtracks
ORDER BY max_track_length_mins DESC, artist;
*************************************************************************

