
USE ecocapture;
CREATE VIEW photography AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.photography
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
          CASE
            WHEN LOWER(Comments) like LOWER('%photo%') THEN "photography"
            ELSE ' '
        END AS photography
          FROM
       Comment A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.photography="photography"  
    ORDER BY act.InputID
    ;
/*Wildlife_nature*************************************************/
CREATE VIEW Wildlife_nature AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Wildlife_nature
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
        CASE
            WHEN LOWER(Comments) REGEXP LOWER('wildlife|wild life|safari|diving|snorking|leopard|leopards|elephant|elephants|peacock|bear|coral|whale|dolphin|nature|rainforest|animal|animals|monkey|lizard|butterfly|garden|reptile|snake|fish|Bats|
            Wetlands|Jungle|forest|flora|fauna|spider|owl|frogmouth|squirre|fowl|biolog|sinharaja|plants|naturalist|eagles|bird|birdlife|birding|birdwatching|magpie|birdsong|yala|wilpattu|buffalo|corals|plants|
            snails|geckos|deers|Game Camp|raptors|hornbills|turtles|waterfalls|water fall|reserve|udawalawe') THEN "wildlife_nature"
            ELSE ' '
        END AS wildlife_nature
          FROM
       Comment A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Wildlife_nature="wildlife_nature"  
    ORDER BY act.InputID
    ;  
    
 /*Wildlife_photography*************************************************/   
    drop view if exists Wildlife_photography;
    CREATE VIEW Wildlife_photography AS
	select 
	    wl.InputID,
        wl.Traveller_ID,
        wl.Wildlife_photography 
	    from 
        ( 
        select 
        A.InputID,
        A.Traveller_ID,
        A.photography,
        B.Wildlife_nature,
        case
        when  A.photography="photography" and B.Wildlife_nature="Wildlife_nature" then "Wildlife_photography"  
        else " "
        end as Wildlife_photography
        from photography A
        left join 
        wildlife_nature B on A.InputID = B.InputID and A.Traveller_ID =  B.Traveller_ID
        ) as wl
        where wl.Wildlife_photography ="Wildlife_photography"
       ORDER BY wl.InputID
	 ;  
/*Hiking_climbing*************************************************/

CREATE VIEW Hiking_climbing AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Hiking_climbing
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER('hike|hiking|walking|trekking|trek|climbing|rappaling|walked|stroll') THEN "Hiking_climbing"
            ELSE ' '
        END AS Hiking_climbing
          FROM
       Comment A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Hiking_climbing="Hiking_climbing"  
    ORDER BY act.InputID
    ;
    
    /**Biking_cycling**************************************************/
    
    CREATE VIEW Biking_cycling AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Biking_cycling
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER('biking|cycling|motorbike') THEN "Biking_cycling"
            ELSE ' '
        END AS Biking_cycling
          FROM
       Comment A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Biking_cycling="Biking_cycling"  
    ORDER BY act.InputID
    ;
    
    /**Historical_Sites**************************************************/
    
    CREATE VIEW Historical_Sites AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Historical_Sites
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP ('ancient|ruing|archaeology|historical') THEN "Historical_Sites"
            ELSE ' '
        END AS Historical_Sites
          FROM
       Comment A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Historical_Sites="Historical_Sites"  
    ORDER BY act.InputID
    ;
    
     /**Beach_Water_Sports**************************************************/
    
    CREATE VIEW Beach_Water_Sports AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Beach_Water_Sports
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER('surfing|diving|scuba|snorke|snorkeling|swim|swimming|boat|Boat trip|beach|rafting|canoe|Kayaking') THEN "Beach_Water_Sports"
            ELSE ' '
        END AS Beach_Water_Sports
          FROM
       Comment A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Beach_Water_Sports="Beach_Water_Sports"  
    ORDER BY act.InputID
    ;
    
    /**Beach_Water_Sports**************************************************/
    CREATE VIEW Sightseeing AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Sightseeing
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER('sightsee|sightseeing|waterfall|abseil|skydiving|paramotor|paraglid|ATV|architecture|lake|landscape') THEN "Sightseeing"
            ELSE ' '
        END AS Sightseeing
          FROM
       Comment A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Sightseeing="Sightseeing"  
    ORDER BY act.InputID
    ;
    /**Religious**************************************************/
    CREATE VIEW Religious AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Religious
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER('temple|church|mosques|synagogue|spiritual|praying|prayer|worship|ritual|Kovil|nallur kovil') THEN "Religious"
            ELSE ' '
        END AS Religious
          FROM
       Comment A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Religious="Religious"  
    ORDER BY act.InputID
    ;
    
	/**Relaxing**************************************************/
    CREATE VIEW Relaxing AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Relaxing
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER ('relax|relaxing|unwind|leisure|rejuvenat|bliss|retreat|resort|sanctuary|zen|solitude') THEN "Relaxing"
            ELSE ' '
        END AS Relaxing
          FROM
       Comment A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Relaxing="Relaxing"  
    ORDER BY act.InputID
    ;
    
	/**Romantic_holiday**************************************************/
    CREATE VIEW Romantic_holiday AS
	select 
	    act.InputID,
        act.Traveller_ID,
        act.Romantic_holiday
	    from
        (
		SELECT 
        A.InputID as InputID, 
        A.Traveller_ID as Traveller_ID,
         LOWER(A.Comments) AS Comments,
      CASE
            WHEN LOWER(Comments) REGEXP LOWER ('anniversary|wedding|romantic|romance') THEN "Romantic_holiday"
            ELSE ' '
        END AS Romantic_holiday
          FROM
       Comment A
     ORDER BY A.InputID AND A.Traveller_ID
    ) AS act
    where act.Romantic_holiday="Romantic_holiday"  
    ORDER BY act.InputID
    ;
    
DROP table if exists activity;  
create table activity as    
select * from  photography
union all
select * from  Wildlife_nature
union all
select * from  Wildlife_photography  
union all
select * from  Hiking_climbing
union all
select * from  Biking_cycling
union all
select * from  Historical_Sites
union all
select * from  Beach_Water_Sports
union all
select * from  Sightseeing
union all
select * from   Religious
union all
select * from  Relaxing
union all
select * from  Romantic_holiday;

alter table  activity
Rename Column photography to activity;
  
DROP view if exists photography;
DROP view if exists Wildlife_nature;
drop view if exists Wildlife_photography;
DROP view if exists Hiking_climbing;
DROP view if exists Rafting_Kayaking;
DROP view if exists Biking_cycling;
DROP view if exists Historical_Sites;
DROP view if exists Beach_Water_Sports;
DROP view if exists Sightseeing;
DROP view if exists  Religious;
DROP view if exists Relaxing;
DROP view if exists Romantic_holiday;   
    
    
    