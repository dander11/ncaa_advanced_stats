// To parse this JSON data, do
//
//     final player = playerFromJson(jsonString);

import 'dart:convert';

class Player {
  int id;
  String firstName;
  String lastName;
  int height;
  int weight;
  int jersey;
  int year;
  String position;
  String city;
  String state;
  String country;

  Player({
    this.id,
    this.firstName,
    this.lastName,
    this.height,
    this.weight,
    this.jersey,
    this.year,
    this.position,
    this.city,
    this.state,
    this.country,
  });

  factory Player.fromRawJson(String str) => Player.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json["id"] == null ? null : json["id"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        height: json["height"] == null ? null : json["height"],
        weight: json["weight"] == null ? null : json["weight"],
        jersey: json["jersey"] == null ? null : json["jersey"],
        year: json["year"] == null ? null : json["year"],
        position: json["position"] == null ? null : json["position"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        country: json["country"] == null ? null : json["country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "height": height == null ? null : height,
        "weight": weight == null ? null : weight,
        "jersey": jersey == null ? null : jersey,
        "year": year == null ? null : year,
        "position": position == null ? null : position,
        "city": city == null ? null : city,
        "state": state == null ? null : state,
        "country": country == null ? null : country,
      };
}
