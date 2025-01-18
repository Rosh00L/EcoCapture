USE ecocapture;

DROP view if exists Traveller_country; 
CREATE VIEW Traveller_country AS
    SELECT 
		A.InputID,
		A.Traveller_ID,
        A.Traveller_Location,
        B.Traveller_Country
    FROM
        Traveller A
            LEFT JOIN
        country B ON A.Traveller_Location = B.Traveller_Location
;   

DROP view if exists country_count; 
CREATE VIEW country_count AS
    SELECT 
		B.Traveller_Country,
        count(A.Traveller_ID) as Count_Country 
    FROM
        Traveller A
            LEFT JOIN
        country B ON A.Traveller_Location = B.Traveller_Location
        group by B.Traveller_Country
        ORDER BY Count_Country desc
        limit 10
        ;   
        
   
Drop VIEW IF EXISTS Visit_Date;
CREATE VIEW Visit_Date AS
    SELECT 
       A.inputID, A.Traveller_ID, B.Travel_Date, B.Travel_Year, B.Travel_Month
    FROM
       Traveller A
			INNER JOIN
        Dateall B ON A.inputID = B.inputID
        ORDER BY B.Travel_Date
;


Drop VIEW IF EXISTS CountryDate;
CREATE VIEW CountryDate AS
    SELECT 
       A.inputID, A.Traveller_ID,A.Traveller_Country, B.Travel_Date, B.Travel_Year, B.Travel_Month, B.month
    FROM
      Traveller_country  A
		Left JOIN
        Dateall B ON A.inputID = B.inputID
ORDER BY B.Travel_Date
;

Drop VIEW IF EXISTS loca_Rating;
CREATE VIEW loca_Rating AS
    SELECT 
       A.inputID, A.Traveller_ID,B.Travel_Year,B.month, D.rating,C.City, C.Province
       
    FROM
      Traveller_country  A
		Left JOIN
        Dateall B ON A.inputID = B.inputID
        Left JOIN
        location C ON A.inputID = C.inputID
        left join 
        rating  D  on A.inputID = D.inputID
ORDER BY C.location
;

/****************************************************************/
CREATE VIEW loca_count_ as
 SELECT 
 x.city,
 X.cityC
 FROM(
	select city,
	count(city) as cityC
	from loca_Rating
	group by city
	order by cityC desc
 /*limit 30*/
 )AS X
;

CREATE VIEW loca_sum as 
select 
sum(cityC) as sumCitr
from  loca_count_;

drop view if exists  loca_count;
CREATE VIEW loca_count as
select
x.city,
X.cityC,
X.sumCitr,
(X.cityC / 36) as avgCal
from 
(
select
A.*,
B.*
from loca_count_ A
join
loca_sum B
) as X
;
drop view if exists  loca_count_;
drop view if exists  loca_sum; 



/****************************************************************/
Drop VIEW IF EXISTS CountryByYear;
CREATE VIEW CountryByYear AS
    SELECT
     X.Year,
     X.Country,
     X.countC
     FROM
     ( Select A.Travel_Year as Year,
		A.Traveller_Country as Country ,
		count(A.Traveller_Country) as countC
		from CountryDate  A
		group by A.Travel_Year,A.Traveller_Country
  		ORDER BY A.Travel_Year,A.Traveller_Country
    ) AS X   
	where Country is not null  and X.countC is not null 
    ORDER BY X.Country
;

Drop VIEW IF EXISTS CountryT;
SET SESSION group_concat_max_len = 1000000;
SET @sql = null;
SELECT GROUP_CONCAT(DISTINCT
           'MAX(CASE WHEN Country = "', Country, '" THEN countC END) AS "',Country, '"')
INTO @sql
FROM CountryByYear;

SET @sql = CONCAT('CREATE VIEW CountryT AS SELECT Year, ', @sql, ' FROM CountryByYear GROUP BY Year;');
PREPARE T_stmt FROM @sql;
EXECUTE T_stmt;
DEALLOCATE PREPARE T_stmt;


/***sentiment analysis*********************************************************/
Drop VIEW IF EXISTS siaRating;
CREATE VIEW siaRating AS
    SELECT
		A.*,
        B.Rating
    FROM
        sia A
            INNER JOIN
        rating B ON A.inputID = B.inputID
    ORDER BY sentiment_comments desc,B.Rating 
;       

/***photography intrest holidaymakers *********************************************************/
drop View if exists photographyCheck;  
CREATE VIEW photographyCheck  AS
    SELECT 
		A.InputID,
		A.Traveller_ID,
        A.activity,
        B.Traveller_Country
	FROM
        activity A
	LEFT JOIN
		countrydate B ON A.InputID = B.InputID
	where  activity='photography' or  activity='wildlife_nature' or activity='Wildlife_photography'
	ORDER BY A.Traveller_ID
;   

/***photography intrest holidaymakers *********************************************************/
drop View if exists Wildlife_photo_Rating;  
CREATE VIEW Wildlife_photo_Rating  AS
    SELECT 
		A.InputID,
		A.Traveller_ID,
        A.activity,
        B.Traveller_Country,
        C.City,
        C.location_Type,
        D.rating,
        D.sentiment_comments        
	FROM
        activity A
	LEFT JOIN
		countrydate B ON A.InputID = B.InputID
	LEFT JOIN
		location C ON A.InputID = C.InputID
	LEFT JOIN
		siarating D ON A.InputID = D.InputID    
	where  activity='Wildlife_photography'
	ORDER BY A.Traveller_ID
;  

