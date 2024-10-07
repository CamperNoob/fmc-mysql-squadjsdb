DROP PROCEDURE IF EXISTS `sp_newMatch`;
CREATE PROCEDURE `sp_newMatch`(
    mapName char(255),
    startTimeNew DATETIME,
    winnerVar varchar(255))
BEGIN
	select @newMatch := max(id) + 1 from dblog_matches;
    INSERT INTO dblog_matches (id, dlc, mapClassname, layerClassname, map, layer, startTime, endTime, winner, server)
	values (@newMatch, "Game", mapName, mapName, mapName, mapName, date_add(startTimeNew, interval -3 hour), date_add(startTimeNew, interval -1 hour), winnerVar, 10);
END