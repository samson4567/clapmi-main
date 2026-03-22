import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:flutter/material.dart';

TextStyle titleStyle = const TextStyle(color: Colors.white, fontSize: 25);
TextStyle fadedTextStyle =
    TextStyle(color: getFigmaColor("FFFFFF", 56), fontSize: 13);

// Product Manager

Color linkColor = getFigmaColor("1666C5");

bool toPop = false;

final rootNavigatorKey = GlobalKey<NavigatorState>();
bool bragToBeUploadedToFirebase = true;

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> sectionNavigatorKey =
    GlobalKey<NavigatorState>();

int amountOfCachablePost = 10;
int screenShareUid = 749528103621;

bool isLoggedIn = false;

GlobalKey<ScaffoldMessengerState> globalScaffoldKey =
    GlobalKey<ScaffoldMessengerState>();
String baseURL = "https://api.clapmi.com/api";
String baseNotificationServerURL = "https://clapmi-server.vercel.app";

//internetStoreVar
bool hasInternetAccess = false;

// device width
double? deviceWidth;
List<PostModel> theListOfPreviouslyStoredPostModelListG = [];
