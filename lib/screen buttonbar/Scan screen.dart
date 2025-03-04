import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../logic/ConfirmImageDialog.dart';
import '../Widget/arrow_back.dart';
import '../fontstyle.dart';
import '../result/screenresult.dart';

class SkinScanScreen extends StatefulWidget {
  @override
  _SkinScanScreenState createState() => _SkinScanScreenState();
}

class _SkinScanScreenState extends State<SkinScanScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras![0], ResolutionPreset.high);
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
      _imageFile = null;
    });
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      final image = await _cameraController!.takePicture();
      _confirmImage(image);
    } catch (e) {
      print("Error taking photo: $e");
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _confirmImage(XFile(pickedFile.path));
    }
  }

  void _confirmImage(XFile image) {
    showDialog(
      context: context,
      builder: (context) => ConfirmImageDialog(
        image: image,
        onRecapture: () {
          setState(() {
            _imageFile = null;
          });
        },
        onConfirm: () {
          setState(() {
            _imageFile = image;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScreenResult()),
          );
        },
      ),
    );
  }


  void _goToDiagnosisScreen() {
    Navigator.pushNamed(context, '/diagnosis', arguments: _imageFile?.path);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child:
                _isCameraInitialized
                    ? CameraPreview(_cameraController!)
                    : Center(child: CircularProgressIndicator()),
          ),

          Positioned(
            top: 40,
            left: 16,
            child: CustomIconButton(
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => _initializeCamera(),
                  child: Icon(
                    Icons.restart_alt_sharp,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                GestureDetector(
                  onTap: _captureImage,
                  child: Icon(Icons.camera, color: Colors.white, size: 50),
                ),
                GestureDetector(
                  onTap: _pickImageFromGallery,
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
