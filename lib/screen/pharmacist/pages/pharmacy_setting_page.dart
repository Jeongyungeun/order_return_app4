import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PharmacySettingPage extends StatelessWidget {
  const PharmacySettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
    );
  }
}
