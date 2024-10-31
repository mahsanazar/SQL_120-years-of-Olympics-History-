select * from noc_regions
select * from athlete_events

-- How many olympics games have been held?
SELECT COUNT(DISTINCT CAST(SUBSTRING(Games, 1, 4) AS INT)) AS Number
FROM athlete_events
WHERE ISNUMERIC(SUBSTRING(Games, 1, 4)) = 1;

--List down all Olympics games held so far.

SELECT COUNT(DISTINCT CAST(SUBSTRING(Games, 1, 4) AS INT)) AS Number, Games
FROM athlete_events
WHERE ISNUMERIC(SUBSTRING(Games, 1, 4)) = 1
group by Games
Order by Number desc;
--Mention the total no of nations who participated in each olympics game?
select count(distinct Team) as Number , Team
from athlete_events
group by Team
order by Number desc;

SELECT COUNT(DISTINCT Team) AS TotalNumberOfTeams
FROM athlete_events;

--Which year saw the highest and lowest no of countries participating in olympics?


select top 1 YEAR , count(distinct Team) as min_number
from athlete_events
group by Year
order by min_number asc;

select top 1 YEAR , count(distinct Team) as max_number
from athlete_events
group by Year
order by max_number desc;

 -- list of sports in each year  
 
SELECT DISTINCT Year, Sport
FROM athlete_events
ORDER BY Year;


--Which nation has participated in all of the olympic games?

WITH TotalGames AS (
    SELECT COUNT(DISTINCT Games) AS Total
    FROM athlete_events
),
TeamParticipation AS (
    SELECT Team, COUNT(DISTINCT Games) AS GamesParticipated
    FROM athlete_events
    GROUP BY Team
)
SELECT TP.Team
FROM TeamParticipation TP, TotalGames TG
WHERE TP.GamesParticipated = TG.Total;

-- which sports are played 
select distinct( Sport)
from athele_events;

--Identify the sport which was played in all summer olympics.
WITH SummerGamesCount AS (
    SELECT COUNT(DISTINCT Year) AS TotalSummerGames
    FROM athlete_events
    WHERE Season = 'Summer'
),
SportParticipation AS (
    SELECT Sport, COUNT(DISTINCT Year) AS GamesCount
    FROM athlete_events
    GROUP BY Sport
)
SELECT SP.Sport
FROM SportParticipation SP, SummerGamesCount SGC
WHERE SP.GamesCount = SGC.TotalSummerGames;




--Which Sports were just played only once in the olympics?
select distinct( Sport)
from athele_events;

--Identify the sport which was played in all summer olympics.
WITH SportParticipation AS (
    SELECT Sport, COUNT(DISTINCT Year) AS GamesCount
    FROM athlete_events
    GROUP BY Sport
)
SELECT SP.Sport
FROM SportParticipation SP
WHERE SP.GamesCount = 1;
--Fetch the total no of sports played in each olympic games.
 SELECT Year,  COUNT(DISTINCT Sport) AS GamesPlayed
 FROM athlete_events
 GROUP BY Year;

 --Fetch details of the oldest athletes to win a gold medal.
SELECT Name, ID, Sex, Age, Medal, Event, Year, Sport, Team
FROM athlete_events
WHERE Age = (
    SELECT MAX(Age)
    FROM athlete_events
    WHERE Medal = 'Gold'
) AND Medal = 'Gold';

--Find the Ratio of male and female athletes participated in all olympic games.

SELECT 
    SUM(CASE WHEN Sex = 'M' THEN 1 ELSE 0 END) AS male_number,
    SUM(CASE WHEN Sex = 'F' THEN 1 ELSE 0 END) AS female_number,
    CAST(SUM(CASE WHEN Sex = 'M' THEN 1 ELSE 0 END) AS FLOAT) / 
    CAST(SUM(CASE WHEN Sex = 'F' THEN 1 ELSE 0 END) AS FLOAT) AS male_to_female_ratio
FROM 
    athlete_events;
----- another query for this question
SELECT 
    (SELECT COUNT(*) FROM athlete_events WHERE Sex = 'M') AS male_number,
    (SELECT COUNT(*) FROM athlete_events WHERE Sex = 'F') AS female_number,
    (SELECT CAST((SELECT COUNT(*) FROM athlete_events WHERE Sex = 'M') AS FLOAT) / 
            CAST((SELECT COUNT(*) FROM athlete_events WHERE Sex = 'F') AS FLOAT)) AS male_to_female_ratio;




--Fetch the top 5 athletes who have won the most gold medals.


select TOP 5 Name , COUNT(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS Num
from athlete_events
GROUP BY Name
ORDER BY Num DESC;

-- Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

--List down total gold, silver and broze medals won by each country.
SELECT  top 5 NOC,
       SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS gold_number,
       SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS silver_number,
       SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_number,
       COUNT(*) AS total_medals
FROM athlete_events
GROUP BY NOC
ORDER BY gold_number DESC, silver_number DESC, bronze_number DESC;

--List down total gold, silver and broze medals won by each country corresponding to each olympic games.
--Identify which country won the most gold, most silver and most bronze medals in each olympic games.
SELECT Team,Games,
       SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS gold_number,
       SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS silver_number,
       SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_number,
       COUNT(*) AS total_medals
FROM athlete_events
GROUP BY Team,Games
ORDER BY gold_number DESC, silver_number DESC, bronze_number DESC;
--Identify  won the most gold, most silver and most bronze medals in each olympic games.
SELECT Event,
       SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS gold_number,
       SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS silver_number,
       SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_number,
       COUNT(*) AS total_medals
FROM athlete_events
GROUP BY Event
ORDER BY gold_number DESC, silver_number DESC, bronze_number DESC;

-- Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games


--Which countries have never won gold medal but have won silver/bronze medals?

SELECT DISTINCT NOC, Medal, Event, Team
FROM athlete_events
WHERE Medal IN ('Silver', 'Bronze')
AND NOC NOT IN (
    SELECT DISTINCT NOC
    FROM athlete_events
    WHERE Medal = 'Gold'
);

--In which Sport/event, India has won highest medals.

SELECT TOP 1 Event, 
       Games, 
       Year, 
       COUNT(*) AS medal_count
FROM athlete_events
WHERE Team = 'India'
GROUP BY Event, Games, Year
ORDER BY medal_count DESC;


--Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.

SELECT Games,  
       COUNT(*) AS medal_count
FROM athlete_events
WHERE Team = 'India' and  Event LIKE '%Hockey%'
GROUP BY  Games
ORDER BY medal_count DESC;

