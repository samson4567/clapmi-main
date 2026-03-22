import 'package:clapmi/global_object_folder_jacket/global_classes/global_classes.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: buildBackArrow(context),
        centerTitle: true,
        title: Title(color: Colors.white, child: const Text("Rachael’s Info")),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Image.asset(
                    "assets/images/profilePhoto.png",
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Rachael Tallman"),
                const SizedBox(height: 10),
                const Text("@RachyTee"),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PillButton(
                      width: 111.w,
                      child: const Text("Chat"),
                    ),
                    const SizedBox(width: 20),
                    FancyContainer(
                      width: 111.w,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      backgroundColor: AppColors.secondaryColor,
                      hasBorder: true,
                      radius: 30,
                      borderColor: AppColors.primaryColor,
                      child: const Text("Gift"),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Media & Links",
                  ),
                ),
                const SizedBox(height: 15),
                ListTile(
                  leading: Text(
                    "2,304 media & 57 links",
                    style: fadedTextStyle,
                  ),
                  trailing: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.chevron_right)),
                )
              ],
            ),
            const Text("You and Rachael has been friends since 20th Dec, 2020")
          ],
        ),
      ),
    );
  }
}
