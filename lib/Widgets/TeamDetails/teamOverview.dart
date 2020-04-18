import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../Models/Models.dart';
import '../InheritedBlocs.dart';
import 'package:queries/collections.dart';

import 'teamItemCard.dart';

class TeamOverview extends StatefulWidget {
  const TeamOverview({
    Key key,
    @required this.team,
  }) : super(key: key);

  final Team team;

  @override
  _TeamOverviewState createState() => _TeamOverviewState();
}

class _TeamOverviewState extends State<TeamOverview> {
  StreamController<LineTouchResponse> _controller;

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = StreamController();
    _controller.stream.distinct().listen((LineTouchResponse response) {});
  }

  @override
  Widget build(BuildContext context) {
    return TeamItemCard(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Conference:",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    if (widget.team.conference != null)
                      Text(
                        widget.team.conference,
                        style: Theme.of(context).textTheme.headline,
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Division:",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      widget.team.division ?? "",
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                StreamBuilder<List<SpRatings>>(
                    stream: InheritedBlocs.of(context).statsBloc.teamRating,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.hasError ||
                          !snapshot.data
                              .any((sp) => sp.team == widget.team.school) ||
                          snapshot.data
                                  .where((sp) => sp.team == widget.team.school)
                                  .length ==
                              1) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data
                              .where((sp) => sp.team == widget.team.school)
                              .length !=
                          snapshot.data
                              .where((sp) => sp.team != widget.team.school)
                              .length) {
                        snapshot.data.retainWhere((sp) =>
                            sp.team == widget.team.school ||
                            snapshot.data
                                .where((sp) => sp.team == widget.team.school)
                                .any((teamSp) => teamSp.year == sp.year));
                      }
                      var teamColor = Color(
                          int.parse("0xff" + widget.team.color.substring(1)));

                      var ratingCollection = Collection(snapshot.data);

                      return Flex(
                        direction: Axis.vertical,
                        children: <Widget>[
                          Text(
                            "SP+ Rating vs National Avg.",
                            style: Theme.of(context).textTheme.headline,
                          ),
                          AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: TeamGraph(
                                controller: _controller,
                                teamColor: teamColor,
                                years: ratingCollection
                                    .where(
                                        (sp) => sp.team == widget.team.school)
                                    .select((rating) => rating.year)
                                    .toList(),
                                team: widget.team,
                                teamRatings: ratingCollection
                                    .where(
                                        (sp) => sp.team == widget.team.school)
                                    .select((rating) => rating.rating)
                                    .toList(),
                                avgRatings: ratingCollection
                                    .where(
                                        (sp) => sp.team != widget.team.school)
                                    .select((rating) => rating.rating)
                                    .toList(),
                              ),
                            ),
                          ),
                          Divider(
                            height: 30.0,
                          ),
                          Text(
                            "SP+ Off. Rating vs National Avg.",
                            style: Theme.of(context).textTheme.headline,
                          ),
                          AspectRatio(
                              aspectRatio: 4 / 3,
                              child: TeamGraph(
                                controller: _controller,
                                teamColor: teamColor,
                                team: widget.team,
                                years: ratingCollection
                                    .where(
                                        (sp) => sp.team == widget.team.school)
                                    .select((rating) => rating.year)
                                    .toList(),
                                teamRatings: ratingCollection
                                    .where(
                                        (sp) => sp.team == widget.team.school)
                                    .select((rating) => rating.offense.rating)
                                    .toList(),
                                avgRatings: ratingCollection
                                    .where(
                                        (sp) => sp.team != widget.team.school)
                                    .select((rating) => rating.offense.rating)
                                    .toList(),
                              )),
                          Divider(
                            height: 30.0,
                          ),
                          Text(
                            "SP+ Def Rating vs National Avg.",
                            style: Theme.of(context).textTheme.headline,
                          ),
                          AspectRatio(
                            aspectRatio: 4 / 3,
                            child: TeamGraph(
                              controller: _controller,
                              teamColor: teamColor,
                              team: widget.team,
                              years: ratingCollection
                                  .where((sp) => sp.team == widget.team.school)
                                  .select((rating) => rating.year)
                                  .toList(),
                              teamRatings: ratingCollection
                                  .where((sp) => sp.team == widget.team.school)
                                  .select((rating) => rating.defense.rating)
                                  .toList(),
                              avgRatings: ratingCollection
                                  .where((sp) => sp.team != widget.team.school)
                                  .select((rating) => rating.defense.rating)
                                  .toList(),
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /*  _getTeamRatingGraph(BuildContext context, String school) {
    return StreamBuilder<List<SpRatings>>(
        stream: InheritedBlocs.of(context).statsBloc.teamRating,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.hasError ||
              !snapshot.data.any((sp) => sp.team == widget.team.school) ||
              snapshot.data
                      .where((sp) => sp.team == widget.team.school)
                      .length ==
                  1) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return new TeamGraph(
            controller: _controller,
            teamColor: teamColor,
            team: widget.team,
            startYear: snapshot.data.first.year,
            teamRatings: ratingCollection
                .where((sp) => sp.team == widget.team.school)
                .select((rating) => rating.rating)
                .toList(),
            avgRatings: ratingCollection
                .where((sp) => sp.team != widget.team.school)
                .select((rating) => rating.rating)
                .toList(),
          );
        });
  } */
}

class TeamGraph extends StatelessWidget {
  const TeamGraph({
    Key key,
    @required StreamController<LineTouchResponse> controller,
    @required this.teamColor,
    @required this.team,
    @required this.teamRatings,
    @required this.avgRatings,
    @required this.years,
  })  : _controller = controller,
        super(key: key);

  final StreamController<LineTouchResponse> _controller;
  final Color teamColor;
  final Team team;
  final List<double> teamRatings;
  final List<double> avgRatings;
  final List<int> years;

  @override
  Widget build(BuildContext context) {
    bool markedZero = false;
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.white.withOpacity(1.0),
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  var toolTipItems =
                      touchedSpots.map((LineBarSpot touchedLineSpot) {
                    if (touchedSpots == null || touchedLineSpot == null) {
                      return null;
                    }
                    var teamName = team.abbreviation ?? team.school;
                    String text =
                        "${touchedLineSpot.bar.colors.any((c) => c == teamColor) ? teamName : "Avg."} ${touchedLineSpot.y.toStringAsFixed(2)}";
                    if (touchedSpots.first == touchedLineSpot) {
                      text = "${touchedLineSpot.x.toInt().toString()}\n$text";
                    }
                    final TextStyle textStyle = TextStyle(
                      color: touchedLineSpot.bar.colors.first,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    );
                    return LineTooltipItem(text, textStyle);
                  }).toList();
                  return toolTipItems;
                })),
        gridData: FlGridData(
          show: false,
        ),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            textStyle: TextStyle(
              color: const Color(0xff72719b),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            margin: 10,
            getTitles: (value) {
              var yearSeperation = 1.0;
              if (years.last - years.first > 25) {
                yearSeperation = 10.0;
              } else if (years.last - years.first > 10) {
                yearSeperation = 5.0;
              } else {
                yearSeperation = 1.0;
              }
              return (value.toInt() % yearSeperation) == 0
                  ? value.toInt().toString()
                  : "";
            },
          ),
          leftTitles: SideTitles(
            showTitles: false,
            textStyle: TextStyle(
              color: Color(0xff75729e),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            getTitles: (value) {
              var text = '';
              text = (value.roundToDouble().toInt() % 5.0) == 0
                  ? value.roundToDouble().toInt().toString()
                  : "";

              if (markedZero && value.toInt() == 0) {
                text = '';
              }
              if (value.toInt() == 0) {
                markedZero = true;
              }
              return text;
            },
            margin: 8,
            reservedSize: 30,
          ),
        ),
        borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(
                color: Color(0xff4e4965),
                width: 4,
              ),
              left: BorderSide(
                color: Colors.transparent,
              ),
              right: BorderSide(
                color: Colors.transparent,
              ),
              top: BorderSide(
                color: Colors.transparent,
              ),
            )),
        minX: years.first.toDouble(),
        maxX: years.last.toDouble(),
        maxY: Collection(teamRatings).max() > Collection(avgRatings).max()
            ? Collection(teamRatings).max() + 1
            : Collection(avgRatings).max() + 1,
        minY: Collection(teamRatings).min() < Collection(avgRatings).min()
            ? Collection(teamRatings).min() - 1
            : Collection(avgRatings).min() - 1,
        lineBarsData: [
          LineChartBarData(
            show: true,
            belowBarData: BarAreaData(
              show: false,
            ),
            spots: teamRatings
                .where((x) => x != null)
                .toList()
                .asMap()
                .map((index, value) => MapEntry(
                    index, FlSpot((this.years[index]).toDouble(), value ?? 0)))
                .values
                .toList(),
            isCurved: false,
            colors: [
              teamColor,
            ],
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
          ),
          LineChartBarData(
            show: true,
            spots: avgRatings
                .where((x) => x != null)
                .toList()
                .asMap()
                .map((index, value) => MapEntry(
                    index, FlSpot((this.years[index]).toDouble(), value ?? 0)))
                .values
                .toList(),
            isCurved: false,
            colors: [
              Colors.black,
            ],
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ),
          ),
        ],
      ),
    );
  }
}
