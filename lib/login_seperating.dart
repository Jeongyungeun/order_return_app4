import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginSeperating extends StatelessWidget {
  const LoginSeperating({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SpinKitFadingCircle(color: Colors.white, size:50.0),
    );
  }
}
