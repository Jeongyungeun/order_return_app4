import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:order_return_app4/constant/widget_design.dart';
import 'package:order_return_app4/model/contact_model.dart';
import 'package:order_return_app4/repository/business_card_service.dart';
import 'package:order_return_app4/staus/user_notifier.dart';
import 'package:provider/src/provider.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({Key? key}) : super(key: key);

  @override
  _ContactCardState createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  bool isCreatedBusinessCard = false;
  final _formKey = GlobalKey<FormState>();
  String companyName = '';
  String name = '';
  String phoneNumber = '';
  PhoneContact? _phoneContact;
  TextEditingController? _textEditingController1;
  TextEditingController? _textEditingController2;
  String? fromContactPhoneNumber;
  String? fromContactName;

   @override
  void initState() {
     _textEditingController1 = TextEditingController();
     _textEditingController2 = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size _size = MediaQuery.of(context).size;
        return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[100],
          title: Text('연 락 처 등 록'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context,true);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20,),
                      child: Card(
                        color: Colors.grey[200],
                        elevation: 3,
                        clipBehavior: Clip.antiAlias,
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: common_padding * 2),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _textEditingController1,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: '회사명'),
                                    onSaved: (newValue) {

                                      setState(() {
                                        companyName = newValue as String;
                                      });
                                    },
                                    validator: (value) {
                                      if (value != null && value.length > 1) {
                                        return null;
                                      } else {
                                        return '회사명 확인 부탁드립니다.';
                                      }
                                    }),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: '담당자 이름'),
                                  onSaved: (newValue) {
                                    name = newValue as String;
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _textEditingController2,
                                    inputFormatters: [
                                      MaskedInputFormatter('000-0000-0000')
                                    ],
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: '휴대폰 번호',
                                    ),
                                    onSaved: (newValue) {
                                      phoneNumber = (newValue as String)
                                          .replaceAll('-', '')
                                          .replaceFirst('0', '+82');
                                    },
                                    validator: (value) {
                                      if (value != null && value.length == 13) {
                                        return null;
                                      } else {
                                        return '전화번호 확인 부탁드립니다.';
                                      }
                                    }),
                                SizedBox(
                                  height: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                              contactSubmitted();
                                          },
                                        child: Text(
                                          '연락처 저장하기',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: common_padding),
                      child: TextButton(
                        style: Theme.of(context).textButtonTheme.style,
                        onPressed: () async {
                          final PhoneContact contact =
                          await FlutterContactPicker.pickPhoneContact();
                          setState(() {
                            extractingFromContact(contact);
                            });
                        },
                        child: Text(
                          '연락처 가져오기',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ); },
    );
  }


  void extractingFromContact(PhoneContact contact) {

    _phoneContact = contact;
    var x =
        _phoneContact!.phoneNumber!.number;
    fromContactPhoneNumber = x!.substring(0, 3) + '-' + x.substring(3, 7)+ '-' + x.substring(7, x.length);
    fromContactName = _phoneContact!.fullName;
    _textEditingController1 = TextEditingController(text: fromContactName);
    _textEditingController2 = TextEditingController(text: fromContactPhoneNumber);

  }

  contactSubmitted() {
    if (_formKey.currentState != null) {
      bool passed = _formKey.currentState!.validate();
      _formKey.currentState!.save();
      if (passed) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('저장이 완료되었습니다.'))

        );
        contactToFirebase();
        //firebase 구현
      }
    }
  }

  void contactToFirebase() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    isCreatedBusinessCard = true;
    setState(() {});
    final String userKey = FirebaseAuth.instance.currentUser!.uid;
    final String cardKey = ContactModel.generateContactKey(userKey);

    UserNotifier userNotifier = context.read<UserNotifier>();
    if (userNotifier.userModel == null) return;

    ContactModel contactModel = ContactModel(
      cardKey: cardKey,
      userKey: userKey,
      name: name,
      company: companyName,
      phoneNum: phoneNumber,
      createdDate: DateTime.now().toUtc(),
    );
    await BusinessCardService().createNewCard(contactModel, cardKey, userKey);
  }
}
