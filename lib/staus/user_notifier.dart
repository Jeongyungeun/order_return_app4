import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:order_return_app4/constant/shared_pref_keys.dart';
import 'package:order_return_app4/logger/logger.dart';
import 'package:order_return_app4/model/user_model.dart';
import 'package:order_return_app4/repository/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends ChangeNotifier {
  User? _user;
  UserModel? _userModel;
  bool? _isPharmacist;


  UserNotifier() {
    initUser();
  }

  void initUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      await _setNewUser(user);
      notifyListeners();
    });
  }

  Future _setNewUser(User? user) async {
    _user = user;
    if (user != null && user.phoneNumber != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isPharmacist = prefs.getBool(SHARED_JOBS) ?? true;

      double lat = prefs.getDouble(SHARED_LAT) ?? 0;
      double lon = prefs.getDouble(SHARED_LON) ?? 0;
      String phoneNumber = user.phoneNumber!;
      String userKey = user.uid;

      UserModel userModel = UserModel(
        userKey: '',
        isPharmacist: isPharmacist,
        phoneNumber: phoneNumber,
        geoFirePoint: GeoFirePoint(lat, lon),
        createdDate: DateTime.now().toUtc(),
      );

      //여기서 이미 존재하는지 확인한다.  userService에서 중복되는지 검사하는것
      await UserService().createNewUser(userModel.toJson(), userKey);
      _userModel = await UserService().getUserModel(userKey);
      _isPharmacist = _userModel?.isPharmacist;
      logger.i(_userModel!.toJson());

    }
  }
  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool? get isPharmacist => _isPharmacist;
}
