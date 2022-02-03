import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:extended_image/extended_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart';



///완성 하지 못합
//todo 이미지를 resizing 하고 업로드 하는 걸 완성하지 못함.
///



class ContactFromCam extends StatefulWidget {
  ContactFromCam({Key? key}) : super(key: key);

  @override
  _ContactFromCamState createState() => _ContactFromCamState();
}

class _ContactFromCamState extends State<ContactFromCam> {
  bool isCaptured = false;
  late CameraController _cameraController;
  Future<void>? _initCameraControllerFuture;
  File? _cropped;
  File? captureImage;
  Uint8List? imageAsBytes;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    _initCameraControllerFuture = _cameraController.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('명함촬영'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: !isCaptured
          ? Column(
              ///촬영 할때
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: FutureBuilder(
                    future: _initCameraControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Stack(
                          children: [
                            SizedBox(
                              width: size.width,
                              height: size.width,
                              child: ClipRect(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: SizedBox(
                                    width: size.width,
                                    child: AspectRatio(
                                        aspectRatio: 1 /
                                            _cameraController.value.aspectRatio,
                                        child:
                                            CameraPreview(_cameraController)),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: FractionalOffset(0.1, 0.3),
                              //       0.1=offset.dx / size.width,
                              //       0.3=offset.dy / size.height,
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.black, width: 2),
                                        left: BorderSide(
                                            color: Colors.black, width: 2))),
                                width: 80.0,
                                height: 40.0,
                                padding: EdgeInsets.all(20.0),
                              ),
                            ),
                            Align(
                              alignment: FractionalOffset(0.9, 0.7),
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 2),
                                        right: BorderSide(
                                            color: Colors.black, width: 2))),
                                width: 80.0,
                                height: 40.0,
                                padding: EdgeInsets.all(20.0),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            try {
                              await _cameraController
                                  .takePicture()
                                  .then((value)  {
                                captureImage = File(value.path);
                              });

                              /// 화면 상태 변경 및 이미지 저장
                              setState(() {
                                isCaptured = true;
                                imageAsBytes = captureImage!.readAsBytesSync();

                              });
                            } catch (e) {
                              print("$e");
                            }
                          },
                          child: Container(
                            height: 80.0,
                            width: 80.0,
                            padding: const EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black, width: 1.0),
                              color: Colors.white,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.black, width: 3.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                /// 촬영 된 이미지 출력
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: FutureBuilder<int>(
                      future: Future.delayed(Duration(seconds: 1), () => 29),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return fixedImage2(size);
                        } else {
                          return Container(
                            width: size.width,
                            height: size.width,
                            child: ClipRect(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: SizedBox(
                                  width: size.width,
                                  child: AspectRatio(
                                    aspectRatio:
                                        1 / _cameraController.value.aspectRatio,
                                    child: Container(
                                      width: size.width,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: MemoryImage(
                                            captureImage!.readAsBytesSync()),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: InkWell(
                    onTap: () {
                      /// 재촬영 선택시 카메라 삭제 및 상태 변경
                      captureImage!.delete();
                      setState(() {
                        isCaptured = false;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            "다시 찍기",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget fixedImage(Size size) {
    return Container(
      width: size.width,
      height: size.width,
      child: ClipRect(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: SizedBox(
            width: size.width,
            child: AspectRatio(
              aspectRatio: 1 / _cameraController.value.aspectRatio,
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: MemoryImage(captureImage!.readAsBytesSync()),
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget fixedImage2(Size size) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: SizedBox(
            width: size.width * 0.8,
            height: size.width * 0.5,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.center,
                      image: MemoryImage(captureImage!.readAsBytesSync()) ,
                    )),
              ),
            ),
          ),
        );
      },
    );
  }

}
