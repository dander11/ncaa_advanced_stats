// To parse this JSON data, do
//
//     final conference = conferenceFromJson(jsonString);

import 'dart:convert';

class Conference {
  int id;
  String name;
  String shortName;
  String abbreviation;

  Conference({
    this.id,
    this.name,
    this.shortName,
    this.abbreviation,
  });

  factory Conference.fromRawJson(String str) =>
      Conference.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Conference.fromJson(Map<String, dynamic> json) => Conference(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        shortName: json["short_name"] == null ? null : json["short_name"],
        abbreviation:
            json["abbreviation"] == null ? null : json["abbreviation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "short_name": shortName == null ? null : shortName,
        "abbreviation": abbreviation == null ? null : abbreviation,
      };
}
