import 'package:flutter/material.dart';
import 'package:queries/collections.dart';
import '../../Models/Models.dart';
import '../InheritedBlocs.dart';
import '../Routing/RouteArgs/RouteArgs.dart';
import '../Routing/Router.dart';

class ConferencesList extends StatelessWidget {
  const ConferencesList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Team>>(
      stream: InheritedBlocs.of(context).statsBloc.teams.stream,
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
      onExpansionChanged: (opened) {
        if (opened) {
          InheritedBlocs.of(context)
              .analytics
              .logViewItemList(itemCategory: this.conference);
        }
      },
      title: (Text(conference == null || conference.isEmpty
          ? "Independant"
          : conference)),
      children: [
        for (Team team
            in teams.where((aTeam) => aTeam.conference == this.conference))
          ListTile(
            title: Text(team.school),
            subtitle:
                Text(team.conference == null ? "Independant" : team.conference),
            onTap: () {
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
      ],
    );
  }
}
