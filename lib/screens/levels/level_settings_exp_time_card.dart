import 'package:animu/bloc/blocs/level_settings_bloc.dart';
import 'package:animu/bloc/events/level_settings_event.dart';
import 'package:animu/bloc/states/level_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LevelSettingsExpTimeCard extends StatefulWidget {
  @override
  _LevelSettingsExpTimeCardState createState() =>
      _LevelSettingsExpTimeCardState();
}

class _LevelSettingsExpTimeCardState extends State<LevelSettingsExpTimeCard> {
  double sliderVal = 1;
  bool isValSet = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LevelSettingsBloc, LevelSettingsState>(
      builder: (context, state) {
        if (state is LevelSettingsLoaded) {
          if (!isValSet) {
            sliderVal = state.settings.expTime.toDouble();
            isValSet = true;
          }
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Exp Time',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18.0,
                    ),
                  ),
                  Slider(
                    onChanged: (val) {
                      if (mounted)
                        setState(() {
                          sliderVal = val;
                        });
                    },
                    onChangeEnd: (val) {
                      BlocProvider.of<LevelSettingsBloc>(context).add(
                          UpdateLevelSettings(
                              key: 'expTime', value: val.toInt()));
                    },
                    value: sliderVal.toDouble(),
                    min: 1,
                    divisions: 59,
                    max: 60,
                    activeColor: Colors.blue,
                    label: sliderVal.toInt().toString(),
                  ),
                ],
              ),
            ),
          );
        }

        return Text('...');
      },
    );
  }
}
