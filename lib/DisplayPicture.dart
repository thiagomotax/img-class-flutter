// A widget that displays the picture taken by the user.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:color_thief_flutter/utils.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Imagem capturada')),
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
              ],
            ),
          )
        ],
      ),
    );
  }

  analisarImgem(){
    final imageProvider = Image(image: FileImage(File(imagePath)));


    getPaletteFromUrl('https://colorate.azurewebsites.net/SwatchColor/000000').then((palette) {
      print(palette); // [[R,G,B]]
    });


  }
  cortarImagem() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
  }
}
