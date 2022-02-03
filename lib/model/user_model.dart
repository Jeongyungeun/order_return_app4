import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:order_return_app4/constant/firebase_key.dart';

/// userKey : "userKey"
/// phoneNumber : "phoneNumber"
/// geoFirePoint : "geoFirePoint"
/// createdDate : "createdDate"
/// reference : "reference"

class UserModel {
  late String userKey;
  late bool isPharmacist;
  late String phoneNumber;
  late GeoFirePoint geoFirePoint;
  late DateTime createdDate;
  DocumentReference? reference;

  UserModel({
    required this.userKey,
    required this.isPharmacist,
    required this.phoneNumber,
    required this.geoFirePoint,
    required this.createdDate,
    this.reference,
  });

  UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.reference) {
    phoneNumber = json[DOC_PHONENUMBER];
    isPharmacist = json[DOC_ISPHARMACIST];
    geoFirePoint = GeoFirePoint((json[DOC_GEOFIREPOINT]['geopoint']).latitude,
        (json[DOC_GEOFIREPOINT]['geopoint']).longitude);
    createdDate = json[DOC_CREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
  }

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[DOC_PHONENUMBER] = phoneNumber;
    map[DOC_ISPHARMACIST] = isPharmacist;
    map[DOC_GEOFIREPOINT] = geoFirePoint.data;
    map[DOC_CREATEDDATE] = createdDate;
    return map;
  }
}
