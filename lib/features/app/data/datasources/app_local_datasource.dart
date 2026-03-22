import 'dart:convert';

import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/features/post/data/models/post_model.dart';

abstract class AppLocalDatasource {
  Future<List<PostModel>?> getPreviouslyStoredPostModelList();
  Future setPreviouslyStoredPostModelList(List<PostModel> theListToBeStored);
}

class AppLocalDatasourceImpl implements AppLocalDatasource {
  AppLocalDatasourceImpl({required this.appPreferenceService});
  final AppPreferenceService appPreferenceService;

  @override
  Future<List<PostModel>?> getPreviouslyStoredPostModelList() async {
    final listOfStoredPostModel =
        appPreferenceService.getValue<String>("storedListOfPostModel");
    if (listOfStoredPostModel == null) return null;
    return (jsonDecode(listOfStoredPostModel) as List)
        .map(
          (e) => PostModel.fromJson(e),
        )
        .toList();
    // UserModel.fromJson();
  }

  @override
  Future setPreviouslyStoredPostModelList(
      List<PostModel> theListToBeStored) async {
    String thevalueToBeSaved = jsonEncode(theListToBeStored);
    await appPreferenceService.saveValue<String>(
        "storedListOfPostModel", thevalueToBeSaved);

    // UserModel.fromJson();
  }
}
