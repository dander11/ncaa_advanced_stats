import 'package:flutter/material.dart';
import '../../Models/Models\.dart';
import '../InheritedBlocs.dart';
import '../Routing/RouteArgs/RouteArgs.dart';
import '../Routing/Router.dart';

class StandingsWidget extends StatefulWidget {
  const StandingsWidget({
    Key key,
  }) : super(key: key);

  @override
  _StandingsWidgetState createState() => _StandingsWidgetState();
}

class _StandingsWidgetState extends State<StandingsWidget> {
  List<SpRatings> _ratings;

  @override
  void initState() {
    _ratings = List<SpRatings>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SpRatings>>(
      stream: InheritedBlocs.of(context).statsBloc.teamStandings.stream,
      builder: (BuildContext context, AsyncSnapshot<List<SpRatings>> snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.length < 100) {
          updateStats();
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          snapshot.data.removeLast();
          _ratings = snapshot.data;
        }
        return RefreshIndicator(
          onRefresh: () async {
            /* InheritedBlocs.of(context).statsBloc.teamRatingFilter.add(SpFilter(
                            year: DateTime.now().year,
                          )); */
          },
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              height: 10.0,
            ),
            itemBuilder: (context, index) {
              var rating = _ratings[index];
              return Container(
                child: ListTile(
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
                    var team = InheritedBlocs.of(context)
                        .statsBloc
                        .teams
                        .value
                        .firstWhere((aTeam) => aTeam.school == rating.team);

                    Navigator.pushNamed(
                      context,
                      "${Routes.TeamDetailsRoute}/${team.school}",
                      arguments: TeamDetailAruments(
                        context,
                        team: team,
                      ),
                    );
                  },
                ),
              );
            },
            itemCount: _ratings.length,
          ),
        );
      },
    );
  }

  void updateStats() async {
    var ratings =
        await InheritedBlocs.of(context).statsBloc.teamRating.toList();
    //.lastWhere((ratingList) => ratingList.length > 100);

    setState(() {
      _ratings = ratings.first;
    });
  }
}
