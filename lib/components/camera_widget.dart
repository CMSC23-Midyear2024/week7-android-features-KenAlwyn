import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  // camera permission is denied by default
  Permission permission = Permission.camera;
  PermissionStatus permissionStatus = PermissionStatus.denied;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await permission.status;
    setState(() => permissionStatus = status);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () async {
                  if (permissionStatus == PermissionStatus.granted) {
                    final image = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
        
                    setState(() {
                      imageFile = image == null ? null : File(image.path);
                    });
                  } else {
                    requestPermission();
                  }
                },
                icon: const Icon(Icons.linked_camera_rounded, size: 50,)),
            imageFile == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(30),
                    child: ClipOval(
                      child: Image.file(
                        width: 100,
                        height: 100,
                        imageFile!, 
                        fit: BoxFit.cover
                      ),
                    ),
                  )
          ],
        );
  }

  Future<void> requestPermission() async {
    final status = await permission.request();

    setState(() {
      permissionStatus = status;
    });
  }
}
