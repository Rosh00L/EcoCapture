USE ecocapture;

DROP table if exists _Traveller_country;
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

DROP table if exists V_CountryDate;
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
DROP table if exists V_photoVisit_Rating;
CREATE Table  V_photoVisit_Rating  AS
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

/*Photography holiday vs non Photography holiday
DROP table if exists _PhotographyVSnon;*/
create Table _PhotographyVSnon as 
select * from  _Photovisit_ndup
union all   
select * from  _no_Photovisit_ndup
;
 
DROP table if exists V_PhotographyVSnonall;
create Table  V_PhotographyVSnonall as 
select 
		A.InputID,
		A.Traveller_ID,
        E.Traveller_Country,
        A.Photography,
        D.location_Type,
		B.Travel_Year,
        B.Travel_month,
        B.month,
        C.rating,
        F.sentiment_comments
	From  _PhotographyVSnon A
	LEFT JOIN 
	DATEALL B ON  A.InputID = B.InputID
    LEFT JOIN 
	Rating C ON A.InputID = C.InputID
    LEFT JOIN
	location D ON A.InputID = D.InputID
    LEFT JOIN
	V_countrydate E ON A.InputID = E.InputID
	LEFT JOIN
	sia F ON A.InputID = F.InputID  
    ORDER BY A.Photography,A.Traveller_ID
    ;

DROP table if exists V_twoCatStats;
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
 
 
DROP table if exists V_FrqCountry;
 create Table  V_FrqCountry  as 
 Select 
	stat.Photography,
    stat.sentiment_comments,
    stat.Traveller_Country,
    stat.Travel_Year,
    stat.CountryCount
    from
	( select 
	Photography,
    Traveller_Country,
    Travel_Year,
    sentiment_comments,
    count(Traveller_Country) as CountryCount
    from v_photographyvsnonall
    where Traveller_Country is not null
	group by  Photography,sentiment_comments,Traveller_Country,Travel_Year
    ) as stat
    where stat.Photography='photography' and stat.sentiment_comments = "Positive" and stat.CountryCount > 1
  order by stat.Traveller_Country,stat.CountryCount desc,stat.Travel_Year,stat.Photography
;  
 
DROP Table if exists _Traveller_country; 
DROP Table if exists _PhotographyVSnon; 
DROP table if exists _no_photography;
DROP table if exists _photography;
DROP table if exists _photovisit_ndup;
DROP table if exists _activity;
DROP table if exists v_twocatstats;

/*DROP table if exists _photovisit_ndup;
DROP table if exists _no_photovisit_ndup;*/

