import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageUploader extends StatefulWidget {
  final File file;

  const ImageUploader({Key key, this.file}) : super(key: key);
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
      bucket: 'gs://goaltracker-dc635.appspot.com/');

  UploadTask _uploadTask;

  void _startUpload() {
    String filePath = 'images/${DateTime.now()}.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
          stream: _uploadTask.snapshotEvents,
          builder:
              (BuildContext context, AsyncSnapshot<TaskSnapshot> snapshot) {
            if (snapshot.hasData) {
              TaskState state = snapshot.data.state;
              if (state == TaskState.success) {
                return FlatButton.icon(
                  onPressed: () {},
                  label: Text('COMPLETED'),
                  icon: Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
                );
              } else if (state == TaskState.error) {
                return Center(
                  child: Text('AN ERROR OCCURED'),
                );
              } else if (state == TaskState.running)
                return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: CircularProgressIndicator());
            }
          });
    } else {
      return FlatButton.icon(
        onPressed: _startUpload,
        label: Text('UPLOAD NEW IMAGE'),
        icon: Icon(Icons.cloud_circle_sharp),
      );
    }
  }
}
