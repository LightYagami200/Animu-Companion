import 'package:animu/screens/self_roles/self_roles.dart';
import 'package:animu_common/animu_common.dart';
import 'package:animu/screens/home/home.dart';
import 'package:animu/screens/levels/levels.dart';
import 'package:animu/screens/rep/rep.dart';
import 'package:animu/screens/settings/settings.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Wrapper extends StatefulWidget {
  final AnimuRepository animuRepository;
  final String token;
  final Function clearToken;
  Wrapper({@required this.animuRepository, this.token, this.clearToken});

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: IndexedStack(
          index: currentIndex,
          children: <Widget>[
            Home(
              animuRepository: widget.animuRepository,
            ),
            BlocProvider(
              create: (context) {
                return LevelsBloc(animuRepository: widget.animuRepository)
                  ..add(FetchLevels());
              },
              child: Levels(
                animuRepository: widget.animuRepository,
              ),
            ),
            Rep(
              animuRepository: widget.animuRepository,
            ),
            SelfRoles(
              animuRepository: widget.animuRepository,
            ),
            SettingsPage(
              animuRepository: widget.animuRepository,
              clearToken: widget.clearToken,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Theme.of(context).primaryColor,
        opacity: .2,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        hasInk: true,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(
                Icons.dashboard,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.blue,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.orange,
              icon: Icon(
                Icons.show_chart,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              activeIcon: Icon(
                Icons.show_chart,
                color: Colors.orange,
              ),
              title: Text("Levels")),
          BubbleBottomBarItem(
              backgroundColor: Colors.orange[200],
              icon: Icon(
                Icons.bookmark_border,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              activeIcon: Icon(
                Icons.bookmark_border,
                color: Colors.orange[200],
              ),
              title: Text("Rep")),
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(
                Icons.person_outline,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              activeIcon: Icon(
                Icons.person_outline,
                color: Colors.green,
              ),
              title: Text("Self Roles")),
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              activeIcon: Icon(
                Icons.settings,
                color: Colors.red,
              ),
              title: Text("Settings")),
        ],
      ),
    );
  }
}
