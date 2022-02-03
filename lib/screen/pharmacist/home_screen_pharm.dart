import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:order_return_app4/model/user_model.dart';
import 'package:order_return_app4/screen/pharmacist/pages/pharmacy_chatting_list_page.dart';
import 'package:order_return_app4/screen/pharmacist/pages/pharmacy_home_page.dart';
import 'package:order_return_app4/screen/pharmacist/pages/pharmacy_order_page.dart';
import 'package:order_return_app4/screen/pharmacist/pages/pharmacy_return_page.dart';
import 'package:order_return_app4/screen/pharmacist/pages/pharmacy_setting_page.dart';
import 'package:order_return_app4/staus/user_notifier.dart';
import 'package:provider/provider.dart';

class HomeScreenPharm extends StatefulWidget {
  const HomeScreenPharm({Key? key}) : super(key: key);

  @override
  State<HomeScreenPharm> createState() => _HomeScreenPharmState();
}

class _HomeScreenPharmState extends State<HomeScreenPharm> {
  int _selectedBottomNavigationBar = 0;
  @override
  Widget build(BuildContext context) {
    UserModel? userModel = context.read<UserNotifier>().userModel;
    return Scaffold(
        body: userModel == null
            ? Container()
            : IndexedStack(
                index: _selectedBottomNavigationBar,
                children: [
                  PharmacyHomePage(userKey: userModel.userKey,),
                  PharmacyChattingListPage(),
                  PharmacyOrderPage(),
                  PharmacyReturnPage(),
                  PharmacySettingPage(),
                ],
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedBottomNavigationBar,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            setState(() {
              _selectedBottomNavigationBar = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              label: '홈',
              icon: _selectedBottomNavigationBar == 0
                  ? const ImageIcon(AssetImage('image/home_black.png'))
                  : const ImageIcon(AssetImage('image/home.png')),
            ),
            BottomNavigationBarItem(
              label: '채팅',
              icon: _selectedBottomNavigationBar == 1
                  ? const ImageIcon(AssetImage('image/chat_black.png'))
                  : const ImageIcon(AssetImage('image/chat.png')),
            ),
            BottomNavigationBarItem(
              label: '주문',
              icon: _selectedBottomNavigationBar == 2
                  ? const ImageIcon(AssetImage('image/note_black.png'))
                  : const ImageIcon(AssetImage('image/note.png')),
            ),
            BottomNavigationBarItem(
              label: '반품',
              icon: _selectedBottomNavigationBar == 3
                  ? const ImageIcon(AssetImage('image/return_black.png'))
                  : const ImageIcon(AssetImage('image/return.png')),
            ),
            BottomNavigationBarItem(
              label: '세팅',
              icon: _selectedBottomNavigationBar == 4
                  ? const ImageIcon(AssetImage('image/settings_black.png'))
                  : const ImageIcon(AssetImage('image/settings.png')),
            ),
          ],
        ));
  }
}
