import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:order_return_app4/constant/shared_pref_keys.dart';
import 'package:order_return_app4/logger/logger.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:order_return_app4/repository/user_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  List<bool> _isSelected = List.generate(2, (index) => false);


  TextEditingController _phoneNumController = TextEditingController();

  TextEditingController _codeNum = TextEditingController();

  VerificationsStatus _verificationsStatus = VerificationsStatus.none;

  GlobalKey<FormState> _formKey = GlobalKey();

  Position? _myposition;

  String? _verificationId;

  int? _forecResendingToken;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _sizeWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        centerTitle: true,
        backgroundColor: Colors.grey[300],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: IgnorePointer(
            ignoring: _verificationsStatus == VerificationsStatus.verify,
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '직군을 선택해주세요',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ToggleButtons(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                          borderWidth: 5,
                          children: [
                            Container(
                              child: Text(
                                '약사',
                                style: TextStyle(fontSize: 17),
                              ),
                              height: _sizeWidth / 5,
                              width: _sizeWidth / 4,
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              alignment: Alignment.center,
                            ),
                            Container(
                              child: Text(
                                '제약사',
                                style: TextStyle(fontSize: 17),
                              ),
                              height: _sizeWidth / 5,
                              width: _sizeWidth / 4,
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              alignment: Alignment.center,
                            ),
                          ],
                          isSelected: _isSelected,
                          onPressed: (index) {
                            setState(() {
                              for (int indexBtn = 0;
                                  indexBtn < _isSelected.length;
                                  indexBtn++) {
                                if (indexBtn == index) {
                                  _isSelected[indexBtn] =
                                      !_isSelected[indexBtn];
                                } else {
                                  _isSelected[indexBtn] = false;
                                }
                              }
                            });
                          }),
                      SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          enabled:
                              (_isSelected[0] != _isSelected[1]) ? true : false,
                          controller: _phoneNumController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            MaskedInputFormatter('000-0000-0000')
                          ],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              left: 24,
                            ),
                            labelText: '전화번호',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (phoneNumber) {
                            if (phoneNumber != null &&
                                phoneNumber.length == 13) {
                              return null;
                            } else {
                              //error
                              return '전화번호를 다시 확인해주세요!';
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(_sizeWidth - 16, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () async {

                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState != null) {
                            bool passed = _formKey.currentState!.validate();

                            if (passed) {
                              String phoneNum = _phoneNumController.text
                                ..replaceAll('-', 'replace')
                                ..replaceFirst('0', '');

                              setState(() {
                                _verificationsStatus =
                                    VerificationsStatus.codeSending;
                              });
                              FirebaseAuth auth = FirebaseAuth.instance;
                              await auth.verifyPhoneNumber(
                                phoneNumber: '+82$phoneNum',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) async {
                                  await auth.signInWithCredential(credential);
                                },
                                codeSent: (String verificationId,
                                    int? forceResendingToken) async {
                                  setState(() {
                                    _verificationsStatus =
                                        VerificationsStatus.codeSent;
                                  });
                                  _verificationId = verificationId;
                                  _forecResendingToken = forceResendingToken;
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                                verificationFailed:
                                    (FirebaseAuthException error) {
                                  logger.e(error.message);
                                  setState(() {
                                    _verificationsStatus =
                                        VerificationsStatus.none;
                                  });
                                },
                              );
                            }
                          }
                        },
                        child: (_verificationsStatus ==
                                VerificationsStatus.codeSending)
                            ? SizedBox(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                height: 30,
                              )
                            : Text(
                                '인증 코드 발송',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AnimatedOpacity(
                        curve: Curves.easeInOut,
                        opacity:
                            (_verificationsStatus == VerificationsStatus.none)
                                ? 0
                                : 1,
                        duration: Duration(
                          milliseconds: 300,
                        ),
                        child: AnimatedContainer(
                          duration: Duration(
                            milliseconds: 300,
                          ),
                          curve: Curves.easeInOut,
                          height: getVerificationHeight(_verificationsStatus),
                          child: TextFormField(
                            controller: _codeNum,
                            keyboardType: TextInputType.number,
                            inputFormatters: [MaskedInputFormatter('000000')],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                left: 24,
                              ),
                              labelText: '코드',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            validator: (code) {
                              if (code != null && code.length == 6) {
                                return null;
                              } else {
                                //error
                                return '코드를 확인해주세요!';
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height:
                            getVerificationButtonHeight(_verificationsStatus),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(_sizeWidth - 16, 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            attemptVerify();
                            // test(인증이 되어야 사용가능)
                            // UserService().firestoreTest();
                            //
                          },
                          child: (_verificationsStatus ==
                                  VerificationsStatus.verify)
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  '코드 인증',
                                  style: TextStyle(fontSize: 15),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double getVerificationHeight(VerificationsStatus status) {
    switch (status) {
      case VerificationsStatus.none:
        return 0;
      case VerificationsStatus.codeSending:
      case VerificationsStatus.codeSent:
      case VerificationsStatus.verify:
      case VerificationsStatus.verificationDone:
        return 56;
    }
  }

  double getVerificationButtonHeight(VerificationsStatus status) {
    switch (status) {
      case VerificationsStatus.none:
        return 0;
      case VerificationsStatus.codeSending:
      case VerificationsStatus.codeSent:
      case VerificationsStatus.verify:
      case VerificationsStatus.verificationDone:
        return 40;
    }
  }

  void attemptVerify() async {
    setState(() {
      _verificationsStatus = VerificationsStatus.verify;
    });
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: _codeNum.text);

      // Sign the user in (or link) with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      logger.e('verification failed!!');
      //error 시 스낵바 보여줌.
      SnackBar snackBar = SnackBar(
        content: Text(
          '입력하신 코드를 다시한번 확인해주세요.',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }


    setState(() {
       setUserInfo(_isSelected[0]);
      _verificationsStatus = VerificationsStatus.verificationDone;
    });
  }

  void setUserInfo(bool bePharmacist) async{
    try {
      Position position = await _getUserLocation();
      _getUserInfoThroughPrefs(bePharmacist, position.latitude, position.longitude);
    }catch(e){
      logger.e('위치정보획득에서 에러 발생');
    }
  }

  Future<Position> _getUserLocation() async {
    bool _serviceEnabled = await Permission.locationWhenInUse.status.isGranted;
    if (!_serviceEnabled) {
      return Future.error('위치정보에 접근하지 못하였습니다.');
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    }
  }

  void _getUserInfoThroughPrefs(
      bool bePharmacist, double lat, double lon) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SHARED_JOBS, bePharmacist);
    await prefs.setDouble(SHARED_LAT, lat);
    await prefs.setDouble(SHARED_LON, lon);
  }
}

enum VerificationsStatus {
  none,
  codeSending,
  codeSent,
  verify,
  verificationDone
}
