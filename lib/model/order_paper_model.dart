import 'package:cloud_firestore/cloud_firestore.dart';

import '../constant/firebase_key.dart';

/// userKey : ""
/// orderProduct : ""
/// orderNum : ""
/// orderMsg : ""
/// orderDate : ""

class OrderPaperModel {
  late String userKey;
  late String orderProduct;
  late String orderNum;
  String? orderMsg;
  late String orderDate;
  DocumentReference? reference;

  OrderPaperModel({
     required this.userKey,
     required this.orderProduct,
     required this.orderNum,
     this.orderMsg,
     required this.orderDate,});

  OrderPaperModel.fromJson( Map<String, dynamic> json, this.userKey, this.reference) {
    orderProduct = json[DOC_ORDERPRODUCT]??'';
    orderNum = json[DOC_ORDERNUM]??'';
    orderMsg = json['orderMsg']??'';
    orderDate = json['orderDate']??"";
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userKey'] = userKey;
    map['orderProduct'] = orderProduct;
    map['orderNum'] = orderNum;
    map['orderMsg'] = orderMsg;
    map['orderDate'] = orderDate;
    return map;
  }

}