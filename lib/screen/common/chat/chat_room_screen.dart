import 'package:flutter/material.dart';
import 'package:order_return_app4/constant/widget_design.dart';
import 'package:order_return_app4/model/user_model.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatroomKey;
  const ChatRoomScreen({Key? key, required this.chatroomKey}) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController _chattingTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(UserModel userModel) {
    return SizedBox(
      height: 62,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
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
                      suffixIcon: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
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
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                  color: Colors.grey,
                ),
              ),
            ],
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
}
