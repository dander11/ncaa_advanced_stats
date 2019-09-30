import 'package:flutter/widgets.dart';
import 'package:ncaa_stats/Blocs/statsBloc.dart';
import 'package:ncaa_stats/Models/team.dart';

class InheritedBlocs extends InheritedWidget {
  List<Team> teams;

  InheritedBlocs({Key key, this.child, this.statsBloc})
      : super(key: key, child: child);

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
