import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerFunctionalities {
  ImagePickerFunctionalities();

  final picker = ImagePicker();
  File? image;
  //Image Picker function to get image from gallery

  Future<File?> getImage(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    return image;
  }

  Future<List<File>> getImages(ImageSource imageSource) async {
    List<File> result = [];
    if (imageSource == ImageSource.camera) {
      final pickedFile = await picker.pickImage(source: imageSource);

      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
      if (image != null) result.add(image!);
    } else {
      final pickedFiles = await picker.pickMultiImage();

      for (var element in pickedFiles) {
        // s
        result.add(File(element.path));
      }
    }

    return result;
  }

  Future<File?> getVideo(ImageSource imageSource) async {
    final pickedFile = await picker.pickVideo(source: imageSource);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    return image;
  }

  //Show options to get image from camera or gallery
  static Future<ImageSource?> showOptions(BuildContext context) async {
    return await showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () async {
              // close the options modal
              Navigator.of(context).pop(ImageSource.gallery);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () async {
              // get image from camera
              // close the options modal
              Navigator.of(context).pop(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }
}
