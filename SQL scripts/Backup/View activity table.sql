/*ALTER TABLE votes
    DROP primary key;
SET SQL_SAFE_UPDATES = 0;    
Delete  from  votes
where InputID > 0 ;

*/

USE ecocapture;

DROP view if exists activity;

CREATE VIEW activity AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Location_Name,
        act.Location_Type,
        act.Title,
        act.Rating,
        /*act.Comments,*/
        act.photography_Interest,
		act.Wildlife_nature,
        act.Hiking_climbing,
        act.Rafting_Kayaking,
        act.Biking_cycling,
        act.Historical_Sites,
        act.Beach_Water_Sports,
        act.Sightseeing,
        act.Religious,
        act.Relaxing,
        act.Romantic_holiday,
        /*
        CASE
            WHEN LOWER(act.photography_Interest) REGEXP LOWER('photography|photo|photos!|photos|picture|pictures|photographic|photographs|photograph|photographer|photographers|
            photogenic|macrophoto|photographing|photographed|photoshoot|photographable|telephoto|photographer|photographing|photography!|photography|lens|tripod') THEN 1
            ELSE ' '
        END AS Photography_allowed,
        CASE
            WHEN
                LOWER(act.photography_Interest) REGEXP LOWER('no photography|no photos inside|no pictures allowed|Photography is restricted|Photography restricted|Photography is forbidde|photography not allowed|pictures are forbidden|
                photography is not allowed|photographing is not allowed|photographs are not allowed|prohibited to take pictures|Photography is not permitted|prohibiting photography|no photography allowed|Flash photography is not condoned|not allow photography
                |No photography are allowed|Photography inside the buildings is prohibited|Photography is strictly prohibited| photography is banned|No photos of exhibits allowed|cannot take photographs!|
                not allowed to take any photograph|do not take a photo|cant take photos inside|photos were forbidden|not allowed to photograph|no photos allowed')
            THEN 1
            ELSE ' '
        END AS Photography_Restricted,
        */
        CASE
			WHEN act.photography_Interest=1 and act.Wildlife_nature=1 THEN 1
            ELSE ' '
        END AS Wildlife_and_Photography
        from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
        B.City as City,
        B.Location_Type as Location_Type,
        A.Title as Title,
        C.Rating,
        C.Location_Name,
        LOWER(A.Comments) AS Comments,
          CASE
            WHEN LOWER(Comments) like LOWER('%photo%') THEN 1
            ELSE ' '
        END AS photography_Interest,
                 
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('wildlife|wild life|safari|diving|snorking|leopard|leopards|elephant|elephants|peacock|bear|coral|whale|dolphin|nature|rainforest|animal|animals|monkey|lizard|butterfly|garden|reptile|snake|fish|Bats|
            Wetlands|Jungle|forest|flora|fauna|spider|owl|frogmouth|squirre|fowl|biolog|sinharaja|plants|naturalist|eagles|bird|birdlife|birding|birdwatching|magpie|birdsong|yala|wilpattu|buffalo|corals|plants|
            snails|geckos|deers|Game Camp|raptors|hornbills|turtles|waterfalls|water fall|reserve|udawalawe') THEN 1
            ELSE ' '
        END AS Wildlife_nature,
       CASE
            WHEN LOWER(Comments) REGEXP LOWER('hike|hiking|walking|trekking|trek|climbing|rappaling|walked|stroll') THEN 1
            ELSE ' '
        END AS Hiking_climbing,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('rafting|canoe|Kayaking') THEN 1
            ELSE ' '
        END AS Rafting_Kayaking,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('biking|cycling|motorbike') THEN 1
            ELSE ' '
        END AS Biking_cycling,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('ancient|ruing|archaeology|historical') THEN 1
            ELSE ' '
        END AS Historical_Sites,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('surfing|diving|scuba|snorke|snorkeling|swim|swimming|boat|Boat trip|beach') THEN 1
            ELSE ' '
        END AS Beach_Water_Sports,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('sightsee|sightseeing|waterfall|abseil|skydiving|paramotor|paraglid|ATV|architecture|lake|landscape') THEN 1
            ELSE ' '
        END AS Sightseeing,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('temple|church|mosques|synagogue|spiritual|praying|prayer|worship|ritual|Kovil|nallur kovil') THEN 1
            ELSE ' '
        END AS Religious,
                CASE
            WHEN LOWER(Comments) REGEXP LOWER('relax|relaxing|unwind|leisure|rejuvenat|bliss|retreat|resort|sanctuary|zen|solitude') THEN 1
            ELSE ' '
        END AS Relaxing,
 		CASE
            WHEN LOWER(Comments) REGEXP LOWER('anniversary|wedding|romantic|romance') THEN 1
            ELSE ' '
        END AS Romantic_holiday
        FROM
       Comment A
           Left JOIN
        location B ON A.InputID = B.InputID
           Left JOIN
        rating C ON A.InputID = C.InputID

     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    ORDER BY act.InputID
    ;

/********************************************************************************/
drop view if exists active_Cat;
CREATE VIEW active_Cat as
select 
		act.InputID,
        act.Traveller_ID,
        act.Location_Name,
        act.Location_Type,
        act.Title,
        act.Rating,
        act.activeCat
  	from    
		( select
        InputID,
        Traveller_ID,
        Location_Name,
        Location_Type,
        Title,
        Rating,
        photography_Interest as activeCat
        from activity A   
	   where  photography_Interest ='1' 
     )   as act
     ;
    
    
/********************************************************************************/
drop view if exists activ_sum;
CREATE VIEW activ_sum as 
select 
sum(photography_Interest) as photography_Interest,
sum(Wildlife_nature) as Wildlife_nature,
sum(Hiking_climbing) as Hiking_climbing,
sum(Rafting_Kayaking) as Rafting_Kayaking,
sum(Biking_cycling) as Biking_cycling,
sum(Historical_Sites) as Historical_Sites,
sum(Beach_Water_Sports) as Beach_Water_Sports,
sum(Sightseeing) as Sightseeing,
sum(Religious) as Religious,
sum(Relaxing) as Relaxing,
sum(Romantic_holiday) as Romantic_holiday,
sum(Wildlife_and_Photography) as Wildlife_and_Photography
from  activity;

drop view if exists activ_sum;
CREATE VieW activeSuM AS SELECT * FROM activ_sum_pivot;
drop table if exists activ_sum_pivot;
drop view if exists activ_sum;