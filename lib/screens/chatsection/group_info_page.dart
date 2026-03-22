import 'package:clapmi/global_object_folder_jacket/global_classes/global_classes.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupInfoPage extends StatefulWidget {
  const GroupInfoPage({super.key});

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_left),
        ),
        centerTitle: true,
        title: Title(color: Colors.white, child: const Text("Group Info")),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Image.asset(
                        "assets/images/groupProfilePhoto.png",
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Set of 2024"),
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
                          onPressed: () {},
                          icon: const Icon(Icons.chevron_right)),
                    ),
                    TitleMoreAndBodyWidget(
                        title: "Group members",
                        othetSideButton: const PillButton(
                          child: Row(
                            children: [
                              Icon(Icons.add_circle_outline_sharp),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Add to Group")
                            ],
                          ),
                        ),
                        body: Column(
                          children: List.generate(
                            5,
                            (index) => ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                child: Image.asset(
                                  "assets/images/profilePhoto.png",
                                ),
                              ),
                              title: const Text("Rachael Tallman"),
                              subtitle: const Text("@RachyTee"),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 45,
              color: AppColors.secondaryColor,
              child: const Text(
                  "You have been in this group since 20th Dec, 2020"),
            )
          ],
        ),
      ),
    );
  }
}
