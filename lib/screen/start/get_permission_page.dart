import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_return_app4/logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/src/provider.dart';

class GetPermissionPage extends StatefulWidget {
  const GetPermissionPage({Key? key}) : super(key: key);

  @override
  State<GetPermissionPage> createState() => _GetPermissionPageState();
}

class _GetPermissionPageState extends State<GetPermissionPage> {
  bool _location = false;
  bool _camera = false;
  bool _contacts = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 1.0),
                child: Text(
                  '약국 업무 관리',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: constraints.maxWidth * 0.45,
              ), // 이미지나 사진을 넣을 자리
              Text(
                '좀더 스마트한 약국을 위해...\n',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                '좀더 개선된 서비스를 위해\n 위치, 카메라 사용 허가를 원합니다.',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      child: Text('앱 설정 바로가기'),
                      style: TextButton.styleFrom(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: AppSettings.openAppSettings,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    FutureBuilder<Map<Permission, PermissionStatus>>(
                        future: callPermissions(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return TextButton(
                              child: Text('회원가입'),
                              style: TextButton.styleFrom(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () async {
                                (await Permission.locationWhenInUse.status.isGranted ==true &&
                                        await Permission.contacts.status.isGranted==true &&
                                        await Permission.camera.status.isGranted == true)
                                    ? context
                                        .read<PageController>()
                                        .animateToPage(2,
                                            duration: Duration(milliseconds: 500),
                                            curve:
                                                Curves.fastLinearToSlowEaseIn)
                                    : ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                        SnackBar(
                                          content: Text('권한설정을 확인해 주세요^^'),
                                        ),
                                      );
                              },
                            );
                          } else {
                            return Container(
                              height: 30,
                              width: 30,
                              color: Colors.transparent,
                            );
                          }
                        }),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<Map<Permission, PermissionStatus>> callPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationWhenInUse,
      Permission.camera,
      Permission.contacts,
    ].request();

    getPermission(statuses);
    return statuses;
  }

  void getPermission(Map<Permission, PermissionStatus> statuses) {
    _location = statuses[Permission.locationWhenInUse]?.isGranted ?? false;
    _camera = statuses[Permission.camera]?.isGranted ?? false;
    _contacts = statuses[Permission.contacts]?.isGranted ?? false;
  }

}
