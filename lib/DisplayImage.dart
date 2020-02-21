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

class DisplayImage extends StatefulWidget {
  String imagePath;
  Color cor;

  DisplayImage({Key key, this.imagePath}) : super(key: key);

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  @override
  Color cor = Colors.white;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagem capturada'),
        backgroundColor: Colors.deepOrange,
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      bottomSheet: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton.extended(
              onPressed: cortarImagem,
              label: Text('Cortar'),
              icon: Icon(Icons.content_cut),
              backgroundColor: Colors.pink,
              heroTag: null,
            ),
            Padding(
              padding: EdgeInsets.only(right: 3),
            ),
            FloatingActionButton.extended(
              onPressed: analisarImgem,
              label: Text('Analisar'),
              icon: Icon(Icons.done),
              backgroundColor: Colors.pink,
              heroTag: null,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            height: 400,
            width: 400,
            child: Image.file(File(widget.imagePath)),
          ),
          Container(
            child: Row(
              children: <Widget>[
//                RaisedButton(
//                  color: Colors.orange,
//                  onPressed: cortarImagem,
//                  child: Text("Cortar"),
//                ),
//                RaisedButton(
//                  color: Colors.orange,
//                  onPressed: analisarImgem,
//                  child: Text("Analisar"),
//                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Cor predominante da imagem: ")
                  ,
                ),
                Container(
                  padding: EdgeInsets.all(30),
                  color: cor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  analisarImgem() {
    load();
  }

  Future<ui.Image> load() async {
    ByteData data = await rootBundle.load(widget.imagePath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    getColorFromImage(fi.image).then((color) {
      print(color); // [R,G,B]
      setState(() {
        cor = Color.fromRGBO(color[0], color[1], color[2], 1);
      });
    });
  }

  cortarImagem() async {
    return await ImageCropper.cropImage(
        sourcePath: widget.imagePath,
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
