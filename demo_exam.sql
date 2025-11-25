

SELECT * from LabExam12022Table order by trapTS desc LIMIT 10 ;

select count(*) from LabExam12022Table;

--QUESTION 1: Write an SQL query to return all rows where the vehicle is a car, the captured speed is
--between 100 and 140 mph (both inclusive) and the speed camera observed this vehicle on ANY day
--in December

select * from LabExam12022Table LIMIT 10;

select * from LabExam12022Table where vehicle = 'car' and (mph >= 100 and mph <= 140) and date_part('month',trapts) = 12;

--row number = 131

--QUESTION 2: Write a query returning rows where the day of any month is 7 or 14

select * from LabExam12022Table where date_part('day',trapts) = 7 or date_part('day',trapts) = 14;

--row number = 80

--QUESTION 3: The Autostrada del Sole close to the town of Melegano in the south of Milano is a well
--known motorway junction. The center point of this junction is given as WKT in EPSG:4326 as
--POINT(9.303231 45.355149). Write an SQL query which returns ALL rows where the vehicle is a bus
--and the location is less than or equal to 10KM away from this point.

select * from LabExam12022Table where (vehicle = 'bus') and ST_DISTANCE(st_transform(ST_GeomFromtext('POINT(9.303231 45.355149)',4326),6875),
st_transform(thegeom,6875))/1000 <= 10;

select vehicle,ST_DISTANCE(st_transform(ST_GeomFromtext('POINT(9.303231 45.355149)',4326),6875),
st_transform(thegeom,6875))/1000 as Distcalc from LabExam12022Table where (vehicle = 'bus') and ST_DISTANCE(st_transform(ST_GeomFromtext('POINT(9.303231 45.355149)',4326),6875),
st_transform(thegeom,6875))/1000 <= 10;

--nrow = 15

--QUESTION 4: Suppse you are given the location in WKT in EPSG:4326 as POINT(9.262569
--45.382383). Write an SQL query which finds the REGISTRATION PLATE of the ‘van’ vehicle detected
--at the location closest to this point. The vehicle must be detected travelling at less than 90 mp

select * from LabExam12022Table limit 10;

select reg,mph,ST_DISTANCE(st_transform(ST_GeomFromtext('POINT(9.262569 45.382383)',4326),6875),
st_transform(thegeom,6875))/1000 as Distcalc from LabExam12022Table where vehicle = 'van' and mph < 90 order by Distcalc asc;

-- reg = "LJ7023AZ"

--QUESTION 5: Suppose you are given a point in WKT expressed in EPSG:3857 as follows POINT
--(1016235.07 5696786.90). Write an SQL query to return all rows where vehicles are travelling over
--100mph within 2KM of this location.


select pkid,ST_DISTANCE(st_transform(ST_GeomFromtext('POINT(1016235.07 5696786.90)',3857),6875),
st_transform(thegeom,6875))/1000 as Distcalc from LabExam12022Table where mph > 100 and ST_DISTANCE(st_transform(ST_GeomFromtext('POINT(1016235.07 5696786.90)',3857),6875),
st_transform(thegeom,6875))/1000 < 2;

--nrow = 3

--SELECT * FROM LabExam12022Table 
--WHERE mph > 100 AND ST_Distance(
--ST_Transform(ST_Transform(ST_GeomFromText('POINT(1016235.07 5696786.90)', 3857), 4326), 6875),
--ST_Transform(thegeom, 6875)) / 1000 < 2;

--QUESTION 6. Write an SQL query to return all rows where the registration plate begin with two
--vowels and ends with two vowels. [Vowels are A, E, I, O and U]

select * from LabExam12022Table limit 5;

select * from LabExam12022Table where reg ~ '^(A|E|I|O|U){2}\d{4}(A|E|I|O|U){2}$';

SELECT * 
FROM LabExam12022Table 
WHERE reg ~ '^[AEIOU]{2}[0-9]{4}[AEIOU]{2}$';

--nrow = 1

--QUESTION 7: Considering ‘truck’ and ‘motorcyle’ (note the spelling) only, write an SQL query to
--return all rows where these vehicles have registration plates where the first and last characters are
--both one of the following alphabetical characters A, B, C, D, M, N, O, P. The other letters and digits
--in the registration plate are not relevant.

