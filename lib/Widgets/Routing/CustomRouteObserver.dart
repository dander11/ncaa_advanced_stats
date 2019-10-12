import 'package:flutter/material.dart';
import 'package:ncaa_stats/Widgets/Routing/RouteArgs/RouteArgs.dart';
import 'package:ncaa_stats/Widgets/Routing/Router.dart';

class CustomRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route is PageRoute) {
      if (!(route.settings.arguments is RouteArgBase)) {
        var context = route.navigator.context;
//route.settings.arguments = RouteArgBase(context);
        route.navigator.pushReplacementNamed(Routes.HomeViewRoute,
            arguments: RouteArgBase(context));
      }
    } else {
      super.didPush(route, previousRoute);
    }
  }
}
