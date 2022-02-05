import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_return_app4/constant/firebase_key.dart';

/// myKey : "myKey"
/// yourKey : "yourKey"
/// lastMsg : "lastMsg"
/// lstMsgTime : "lstMsgTime"
/// lstMsgUserKey : "lstMsgUserKey"
/// chatroomKey : "chatroomKey"
/// reference : "reference"

class ChatroomModel {
  late String userKey;
  late String yourKey;
  late String lastMsg;
  late DateTime lstMsgTime;
  late String lstMsgUserKey;
  late String chatroomKey;
  DocumentReference? reference;

  ChatroomModel({
    required this.userKey,
    required this.yourKey,
    this.lastMsg='',
    required this.lstMsgTime,
    this.lstMsgUserKey='',
    required this.chatroomKey,
    this.reference,});

  ChatroomModel.fromJson(Map<String, dynamic> json, this.chatroomKey, this.reference ) {
    userKey = json[DOC_USERKEY] ?? '';
    yourKey = json[DOC_YOURKEY] ?? '';
    lastMsg = json[DOC_LASTMSG] ?? '';
    lstMsgTime = json[DOC_LASTMSGTIME] ?? '';
    lstMsgUserKey = json[DOC_LSTMSGUSERKEY]?? '';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[DOC_USERKEY] = userKey;
    map[DOC_YOURKEY] = yourKey;
    map[DOC_LASTMSG] = lastMsg;
    map[DOC_LASTMSGTIME] = lstMsgTime;
    map[DOC_LSTMSGUSERKEY] = lstMsgUserKey;
    map[DOC_CHATROOMKEY] = chatroomKey;
    return map;
  }
  ChatroomModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
  : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference) ;


  ChatroomModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
  : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  static String generateChatroomKey(String userKey, String yoursKey){
    return '${userKey}_${yoursKey}';
  }

}