import 'package:ncaa_stats/Models/game.dart';
import 'package:ncaa_stats/Models/gameFilter.dart';
import 'package:ncaa_stats/Models/gameStats.dart';
import 'package:ncaa_stats/Models/player.dart';
import 'package:ncaa_stats/Models/spRatings.dart';
import 'package:ncaa_stats/Models/team.dart';

abstract class ICollegeFootballStats {
  Future<List<Team>> getTeams();
  Future<List<Player>> getTeamRoster({String teamName});
  Future<List<Game>> getGames(GamesFilter filter);
  Future<GameStats> getGamePlayerStats(GamesFilter filter);
  Future<List<SpRatings>> getTeamRating(String school, int year);
}