SELECT DISTINCT vehicle 
FROM LabExam12022Table 
ORDER BY vehicle;

select * from LabExam12022Table where reg ~ '^(A|B|C|D|M|N|O|P){1}.*[ABCDMNOP]{1}$' and (vehicle = 'truck' or vehicle = 'motorcyle') ;

--nrow = 25

--SELECT * FROM LabExam12022Table 
--WHERE reg ~ '^[ABCDMNOP][A-Z0-9]{5}[ABCDMNOP]$'
--AND (vehicle = 'truck' OR vehicle = 'motorcyle');

SELECT * 
FROM LabExam12022Table 
WHERE reg ~ '^[ABCDMNOP].*[ABCDMNOP]$' 
  AND vehicle IN ('truck', 'motorcyle');

--QUESTION 8: Write an SQL query to return all rows where the registration plate contains 3 or 4
--adjacent digits where the adjacent digits are only 1, 2 and 3. For example AH7312HA or PG3123HJ
--are registrations displaying this pattern. The registration BG3183KJ does not display this patten. You
--may have repeated digits

select * from LabExam12022Table where reg ~ '^[A-Z]{2}[123]{3,4}[A-Z]{2}$';

SELECT * 
FROM LabExam12022Table 
WHERE reg ~ '^[A-Z]{2}.*[123]{3,4}.*[A-Z]{2}$';

SELECT *
FROM LabExam12022Table
WHERE reg ~ '[123]{3,4}';

--nrow =33

--QUESTION 9: Write an SQL query that returns all rows where the trapts timestamp is between
--exactly midnight (inclusive) and before 01:30 for any day recorded.


SELECT * 
FROM LabExam12022Table 
WHERE (date_part('hour', trapTS) = 0 OR date_part('hour', trapTS) = 1)
  AND (date_part('hour', trapTS) = 0 OR date_part('minute', trapTS) < 30);

--row = 63

SELECT *
FROM LabExam12022Table
WHERE date_part('hour', trapTS) = 0
   OR (date_part('hour', trapTS) = 1 AND date_part('minute', trapTS) < 30);


--QUESTION 10: Write an SQL query which returns all rows where the sum of the hour, minute and
--second value of trapts is greater or equal to the corresponding mph value. The query should only
--show vehicles where the type of vehicle is not listed as a car.

select * from LabExam12022Table where (vehicle != 'car') and date_part('hour',trapts) + date_part('minute',trapts) + date_part('second',trapts)>= mph;

select mph,date_part('hour',trapts) + date_part('minute',trapts) + date_part('second',trapts) as totaltime from LabExam12022Table where (vehicle != 'car') and date_part('hour',trapts) + date_part('minute',trapts) + date_part('second',trapts)>= mph;

--nrow= 124

--QUESTION 11: Consider the reg column. The structure is described above. If one considers the four
--digits in the reg value as a numerical value by reading the digits from left to right. For example
--JY9655YL. As a numerical value this equals 9,655. Write an SQL query which returns all rows
--containing reg column values where the NUMERICAL VALUE of the FOUR DIGITS in the registration
--plate is greater or equal to 9,600.

select * from LabExam12022Table where reg ~ '[9][6789][0-9]{2}';
--nrow = 226

SELECT * 
FROM LabExam12022Table 
WHERE reg ~ '^[A-Z]{2}(9[6-9][0-9]{2}|[0-9]{5,})[A-Z]{2}$';

--SELECT * 
--FROM LabExam12022Table 
--WHERE reg ~ '(9[6-9][0-9]{2}|[0-9]{5,})';

--QUESTION 12: Refer to the description in Question 11. In this question you will use the very same
--definition. Write an SQL query which returns all rows containing reg column values where the
--NUMERICAL VALUE of the FOUR DIGITS in the registration plate is less than 4,600.

select * from LabExam12022Table where reg ~ '[0-3][0-9]{3}|[4][0-5][0-9]{2}';

SELECT * 
FROM LabExam12022Table 
WHERE reg ~ '^[A-Z]{2}([0-3][0-9]{3}|4[0-5][0-9]{2})[A-Z]{2}$';

-- nrow = 22