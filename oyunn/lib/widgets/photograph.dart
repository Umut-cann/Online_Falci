

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Photograph extends StatefulWidget {
  final Function(File?) onPhotoSelected;

  Photograph({required this.onPhotoSelected});

  @override
  _PhotographState createState() => _PhotographState();
}

class _PhotographState extends State<Photograph> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        _getImageFromGallery();
      },
      child: Container(
        height: MediaQuery.of(context).size.width * 0.22,
        width: MediaQuery.of(context).size.width * 0.22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _selectedImage == null ? Colors.blueGrey : null,
        ),
        child: _selectedImage != null
            ? Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.no_photography),
      ),
    );
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

   
      widget.onPhotoSelected(_selectedImage);
    }
  }
}
