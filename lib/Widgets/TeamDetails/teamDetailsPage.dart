import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncaa_stats/Models/game.dart';
import 'package:ncaa_stats/Models/gameFilter.dart';
import 'package:ncaa_stats/Models/spFilter.dart';
import 'package:ncaa_stats/Models/spRatings.dart';
import 'package:ncaa_stats/Models/team.dart';
import 'package:ncaa_stats/Widgets/GameDetails/gameDetailsPage.dart';
import 'package:ncaa_stats/Widgets/InheritedBlocs.dart';
import 'package:ncaa_stats/Widgets/TeamDetails/teamItemCard.dart';
import 'package:ncaa_stats/Widgets/TeamDetails/teamOverview.dart';
import 'package:ncaa_stats/Widgets/TeamDetails/teamRatings.dart';
import 'package:ncaa_stats/Widgets/TeamDetails/teamSchedule.dart';

class TeamDetailPage extends StatelessWidget {
  const TeamDetailPage({
    Key key,
    @required this.team,
  }) : super(key: key);

  final Team team;

  @override
  Widget build(BuildContext context) {
    var mainColor = Color(int.parse("0xff" + team.color.substring(1)));
    var altColor = team.altColor != null
        ? Color(int.parse("0xff" + team.altColor.substring(1)))
        : this.getTextColor(mainColor);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: altColor,
        body: NestedScrollView(
          headerSliverBuilder: (context, a) {
            return [
              SliverAppBar(
                centerTitle: true,
                elevation: 0.0,
                backgroundColor: altColor,
                pinned: true,
                iconTheme: Theme.of(context).iconTheme.copyWith(
                      color: this.getTextColor(altColor),
                    ),
                expandedHeight: this.getHeaderHeight(context),
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FractionallySizedBox(
                        child: Image.network(team.logos.first),
                        widthFactor: .3,
                      ),
                    ],
                  ),
                ),
                title: Text(
                  team.school,
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: this.getTextColor(altColor),
                      ),
                ),
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        "Overview",
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: this.getTextColor(altColor),
                            ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Ratings",
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: this.getTextColor(altColor),
                            ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Schedule",
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: this.getTextColor(altColor),
                            ),
                      ),
                    ),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              TeamOverview(team: team),
              TeamRatings(team: team, year: 2019),
              TeamGames(
                team: team,
                year: 2019,
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTextColor(Color color) {
    int d = 0;

    // Counting the perceptive luminance - human eye favors green color...
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

    if (luminance > 0.5)
      d = 0; // bright colors - black font
    else
      d = 255; // dark colors - white font

    return Color.fromARGB(color.alpha, d, d, d);
  }

  getHeaderHeight(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    double headerHeight = 200.0;
    double headerPercentage = .35;
    if ((deviceHeight * headerPercentage) > 200) {
      headerHeight = (deviceHeight * headerPercentage);
    }
    return headerHeight;
  }
}