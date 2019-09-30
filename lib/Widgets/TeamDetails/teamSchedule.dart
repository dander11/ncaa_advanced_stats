import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncaa_stats/Models/game.dart';
import 'package:ncaa_stats/Models/gameFilter.dart';
import 'package:ncaa_stats/Models/team.dart';
import 'package:ncaa_stats/Widgets/GameDetails/gameDetailsPage.dart';
import 'package:ncaa_stats/Widgets/TeamDetails/teamItemCard.dart';

import '../InheritedBlocs.dart';

class TeamGames extends StatefulWidget {
  final Team team;
  final int year;

  const TeamGames({Key key, this.team, this.year}) : super(key: key);
  @override
  _TeamGamesState createState() =>
      _TeamGamesState(team: this.team, year: this.year);
}

class _TeamGamesState extends State<TeamGames> {
  final Team team;
  final int year;
  List<Game> games = [];

  _TeamGamesState({this.team, this.year});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InheritedBlocs.of(context)
        .statsBloc
        .gamesFilter
        .add(GamesFilter(team: team.school, year: this.year));
    return TeamItemCard(
      child: StreamBuilder<List<Game>>(
        stream: InheritedBlocs.of(context).statsBloc.games,
        builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
          if (!snapshot.hasData ||
              snapshot.data
                      .where((games) => (games.awayTeam == team.school ||
                          team.school == games.homeTeam))
                      .length !=
                  snapshot.data.length) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            this.games = snapshot.data;
          }
          return ListView.separated(
            itemCount: games.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              var game = this.games[index];
              return ListTile(
                title: Text(
                    "${game.homeTeam} ${game.homePoints ?? ''} at ${game.awayTeam} ${game.awayPoints ?? ''}"),
                trailing: game.homePoints != null
                    ? Icon(Icons.keyboard_arrow_right)
                    : null,
                subtitle: Text(
                  DateFormat.yMMMd().format(
                    DateTime.parse(game.startDate),
                  ),
                ),
                onTap: () => {
                  if (game.homePoints != null)
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return GameDetailsPage(
                              gameId: game.id,
                              year: game.season,
                            );
                          },
                        ),
                      )
                    },
                },
              );
            },
          );
        },
      ),
    );
  }
}
