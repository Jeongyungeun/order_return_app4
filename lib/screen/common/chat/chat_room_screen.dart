import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:order_return_app4/constant/widget_design.dart';
import 'package:order_return_app4/model/user_model.dart';
import 'package:order_return_app4/screen/common/chat/chat.dart';
import 'package:order_return_app4/staus/chat_notifier.dart';
import 'package:order_return_app4/staus/user_notifier.dart';
import 'package:provider/provider.dart';

import '../../../model/chat_model.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatroomKey;
  final String fixChatroomKey;

  ChatRoomScreen({
    Key? key,
    required this.chatroomKey,
  })  : fixChatroomKey = chatroomKey.replaceFirst(':', ''),
        super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController _chattingTextController = TextEditingController();
  late ChatNotifier _chatNotifier;

  @override
  void initState() {
    _chatNotifier = ChatNotifier(widget.fixChatroomKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatNotifier>.value(
      value: _chatNotifier,
      child: Consumer<ChatNotifier>(
        builder: (context, chatNotifier, child) {
          Size _size = MediaQuery.of(context).size;
          UserModel userModel = context.read<UserNotifier>().userModel!;
          return Scaffold(
            appBar: AppBar(
              title: Text('한미약품'),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Beamer.of(context).beamBack();
                },
              ),
            ),
            backgroundColor: Colors.grey[200],
            body: SafeArea(
              child: Column(
                children: [
                  _buildBanner(context),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        color: Colors.white,
                        child: ListView.separated(
                            reverse: true,
                            padding: EdgeInsets.all(common_padding),
                            itemBuilder: (context, index) {
                              bool isMine =
                                  _chatNotifier.chatList[index].userKey ==
                                      userModel.userKey;

                              return Chat(
                                  size: _size,
                                  isMine: isMine,
                                  chatModel: _chatNotifier.chatList[index]);
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 12,
                              );
                            },
                            itemCount: _chatNotifier.chatList.length),
                      ),
                    ),
                  ),
                  _buildInputBar(userModel)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(UserModel userModel) {
    return SizedBox(
      height: 62,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _showDialog(context);
            },
            icon: Icon(
              Icons.add,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _chattingTextController,
              decoration: InputDecoration(
                  isDense: true,
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey[800],
                    ),
                  ),
                  suffixIconConstraints: BoxConstraints.tight(
                    Size(30, 30),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  hintText: '메세지를 입력학세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  )),
            ),
          ),
          IconButton(
            splashColor: Colors.grey,
            onPressed: () async {
              if (_chattingTextController.text == '') {
              } else {
                ChatModel chatModel = ChatModel(
                  userKey: userModel.userKey,
                  createdDate: DateTime.now(),
                  msg: _chattingTextController.text,
                );
                _chatNotifier.addNewChat(chatModel);
                _chattingTextController.clear();
              }
              ;
            },
            icon: Icon(
              Icons.send,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return MaterialBanner(
      actions: [Container()],
      content: Column(
        children: [
          Row(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 12, top: 12, bottom: 12),
              ),
              Text('광고판'),
            ],
          )
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Container(
              width: MediaQuery.of(context).size.width - 24,
              padding: EdgeInsets.symmetric(vertical: 9),
              color: Colors.lightBlue,
              child: Center(
                child: Text(
                  '주문증',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      '주문 품목 ',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Expanded(
                      child: TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '주문 수량 ',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '요청 사항 ',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text('전송'),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text('취소'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
