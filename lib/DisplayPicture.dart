// A widget that displays the picture taken by the user.
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:color_thief_flutter/utils.dart';
import 'package:path/path.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:convert';

import 'package:flutter/painting.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //teste

    String _resultado = "vazio";
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagem capturada'),
        backgroundColor: Colors.deepOrange,
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: <Widget>[
          Container(
            child: Image.file(File(imagePath)),
          ),
          Container(
            child: Row(
              children: <Widget>[
                RaisedButton(
                  color: Colors.orange,
                  onPressed: cortarImagem,
                  child: Text("Cortar"),
                ),
                RaisedButton(
                  color: Colors.orange,
                  onPressed: analisarImgem,
                  child: Text("Analisar"),
                ),
                //Text(_resultado)
              ],
            ),
          )
        ],
      ),
    );
  }

  analisarImgem() {
    load();
  }

  Future<ui.Image> load() async {
    ByteData data = await rootBundle.load(imagePath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    getColorFromImage(fi.image).then((color) {
      print(color); // [R,G,B]
    });
  }

  cortarImagem() async {
    return await ImageCropper.cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Ajustar imagem',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
  }
}
