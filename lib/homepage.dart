import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController controller;
  CameraImage imgCamera;
  bool isWorking = false;
  String result = "";

  @override
  void initState() {
    super.initState();

    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        controller.startImageStream((imageStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  imgCamera = imageStream,
                  runModelonFrame(),
                }
            });
      });
    });

    loadModel();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  runModelonFrame() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera.planes.map((e) {
          return e.bytes;
        }).toList(),
        imageHeight: imgCamera.height,
        imageWidth: imgCamera.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );
      result = "";

      recognitions.forEach((response) {
        result += response["labels"] + "\n";
      });

      setState(() {
        result;
      });

      isWorking = false;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Center(
            child: Text(
              result,
              textAlign: TextAlign.center,
              style: TextStyle(
                backgroundColor: Colors.black54,
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height - 100,
            child: Container(
              height: size.height - 100,
              child: (!controller.value.isInitialized)
                  ? Container()
                  : AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: CameraPreview(controller),
                    ),
            ),
          ),
        ],
      ),
    ));
  }
}
