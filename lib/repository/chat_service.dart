import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_return_app4/constant/firebase_key.dart';
import 'package:order_return_app4/model/chat_model.dart';
import 'package:order_return_app4/model/chat_room_model.dart';

class ChatService {
  static final ChatService _chatService = ChatService._internal();
  factory ChatService() => _chatService;
  ChatService._internal();

  ///Create new Chatroom///
  //chatroom model 만 전달해주면 된다.
  // 경로를 설정해주고 같은 경로의 snapshot이 없으면 만들어준다.
  Future createNewChatroom(ChatroomModel chatroomModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(
            ChatroomModel.generateChatroomKey(
                chatroomModel.userKey, chatroomModel.yourKey));
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    if (!documentSnapshot.exists) {
      await documentReference.set(chatroomModel.toJson());
    }
  }

  ///create new chat///
  Future createNewChat(String chatroomKey, ChatModel chatModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance
            .collection(COL_CHATROOMS)
            .doc(chatroomKey)
            .collection(COL_CHATS)
            .doc(); // 따로 키를 지정하지 않고 firebase에서 오토로

    //chatroom으로 들어가는 부분(documentreference)
    DocumentReference<Map<String, dynamic>> chatroomDocRef =
        FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(chatroomKey);

    await documentReference.set(chatModel.toJson());

    //chatroom에 마지막 메시지를 chatroom에 저장해줘야 한다. 마지막 teller도
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatModel.toJson());

      //set이 아니고 update
      transaction.update(chatroomDocRef, {
        DOC_LASTMSG: chatModel.msg,
        DOC_LASTMSGTIME: chatModel.createdDate,
        DOC_LASTMSGUSERKEY: chatModel.userKey
      });
    });
  }

  ///get chatroom detail///
  Stream<ChatroomModel> connectChatroom(String chatroomKey) {
    return FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .snapshots()
        .transform(snapshotToChatroom);
  }

// streem에서 들어오는 snapshot 데이터를 chatroomModel로 변경하는 과정이다.
  var snapshotToChatroom = StreamTransformer<
      DocumentSnapshot<Map<String, dynamic>>,
      ChatroomModel>.fromHandlers(handleData: (snapshot, sink) {
    ChatroomModel chatroom = ChatroomModel.fromSnapShot(snapshot);
    sink.add(chatroom);
  });

  ///이전 10개의 메세지만 받아오기///

  Future<List<ChatModel>> getChatList(String chatroomKey) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .limit(10)
        .get();

    List<ChatModel> chatlist = [];
    snapshot.docs.forEach((docSnapshot) {
      ChatModel chatModel = ChatModel.fromQuerySnapshot(docSnapshot);
      chatlist.add(chatModel);
    });
    return chatlist;
  }

  ///마지막 채팅
  Future<List<ChatModel>> getLatestChats(
      String chatroomKey, DocumentReference currentLatestChatRef) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .get();

    List<ChatModel> chatlist = [];
    snapshot.docs.forEach((docSnapshot) {
      ChatModel chatModel = ChatModel.fromQuerySnapshot(docSnapshot);
      chatlist.add(chatModel);
    });
    return chatlist;
  }

  /// 더 오래된 채팅 내용 가져오기///

  Future<List<ChatModel>> getOlderChats(
      String chatroomKey, DocumentReference oldestChatRef) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .startAfterDocument(await oldestChatRef.get())
        .limit(10)
        .get();
    List<ChatModel> chatlist = [];
    snapshot.docs.forEach((docsSnapshot) {
      ChatModel chatModel = ChatModel.fromQuerySnapshot(docsSnapshot);
      chatlist.add(chatModel);
    });
    return chatlist;
  }

  /// 내 채팅 다 가져오기

  Future<List<ChatroomModel>> getMyChatList(String myUserKey) async {
    List<ChatroomModel> chatrooms = [];
    QuerySnapshot<Map<String, dynamic>> firstChat = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .where(DOC_YOURKEY, isEqualTo: myUserKey)
        .get();

    QuerySnapshot<Map<String, dynamic>> lastChat = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .where(DOC_YOURKEY, isEqualTo: myUserKey)
        .get();

    firstChat.docs.forEach((documentSnapshot) {
      chatrooms.add(ChatroomModel.fromQuerySnapshot(documentSnapshot));
    });

    lastChat.docs.forEach((documentSnapshot) {
      chatrooms.add(ChatroomModel.fromQuerySnapshot(documentSnapshot));
    });
    chatrooms.sort((a,b)=>(a.lstMsgTime).compareTo(b.lstMsgTime));

    return chatrooms;
  }
}
