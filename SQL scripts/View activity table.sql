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
        act.Location_Type,
        act.Title,
        act.Comments,
  		act.Photography_Restricted,
        act.Wildlife_nature,
        act.Hiking_climbing,
        act.Rafting_Kayaking,
        act.Biking_cycling,
        act.Historical_Sites,
        act.Beach_Water_Sports,
        act.Sightseeing,
        act.Religious,
        act.Relax,
        act.Romantic_holiday,
		CASE
			WHEN act.Photography_Restricted=' ' AND act.Photography_allowed='Y' THEN 'Y'
        END AS Photography,
        CASE
			WHEN act.Photography_Restricted=' ' and act.Photography_allowed='Y' and act.Wildlife_nature='Y' THEN 'Y'
            ELSE ' '
        END AS Wildlife_Photography
        from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
        B.City as City,
        B.Location_Type as Location_Type,
        A.Title as Title,
        LOWER(A.Comments) AS Comments,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('photography|photo|photos!|photos|picture|pictures|photographic|photographs|photograph|photographer|photographers|
            photogenic|macrophoto|photographing|photographed|photoshoot|photographable|telephoto|photographer|photographing|photography!|photography|lens|tripod') THEN 'Y'
            ELSE ' '
        END AS Photography_allowed,
        CASE
            WHEN
                LOWER(Comments) REGEXP LOWER('No photography|no photos inside|no pictures allowed|Photography is restricted|Photography restricted|Photography is forbidde|photography not allowed|pictures are forbidden|
                photography is not allowed|photographing is not allowed|photographs are not allowed|prohibited to take pictures|Photography is not permitted|prohibiting photography|no photography allowed|Flash photography is not condoned|not allow photography
                |No photography are allowed|Photography inside the buildings is prohibited|Photography is strictly prohibited| photography is banned|No photos of exhibits allowed|cannot take photographs!|
                not allowed to take any photograph|do not take a photo|cant take photos inside|photos were forbidden|not allowed to photograph|no photos allowed')
            THEN 'Y'
            when Location_Type='Religious Sites' then 'Y'
            ELSE ' '
        END AS Photography_Restricted,
      
                  
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('wildlife|safari|diving|snorking|leopard|leopards|elephant|elephants|peacock|bear|coral|whale|dolphin|nature|rainforest|animal|animals|monkey|lizard|butterfly|garden|reptile|snake|fish|Bats
            |Wetlands|Jungle|forest|flora|fauna|spider|owl|frogmouth|squirre|fowl|biolog|sinharaja|plants|naturalist|eagles|bird|birdlife|birding|birdwatching|Magpie|birdsong|Yala|buffalo|corals|plants|
            snails|geckos|deers|Game Camp|raptors|hornbills|turtles') THEN 'Y'
            ELSE ' '
        END AS Wildlife_nature,
       CASE
            WHEN LOWER(Comments) REGEXP LOWER('hike|hiking|walking|trekking|trek|climbing|rappaling|walked|stroll') THEN 'Y'
            ELSE ' '
        END AS Hiking_climbing,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('rafting|canoe|Kayaking') THEN 'Y'
            ELSE ' '
        END AS Rafting_Kayaking,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('biking|cycling|motorbike') THEN 'Y'
            ELSE ' '
        END AS Biking_cycling,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('ancient|ruing|archaeology|historical') THEN 'Y'
            ELSE ' '
        END AS Historical_Sites,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('surfing|diving|scuba|snorke|snorkeling|swim|swimming|boat|Boat trip|beach') THEN 'Y'
            ELSE ' '
        END AS Beach_Water_Sports,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('sightsee|sightseeing|waterfall|abseil|skydiving|paramotor|paraglid|ATV|architecture|lake|landscape') THEN 'Y'
            ELSE ' '
        END AS Sightseeing,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('temple|church|mosques|synagogue|spiritual|praying|prayer|worship|ritual|Kovil|nallur kovil') THEN 'Y'
            ELSE ' '
        END AS Religious,
                CASE
            WHEN LOWER(Comments) REGEXP LOWER('relax|relaxing|unwind|leisure|rejuvenat|bliss|retreat|resort|sanctuary|zen|solitude') THEN 'Y'
            ELSE ' '
        END AS Relax,
 		CASE
            WHEN LOWER(Comments) REGEXP LOWER('anniversary|wedding|romantic|romance') THEN 'Y'
            ELSE ' '
        END AS Romantic_holiday
        FROM
       Comment A
            JOIN
        location B ON A.InputID = B.InputID
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    ;
