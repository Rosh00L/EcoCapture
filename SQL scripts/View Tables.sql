USE ecocapture;

DROP view if exists traveler_country; 
CREATE VIEW traveler_country AS
    SELECT 
        A.inputID,
        A.Traveler_ID,
        A.Traveler_Location,
        B.traveler_Country
    FROM
        traveler A
            LEFT JOIN
        country B ON A.Traveler_Location = B.Traveler_Location;    
   
SELECT 
    *
FROM
    traveler_Country;

Drop VIEW IF EXISTS Traveler_Date;
CREATE VIEW Traveler_Date AS
    SELECT 
        A.Traveler_ID, C.traveler_Country, B.Travel_Date, A.Town
    FROM
        location A
            INNER JOIN
        Dateall B ON A.inputID = B.inputID
            INNER JOIN
        traveler_country C ON A.inputID = C.inputID
    ORDER BY B.Travel_Date
;

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
    