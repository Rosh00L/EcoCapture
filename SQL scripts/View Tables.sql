USE ecocapture;

DROP view if exists Traveller_country; 
CREATE VIEW Traveller_country AS
    SELECT 
        A.inputID,
        A.Traveller_ID,
        A.Traveller_Location,
        B.Traveller_Country
    FROM
        Traveller A
            LEFT JOIN
        country B ON A.Traveller_Location = B.Traveller_Location;    
   
Drop VIEW IF EXISTS Traveller_Date;
CREATE VIEW Traveller_Date AS
    SELECT 
        A.Traveller_ID, C.Traveller_Country, B.Travel_Date, A.City
    FROM
        location A
            INNER JOIN
        Dateall B ON A.inputID = B.inputID
            INNER JOIN
        Traveller_country C ON A.inputID = C.inputID
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
