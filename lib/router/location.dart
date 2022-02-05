import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:order_return_app4/screen/common/chat/chat_room_screen.dart';
import 'package:order_return_app4/screen/compony_pharm/home_screen_com.dart';
import 'package:order_return_app4/screen/common/contact_card.dart';
import 'package:order_return_app4/screen/common/home_screen.dart';
import 'package:order_return_app4/screen/pharmacist/home_screen_pharm.dart';
import 'package:order_return_app4/screen/pharmacist/pages/pharmacy_home_page.dart';
import 'package:order_return_app4/screen/start/sign_in_page.dart';

const LOCATION_PHARM = 'home_pharm';
const LOCATION_COMP = 'home_comp';
const LOCATION_HOME = 'home';
const LOCATION_CONTACT_PHARM = 'contact_input';
const LOCATION_CHATROOM_ID = 'chatroom_id';

class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: HomeScreen(),
        key: ValueKey(LOCATION_HOME),
      ),
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/'];
}

class ChatroomForPharmLocation extends BeamLocation<BeamState>{
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
          child: ChatRoomScreen(chatroomKey: state.pathParameters[LOCATION_CHATROOM_ID]?? "",),
        key: ValueKey(LOCATION_CHATROOM_ID)
      )
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/$LOCATION_PHARM/:$LOCATION_CHATROOM_ID'];

}

