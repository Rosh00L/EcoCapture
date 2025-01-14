/*ALTER TABLE votes
    DROP primary key;
SET SQL_SAFE_UPDATES = 0;    
Delete  from  votes
where InputID > 0 ;

*/

USE ecocapture;

DROP view if exists activity;

CREATE VIEW activity AS
    SELECT 
        A.InputID,
        A.Traveller_ID,
        B.City,
        B.Location_Type,
        A.Title,
        LOWER(A.Comments) AS Comments,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('photography|photo|photos|picture|pictures') THEN 'Y'
            ELSE ' '
        END AS Photography,
        CASE
            WHEN
                LOWER(Comments) REGEXP LOWER('photography is not|photography isn|Photography not|No photography|Photography is restricted|Photography is forbidde|
                        photo is not|photo isn|Photo not|No photo|photos are not|photos are|Photos not|No photos|
                        picture is not|picture isn|picture not|No picture|pictures are not|pictures are|pictures not|no pictures')
            THEN
                'Y'
            ELSE ' '
        END AS Photography_Restricted,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('wildlife|safar|diving|snorking|leopard|eleph|bear|coral|whale|dolphin|nature|rainforest|animal|monkey|lizard|butterfly|garden|reptile|snake|fish|Bats
            |Wetlands|Jungle|forest|flora|fauna|spider|owl|frogmouth|squirre|fowl|biolog|sinharaja|plants|naturalist|eagles|bird|birdlife|birding|birdwatching|Magpie|birdsong') THEN 'Y'
            ELSE ' '
        END AS Wildlife_nature,
       CASE
            WHEN LOWER(Comments) REGEXP LOWER('hike|hiking|walking|trekking|trek|climbing|rappaling') THEN 'Y'
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
        END AS Historical_Sites_traveller_date,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('surfing|diving|scuba|snorke|snorkeling|swim|swimming|boat|Boat trip') THEN 'Y'
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
        END AS Relax
    FROM
        Comment A
            JOIN
        location B ON A.InputID = B.InputID
	ORDER BY A.InputID AND A.Traveller_ID;

