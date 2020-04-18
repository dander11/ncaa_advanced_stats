import 'package:flutter/material.dart';
import '../../Models/Models.dart';
import '../../main.dart';
import '../InheritedBlocs.dart';
import '../TeamDetails/teamDetailsPage.dart';
import 'RouteArgs/RouteArgs.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // Here we'll handle all the routing
  var route = settings.name;
  var routeArgs = settings.arguments as RouteArgBase;

  if (route == Routes.HomeViewRoute) {
    InheritedBlocs.of(routeArgs.context).statsBloc.teamStandingsFilter.add(
          SpFilter(
            year: DateTime.now().year,
          ),
        );
    return getHomePageRoute();
  } else if (route
      .split("/")
      .any((section) => section == Routes.TeamDetailsRoute)) {
    var args = settings.arguments as TeamDetailAruments;

    updateTeamInBloc(routeArgs, args);

    //return getTeamDetailRoute(args);
  } else {
    return null;
  }
}

void updateTeamInBloc(RouteArgBase routeArgs, TeamDetailAruments args) {
  InheritedBlocs.of(routeArgs.context).statsBloc.currentTeam.add(args.team);

  InheritedBlocs.of(routeArgs.context)
      .statsBloc
      .teamRatingFilter
      .add(SpFilter(team: args.team.school));

  InheritedBlocs.of(routeArgs.context)
      .statsBloc
      .gamesFilter
      .add(GamesFilter(team: args.team.school, year: DateTime.now().year));
}

MaterialPageRoute getTeamDetailRoute(TeamDetailAruments args) {
  return MaterialPageRoute(
    builder: (context) {
      return TeamDetailPage(
        team: args.team,
      );
    },
  );
}

MaterialPageRoute getHomePageRoute() {
  return MaterialPageRoute(builder: (context) {
    return MyHomePage(title: 'NCAA Advanced Stats');
  });
}

class Routes {
  static const String HomeViewRoute = '/';
  static const String TeamDetailsRoute = 'teamDetailsPage';
}
