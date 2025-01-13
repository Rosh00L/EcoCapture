
DROP view if exists project.traveler_country; 

Create  view project.traveler_country as
	select 
    A.inputID,
    A.Traveler_ID,
    A.Traveler_Location,
    B.traveler_Country
    From  project.traveler A Left join project.country B 
    on A.Traveler_Location and A.Traveler_ID = B.Traveler_Location and B.Traveler_ID;    
    
SELECT * FROM project.traveler_Country;
