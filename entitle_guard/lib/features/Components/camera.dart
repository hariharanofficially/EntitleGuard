import 'dart:io';

import 'package:camera/camera.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Bill_form/Result/Result.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/Models/apimodels.dart';

// void main() {
//   runApp(const App());
// }

class Camera extends StatelessWidget {
  final Bill bill;
  const Camera({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MainScreen(
        bill: bill,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final Bill bill;
  const MainScreen({super.key, required this.bill});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;

  late final Future<void> _future;
  CameraController? _cameraController;

  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);

                    return Center(child: CameraPreview(_cameraController!));
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              backgroundColor: _isPermissionGranted ? Colors.transparent : null,
              body: _isPermissionGranted
                  ? Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: _scanImage,
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Makes the button width only as wide as the contents
                                children: const [
                                  Icon(Icons
                                      .search), // Replace with your desired icon
                                  SizedBox(
                                      width:
                                          8.0), // Space between the icon and text
                                  Text('Scan text'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Allow Camera',
                      textAlign: TextAlign.center,
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await _cameraController!.takePicture();

      // Display the captured picture
      await navigator.push(
        MaterialPageRoute(
          builder: (BuildContext context) => Result(
            imagePath: pictureFile.path,
            bill: widget.bill,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }

  // Future<void> _scanImage() async {
  //   if (_cameraController == null) return;

  //   final navigator = Navigator.of(context);

  //   try {
  //     final pictureFile = await _cameraController!.takePicture();

  //     final file = File(pictureFile.path);

  //     final inputImage = InputImage.fromFile(file);
  //     final recognizedText = await textRecognizer.processImage(inputImage);

  //     await navigator.push(
  //       MaterialPageRoute(
  //         builder: (BuildContext context) => Result(text: recognizedText.text),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('An error occurred when scanning text'),
  //       ),
  //     );
  //   }
  // }
}

// class ResultScreen extends StatelessWidget {
//   final String text;

//   const ResultScreen({super.key, required this.text});

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: const Text('Result'),
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.all(30.0),
//             child: Text(text),
//           ),
//         ),
//       );
// }
