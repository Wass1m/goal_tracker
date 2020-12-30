import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goaltracker/shared/image_uploader.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    PickedFile selected =
        await ImagePicker().getImage(source: source, imageQuality: 70);

    setState(() {
      _imageFile = File(selected.path);
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path, compressQuality: 70);

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(
                ImageSource.camera,
              ),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(
                ImageSource.gallery,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            Row(
              children: [
                FlatButton(
                  onPressed: _cropImage,
                  child: Icon(
                    Icons.crop,
                  ),
                ),
                FlatButton(
                  onPressed: _clear,
                  child: Icon(
                    Icons.refresh,
                  ),
                ),
              ],
            ),
            ImageUploader(
              file: _imageFile,
            ),
          ]
        ],
      ),
    );
  }
}
