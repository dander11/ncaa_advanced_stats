import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Models/Models.dart';
import '../GameDetails/gameDetailsPage.dart';
import '../InheritedBlocs.dart';
import 'teamItemCard.dart';

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
  int year;
  List<Game> games = [];

  _TeamGamesState({this.team, this.year});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TeamItemCard(
      child: StreamBuilder<List<Game>>(
        stream: InheritedBlocs.of(context).statsBloc.games,
        builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            this.games = snapshot.data;
          }
          var years = [for (var i = 1972; i <= DateTime.now().year; i += 1) i];
          var wins = games
              .where((game) =>
                  game.awayPoints != null &&
                  ((game.homeTeam == this.team.school &&
                          game.homePoints > game.awayPoints) ||
                      (game.awayTeam == this.team.school &&
                          game.homePoints < game.awayPoints)))
              .length;
          var losses = games
              .where((game) =>
                  game.awayPoints != null &&
                  ((game.homeTeam == this.team.school &&
                          game.homePoints < game.awayPoints) ||
                      (game.awayTeam == this.team.school &&
                          game.homePoints > game.awayPoints)))
              .length;

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "$wins-$losses",
                      style: Theme.of(context).textTheme.display1,
                    ),
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
                          InheritedBlocs.of(context).statsBloc.gamesFilter.add(
                              GamesFilter(team: team.school, year: this.year));
                        });
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: games.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    var game = this.games[index];

                    return ListTile(
                      title: Text(
                          "${game.homeTeam} ${game.homePoints ?? ''} at ${game.awayTeam} ${game.awayPoints ?? ''}"),
                      trailing:

                          //game.homePoints != null

                          //  ? Icon(Icons.keyboard_arrow_right)

                          //:

                          null,
                      subtitle: Text(
                        DateFormat.yMMMd().format(
                          DateTime.parse(game.startDate),
                        ),
                      ),
                      onTap: () => {
                        //removing this feature in the dirtiest way possible for now

                        if (false)
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
