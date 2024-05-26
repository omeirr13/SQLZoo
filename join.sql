-- join is like get all and then filter from em
-- subquery is bottom up, get specific records and then go to real result

-- 1.
-- The first example shows the goal scored by a player with the last name 'Bender'. The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtimeModify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'

--Subquery:
SELECT matchid, player FROM goal WHERE teamid = (SELECT id FROM eteam WHERE teamname = 'Germany');
--Join:
SELECT g.matchid, g.player
FROM goal g INNER JOIN eteam e ON g.teamid = e.id
WHERE teamname = 'Germany';


--2.
--From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match. Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.

--simple
SELECT id, stadium, team1, team2 FROM game WHERE id = 1012;



--3. Modify it to show the player, teamid, stadium and mdate for every German goal.
SELECT go.player, go.teamid, g.stadium, g.mdate
FROM goal go INNER JOIN eteam e ON go.teamid = e.id
INNER JOIN game g ON g.id = go.matchid
WHERE e.teamname = 'Germany' 

--4. Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'

-- with a join
SELECT g.team1, g.team2, go.player
FROM game g INNER JOIN goal go
ON g.id = go.matchid
WHERE go.player LIKE 'Mario%';

-- with a subquery
SELECT g.team1, g.team2, go.player
FROM game g INNER JOIN (SELECT matchid, player FROM goal go
WHERE player LIKE 'Mario%') go ON g.id = go.matchid;

-- 5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

-- with a join :)
SELECT go.player, go.teamid, e.coach, go.gtime
FROM goal go INNER JOIN eteam e
ON go.teamid = e.id
WHERE go.gtime <= 10;


--with a subquery and a join both hehe
SELECT go.player, go.teamid, e.coach, go.gtime FROM eteam e INNER JOIN (SELECT player, teamid, gtime
FROM goal 
WHERE gtime <= 10) go ON e.id = go.teamid;

-- 6. List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
-- Join
SELECT g.mdate, e.teamname
FROM game g INNER JOIN eteam e
ON g.team1 = e.id
WHERE e.coach = 'Fernando Santos';

-- Subquery and Join (1)
SELECT g.mdate, e.teamname
FROM game g INNER JOIN
(SELECT id, teamname FROM eteam WHERE coach = 'Fernando Santos') e
ON g.team1 = e.id;


-- 7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

-- Easy Subquery
SELECT player FROM goal WHERE matchid IN (SELECT id FROM game WHERE stadium = 'National Stadium, Warsaw');

-- Easy Join (Yawns)
SELECT go.player
FROM game g INNER JOIN goal go
ON g.id = go.matchid
WHERE g.stadium = 'National Stadium, Warsaw';

-- Combine Em(WOosh) :)
SELECT go.player
FROM game g INNER JOIN (SELECT matchid, player FROM goal) go
ON g.id = go.matchid
WHERE g.stadium = 'National Stadium, Warsaw';


-- 8. Instead show the name of all players who scored a goal against Germany.

-- idk how he would know its 'GER';
SELECT DISTINCT go.player
FROM goal go INNER JOIN eteam e
ON go.teamid = e.id
INNER JOIN game g ON g.id = go.matchid
WHERE e.teamname <> 'Germany' AND (g.team1 = 'GER' OR g.team2 = 'GER');

-- thora complex, but better ig
SELECT DISTINCT go.player
FROM goal go INNER JOIN eteam e
ON go.teamid = e.id
INNER JOIN game g ON g.id = go.matchid
WHERE e.teamname <> 'Germany' AND (g.team1 = (SELECT id FROM eteam WHERE teamname = 'Germany') OR g.team2 = (SELECT id FROM eteam WHERE teamname = 'Germany'));


-- 9. Show teamname and the total number of goals scored.

-- Wasn't hard
SELECT e.teamname, COUNT(*)
FROM goal g INNER JOIN eteam e
ON g.teamid = e.id
GROUP BY e.teamname

