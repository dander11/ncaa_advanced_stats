import 'package:flutter/material.dart';
import 'package:ncaa_stats/Models/spFilter.dart';
import 'package:ncaa_stats/Models/spRatings.dart';
import 'package:ncaa_stats/Models/team.dart';
import 'package:ncaa_stats/Widgets/InheritedBlocs.dart';

class TeamRatings extends StatefulWidget {
  final Team team;
  final int year;

  const TeamRatings({Key key, this.team, this.year}) : super(key: key);

  @override
  _TeamRatingsState createState() => _TeamRatingsState(team: team, year: year);
}

class _TeamRatingsState extends State<TeamRatings> {
  final Team team;
  int year;

  _TeamRatingsState({this.team, this.year});
  @override
  Widget build(BuildContext context) {
    InheritedBlocs.of(context)
        .statsBloc
        .teamRatingFilter
        .add(SpFilter(team: this.team.school, year: this.year));
    return StreamBuilder<List<SpRatings>>(
        stream: InheritedBlocs.of(context).statsBloc.teamRating,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.data.where((sp) => sp.team == this.team.school).length >
                  1) {
            InheritedBlocs.of(context)
                .statsBloc
                .teamRatingFilter
                .add(SpFilter(team: this.team.school, year: this.year));
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var teamRating = snapshot.data
              .firstWhere((rating) => rating.team == this.widget.team.school);
          var averageRating = snapshot.data
              .firstWhere((rating) => rating.team != this.widget.team.school);
          var ratingColor = Colors.white;
          var years = [for (var i = 1972; i <= DateTime.now().year; i += 1) i];
          var cardElevation = 0.0;
          return ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Card(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "SP+ Ratings",
                              style: Theme.of(context).textTheme.display3,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            DropdownButton<int>(
                              style: Theme.of(context).textTheme.display1,
                              value: this.year,
                              items: years.map((int value) {
                                return new DropdownMenuItem<int>(
                                  value: value,
                                  child: new Text(value.toString()),
                                );
                              }).toList(),
                              onChanged: (selectedYear) {
                                setState(() {
                                  this.year = selectedYear;
                                });
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RatingCard(
                          ratingFlex: 1,
                          ratingColor: ratingColor,
                          ratingTitle: "Overall Rating",
                          ratingStirng: teamRating.rating.toStringAsFixed(2),
                          nationalAverageRating:
                              averageRating.rating.toStringAsFixed(2),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      RatingCard(
                        ratingFlex: 1,
                        ratingColor: ratingColor,
                        ratingTitle: "Offensive Rating",
                        ratingStirng:
                            teamRating.offense.rating.toStringAsFixed(2),
                        nationalAverageRating:
                            averageRating.offense.rating.toStringAsFixed(2),
                      ),
                      RatingCard(
                        ratingFlex: 1,
                        ratingColor: ratingColor,
                        ratingTitle: "Defensive Rating",
                        ratingStirng:
                            teamRating.defense.rating.toStringAsFixed(2),
                        nationalAverageRating:
                            averageRating.defense.rating.toStringAsFixed(2),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      RatingCard(
                        ratingFlex: 1,
                        ratingColor: ratingColor,
                        ratingTitle: "Special Teams Rating",
                        ratingStirng:
                            teamRating.specialTeams.rating?.toStringAsFixed(4),
                        nationalAverageRating: averageRating.specialTeams.rating
                            .toStringAsFixed(4),
                      ),
                    ],
                  ),
                  if (teamRating.hasAdvancedRatings) ...[
                    Card(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Advanced Ratings",
                                    style: Theme.of(context).textTheme.display2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              RatingCard(
                                ratingFlex: 1,
                                ratingColor: ratingColor,
                                ratingTitle: "Strength of Schedule",
                                ratingStirng: teamRating.sos.toStringAsFixed(2),
                                nationalAverageRating:
                                    averageRating.sos.toStringAsFixed(2),
                              ),
                              RatingCard(
                                ratingFlex: 1,
                                ratingColor: ratingColor,
                                ratingTitle: "Second Order Wins",
                                ratingStirng: teamRating.secondOrderWins
                                    .toStringAsFixed(2),
                                nationalAverageRating: averageRating
                                    .secondOrderWins
                                    .toStringAsFixed(2),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: cardElevation,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Offensive Ratings",
                                style: Theme.of(context).textTheme.display2,
                              ),
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Explosiveness",
                                  ratingStirng: teamRating.offense.explosiveness
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .offense.explosiveness
                                      .toStringAsFixed(2),
                                ),
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Sucess Rate",
                                  ratingStirng: teamRating.offense.success
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .offense.success
                                      .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Rushing",
                                  ratingStirng: teamRating.offense.rushing
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .offense.rushing
                                      .toStringAsFixed(2),
                                ),
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Passing",
                                  ratingStirng: teamRating.offense.passing
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .offense.passing
                                      .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Run Rate",
                                  ratingStirng: teamRating.offense.runRate
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .offense.runRate
                                      .toStringAsFixed(2),
                                ),
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Pace",
                                  ratingStirng: teamRating.offense.pace
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .offense.pace
                                      .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Passing Downs",
                                  ratingStirng: teamRating.offense.passingDowns
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .offense.passingDowns
                                      .toStringAsFixed(2),
                                ),
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Standard Downs",
                                  ratingStirng: teamRating.offense.standardDowns
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .offense.standardDowns
                                      .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: cardElevation,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Defensive Ratings",
                                style: Theme.of(context).textTheme.display2,
                              ),
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Explosiveness",
                                  ratingStirng: teamRating.defense.explosiveness
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .defense.explosiveness
                                      .toStringAsFixed(2),
                                ),
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Sucess Rate",
                                  ratingStirng: teamRating.defense.success
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .defense.success
                                      .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Rushing",
                                  ratingStirng: teamRating.defense.rushing
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .defense.rushing
                                      .toStringAsFixed(2),
                                ),
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Passing",
                                  ratingStirng: teamRating.defense.passing
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .defense.passing
                                      .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Passing Downs",
                                  ratingStirng: teamRating.defense.passingDowns
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .defense.passingDowns
                                      .toStringAsFixed(2),
                                ),
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Standard Downs",
                                  ratingStirng: teamRating.defense.standardDowns
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .defense.standardDowns
                                      .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Havoc Rating",
                                  ratingStirng: teamRating.defense.havoc.total
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .defense.havoc.total
                                      .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "DB Havoc Rating",
                                  ratingStirng: teamRating.defense.havoc.db
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .defense.havoc.db
                                      .toStringAsFixed(2),
                                ),
                                RatingCard(
                                  ratingFlex: 1,
                                  ratingColor: ratingColor,
                                  ratingTitle: "Front 7 Havoc Rating",
                                  ratingStirng: teamRating
                                      .defense.havoc.frontSeven
                                      .toStringAsFixed(2),
                                  nationalAverageRating: averageRating
                                      .defense.havoc.frontSeven
                                      .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ],
          );
        });
  }
}

class RatingCard extends StatelessWidget {
  const RatingCard({
    Key key,
    @required this.ratingFlex,
    @required this.ratingColor,
    @required this.ratingTitle,
    @required this.ratingStirng,
    this.nationalAverageRating,
  }) : super(key: key);

  final int ratingFlex;
  final Color ratingColor;
  final String ratingTitle;
  final String ratingStirng;
  final String nationalAverageRating;

  @override
  Widget build(BuildContext context) {
    if (ratingStirng == null) {
      return Container();
    }
    return Flexible(
      flex: ratingFlex,
      fit: FlexFit.tight,
      child: Card(
        elevation: 0.0,
        color: ratingColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              ratingTitle,
              style: Theme.of(context).textTheme.headline,
              textAlign: TextAlign.center,
            ),
            Text(
              ratingStirng,
              style: Theme.of(context).textTheme.display2,
            ),
            Text(this.nationalAverageRating != null
                ? "NCAA avg: ${this.nationalAverageRating}"
                : "")
          ],
        ),
      ),
    );
  }
}
