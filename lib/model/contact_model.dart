import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_return_app4/constant/firebase_key.dart';

class ContactModel {
  late String cardKey;
  late String userKey;
  late String name;
  late String company;
  late String phoneNum;
  late DateTime createdDate;
  List<String>? contactImageUrl;
  DocumentReference? reference;

  ContactModel(
      {required this.cardKey,
      required this.userKey,
      required this.name,
      required this.company,
      required this.phoneNum,
      required this.createdDate,
      this.contactImageUrl,
      this.reference});

  ContactModel.fromJson(
      Map<String, dynamic> json, this.userKey, this.reference) {
    cardKey = json[DOC_CARDKEY] ?? '';
    name = json[DOC_NAME] ?? '';
    company = json[DOC_COMPANY] ?? '';
    phoneNum = json[DOC_PHONENUMBER] ?? '';
    createdDate = json[DOC_CREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
    contactImageUrl = json[DOC_CONTACTIMAGEURL]==null
    ?[]
    :json[DOC_CONTACTIMAGEURL].cast<String>();
  }

  ContactModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot
      ) : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[DOC_CARDKEY] = cardKey;
    map[DOC_USERKEY] = userKey;
    map[DOC_NAME] = name;
    map[DOC_COMPANY] = company;
    map[DOC_PHONENUMBER] = phoneNum;
    map[DOC_CREATEDDATE] = createdDate;
    map[DOC_CONTACTIMAGEURL] = contactImageUrl;
    return map;
  }

  static String generateContactKey(String uid) {
    String timeInMilli = DateTime.now().millisecondsSinceEpoch.toString();
    return '${uid}_${timeInMilli}';
  }
}
