import 'dart:ui';
import 'package:clapmi/Uicomponent/DialogsAndBottomSheets/challenge_box.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/global_classes.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';

class LiveComboScreen extends StatefulWidget {
  const LiveComboScreen({super.key});

  @override
  State<LiveComboScreen> createState() => _LiveComboScreenState();
}

class _LiveComboScreenState extends State<LiveComboScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Container(
          color: Colors.orange,
          child: Stack(
            children: <Widget>[
                  Image.asset(
                    "assets/icons/fineGirl.png",
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: ThemeButton(
                        color: Colors.red.withAlpha(100),
                        width: 250,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircularContainer(
                                child: Image.asset(
                                    "assets/icons/Frame 1000002049.png"),
                              ),
                            ),
                            const Icon(Icons.add),
                            const Text("Follow"),
                            const SizedBox(width: 10),
                            const Text("Leah6000")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CommentList(),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: ThemeButton(
                                  color: Colors.transparent,
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 20,
                                      sigmaY: 20,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Expanded(
                                              child: TextField(
                                            decoration: InputDecoration(
                                                hintText: "Comment",
                                                border: InputBorder.none),
                                          )),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                  Icons.sentiment_satisfied))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: iconWithLabelWidget(
                                    icon: Image.asset(
                                      "assets/icons/commentcoin.png",
                                      height: 30,
                                    ),
                                    text: const Text(
                                      "Gift coin",
                                      style: TextStyle(fontSize: 10),
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: iconWithLabelWidget(
                                    icon: Image.asset(
                                      "assets/icons/commentaddcoin.png",
                                      height: 30,
                                    ),
                                    text: const Text(
                                      "buy coin",
                                      style: TextStyle(fontSize: 10),
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: iconWithLabelWidget(
                                  icon: Image.asset(
                                    "assets/icons/commentclap.png",
                                    height: 40,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )))
                ] +
                [
                  Container(
                    color: AppColors.backgroundColor,
                    height: MediaQuery.of(context).size.height / 12,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert)),
                        Image.asset("assets/images/Mic.png"),
                        ThemeButton(
                          color: Colors.red,
                          width: 38,
                          height: 28,
                          text: "live",
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.visibility),
                        const SizedBox(width: 10),
                        Text("26k", style: fadedTextStyle),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "Designers earn more than Front end.......",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.normal),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                ],
          ),
        ),
      )),
    );
  }
}

// ignore: must_be_immutable
class iconWithLabelWidget extends StatelessWidget {
  Widget icon;
  Text? text;
  double? spacing;

  iconWithLabelWidget({super.key, required this.icon, this.text, this.spacing});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [icon, SizedBox(height: spacing ?? 5), if (text != null) text!],
    );
  }
}

class CommentList extends StatefulWidget {
  const CommentList({super.key});

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        4,
        (index) => ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircularContainer(
              child: Image.asset("assets/icons/Frame 1000002049.png"),
            ),
          ),
          title: Text(" Christano Roaldo "),
          subtitle: Row(
            children: [
              const Text("i love it 😂"),
              Container(
                  height: 40,
                  width: 190,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0XFF5C0E1C)),
                  child: Row(
                    children: [
                      Image.asset("assets/images/fra.png"),
                      Text("Christano007 2",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Image.asset("assets/images/coin_big.png"),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
