USE ecocapture;

/*DROP table if exists _Traveller_country;*/
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
        where Traveller_Country is not null 
        ORDER BY A.inputID
;   

/*DROP table if exists V_CountryDate;*/
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
/*DROP table if exists V_photography_Rating;*/
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


DROP table if exists photography_find_dups;
CREATE Table  photography_find_dups 
	select
		A.InputID,
		A.Traveller_ID,
		A.Photography,
	    B.Photography as No_Photography
      
	from _Photography A
	left outer join _no_Photography B on A.Traveller_ID=B.Traveller_ID
	union all    
	select
		A.InputID,
		A.Traveller_ID,
		A.Photography,
		B.Photography as No_Photography

	from _no_Photography B 
    left outer join _Photography A on A.Traveller_ID=B.Traveller_ID
	where  A.Traveller_ID IS NULL or  B.Traveller_ID IS NULL
;


/*Photography holiday vs non Photography holiday*
DROP table if exists _PhotographyVSnon;
create Table _PhotographyVSnon as 
select * from  _Photography
union all   
select * from  _no_Photography
;
 */

 
/*DROP table if exists V_PhotographyVSnonall;*/
create Table  V_PhotographyVSnonall as 
select 
		A.InputID,
		A.Traveller_ID,
        A.Photography,
        D.location_Type,
		B.Travel_Year,
        B.Travel_month,
        B.month,
        C.rating
	From  _PhotographyVSnon A
	LEFT JOIN 
	DATEALL B ON  A.InputID = B.InputID
    LEFT JOIN 
	Rating C ON A.InputID = C.InputID
    LEFT JOIN
	location D ON A.InputID = D.InputID
    ORDER BY A.Photography,A.Traveller_ID
    ;

 /*DROP table if exists V_twoCatStats;*/
 create Table  V_twoCatStats  as 
 select 
	Photography,
    Travel_Year,
    #avg(Traveller_ID) as MEAN_,
   convert(AVG(Traveller_ID),decimal(9,4)) as Mean,
    MAX(Traveller_ID) as MAX_,
    MIN(Traveller_ID) as MIN_,
    STDDEV(Traveller_ID) as STDDEV
   from V_PhotographyVSnonall
   group by  Photography,Travel_Year
  ;
 
DROP Table if exists _Traveller_country; 
DROP Table if exists _PhotographyVSnon; 
/*
DROP table if exists _no_photography;
DROP table if exists _photography;*/