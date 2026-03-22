import 'package:clapmi/global_object_folder_jacket/global_classes/global_classes.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateNewGroupPage extends StatefulWidget {
  const CreateNewGroupPage({super.key});

  @override
  State<CreateNewGroupPage> createState() => _CreateNewGroupPageState();
}

class _CreateNewGroupPageState extends State<CreateNewGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: buildBackArrow(context),
        centerTitle: true,
        title:
            Title(color: Colors.white, child: const Text("Create new group")),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: Image.asset(
                          "assets/images/profilePhoto.png",
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Set of 2024"),
                      const SizedBox(height: 10),
                      const Text("We are the best set @2k24"),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FancyContainer(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            backgroundColor: AppColors.secondaryColor,
                            hasBorder: true,
                            radius: 30,
                            borderColor: AppColors.primaryColor,
                            child: const Text(
                              "Edit profile picture",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Group name",
                          style: fadedTextStyle,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: SizedBox(
                            height: 45,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Set of 2024",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "bio",
                          style: fadedTextStyle,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: SizedBox(
                            height: 45,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "We are the best set @2k24",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
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
                              1,
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
                          )),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: PillButton(
                          width: 80,
                          child: Text("See all"),
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: AppColors.secondaryColor,
                height: 75,
                child: Column(
                  children: [
                    const Text("You will be the admin of this group"),
                    const SizedBox(
                      height: 7,
                    ),
                    PillButton(
                      height: 45,
                      child: const Text("Create group"),
                      onTap: () {
                        context.go(MyAppRouteConstant.chatPageForGroup);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
