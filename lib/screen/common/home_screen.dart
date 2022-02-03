import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:order_return_app4/router/location.dart';
import 'package:order_return_app4/screen/compony_pharm/home_screen_com.dart';
import 'package:order_return_app4/screen/pharmacist/home_screen_pharm.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:order_return_app4/staus/user_notifier.dart';
import 'package:beamer/beamer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    // Future<bool> isPharm = context.read<UserNotifier>().isPharmacist as Future<bool>;
    return FutureBuilder<Object>(
      future: Future.delayed(Duration(milliseconds: 500)).then((value) => 1),
        builder: (context,snapshot){
        if(snapshot.hasData && context.read<UserNotifier>().isPharmacist==true){
          return HomeScreenPharm();
        }else {
          if(snapshot.hasData && context.read<UserNotifier>().isPharmacist==false){
          return HomeScreenCompany();
        }else{
          return SplashScreen();
        }
        }
        },);

  //   return MaterialApp(
  //     home: SplashScreen(),
  //     onGenerateRoute: generateRoute,
  //   );
  // }
  // Route<dynamic> generateRoute(RouteSettings settings){
  //   switch(context.read<UserNotifier>().isPharmacist){
  //     case true:
  //       return MaterialPageRoute(builder: (_)=>HomeScreenPharm());
  //     case false:
  //       return MaterialPageRoute(builder: (_)=>HomeScreenCompany());
  //     default:
  //       return MaterialPageRoute(builder: (_)=> SplashScreen());
  //   }
  //
  }


}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(100.0),
      child: Container(
        child: SpinKitFadingCircle(
          color: Colors.amber,
        ),
      ),
    ));
  }
}
