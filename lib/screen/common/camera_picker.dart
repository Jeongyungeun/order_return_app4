import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ContactFromCamera extends StatefulWidget {
  ContactFromCamera({Key? key}) : super(key: key);
  @override
  _ContactFromCameraState createState() => _ContactFromCameraState();
}

class _ContactFromCameraState extends State<ContactFromCamera> {
  CameraController? _cameraController;
  Future<void>? _initCameraControllerFuture;
  int cameraIndex = 0;

  bool isCapture = false;
  File? captureImage;
  File? _cropped;
  XFile? _xfileBeforeCrop;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _cameraController =
        CameraController(cameras[cameraIndex], ResolutionPreset.high);
    _initCameraControllerFuture = _cameraController!.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("명함촬영"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: isCapture
          ? Column(
              children: [
                /// 촬영 된 이미지 출력
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Container(
                    width: size.width,
                    height: size.width,
                    child: ClipRect(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: SizedBox(
                          width: size.width,
                          child: AspectRatio(
                            aspectRatio:
                                1 / _cameraController!.value.aspectRatio,
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
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: InkWell(
                    onTap: () {
                      /// 재촬영 선택시 카메라 삭제 및 상태 변경
                      captureImage!.delete();
                      _cropped!.delete();
                      captureImage = null;
                      _cropped = null;
                      setState(() {
                        isCapture = false;
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
            )
          : Column(
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: FutureBuilder<void>(
                    future: _initCameraControllerFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                                            _cameraController!
                                                .value.aspectRatio,
                                        child:
                                            CameraPreview(_cameraController!)),
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
                              await _cameraController!
                                  .takePicture()
                                  .then((value) {
                                _xfileBeforeCrop = value;
                                captureImage = File(value.path);
                              });
                              /// 화면 상태 변경 및 이미지 저장
                              setState(() {
                              isCapture = true;
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
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: IconButton(
                        //     onPressed: () async {
                        //       /// 후면 카메라 <-> 전면 카메라 변경
                        //       cameraIndex = cameraIndex == 0 ? 1 : 0;
                        //       await _initCamera();
                        //     },
                        //     icon: Icon(
                        //       Icons.flip_camera_android,
                        //       color: Colors.white,
                        //       size: 34.0,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

}
