import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_return_app4/model/chat_model.dart';

const roundedCorner = Radius.circular(20);

class Chat extends StatelessWidget {
  final Size size;
  final bool isMine;
  final String dateFormat;
  final ChatModel chatModel;

  Chat(
      {Key? key,
      required this.size,
      required this.isMine,
      required this.chatModel})
      : dateFormat = DateFormat('kk:mm').format(chatModel.createdDate),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMine ? _buildMyMsg(context) : _buildOtherMsg(context);
  }

  Row _buildOtherMsg(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:  MainAxisAlignment.start,
      children: [
        ExtendedImage.network(
          'https://picsum.photos/200',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(6),
          shape: BoxShape.rectangle,
        ),
        SizedBox(
          width: 6,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: 40,
                maxWidth: size.width * 0.5,
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text(
                chatModel.msg,
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: roundedCorner,
                      topLeft: Radius.circular(2),
                      bottomRight: roundedCorner,
                      bottomLeft: roundedCorner)),
            ),
            SizedBox(
              width: 6,
            ),
            Text('${dateFormat}')
          ],
        )
      ],
    );
  }

  Row _buildMyMsg(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('${dateFormat}', style: TextStyle(fontSize: 7, color: Colors.grey),),
        SizedBox(
          width: 6,
        ),
        Row(
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: 50,
                maxWidth: size.width * 0.5,
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text(
                chatModel.msg,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(2),
                      topLeft: roundedCorner,
                      bottomRight: roundedCorner,
                      bottomLeft: roundedCorner)),
            ),
            SizedBox(
              width: 6,
            ),

          ],
        )
      ],
    );
  }
}
