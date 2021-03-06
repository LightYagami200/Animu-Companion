import 'package:animu_common/animu_common.dart';
import 'package:animu/screens/loading/loading.dart';
import 'package:animu/screens/login/login.dart';
import 'package:animu/screens/splash/splash.dart';
import 'package:animu/screens/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final AuthRepository authRepository = AuthRepository();

  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(authRepository: authRepository)
          ..add(AppStarted());
      },
      child: BlocProvider<ThemeBloc>(
        create: (context) {
          return ThemeBloc()..add(FetchTheme());
        },
        child: Animu(
          authRepository: authRepository,
        ),
      ),
    ),
  );
}

class Animu extends StatelessWidget {
  final AuthRepository authRepository;

  Animu({Key key, @required this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'Animu',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            primaryColor: Colors.white,
            textTheme: TextTheme(
                title: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                subtitle: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
                display1: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.blue,
            toggleableActiveColor: Colors.blue,
            brightness: Brightness.dark,
            textTheme: TextTheme(
                title: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                subtitle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
                display1: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          themeMode: themeState is ThemeDark ? ThemeMode.dark : ThemeMode.light,
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationUninitialized) return Splash();

              if (state is AuthenticationAuthenticated) {
                return Wrapper(
                  animuRepository: AnimuRepository(
                    animuApiClient: AnimuApiClient(
                      httpClient: http.Client(),
                      token: state.token,
                    ),
                  ),
                );
              }

              if (state is AuthenticationUnauthenticated)
                return Login(authRepository: authRepository);

              if (state is AuthenticationLoading) return Loading();

              return Text(
                  "Hmmm, seems like you've tried to do something you weren't supposed to to");
            },
          ),
        );
      },
    );
  }
}
