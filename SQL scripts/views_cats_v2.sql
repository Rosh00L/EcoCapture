/*ALTER TABLE project.votes
    DROP primary key;
SET SQL_SAFE_UPDATES = 0;    
Delete  from  project.votes
where InputID > 0 ;

*/
DROP view if exists project.travel_cats;

create view project.travel_cats as 
select
A.InputID,
B.Traveler_ID,
B.town,
/*B.Province,*/
C.Location_Type,
A.Title,
LENGTH(text) as Len_text ,
LOWER(A.Text) as Text, 
CASE  when lower(text) Regexp lower('photography|photo|photos|picture|pictures') THEN 'Y' 
	else ' ' 
	end as photography,
    
CASE  when lower(text) Regexp lower('photography is not|photography isn|Photography not|No photography|Photography is restricted|Photography is forbidde|
photo is not|photo isn|Photo not|No photo|photos are not|photos are|Photos not|No photos|
picture is not|picture isn|picture not|No picture|pictures are not|pictures are|pictures not|no pictures') THEN 'N' 
	else ' ' 
	end as restricted,
    
CASE  when lower(text) Regexp lower('Wildlife') THEN 'Y' 
	else ' ' 
	end as Wildlife,
  
 CASE  when lower(text) Regexp lower('birder|birding') THEN 'Y' 
	else ' ' 
	end as birding  
    
from project.text A 
join project.location B on A.InputID = B.InputID
join project.type C on A.InputID = C.InputID  
ORDER BY A.InputID and A.Traveler_ID;

