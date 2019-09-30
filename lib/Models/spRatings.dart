// To parse this JSON data, do
//
//     final spRatings = spRatingsFromJson(jsonString);

import 'dart:convert';

class SpRatings {
  int year;
  String team;
  String conference;
  double rating;
  double secondOrderWins;
  double sos;
  OffensiveSpRating offense;
  DefensiveSpRating defense;
  SpecialTeams specialTeams;
  bool get hasAdvancedRatings => (sos != null ||
      secondOrderWins != null ||
      offense.success != null ||
      defense.success != null);

  SpRatings({
    this.year,
    this.team,
    this.conference,
    this.rating,
    this.secondOrderWins,
    this.sos,
    this.offense,
    this.defense,
    this.specialTeams,
  });

  factory SpRatings.fromRawJson(String str) =>
      SpRatings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SpRatings.fromJson(Map<String, dynamic> json) => SpRatings(
        year: json["year"] == null ? null : json["year"],
        team: json["team"] == null ? null : json["team"],
        conference: json["conference"] == null ? null : json["conference"],
        rating: json["rating"] == null ? null : json["rating"].toDouble(),
        secondOrderWins: json["secondOrderWins"] == null
            ? null
            : json["secondOrderWins"].toDouble(),
        sos: json["sos"] == null ? null : json["sos"].toDouble(),
        offense: json["offense"] == null
            ? null
            : OffensiveSpRating.fromJson(json["offense"]),
        defense: json["defense"] == null
            ? null
            : DefensiveSpRating.fromJson(json["defense"]),
        specialTeams: json["specialTeams"] == null
            ? null
            : SpecialTeams.fromJson(json["specialTeams"]),
      );

  Map<String, dynamic> toJson() => {
        "year": year == null ? null : year,
        "team": team == null ? null : team,
        "conference": conference == null ? null : conference,
        "rating": rating == null ? null : rating,
        "secondOrderWins": secondOrderWins == null ? null : secondOrderWins,
        "sos": sos == null ? null : sos,
        "offense": offense == null ? null : offense.toJson(),
        "defense": defense == null ? null : defense.toJson(),
        "specialTeams": specialTeams == null ? null : specialTeams.toJson(),
      };
}

class OffensiveSpRating {
  double rating;
  double success;
  double explosiveness;
  double rushing;
  double passing;
  double standardDowns;
  double passingDowns;
  double runRate;
  double pace;

  OffensiveSpRating({
    this.rating,
    this.success,
    this.explosiveness,
    this.rushing,
    this.passing,
    this.standardDowns,
    this.passingDowns,
    this.runRate,
    this.pace,
  });

  factory OffensiveSpRating.fromRawJson(String str) =>
      OffensiveSpRating.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OffensiveSpRating.fromJson(Map<String, dynamic> json) =>
      OffensiveSpRating(
        rating: json["rating"] == null ? null : json["rating"].toDouble(),
        success: json["success"] == null ? null : json["success"].toDouble(),
        explosiveness: json["explosiveness"] == null
            ? null
            : json["explosiveness"].toDouble(),
        rushing: json["rushing"] == null ? null : json["rushing"].toDouble(),
        passing: json["passing"] == null ? null : json["passing"].toDouble(),
        standardDowns: json["standardDowns"] == null
            ? null
            : json["standardDowns"].toDouble(),
        passingDowns: json["passingDowns"] == null
            ? null
            : json["passingDowns"].toDouble(),
        runRate: json["runRate"] == null ? null : json["runRate"].toDouble(),
        pace: json["pace"] == null ? null : json["pace"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "rating": rating == null ? null : rating,
        "success": success == null ? null : success,
        "explosiveness": explosiveness == null ? null : explosiveness,
        "rushing": rushing == null ? null : rushing,
        "passing": passing == null ? null : passing,
        "standardDowns": standardDowns == null ? null : standardDowns,
        "passingDowns": passingDowns == null ? null : passingDowns,
        "runRate": runRate == null ? null : runRate,
        "pace": pace == null ? null : pace,
      };
}

class DefensiveSpRating {
  double rating;
  double success;
  double explosiveness;
  double rushing;
  double passing;
  double standardDowns;
  double passingDowns;
  Havoc havoc;

  DefensiveSpRating({
    this.rating,
    this.success,
    this.explosiveness,
    this.rushing,
    this.passing,
    this.standardDowns,
    this.passingDowns,
    this.havoc,
  });

  factory DefensiveSpRating.fromRawJson(String str) =>
      DefensiveSpRating.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DefensiveSpRating.fromJson(Map<String, dynamic> json) =>
      DefensiveSpRating(
        rating: json["rating"] == null ? null : json["rating"].toDouble(),
        success: json["success"] == null ? null : json["success"].toDouble(),
        explosiveness: json["explosiveness"] == null
            ? null
            : json["explosiveness"].toDouble(),
        rushing: json["rushing"] == null ? null : json["rushing"].toDouble(),
        passing: json["passing"] == null ? null : json["passing"].toDouble(),
        standardDowns: json["standardDowns"] == null
            ? null
            : json["standardDowns"].toDouble(),
        passingDowns: json["passingDowns"] == null
            ? null
            : json["passingDowns"].toDouble(),
        havoc: json["havoc"] == null ? null : Havoc.fromJson(json["havoc"]),
      );

  Map<String, dynamic> toJson() => {
        "rating": rating == null ? null : rating,
        "success": success == null ? null : success,
        "explosiveness": explosiveness == null ? null : explosiveness,
        "rushing": rushing == null ? null : rushing,
        "passing": passing == null ? null : passing,
        "standardDowns": standardDowns == null ? null : standardDowns,
        "passingDowns": passingDowns == null ? null : passingDowns,
        "havoc": havoc == null ? null : havoc.toJson(),
      };
}

class Havoc {
  double total;
  double frontSeven;
  double db;

  Havoc({
    this.total,
    this.frontSeven,
    this.db,
  });

  factory Havoc.fromRawJson(String str) => Havoc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Havoc.fromJson(Map<String, dynamic> json) => Havoc(
        total: json["total"] == null ? null : json["total"].toDouble(),
        frontSeven:
            json["frontSeven"] == null ? null : json["frontSeven"].toDouble(),
        db: json["db"] == null ? null : json["db"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "total": total == null ? null : total,
        "frontSeven": frontSeven == null ? null : frontSeven,
        "db": db == null ? null : db,
      };
}

class SpecialTeams {
  double rating;

  SpecialTeams({
    this.rating,
  });

  factory SpecialTeams.fromRawJson(String str) =>
      SpecialTeams.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SpecialTeams.fromJson(Map<String, dynamic> json) => SpecialTeams(
        rating: json["rating"] == null ? null : json["rating"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "rating": rating == null ? null : rating,
      };
}
