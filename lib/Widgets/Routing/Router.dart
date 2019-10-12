import 'package:flutter/material.dart';
import 'package:ncaa_stats/Models/gameFilter.dart';
import 'package:ncaa_stats/Models/spFilter.dart';
import 'package:ncaa_stats/Widgets/InheritedBlocs.dart';
import 'package:ncaa_stats/Widgets/Routing/RouteArgs/RouteArgs.dart';
import 'package:ncaa_stats/Widgets/TeamDetails/teamDetailsPage.dart';
import 'package:ncaa_stats/main.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // Here we'll handle all the routing
  var route = settings.name;
  var routeArgs = settings.arguments as RouteArgBase;
  if (route == Routes.HomeViewRoute) {
    InheritedBlocs.of(routeArgs.context).statsBloc.teamRatingFilter.add(
          SpFilter(
            year: DateTime.now().year,
          ),
        );
    return MaterialPageRoute(builder: (context) {
      return MyHomePage(title: 'NCAA Advanced Stats');
    });
  } else if (route
      .split("/")
      .any((section) => section == Routes.TeamDetailsRoute)) {
    var args = settings.arguments as TeamDetailAruments;
    InheritedBlocs.of(routeArgs.context)
        .statsBloc
        .teamRatingFilter
        .add(SpFilter(team: args.team.school));

    InheritedBlocs.of(routeArgs.context)
        .statsBloc
        .gamesFilter
        .add(GamesFilter(team: args.team.school, year: DateTime.now().year));
    return MaterialPageRoute(
      builder: (context) {
        return TeamDetailPage(
          team: args.team,
        );
      },
    );
  }
}

class Routes {
  static const String HomeViewRoute = '/';
  static const String TeamDetailsRoute = 'teamDetailsPage';
}
