import 'package:flutter/material.dart';
import 'package:order_return_app4/screen/start/sign_in_page.dart';
import 'package:provider/provider.dart';

import 'enterence_page.dart';
import 'get_permission_page.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key? key}) : super(key: key);

  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageController>.value(
      value: _pageController,
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            EnterencePage(),
            GetPermissionPage(),
            SignInPage()
          ],
        ),
      ),
    );
  }
}
