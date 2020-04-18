import 'package:flutter/material.dart';
import '../../../Models/Models.dart';

class TeamDetailAruments extends RouteArgBase {
  final String schoolName;
  @required
  final Team team;

  TeamDetailAruments(
    context, {
    this.schoolName,
    this.team,
  }) : super(context);
}

class RouteArgBase {
  @required
  final BuildContext context;

  RouteArgBase(this.context);
}
