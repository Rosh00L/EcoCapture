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


Drop VIEW IF EXISTS FromCountryDate;
CREATE VIEW FromCountryDate AS
    SELECT 
       A.inputID, A.Traveller_ID,A.Traveller_Country, B.Travel_Date, B.Travel_Year, B.Travel_Month
    FROM
      Traveller_country  A
		Left JOIN
        Dateall B ON A.inputID = B.inputID
ORDER BY B.Travel_Date
;


/****************************************************************/
Drop VIEW IF EXISTS FromCountryC;
CREATE VIEW FromCountryC AS
    SELECT
     X.Year,
     X.Country,
     X.countC
     FROM
     ( Select A.Travel_Year as Year,
		A.Traveller_Country as Country ,
		count(A.Traveller_Country) as countC
		from FromCountryDate  A
		group by A.Travel_Year,A.Traveller_Country
  		ORDER BY A.Travel_Year,A.Traveller_Country
    ) AS X   
	where X.Year between (2009 and 2024) and Country is not null  and X.countC is not null 
    ORDER BY X.Country
;

Drop VIEW IF EXISTS CountryT;
SET SESSION group_concat_max_len = 1000000;
SET @sql = null;
SELECT GROUP_CONCAT(DISTINCT
           'MAX(CASE WHEN Country = "', Country, '" THEN countC END) AS "',Country, '"')
INTO @sql
FROM fromcountryc;

SET @sql = CONCAT('CREATE VIEW CountryT AS SELECT Year, ', @sql, ' FROM fromcountryc GROUP BY Year;');
PREPARE T_stmt FROM @sql;
EXECUTE T_stmt;
DEALLOCATE PREPARE T_stmt;

Drop VIEW IF EXISTS CountryT_;
CREATE VIEW CountryT_ AS
    SELECT
		Year,
        count(*) as num
    FROM
        CountryTcategory
	group by Year
    ORDER BY Year desc
;       
/************************************************************/

Drop VIEW IF EXISTS siarating;
CREATE VIEW siarating AS
    SELECT
		A.*,
        B.Rating
    FROM
        sia A
            INNER JOIN
        rating B ON A.inputID = B.inputID
    ORDER BY sentiment_comments desc,B.Rating 
;       
