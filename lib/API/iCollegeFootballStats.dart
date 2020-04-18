import '../Models/Models\.dart';

abstract class ICollegeFootballStats {
  Future<List<Team>> getTeams();
  Future<List<Player>> getTeamRoster({String teamName});
  Future<List<Game>> getGames(GamesFilter filter);
  Future<GameStats> getGamePlayerStats(GamesFilter filter);
  Future<List<SpRatings>> getTeamRating(String school, [int year]);
}
