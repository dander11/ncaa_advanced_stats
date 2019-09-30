import 'dart:convert';

class GameStats {
  int id;
  List<TeamStats> teams;

  GameStats({
    this.id,
    this.teams,
  });

  factory GameStats.fromRawJson(String str) =>
      GameStats.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GameStats.fromJson(Map<String, dynamic> json) => GameStats(
        id: json["id"] == null ? null : json["id"],
        teams: json["teams"] == null
            ? null
            : List<TeamStats>.from(
                json["teams"].map((x) => TeamStats.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "teams": teams == null
            ? null
            : List<dynamic>.from(teams.map((x) => x.toJson())),
      };
}

class TeamStats {
  String school;
  String homeAway;
  int points;
  List<StatCategory> playerStatCategories;
  List<Stat> teamStats;

  TeamStats({
    this.school,
    this.homeAway,
    this.points,
    this.playerStatCategories,
    this.teamStats,
  });

  factory TeamStats.fromRawJson(String str) =>
      TeamStats.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TeamStats.fromJson(Map<String, dynamic> json) => TeamStats(
        school: json["school"] == null ? null : json["school"],
        homeAway: json["homeAway"] == null ? null : json["homeAway"],
        points: json["points"] == null ? null : json["points"],
        playerStatCategories: json["categories"] == null
            ? null
            : List<StatCategory>.from(
                json["categories"].map((x) => StatCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "school": school == null ? null : school,
        "homeAway": homeAway == null ? null : homeAway,
        "points": points == null ? null : points,
        "categories": playerStatCategories == null
            ? null
            : List<dynamic>.from(playerStatCategories.map((x) => x.toJson())),
      };
}

class Stat {
  String category;
  String stat;

  Stat({
    this.category,
    this.stat,
  });

  factory Stat.fromRawJson(String str) => Stat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        category: json["category"] == null ? null : json["category"],
        stat: json["stat"] == null ? null : json["stat"],
      );

  Map<String, dynamic> toJson() => {
        "category": category == null ? null : category,
        "stat": stat == null ? null : stat,
      };
}

class StatCategory {
  String name;
  List<StatType> types;

  StatCategory({
    this.name,
    this.types,
  });

  factory StatCategory.fromRawJson(String str) =>
      StatCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StatCategory.fromJson(Map<String, dynamic> json) => StatCategory(
        name: json["name"] == null ? null : json["name"],
        types: json["types"] == null
            ? null
            : List<StatType>.from(
                json["types"].map((x) => StatType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "types": types == null
            ? null
            : List<dynamic>.from(types.map((x) => x.toJson())),
      };
}

class StatType {
  String name;
  List<AthleteStat> athletes;

  StatType({
    this.name,
    this.athletes,
  });

  factory StatType.fromRawJson(String str) =>
      StatType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StatType.fromJson(Map<String, dynamic> json) => StatType(
        name: json["name"] == null ? null : json["name"],
        athletes: json["athletes"] == null
            ? null
            : List<AthleteStat>.from(
                json["athletes"].map((x) => AthleteStat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "athletes": athletes == null
            ? null
            : List<dynamic>.from(athletes.map((x) => x.toJson())),
      };
}

class AthleteStat {
  int id;
  String name;
  String stat;

  AthleteStat({
    this.id,
    this.name,
    this.stat,
  });

  factory AthleteStat.fromRawJson(String str) =>
      AthleteStat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AthleteStat.fromJson(Map<String, dynamic> json) => AthleteStat(
        id: json["id"] == null ? null : int.parse(json["id"]),
        name: json["name"] == null ? null : json["name"],
        stat: json["stat"] == null ? null : json["stat"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "stat": stat == null ? null : stat,
      };
}

class School {
  String name;
  String conference;

  School({
    this.name,
    this.conference,
  });

  factory School.fromRawJson(String str) => School.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory School.fromJson(Map<String, dynamic> json) => School(
        name: json["name"] == null ? null : json["name"],
        conference: json["conference"] == null ? null : json["conference"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "conference": conference == null ? null : conference,
      };
}
