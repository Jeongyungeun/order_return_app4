import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:order_return_app4/screen/compony_pharm/home_screen_com.dart';
import 'package:order_return_app4/screen/common/contact_card.dart';
import 'package:order_return_app4/screen/common/home_screen.dart';
import 'package:order_return_app4/screen/pharmacist/home_screen_pharm.dart';
import 'package:order_return_app4/screen/start/sign_in_page.dart';

const LOCATION_PHARM = 'home_pharm';
const LOCATION_COMP = 'home_comp';
const LOCATION_HOME = 'home';
const LOCATION_CONTACT_PHARM = 'contact_input';

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


class HomeScreenToContactPharm extends BeamLocation<BeamState>{
  @override
  Widget builder(BuildContext context, Widget navigator) {

    return super.builder(context, navigator);
  }
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [

      if(state.pathPatternSegments.contains(LOCATION_PHARM))
        BeamPage(child: HomeScreenPharm(), key: ValueKey(LOCATION_PHARM)),

      if(state.pathPatternSegments.contains(LOCATION_CONTACT_PHARM))
        BeamPage(child: ContactCard(), key: ValueKey(LOCATION_CONTACT_PHARM)),

    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/$LOCATION_PHARM','/$LOCATION_PHARM/$LOCATION_CONTACT_PHARM'];

}


class HomeLocationComp extends BeamLocation<BeamState>{
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: HomeScreenCompany(),
        key: ValueKey(LOCATION_COMP),
      ),
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/$LOCATION_COMP'];

}