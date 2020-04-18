import 'package:flutter/material.dart';
import 'package:queries/collections.dart';
import '../../Models/Models\.dart';
import '../InheritedBlocs.dart';

class GameDetailsPage extends StatefulWidget {
  final int gameId;
  final int year;

  const GameDetailsPage({Key key, this.gameId, this.year}) : super(key: key);
  @override
  _GameDetailsPageState createState() =>
      _GameDetailsPageState(year: year, gameId: gameId);
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  final int gameId;
  final int year;
  GameStats _stats;

  _GameDetailsPageState({this.gameId, this.year});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameStats>(
        stream: InheritedBlocs.of(context).statsBloc.gameStats,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          GameStats stats = snapshot.data;
          return DefaultTabController(
            length: snapshot.data.teams.length + 1,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                    "${stats.teams.first.school} vs ${stats.teams.last.school} (${this.year})"),
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      child: Text("Overview"),
                    ),
                    for (var team in stats.teams)
                      Tab(
                        child: Text("${team.school} ${team.points.toString()}"),
                      )
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  GameStatsOverview(stats: stats),
                  for (var team in stats.teams) TeamStatsDetails(team: team)
                ],
              ),
            ),
          );
        });
  }
}

class GameStatsOverview extends StatelessWidget {
  final GameStats stats;

  const GameStatsOverview({Key key, this.stats}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var statTypes = Collection([
      ...this.stats.teams.first.teamStats,
      ...this.stats.teams.last.teamStats
    ]);
    var statCategories = statTypes.select((stat) => stat.category).distinct();
    return ListView(
      children: <Widget>[
        GameStatsTable(stats: stats, statCategories: statCategories),
      ],
    );
  }
}

class GameStatsTable extends StatelessWidget {
  const GameStatsTable({
    Key key,
    @required this.stats,
    @required this.statCategories,
  }) : super(key: key);

  final GameStats stats;
  final IEnumerable<String> statCategories;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Category",
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        stats.teams.first.school,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        stats.teams.last.school,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            for (var statCategory in statCategories.toList()) ...[
              Divider(),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _getStatCategoryName(context, statCategory),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          stats.teams.first.teamStats
                              .firstWhere(
                                  (stat) => stat.category == statCategory,
                                  orElse: () => Stat(stat: "0"))
                              .stat,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          stats.teams.last.teamStats
                              .firstWhere(
                                  (stat) => stat.category == statCategory,
                                  orElse: () => Stat(stat: "0"))
                              .stat,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ],
    );
  }

  String _getStatCategoryName(BuildContext context, String statCategory) {
    var nameWithLowerFirstLetter = InheritedBlocs.of(context)
        .splitWordsOnPascalCase(statCategory)
        .join(" ");
    return '${nameWithLowerFirstLetter[0].toUpperCase()}${nameWithLowerFirstLetter.substring(1)}';
  }
}

class TeamStatsDetails extends StatelessWidget {
  final TeamStats team;

  const TeamStatsDetails({Key key, this.team}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: team.playerStatCategories.length,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(
          title: Text(team.playerStatCategories[index].name),
          children: <Widget>[
            for (var categoryType in team.playerStatCategories[index].types)
              StatTypeWidget(
                type: categoryType,
              )
          ],
        );
      },
    );
  }
}

class StatTypeWidget extends StatelessWidget {
  final StatType type;

  const StatTypeWidget({Key key, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(type.name),
    );
  }
}
