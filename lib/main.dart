import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:order_return_app4/constant/theme.dart';
import 'package:order_return_app4/router/location.dart';
import 'package:order_return_app4/first_hello_screen.dart';
import 'package:order_return_app4/screen/start/start_screen.dart';
import 'package:order_return_app4/staus/user_notifier.dart';
import 'package:provider/provider.dart';

final _routerDelegate = BeamerDelegate(
  guards: [
    BeamGuard(
        pathPatterns: [
          ...HomeLocation().pathPatterns,
          ...HomeScreenToContactPharm().pathPatterns,
          ...HomeLocationComp().pathPatterns,
        ],
        check: (BuildContext context, BeamLocation location) {
          return context.watch<UserNotifier>().user != null;
          //여기서 user는 firebaseauth로 초기화가 된다.
        },
        showPage: BeamPage(
          child: StartScreen(),
        )),
  ],
  locationBuilder: BeamerLocationBuilder(beamLocations: [
    HomeLocation(),
    HomeScreenToContactPharm(),
    HomeLocationComp(),
  ]),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: _initialization,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 300,
            ),
            child: _firstLoadingScreen(snapshot),
          );
        });
  }

  Widget? _firstLoadingScreen(AsyncSnapshot<Object> snapshot) {
    if (snapshot.hasError) {
      throw 'Error';
    } else if (snapshot.connectionState == ConnectionState.done) {
      return IntermediateForSignInScreen();
    } else {
      return FirstHelloScreen();
    }
  }
}

class IntermediateForSignInScreen extends StatelessWidget {
  const IntermediateForSignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserNotifier>(
      create: (BuildContext context) {
        return UserNotifier();
      },
      child: MaterialApp.router(
        theme: MyTheme.myThemeDataForLight,
        routeInformationParser: BeamerParser(),
        routerDelegate: _routerDelegate,
      ),
    );
  }
}
