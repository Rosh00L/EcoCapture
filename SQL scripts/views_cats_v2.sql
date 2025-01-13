/*ALTER TABLE votes
    DROP primary key;
SET SQL_SAFE_UPDATES = 0;    
Delete  from  votes
where InputID > 0 ;

*/

USE ecocapture;

DROP view if exists travel_Act;

create view travel_Act as 
select
A.InputID,
B.Traveler_ID,
B.town,
/*B.Province,*/
C.Location_Type,
A.Title,
LENGTH(Comments) as Len_Comments ,
LOWER(A.Comments) as Comments, 
CASE  when lower(Comments) Regexp lower('photography|photo|photos|picture|pictures') THEN 'Y' 
	else ' ' 
	end as photography,
    
CASE  when lower(Comments) Regexp lower('photography is not|photography isn|Photography not|No photography|Photography is restricted|Photography is forbidde|
photo is not|photo isn|Photo not|No photo|photos are not|photos are|Photos not|No photos|
picture is not|picture isn|picture not|No picture|pictures are not|pictures are|pictures not|no pictures') THEN 'N' 
	else ' ' 
	end as restricted,
    
CASE  when lower(Comments) Regexp lower('Wildlife') THEN 'Y' 
	else ' ' 
	end as Wildlife,
  
 CASE  when lower(Comments) Regexp lower('birder|birding') THEN 'Y' 
	else ' ' 
	end as birding, 
    
 CASE  when lower(Comments) Regexp lower('birder|birding') THEN 'Y' 
	else ' ' 
	end as birding 
    
    
from Comment A 
join location B on A.InputID = B.InputID
join type C on A.InputID = C.InputID  
ORDER BY A.InputID and A.Traveler_ID;

