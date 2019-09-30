import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ncaa_stats/Models/spFilter.dart';
import 'package:ncaa_stats/Models/spRatings.dart';
import 'package:ncaa_stats/Models/team.dart';
import 'package:ncaa_stats/Widgets/InheritedBlocs.dart';
import 'package:ncaa_stats/Widgets/TeamDetails/teamItemCard.dart';
import 'package:queries/collections.dart';

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
  void initState() {
    super.initState();

    _controller = StreamController();
    _controller.stream.distinct().listen((LineTouchResponse response) {});
  }

  @override
  Widget build(BuildContext context) {
    InheritedBlocs.of(context)
        .statsBloc
        .teamRatingFilter
        .add(SpFilter(team: this.widget.team.school));
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
                        InheritedBlocs.of(context)
                            .statsBloc
                            .teamRatingFilter
                            .add(SpFilter(team: this.widget.team.school));
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

                      return Column(
                        children: <Widget>[
                          Text(
                            "SP+ Rating vs National Avg.",
                            style: Theme.of(context).textTheme.headline,
                          ),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: TeamGraph(
                                controller: _controller,
                                teamColor: teamColor,
                                team: widget.team,
                                startYear: snapshot.data.first.year,
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
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: TeamGraph(
                                  controller: _controller,
                                  teamColor: teamColor,
                                  team: widget.team,
                                  startYear: snapshot.data.first.year,
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
                          ),
                          Divider(
                            height: 30.0,
                          ),
                          Text(
                            "SP+ Def Rating vs National Avg.",
                            style: Theme.of(context).textTheme.headline,
                          ),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: TeamGraph(
                                controller: _controller,
                                teamColor: teamColor,
                                team: widget.team,
                                startYear: snapshot.data.first.year,
                                teamRatings: ratingCollection
                                    .where(
                                        (sp) => sp.team == widget.team.school)
                                    .select((rating) => rating.defense.rating)
                                    .toList(),
                                avgRatings: ratingCollection
                                    .where(
                                        (sp) => sp.team != widget.team.school)
                                    .select((rating) => rating.defense.rating)
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                Column(
                  children: <Widget>[],
                ),
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
    @required this.startYear,
  })  : _controller = controller,
        super(key: key);

  final StreamController<LineTouchResponse> _controller;
  final Color teamColor;
  final Team team;
  final List<double> teamRatings;
  final List<double> avgRatings;
  final int startYear;

  @override
  Widget build(BuildContext context) {
    bool markedZero = false;
    return FlChart(
      chart: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
              touchResponseSink: _controller.sink,
              touchTooltipData: TouchTooltipData(
                  tooltipBgColor: Colors.white.withOpacity(1.0),
                  getTooltipItems: (touchedSpots) {
                    var toolTipItems =
                        touchedSpots.map((TouchedSpot touchedSpot) {
                      if (touchedSpots == null || touchedSpot.spot == null) {
                        return null;
                      }
                      var touchedLineSpot = touchedSpot as LineTouchedSpot;
                      String text =
                          "${touchedLineSpot.barData.colors.any((c) => c == teamColor) ? team.school : "Avg."} ${touchedSpot.spot.y.toStringAsFixed(2)}";
                      if (touchedSpots.first == touchedSpot) {
                        text =
                            "${touchedSpot.spot.x.toInt().toString()}\n${text}";
                      }
                      final TextStyle textStyle = TextStyle(
                        color: touchedSpot.getColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      );
                      return TooltipItem(text, textStyle);
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
                if (DateTime.now().year - startYear > 20) {
                  yearSeperation = 10.0;
                } else if (DateTime.now().year - startYear > 10) {
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
              showTitles: true,
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
          minX: startYear.toDouble(),
          maxX: DateTime.now().year.toDouble(),
          maxY: Collection(teamRatings).max() > Collection(avgRatings).max()
              ? Collection(teamRatings).max() + 1
              : Collection(avgRatings).max() + 1,
          minY: Collection(teamRatings).min() < Collection(avgRatings).min()
              ? Collection(teamRatings).min() - 1
              : Collection(avgRatings).min() - 1,
          lineBarsData: [
            LineChartBarData(
              spots: teamRatings
                  .asMap()
                  .map((index, value) => MapEntry(index,
                      FlSpot((this.startYear + index).toDouble(), value)))
                  .values
                  .toList(),
              isCurved: true,
              colors: [
                teamColor,
              ],
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BelowBarData(
                show: false,
              ),
            ),
            LineChartBarData(
              spots: avgRatings
                  .asMap()
                  .map((index, value) => MapEntry(index,
                      FlSpot((this.startYear + index).toDouble(), value)))
                  .values
                  .toList(),
              isCurved: true,
              colors: [
                Colors.black,
              ],
              barWidth: 1,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BelowBarData(
                show: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
