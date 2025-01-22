USE ecocapture;

DROP view if exists _Traveller_country; 
CREATE VIEW _Traveller_country AS
    SELECT 
		A.InputID,
		A.Traveller_ID,
        A.Traveller_Location,
        B.Traveller_Country
    FROM
        Traveller A
            LEFT JOIN
        country B ON A.Traveller_Location = B.Traveller_Location
        ORDER BY A.inputID
;   

Drop VIEW IF EXISTS V_CountryDate;
CREATE VIEW V_CountryDate AS
    SELECT 
       A.inputID, A.Traveller_ID,A.Traveller_Country, B.Travel_Date, B.Travel_Year, B.Travel_Month, B.month
    FROM
      _Traveller_country  A
		Left JOIN
        Dateall B ON A.inputID = B.inputID
ORDER BY A.inputID
;

/***Photography rating and SIA *********************************************************/
drop View if exists V_photography_Rating;  
CREATE VIEW V_photography_Rating  AS
    SELECT 
		A.InputID,
		A.Traveller_ID,
        A.activity,
        B.Traveller_Country,
        C.City,
        C.location_Type,
        E.Travel_Year,
        E.Travel_month,
        E.month,
        F.rating,
        D.sentiment_comments
	FROM
        activity A
	LEFT JOIN
		V_countrydate B ON A.InputID = B.InputID
	LEFT JOIN
		location C ON A.InputID = C.InputID
	LEFT JOIN
		sia D ON A.InputID = D.InputID  
   LEFT JOIN
		dateall E ON A.InputID = E.InputID  
	LEFT JOIN
		rating F ON A.InputID = F.InputID        
	/*where  activity='photography'*/
	ORDER BY A.InputID
;  

/*Photography holiday vs non Photography holiday*/
DROP view if exists _PhotographyVSnon; 
create view _PhotographyVSnon as 
select * from  _Photography
union all   
select * from  _no_Photography;
 
DROP view if exists V_PhotographyVSnonall; 
create view V_PhotographyVSnonall as 
select 
		A.InputID,
		A.Traveller_ID,
        A.Photography,
		B.Travel_Year,
        B.Travel_month,
        B.month,
        C.rating
	From  _PhotographyVSnon A
	LEFT JOIN 
	DATEALL B ON  A.InputID = B.InputID
    LEFT JOIN 
	Rating C ON A.InputID = C.InputID
    ORDER BY A.InputID
    ;


 DROP view if exists V_twoCatStats;
 create view V_twoCatStats as 
 select 
	Photography,
    Travel_Year,
    AVG(rating) as Mean,
    MAX(rating) as MAX,
    MIN(rating) as MIN,
    STDDEV(rating) as STDDEV
   from V_PhotographyVSnonall
   group by  Photography,Travel_Year
  ;
   

