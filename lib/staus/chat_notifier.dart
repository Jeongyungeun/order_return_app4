import 'package:flutter/cupertino.dart';
import 'package:order_return_app4/model/chat_model.dart';
import 'package:order_return_app4/model/chat_room_model.dart';
import 'package:order_return_app4/repository/chat_service.dart';

/// 내가 챗을 입력할때 firestore로 들어갔다 화면에 뿌려주는건 아무래도 느리다.
/// 그래서 내가 입력하는건 미리 notifier 를 이용해서 뿌려주고 그건 그거대로 firestore에 저장한다.



class ChatNotifier extends ChangeNotifier{
  ChatroomModel? _chatroomModel;

  List<ChatModel> _chatList = [];
  final String _chatroomKey;

  ChatNotifier(this._chatroomKey){
    //todo connect chatroom with stream
    ChatService().connectChatroom(_chatroomKey).listen((chatroomModel) {
      this._chatroomModel = chatroomModel;

      if(this._chatList.isEmpty){
        //todo fetch 10 latest chats, if chat list is empty
        ChatService().getChatList(_chatroomKey).then((chatlist) {
          _chatList.addAll(chatlist);
        notifyListeners();
        });
      }else{
        //todo when new chatroom arrive, fetch latest chats
        if(_chatList[0].reference == null){
          _chatList.removeAt(0);
        }
        ChatService().getLatestChats(_chatroomKey, _chatList[0].reference!)
        .then((latestChat) {
          _chatList.insertAll(0, latestChat);
          notifyListeners();
        });
      }
    });
  }

  void addNewChat(ChatModel chatModel){
    _chatList.insert(0, chatModel);
    notifyListeners();
    ChatService().createNewChat(_chatroomKey, chatModel);
  }
  String get chatroomKey => _chatroomKey;

  List<ChatModel> get chatList => _chatList;

  ChatroomModel? get chatroomModel => _chatroomModel;
}