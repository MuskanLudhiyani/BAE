import 'dart:io';


import 'api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minor/tts.dart';

class TextRecognitionWidget extends StatefulWidget {
  const TextRecognitionWidget({
    Key key,
  }) : super(key: key);

  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  String _text = '';
  File image;
  bool _loading = false;

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          appBar: AppBar(
            title: const Text(
              'Text Recognition',
              style: TextStyle(
                fontFamily: 'nerko',
                fontSize: 30,
                color: Colors.red,
              ),
            ),
            backgroundColor: Colors.black,
          ),
          body:_loading
              ? Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
              : Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image == null ? Expanded(
                    child: GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Click anywhere to open the Camera',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'nerko'
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ): GestureDetector(
                    onTap: ()=> Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false),
                    child: Column(
                      children: [
                        Image.file(image),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            _text,
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'nerko',
                              fontSize: 30,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
            ),
          ),
      );


  Future pickImage() async {
    final file = await ImagePicker().getImage(source: ImageSource.camera);
    setImage(File(file.path));
    scanText();
  }

  Future scanText() async {
    final text = await FirebaseMLApi.recogniseText(image);
    setState (() {
      _text = text;
      _loading = false;
    });
    if (_text!=null)
    {
      speak(_text+"Click anywhere to start again.");
      print(_text);
    }
  }


  void setImage(File newImage) {
    setState(() {
      image = newImage;
    });
  }
}