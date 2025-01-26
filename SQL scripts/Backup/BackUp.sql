DROP table if exists photography_find_dups;
CREATE Table  photography_find_dups 
		select 
		No_dup.InputID,
		No_dup.Traveller_ID,
		No_dup.Photography,
		No_dup.No_no_Photography
    from (SELECT 
		A.InputID,
		A.Traveller_ID,
		A.Photography
		from   _Photography A
    ) Photo  FULL outer join 
    (SELECT 
		B.InputID,
		b.Traveller_ID,
		B.Photography AS No_no_Photography
    from _no_Photography B
    ) No_dup
    on Photo.Traveller_ID=No_dup.Traveller_ID
;
 
    
ALTER table _photography
  DEFAULT CHARACTER SET utf8mb4,
  MODIFY photography VARCHAR(15)
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL;


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
	/*where  activity='photography' or  activity='wildlife_nature' or activity='Wildlife_photography'*/
	ORDER BY A.Traveller_ID
;   


/***Gen_Photography *********************************************************/
drop View if exists Gen_Photography;  
CREATE VIEW Gen_Photography  AS
    SELECT 
		A.InputID,
		A.Traveller_ID,
        A.activity,
        B.Traveller_Country,
        C.City,
        C.location_Type,
        D.rating,
        D.sentiment_comments, 
        E.Travel_Year,
        E.Travel_month,
        E.month
	FROM
        activity A
	LEFT JOIN
		countrydate B ON A.InputID = B.InputID
	LEFT JOIN
		location C ON A.InputID = C.InputID
	LEFT JOIN
		siarating D ON A.InputID = D.InputID  
   LEFT JOIN
		dateall E ON A.InputID = E.InputID       
	/*where  activity='Wildlife_photography' or activity='photography'*/
	ORDER BY A.Traveller_ID
;  


  
Drop VIEW IF EXISTS Visit_Date;
CREATE VIEW Visit_Date AS
    SELECT 
       A.inputID, A.Traveller_ID, B.Travel_Date, B.Travel_Year, B.Travel_Month,B.month
    FROM
       Traveller A
			INNER JOIN
        Dateall B ON A.inputID = B.inputID
        ORDER BY B.Travel_Date
;

Drop VIEW IF EXISTS loca_Rating;
CREATE VIEW loca_Rating AS
    SELECT 
       A.inputID, A.Traveller_ID,B.Travel_Year,B.month, C.City, C.Province,C.Location_Type,D.rating,E.sentiment_comments
       
    FROM
      Traveller_country  A
		Left JOIN
        Dateall B ON A.inputID = B.inputID
        Left JOIN
        location C ON A.inputID = C.inputID
        left join 
        rating  D  on A.inputID = D.inputID
        left join 
        sia  E  on A.inputID = E.inputID
ORDER BY C.location
;


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


DROP table if exists activity;
create table activity  as 
select 
	A.*,
    B.Travel_Year,
	B.month
 from activity_ A
 left join  v_countrydate B ON A.InputID = B.InputID
; 

      