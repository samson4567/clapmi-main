import 'dart:io';

import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/core/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';

abstract class BragLocalDatasource {
  Future<File?> selectImage({required ImageSource imageSource});
}

class BragLocalDatasourceImpl implements BragLocalDatasource {
  BragLocalDatasourceImpl({required this.appPreferenceService});
  final AppPreferenceService appPreferenceService;

  @override
  Future<File?> selectImage({required ImageSource imageSource}) async {
    ImagePickerFunctionalities imagePickerFunctionalities =
        ImagePickerFunctionalities();

    final result = await imagePickerFunctionalities.getVideo(imageSource);
    return result;
  }
}
