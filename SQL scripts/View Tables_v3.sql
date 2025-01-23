USE ecocapture;

CREATE Table _Traveller_country AS
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


CREATE Table  V_CountryDate AS
    SELECT 
       A.inputID, A.Traveller_ID,A.Traveller_Country, B.Travel_Date, B.Travel_Year, B.Travel_Month, B.month
    FROM
      _Traveller_country  A
		Left JOIN
        Dateall B ON A.inputID = B.inputID
ORDER BY A.inputID
;

/***Photography rating and SIA *********************************************************/

CREATE Table  V_photography_Rating  AS
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
create Table _PhotographyVSnon as 
select * from  _Photography
union all   
select * from  _no_Photography
;
 

create Table  V_PhotographyVSnonall as 
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

 create Table  V_twoCatStats  as 
 select 
	Photography,
    Travel_Year,
   convert(AVG(rating),decimal(7,4)) as Mean,
    MAX(rating) as MAX_,
    MIN(rating) as MIN_,
    STDDEV(rating) as STDDEV
   from V_PhotographyVSnonall
   group by  Photography,Travel_Year
  ;
 
DROP Table if exists _Traveller_country; 
DROP Table if exists _PhotographyVSnon; 
DROP table if exists _no_photography;
DROP table if exists _photography;