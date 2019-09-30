import 'package:flutter/widgets.dart';

class GamesFilter {
  @required
  final int year;
  final int week;
  final SeasonType seasonType;
  final String team;
  final String home;
  final String away;
  final String conference;
  final int gameId;

  GamesFilter(
      {this.year,
      this.week,
      this.seasonType,
      this.team,
      this.home,
      this.away,
      this.conference,
      this.gameId});
}

enum SeasonType { regular, postseason }
