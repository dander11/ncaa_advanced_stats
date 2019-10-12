import 'dart:convert';

import 'package:http/http.dart';
import 'package:ncaa_stats/API/iCollegeFootballStats.dart';
import 'package:ncaa_stats/Models/game.dart';
import 'package:ncaa_stats/Models/gameFilter.dart';
import 'package:ncaa_stats/Models/gameStats.dart';
import 'package:ncaa_stats/Models/player.dart';
import 'package:ncaa_stats/Models/spRatings.dart';
import 'package:ncaa_stats/Models/team.dart';
import 'package:http/http.dart' as http;
import 'package:queries/collections.dart';

class CollegeFootballStats extends ICollegeFootballStats {
  String _apiUrl = "https://api.collegefootballdata.com";
  @override
  Future<List<Game>> getGames(GamesFilter filter) async {
    Map<String, String> filterParams = {};
    filterParams["seasonType"] = "both";
    if (filter.away != null && filter.away.isNotEmpty) {
      filterParams["away"] = filter.away;
    }
    if (filter.conference != null && filter.conference.isNotEmpty) {
      filterParams["conference"] = filter.conference;
    }
    if (filter.home != null && filter.home.isNotEmpty) {
      filterParams["home"] = filter.home;
    }
    if (filter.seasonType != null) {
      //filterParams["seasonType"] = filter.seasonType ==;
    }
    if (filter.team != null && filter.team.isNotEmpty) {
      filterParams["team"] = filter.team;
    }
    if (filter.week != null) {
      filterParams["week"] = filter.week.toString();
    }
    if (filter.year != null) {
      filterParams["year"] = filter.year.toString();
    }
    var response =
        await _makeGetRequest(url: _apiUrl + "/games", params: filterParams);

    List<Game> games = (jsonDecode(response.body) as List)
        .map((e) => new Game.fromJson(e))
        .toList();

    return Collection(games)
        .orderBy((game) => DateTime.parse(game.startDate))
        .toList();
  }

  @override
  Future<List<Player>> getTeamRoster({String teamName}) {
    // TODO: implement getTeamRoster
    return null;
  }

  @override
  Future<List<Team>> getTeams({String conference = ""}) async {
    var response = await _makeGetRequest(
        url: _apiUrl + "/teams/fbs", params: {"conference": conference});

    List<Team> teams = (jsonDecode(response.body) as List)
        .map((e) => new Team.fromJson(e))
        .toList();

    return teams;
  }

  Future<Response> _makeGetRequest({Map<String, String> params, url}) async {
    String requestUrl = url;

    if (params.isNotEmpty) {
      requestUrl += "?";
      List<String> paramList = [];
      params.forEach((key, value) => paramList.add(key + "=" + value));
      requestUrl += paramList.join("&");
    }

    return await http.get(requestUrl);
  }

  @override
  Future<GameStats> getGamePlayerStats(GamesFilter filter) async {
    // TODO: implement getGameStats
    ///games/players?year=2019&gameId=401111653
    ///Map<String, String> filterParams = {};
    Map<String, String> filterParams = {};
    if (filter.away != null && filter.away.isNotEmpty) {
      filterParams["away"] = filter.away;
    }
    if (filter.conference != null && filter.conference.isNotEmpty) {
      filterParams["conference"] = filter.conference;
    }
    if (filter.home != null && filter.home.isNotEmpty) {
      filterParams["home"] = filter.home;
    }
    if (filter.seasonType != null) {
      //filterParams["seasonType"] = filter.seasonType ==;
    }
    if (filter.team != null && filter.team.isNotEmpty) {
      filterParams["team"] = filter.team;
    }
    if (filter.week != null) {
      filterParams["week"] = filter.week.toString();
    }
    if (filter.year != null) {
      filterParams["year"] = filter.year.toString();
    }
    if (filter.gameId != null) {
      filterParams["gameId"] = filter.gameId.toString();
    }
    var response = await _makeGetRequest(
        url: _apiUrl + "/games/players", params: filterParams);

    ///games/teams
    var teamsResponse = await _makeGetRequest(
        url: _apiUrl + "/games/teams", params: filterParams);

    List<dynamic> teamStats = (jsonDecode(teamsResponse.body) as List);
    var teams = teamStats[0]["teams"];

    List<GameStats> gameStats = (jsonDecode(response.body) as List)
        .map((e) => new GameStats.fromJson(e))
        .toList();

    for (var aTeamJson in teams) {
      var team = gameStats.first.teams
          .firstWhere((team) => team.school == aTeamJson["school"]);
      team.teamStats = (aTeamJson["stats"] as List)
          .map((e) => new Stat.fromJson(e))
          .toList();
    }

    return gameStats.first;
  }

  @override
  Future<List<SpRatings>> getTeamRating(String school, [int year]) async {
    Map<String, String> filterParams = {};
    if (school != null && school.isNotEmpty) {
      filterParams["team"] = school;
    }
    if (year != null) {
      filterParams["year"] = year.toString();
    }
    var response = await _makeGetRequest(
        url: _apiUrl + "/ratings/sp", params: filterParams);

    List<SpRatings> ratings = (jsonDecode(response.body) as List)
        .map((e) => new SpRatings.fromJson(e))
        .toList();
    return ratings;
  }
}
