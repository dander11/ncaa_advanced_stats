// To parse this JSON data, do
//
//     final team = teamFromJson(jsonString);

import 'dart:convert';

class Team {
  int id;
  String school;
  String mascot;
  String abbreviation;
  String altName1;
  String altName2;
  String altName3;
  String conference;
  String division;
  String color;
  String altColor;
  List<String> logos;
  List<int> years;

  Team({
    this.id,
    this.school,
    this.mascot,
    this.abbreviation,
    this.altName1,
    this.altName2,
    this.altName3,
    this.conference,
    this.division,
    this.color,
    this.altColor,
    this.logos,
    this.years,
  });

  factory Team.fromRawJson(String str) => Team.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["id"] == null ? null : json["id"],
        school: json["school"] == null ? null : json["school"],
        mascot: json["mascot"] == null ? null : json["mascot"],
        abbreviation:
            json["abbreviation"] == null ? null : json["abbreviation"],
        altName1: json["alt_name_1"] == null ? null : json["alt_name_1"],
        altName2: json["alt_name_2"] == null ? null : json["alt_name_2"],
        altName3: json["alt_name_3"] == null ? null : json["alt_name_3"],
        conference: json["conference"] == null ? null : json["conference"],
        division: json["division"] == null ? null : json["division"],
        color: json["color"] == null ? null : json["color"],
        altColor: json["alt_color"] == null ? null : json["alt_color"],
        logos: json["logos"] == null
            ? null
            : List<String>.from(json["logos"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "school": school == null ? null : school,
        "mascot": mascot == null ? null : mascot,
        "abbreviation": abbreviation == null ? null : abbreviation,
        "alt_name_1": altName1 == null ? null : altName1,
        "alt_name_2": altName2 == null ? null : altName2,
        "alt_name_3": altName3 == null ? null : altName3,
        "conference": conference == null ? null : conference,
        "division": division == null ? null : division,
        "color": color == null ? null : color,
        "alt_color": altColor == null ? null : altColor,
        "logos": logos == null ? null : List<dynamic>.from(logos.map((x) => x)),
      };
}
