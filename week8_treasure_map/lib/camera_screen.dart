import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'picture_screen.dart';
import 'place.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen(this.place, {Key? key}) : super(key: key);
  final Place place;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late CameraDescription camera;
  late Widget cameraPreview;
  late Image image;

  bool initialized = false;

  Future setCamera() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) camera = cameras.first;
  }

  @override
  void initState() {
    setCamera().then((_) {
      cameraController = CameraController(camera, ResolutionPreset.medium);
      cameraController.setFlashMode(FlashMode.off);
      cameraController.initialize().then((snapshot) {
        setState(() {
          cameraPreview = Center(child: CameraPreview(cameraController));
          initialized = true;
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a picture'),
      ),
      body: initialized
          ? Container(
              child: cameraPreview,
            )
          : Container(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera),
        onPressed: () async {
          XFile file = await cameraController.takePicture();
          String path = file.path;
          MaterialPageRoute route = MaterialPageRoute(
              builder: (_) => PictureScreen(path, widget.place));
          Navigator.push(context, route);
        },
      ),
    );
  }
}
