import 'package:animu_common/animu_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RepLeaderboards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepLeaderboardsBloc, RepLeaderboardsState>(
      builder: (context, state) {
        if (state is RepLeaderboardsLoading)
          return Center(
            child: CircularProgressIndicator(),
          );

        if (state is RepLeaderboardsLoaded)
          return Container(
            child: ListView.builder(
              itemCount: state.leaderboardMembers.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  dense: true,
                  leading: SizedBox(
                    width: 70.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${(i + 1).toString()}. ',
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        if (i < 9)
                          SizedBox(
                            width: 10.0,
                          ),
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                              state.leaderboardMembers[i].avatarURL),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    state.leaderboardMembers[i].username,
                  ),
                  trailing: Text(
                    state.leaderboardMembers[i].reputation.toString(),
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                );
              },
            ),
          );

        if (state is RepLeaderboardsError)
          return Center(
            child: Text('An unexpected error occured'),
          );

        return Text('...');
      },
    );
  }
}
