import 'dart:io';

import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/core/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';

abstract class PostLocalDatasource {
  Future<List<File>> selectImage({required ImageSource imageSource});
  Future<File?> selectVideo({required ImageSource imageSource});
}

class PostLocalDatasourceImpl implements PostLocalDatasource {
  PostLocalDatasourceImpl({required this.appPreferenceService});
  final AppPreferenceService appPreferenceService;

  @override
  Future<List<File>> selectImage({required ImageSource imageSource}) async {
    ImagePickerFunctionalities imagePickerFunctionalities =
        ImagePickerFunctionalities();

    final result = await imagePickerFunctionalities.getImages(imageSource);
    return result;
  }

  @override
  Future<File?> selectVideo({required ImageSource imageSource}) async {
    ImagePickerFunctionalities imagePickerFunctionalities =
        ImagePickerFunctionalities();

    final result = await imagePickerFunctionalities.getVideo(imageSource);
    return result;
  }
}
