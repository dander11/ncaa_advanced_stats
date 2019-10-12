import 'package:flutter/material.dart';
import 'package:ncaa_stats/Widgets/Routing/RouteArgs/RouteArgs.dart';
import 'package:ncaa_stats/Widgets/Routing/Router.dart';

class CustomRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    /*  if (route is PageRoute) {
      if (!(route.settings.arguments is RouteArgBase)) {
        var context = route.navigator.context;
        route.navigator.pushReplacementNamed(Routes.HomeViewRoute,
            arguments: RouteArgBase(context));
      }
    } else {
      
    } */
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (previousRoute is PageRoute) {
      if (!(previousRoute.settings.arguments is RouteArgBase)) {
        var context = previousRoute.navigator.context;
        previousRoute.navigator.pushReplacementNamed(Routes.HomeViewRoute,
            arguments: RouteArgBase(context));
      }
    } else {
      super.didPush(route, previousRoute);
    }
  }
}
