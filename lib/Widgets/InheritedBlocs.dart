import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/widgets.dart';
import 'package:ncaa_stats/Blocs/statsBloc.dart';
import 'package:ncaa_stats/Models/team.dart';

class InheritedBlocs extends InheritedWidget {
  List<Team> teams;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  InheritedBlocs({
    Key key,
    this.child,
    this.statsBloc,
    this.observer,
    this.analytics,
  }) : super(key: key, child: child);

  final Widget child;
  final StatsBloc statsBloc;

  static InheritedBlocs of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedBlocs)
        as InheritedBlocs);
  }

  List<String> splitWordsOnPascalCase(String input) {
    final pascalWords = RegExp(r"(?:[A-Z]+|^)[a-z]*");
    return pascalWords.allMatches(input).map((m) => m[0]).toList();
  }

  @override
  bool updateShouldNotify(InheritedBlocs oldWidget) {
    return true;
  }
}
