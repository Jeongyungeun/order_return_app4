import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_return_app4/constant/firebase_key.dart';
import 'package:order_return_app4/model/user_model.dart';

class UserService {
  static final UserService _userService = UserService._internal();
  factory UserService()=>_userService;
  UserService._internal();

  Future createNewUser(Map<String, dynamic> json, String userKey) async {
    //경로와 식별자(userkey) 지정
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    //usernotifier에서 사용되는데, 존재하는 유저에 관한 정보를 보내지 않기 위해 다음구문.
    final DocumentSnapshot documentSnapshot = await documentReference.get();
    if (!documentSnapshot.exists) {
      await documentReference.set(json);
    }
  }

  Future<UserModel> getUserModel(String userKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    //usernotifier에서 사용되는데, 존재하는 유저에 관한 정보를 보내지 않기 위해 다음구문.
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentReference.get();

    UserModel userModel = UserModel.fromSnapshot(documentSnapshot);

    return userModel;
  }


}
