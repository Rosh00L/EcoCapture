SELECT
Traveler_ID, 
count(Traveler_ID) as TravelerCount  
FROM project.traveler
group by Traveler_ID
;

Drop VIEW Traveler_Date;

CREATE VIEW Traveler_Date AS
    SELECT 
        A.Traveler_ID, C.traveler_Country, B.Travel_Date, A.Town
    FROM
        project.location A
            INNER JOIN
        project.Date B ON A.inputID = B.inputID
            INNER JOIN
        project.traveler_country C ON A.inputID = C.inputID
    ORDER BY B.Travel_Date
;


SELECT 
    Traveler_ID,
    Town,
    traveler_date Travel_Date,
    COUNT(Travel_Date) AS DATECount
FROM
    project.Traveler_Date
GROUP BY A.Traveler_ID , Town , Travel_Date
;