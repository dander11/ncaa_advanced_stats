import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncaa_stats/Blocs/statsBloc.dart';
import 'package:ncaa_stats/Models/gameFilter.dart';
import 'package:ncaa_stats/Models/spFilter.dart';
import 'package:ncaa_stats/Models/spRatings.dart';
import 'package:ncaa_stats/Widgets/InheritedBlocs.dart';
import 'package:ncaa_stats/Widgets/TeamDetails/teamDetailsPage.dart';
import 'package:queries/collections.dart';
import 'Models/game.dart';
import 'Models/team.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InheritedBlocs(
      statsBloc: StatsBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'NCAA Advanced Stats'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    InheritedBlocs.of(context).statsBloc.teams.listen((teams) {
      InheritedBlocs.of(context).teams = teams;
    });
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Conferences",
              ),
              Tab(
                text: "Standings",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ConferencesList(),
            StandingsWidget(),
          ],
        ),
      ),
    );
  }
}

class ConferencesList extends StatelessWidget {
  const ConferencesList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Team>>(
      stream: InheritedBlocs.of(context).statsBloc.teams,
      builder: (BuildContext context, AsyncSnapshot<List<Team>> snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Team> teams = snapshot.data;
        Collection<Team> teamsCollection = Collection(teams);

        var conferences = teamsCollection
            .select((Team team) => team.conference)
            .distinct()
            .orderBy((t) => t);

        return RefreshIndicator(
          onRefresh: () => InheritedBlocs.of(context).statsBloc.refreshTeams(),
          child: ListView.builder(
            itemBuilder: (context, index) {
              var conference = conferences.elementAt(index);

              return new ConferenceTile(conference: conference, teams: teams);
            },
            itemCount: conferences.count(),
          ),
        );
      },
    );
  }
}

class StandingsWidget extends StatefulWidget {
  const StandingsWidget({
    Key key,
  }) : super(key: key);

  @override
  _StandingsWidgetState createState() => _StandingsWidgetState();
}

class _StandingsWidgetState extends State<StandingsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InheritedBlocs.of(context).statsBloc.teamRatingFilter.add(SpFilter(
          year: DateTime.now().year,
        ));
    return StreamBuilder<List<SpRatings>>(
      stream: InheritedBlocs.of(context).statsBloc.teamRating,
      builder: (BuildContext context, AsyncSnapshot<List<SpRatings>> snapshot) {
        if (!snapshot.hasData ||
            snapshot.hasError ||
            snapshot.data.length < 100) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        snapshot.data.removeLast();
        var ratings = snapshot.data;

        return RefreshIndicator(
          onRefresh: () async {
            InheritedBlocs.of(context).statsBloc.teamRatingFilter.add(SpFilter(
                  year: DateTime.now().year,
                ));
          },
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              height: 10.0,
            ),
            itemBuilder: (context, index) {
              var rating = ratings[index];
              return ListTile(
                leading: Text(
                  (index + 1).toString(),
                  style: Theme.of(context).textTheme.headline,
                ),
                title: Text(
                  rating.team,
                  style: Theme.of(context).textTheme.headline,
                ),
                subtitle: Text(
                  rating.rating.toStringAsFixed(3),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    var team = InheritedBlocs.of(context)
                        .teams
                        .firstWhere((aTeam) => aTeam.school == rating.team);
                    return new TeamDetailPage(team: team);
                  }));
                },
              );
            },
            itemCount: ratings.length,
          ),
        );
      },
    );
  }
}

class ConferenceTile extends StatelessWidget {
  const ConferenceTile({
    Key key,
    @required this.conference,
    @required this.teams,
  }) : super(key: key);

  final String conference;
  final List<Team> teams;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: (Text(conference == null || conference.isEmpty
          ? "Independant"
          : conference)),
      children: [
        for (var team
            in teams.where((aTeam) => aTeam.conference == this.conference))
          ListTile(
            title: Text(team.school),
            subtitle:
                Text(team.conference == null ? "Independant" : team.conference),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return new TeamDetailPage(team: team);
              }))
            },
          ),
      ],
    );
  }
}
