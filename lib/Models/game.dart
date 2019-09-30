// To parse this JSON data, do
//
//     final game = gameFromJson(jsonString);

import 'dart:convert';

class Game {
  int id;
  int season;
  int week;
  String seasonType;
  String startDate;
  bool neutralSite;
  bool conferenceGame;
  int attendance;
  int venueId;
  String venue;
  String homeTeam;
  String homeConference;
  int homePoints;
  List<int> homeLineScores;
  String awayTeam;
  String awayConference;
  int awayPoints;
  List<int> awayLineScores;

  Game({
    this.id,
    this.season,
    this.week,
    this.seasonType,
    this.startDate,
    this.neutralSite,
    this.conferenceGame,
    this.attendance,
    this.venueId,
    this.venue,
    this.homeTeam,
    this.homeConference,
    this.homePoints,
    this.homeLineScores,
    this.awayTeam,
    this.awayConference,
    this.awayPoints,
    this.awayLineScores,
  });

  factory Game.fromRawJson(String str) => Game.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: json["id"] == null ? null : json["id"],
        season: json["season"] == null ? null : json["season"],
        week: json["week"] == null ? null : json["week"],
        seasonType: json["season_type"] == null ? null : json["season_type"],
        startDate: json["start_date"] == null ? null : json["start_date"],
        neutralSite: json["neutral_site"] == null ? null : json["neutral_site"],
        conferenceGame:
            json["conference_game"] == null ? null : json["conference_game"],
        attendance: json["attendance"] == null ? null : json["attendance"],
        venueId: json["venue_id"] == null ? null : json["venue_id"],
        venue: json["venue"] == null ? null : json["venue"],
        homeTeam: json["home_team"] == null ? null : json["home_team"],
        homeConference:
            json["home_conference"] == null ? null : json["home_conference"],
        homePoints: json["home_points"] == null ? null : json["home_points"],
        homeLineScores: json["home_line_scores"] == null
            ? null
            : List<int>.from(json["home_line_scores"].map((x) => x)),
        awayTeam: json["away_team"] == null ? null : json["away_team"],
        awayConference:
            json["away_conference"] == null ? null : json["away_conference"],
        awayPoints: json["away_points"] == null ? null : json["away_points"],
        awayLineScores: json["away_line_scores"] == null
            ? null
            : List<int>.from(json["away_line_scores"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "season": season == null ? null : season,
        "week": week == null ? null : week,
        "season_type": seasonType == null ? null : seasonType,
        "start_date": startDate == null ? null : startDate,
        "neutral_site": neutralSite == null ? null : neutralSite,
        "conference_game": conferenceGame == null ? null : conferenceGame,
        "attendance": attendance == null ? null : attendance,
        "venue_id": venueId == null ? null : venueId,
        "venue": venue == null ? null : venue,
        "home_team": homeTeam == null ? null : homeTeam,
        "home_conference": homeConference == null ? null : homeConference,
        "home_points": homePoints == null ? null : homePoints,
        "home_line_scores": homeLineScores == null
            ? null
            : List<dynamic>.from(homeLineScores.map((x) => x)),
        "away_team": awayTeam == null ? null : awayTeam,
        "away_conference": awayConference == null ? null : awayConference,
        "away_points": awayPoints == null ? null : awayPoints,
        "away_line_scores": awayLineScores == null
            ? null
            : List<dynamic>.from(awayLineScores.map((x) => x)),
      };
}
