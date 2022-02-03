import 'package:flutter/cupertino.dart';
import 'package:order_return_app4/model/chat_model.dart';
import 'package:order_return_app4/model/chat_room_model.dart';
import 'package:order_return_app4/repository/chat_service.dart';

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