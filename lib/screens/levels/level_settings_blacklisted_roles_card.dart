import 'package:animu/bloc/blocs/level_settings_bloc.dart';
import 'package:animu/bloc/events/level_settings_event.dart';
import 'package:animu/bloc/states/level_settings_state.dart';
import 'package:animu/models/role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';

class LevelSettingsBlacklistedRolesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LevelSettingsBloc, LevelSettingsState>(
      builder: (context, state) {
        if (state is LevelSettingsLoaded)
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ChipsInput(
                  decoration: InputDecoration(
                    labelText: 'Blacklist Roles',
                  ),
                  initialValue: state.settings.ignoreLevelRoles,
                  findSuggestions: (String query) {
                    if (query.length != 0) {
                      var lowercaseQuery = query.toLowerCase();
                      return state.roles.where((role) {
                        return role.name
                                .toLowerCase()
                                .contains(query.toLowerCase()) ||
                            role.id.contains(query);
                      }).toList(growable: false)
                        ..sort((a, b) => a.name
                            .toLowerCase()
                            .indexOf(lowercaseQuery)
                            .compareTo(
                                b.name.toLowerCase().indexOf(lowercaseQuery)));
                    } else {
                      return const <Role>[];
                    }
                  },
                  onChanged: (data) {
                    BlocProvider.of<LevelSettingsBloc>(context).add(
                      UpdateLevelSettings(
                        key: 'ignoreLevelRoles',
                        value: data.map((c) => c.id).toList(),
                      ),
                    );
                  },
                  chipBuilder: (context, state, role) {
                    return InputChip(
                      key: ObjectKey(role.id),
                      label: Text(role.name),
                      onDeleted: () => state.deleteChip(role),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  },
                  suggestionBuilder: (context, state, role) {
                    return ListTile(
                      key: ObjectKey(role.id),
                      title: Text(role.name),
                      onTap: () => state.selectSuggestion(role),
                    );
                  },
                ),
              ),
            ),
          );

        return Text('...');
      },
    );
  }
}
