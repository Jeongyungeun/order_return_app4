import 'package:beamer/src/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:order_return_app4/constant/widget_design.dart';
import 'package:order_return_app4/model/chat_room_model.dart';
import 'package:order_return_app4/model/contact_model.dart';
import 'package:order_return_app4/repository/business_card_service.dart';
import 'package:order_return_app4/repository/chat_service.dart';
import 'package:order_return_app4/router/location.dart';
import 'package:order_return_app4/screen/common/camera_picker_custom.dart';
import 'package:order_return_app4/screen/common/contact_card.dart';
import '../../../widget/costum_expandable_fab.dart';
import 'C:\/Users/yungeun/Desktop/order_return_init/lib/widget/costum_expandable_fab.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../logger/logger.dart';

class PharmacyHomePage extends StatefulWidget {
  final String userKey;

  PharmacyHomePage({Key? key, required this.userKey}) : super(key: key);

  @override
  State<PharmacyHomePage> createState() => _PharmacyHomePageState();
}

class _PharmacyHomePageState extends State<PharmacyHomePage> {
  Size? _size;
  final List<ContactModel> _list = [];
  int? back;
  String? _getOppositNum;
  String? getOppositKey;

  bool init = false;

  @override
  void initState() {
    if (!init) {
      onRefresh();
      init = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _size = MediaQuery.of(context).size;
        return SafeArea(
          child: _buildHomePage(context),
        );
      },
    );
  }

  //todo shimmer
  // Widget _shimmerListView(BuildContext context){
  //   return Shimmer.fromColors(
  //     highlightColor: Colors.grey[100]!,
  //   baseColor: Colors.grey[300]!,
  //   enabled: true,
  //   child: ListView.separated(
  //     itemBuilder: (context, index){
  //
  //     },
  //     separatorBuilder: (_,__){
  //       return Divider(
  //
  //       )
  //     },
  //     itemCount: ,),
  //
  //   )
  // }

  //todo ????????? ?????????

  Scaffold _buildHomePage(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: CustomScrollView(
            slivers: [
              _appBarText(),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    common_padding, common_padding, common_padding, 50),
                sliver: SliverFixedExtentList(
                  itemExtent: 100,
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return SizedBox(
                        height: 300,
                        child: _buildCardAtHome(index),
                      );
                    },
                    childCount: _list.length,
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: ExpandableFab2(
          distance: 100,
          children: [
            ActionButton(
                onPressed: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ContactCard()))
                      .then((value) {
                    if (value) {
                      onRefresh();
                    }
                  });
                },
                icon: const Icon(Icons.add)),
            ActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ContactFromCam()));
                },
                icon: const Icon(Icons.camera_alt_outlined)),
          ],
        ));
  }

  Widget _buildCardAtHome(int index) {
    ContactModel contactModel = _list[index];
    String phone = contactModel.phoneNum.replaceFirst('+82', '0');
    String hypenPhone = phone.substring(0, 3) +
        '-' +
        phone.substring(3, 7) +
        '-' +
        phone.substring(7, phone.length);
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: EdgeInsets.all(common_sm_padding),
      child: InkWell(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: _size!.width / 7,
              width: _size!.width / 5,
              child: CircleAvatar(
                child: (contactModel.contactImageUrl == "")
                    ? ExtendedImage.network(
                        contactModel.contactImageUrl![0],
                        fit: BoxFit.fill,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      )
                    : Text('${contactModel.company.substring(0, 2)}'),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      contactModel.company != null
                          ? '${contactModel.company}'
                          : '',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      contactModel.name != null ? '${contactModel.name}' : '',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(
                  height: common_sm_padding,
                ),
                Text('${hypenPhone}'),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      makePhoneCall('tel://${phone}');
                    },
                    icon: Icon(Icons.phone)),
                IconButton(
                    onPressed: () async{
                      await ChatService()
                          .getUserInfo(contactModel.phoneNum)
                          .then((userModel) {
                        _getOppositNum = userModel[0].phoneNumber;
                        getOppositKey = userModel[0].userKey;
                      });
                      _getOppositNum == contactModel.phoneNum
                          ? _goToChatroom(contactModel)
                          : logger.e('???????????? ???????????? ????????????.');
                    },
                    icon: Icon(Icons.chat_bubble_outline_rounded)),
              ],
            )
          ],
        ),
      ),
    );
  }

//
  //
  SliverAppBar _appBarText() {
    return SliverAppBar(
      pinned: false,
      expandedHeight: _size!.width / 2,
      flexibleSpace: const Center(
          child: Text(
        '???????????? ??????????????????',
      )),
      centerTitle: true,
      backgroundColor: Colors.amber,
    );
  }

  Future onRefresh() async {
    _list.clear();
    _list.addAll(await BusinessCardService().getContact(widget.userKey));
    setState(() {});
  }

  //DialLog??? ???????????? ?????????
  void makePhoneCall(String phoneNum) async {
    if (await canLaunch(phoneNum)) {
      await launch(phoneNum);
      print('???????????? ??????');
    } else {
      print('???????????? ??????');
    }
  }

  void _goToChatroom(ContactModel contactModel) async {
    String chatroomKey = ChatroomModel.generateChatroomKey(
        contactModel.userKey, contactModel.cardKey);
    //???????????? ':'??? ?????????.
    String fixchatroomKey = chatroomKey.replaceFirst(':', '');

    ChatroomModel _chatroomModel = ChatroomModel(
        userKey: contactModel.userKey,
        yourKey: contactModel.cardKey,
        chatroomKey: chatroomKey,
        lstMsgTime: DateTime.now());

    await ChatService().createNewChatroom(_chatroomModel);

    context.beamToNamed('/$LOCATION_PHARM/:$fixchatroomKey');
  }

  Future<bool> isExistedUser(String phone) async {
    ChatService().getUserInfo(phone).then((userModel) {
      _getOppositNum = userModel[0].phoneNumber;
      getOppositKey = userModel[0].userKey;
    });
    return _getOppositNum == phone;
  }
}
