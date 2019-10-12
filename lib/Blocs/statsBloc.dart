import 'dart:async';
import 'package:ncaa_stats/API/collegeFootballStats.dart';
import 'package:ncaa_stats/API/iCollegeFootballStats.dart';
import 'package:ncaa_stats/Models/game.dart';
import 'package:ncaa_stats/Models/gameFilter.dart';
import 'package:ncaa_stats/Models/gameStats.dart';
import 'package:ncaa_stats/Models/spFilter.dart';
import 'package:ncaa_stats/Models/spRatings.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ncaa_stats/Models/team.dart';

class StatsBloc {
  /* Sink<AppPage> get nextPage => _nextPageController.sink;
  final _nextPageController = StreamController<AppPage>();
 */
  BehaviorSubject<List<Team>> get teams => _teams;
  final _teams = BehaviorSubject<List<Team>>.seeded([]);

  ICollegeFootballStats api = CollegeFootballStats();

  BehaviorSubject<List<Game>> get games => _games;
  final _games = BehaviorSubject<List<Game>>.seeded([]);

  Sink<GamesFilter> get gamesFilter => _gameFilterController.sink;
  final _gameFilterController = StreamController<GamesFilter>();

  Stream<GameStats> get gameStats => _gameStats.stream;
  final _gameStats = BehaviorSubject<GameStats>();

  Sink<GamesFilter> get gameStatsFilter => _gameStatsFilterController.sink;
  final _gameStatsFilterController = StreamController<GamesFilter>();

  Stream<List<SpRatings>> get teamRating => _teamRating.stream;
  final _teamRating = BehaviorSubject<List<SpRatings>>();

  BehaviorSubject<List<SpRatings>> get teamStandings => _teamStandings;
  final _teamStandings = BehaviorSubject<List<SpRatings>>();

  Sink<SpFilter> get teamRatingFilter => _teamRatingFilterController.sink;
  final _teamRatingFilterController = StreamController<SpFilter>();

  Sink<SpFilter> get teamStandingsFilter => _teamStandingsFilterController.sink;
  final _teamStandingsFilterController = StreamController<SpFilter>();

  StatsBloc() {
    refreshTeams();
    initListeners();
  }

  updatePage() {}

  refreshTeams() async {
    await api.getTeams().then((onValue) => _teams.add(onValue));
  }

  dispose() async {
    _teams.close();
    _gameFilterController.close();
    _games.close();
    _gameStats.close();
    _gameStatsFilterController.close();
    _teamRating.close();
    _teamRatingFilterController.close();
    _teamStandings.close();
    _teamStandingsFilterController.close();
  }

  void initListeners() {
    _gameFilterController.stream.listen((filter) {
      api.getGames(filter).then((gamesList) {
        _games.add(gamesList);
      });
    });

    _gameStatsFilterController.stream.listen((filter) {
      api.getGamePlayerStats(filter).then((gameStats) {
        _gameStats.add(gameStats);
      });
    });

    _teamRatingFilterController.stream.listen((filter) {
      print("Filter: ${filter.team ?? ""}, ${filter.year ?? ""}");
      api.getTeamRating(filter.team, filter.year).then((ratings) {
        _teamRating.add(ratings);
      });
    });

    _teamStandingsFilterController.stream.listen((filter) {
      api.getTeamRating(filter.team, filter.year).then((ratings) {
        _teamStandings.add(ratings);
      });
    });
  }
}
