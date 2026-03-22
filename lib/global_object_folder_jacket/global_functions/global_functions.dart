import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

Future initializeHandlers() async {
  int count = 0;
}

Future downloadDbs() async {}
Color getFigmaColor(String value, [int percentageOpacity = 100]) {
  return Color(int.parse("0xff$value"))
      .withAlpha((((255 * percentageOpacity) ~/ 100)));
}

convertIntToBool(int integer) {
  if (integer > 0) return true;
  return false;
}

Object? functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(
    Object? decodedData) {
  return (decodedData == null)
      ? decodedData
      : json.decode(decodedData as String);
}

String generalDateFormat(DateTime date) {
  return "${date.day}/${date.month} (${date.minute}:${date.hour})";
}

int generateLongNumber() {
  return Random().nextInt(10000000) +
      Random().nextInt(10000000) +
      Random().nextInt(10000000) +
      Random().nextInt(10000000);
}

Future<String> generateThumbnailFileandGetPathInReturn({
  required File videoFile,
  double maxHieght = 1000,
  double maxWidth = 1000,
}) async {
  return "";
}

Future<bool> waitForCondition(bool Function() condition,
    {Duration checkInterval = const Duration(milliseconds: 200),
    Duration timeout = const Duration(seconds: 30)}) async {
  bool response = true;
  bool done = false;

  if (!condition()) {
    await Future.delayed(
      checkInterval,
      () {
        response = false;
        done = true;
      },
    );
    await waitForCondition(condition,
        checkInterval: checkInterval, timeout: timeout);
  }

  return response;
}

// determineW

Future<String> downloadURL(
    String url, Function(double level) progressUpdater) async {
  String downloadedFilePath = "";

  Directory directory = Directory("");
  if (Platform.isAndroid) {
    directory = (await getExternalStorageDirectory())!;
  } else {
    directory = (await getApplicationDocumentsDirectory());
  }
  String fileNamePlusExtension = url.split('/').last;
  String filePath = '${directory.path}/$fileNamePlusExtension';
  if (!File(filePath).existsSync()) {
    await Dio().download(url, filePath,
        onReceiveProgress: (actualBytes, int totalBytes) {
      progressUpdater.call((actualBytes / totalBytes * 100));
    });
  }
  downloadedFilePath = filePath;
  return filePath;
}
