import 'dart:math';

import 'package:clapmi/global_object_folder_jacket/global_classes/global_classes.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChatPageForGroup extends StatefulWidget {
  const ChatPageForGroup({super.key});

  @override
  State<ChatPageForGroup> createState() => _ChatPageForGroupState();
}

class _ChatPageForGroupState extends State<ChatPageForGroup> {
  bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: getFigmaColor("0C0D0D"),
        appBar: AppBar(
          title: GestureDetector(
              onTap: () {
                context.push(MyAppRouteConstant.groupInfoPage);
              },
              child: const HeaderTile()),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        body: Stack(
          children: [
            (!isEmpty)
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          ...List.generate(5, (i) {
                            bool sd = Random().nextBool();
                            return MessageWidgetForChatGroup(
                              model: TextModelForGroup.dummy(isMine: sd),
                              repliedMessage:
                                  TextModelForGroup.dummy(isMine: false),
                            );
                          }),
                          ...[const SizedBox(height: 60)]
                        ],
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(25.0),
                    child: EmptyChatListWidget(),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FancyContainer(
                height: 55,
                backgroundColor: getFigmaColor("222222"),
                radius: 25,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      FancyContainer(
                        height: 30,
                        width: 30,
                        radius: 10,
                        child: const Icon(Icons.add_circle_outline_sharp),
                      ),
                      const VerticalDivider(),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type your message here"),
                        ),
                      ),
                      FancyContainer(
                        height: 30,
                        width: 30,
                        radius: 10,
                        child: const Icon(Icons.mic_none_sharp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  String selecetdTab = "All";
}

class HeaderTile extends StatefulWidget {
  const HeaderTile({super.key});

  @override
  State<HeaderTile> createState() => _HeaderTileState();
}

class _HeaderTileState extends State<HeaderTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.amber,
        child: Image.asset(
          "assets/images/profilePhoto.png",
        ),
      ),
      title: const Text("Inner Circle"),
      subtitle: Text(
        "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: getFigmaColor("47E800"),
        ),
      ),
    );
  }
}

class EmptyChatListWidget extends StatelessWidget {
  const EmptyChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FancyContainer(
          width: 207.w,
          height: 176.h,
          radius: 24,
          backgroundColor: getFigmaColor("222222"),
        ),
        const SizedBox(height: 16),
        const Text("Say “Hi” to start a conversation with Rachael Tallman"),
        SizedBox(height: 60.h),
      ],
    );
  }
}

class MessageWidgetForChatGroup extends StatefulWidget {
  final TextModelForGroup model;
  final TextModelForGroup? repliedMessage;
  const MessageWidgetForChatGroup(
      {super.key, required this.model, this.repliedMessage});

  @override
  State<MessageWidgetForChatGroup> createState() =>
      _MessageWidgetForChatGroupState();
}

class _MessageWidgetForChatGroupState extends State<MessageWidgetForChatGroup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: widget.model.isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: widget.model.isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              if (!widget.model.isMine)
                Row(
                  children: [
                    Image.asset(
                      "assets/images/profilePhoto.png",
                      height: 30,
                    ),
                    const SizedBox(width: 10),
                    const Text("Rachel Steeze")
                  ],
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                child: FancyContainer(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  radius: 24,
                  backgroundColor: (!widget.model.isMine)
                      ? getFigmaColor("222222")
                      : AppColors.primaryColor,
                  child: Column(
                    children: [
                      (widget.repliedMessage != null)
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: _buildReplyMessage(context),
                            )
                          : const SizedBox(),
                      if (widget.model.messagePhotoUrl != null)
                        Image.network(widget.model.messagePhotoUrl!),
                      Text(
                        widget.model.message ?? '',
                        style: const TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                child: Text(
                    "${TimeOfDay.fromDateTime(widget.model.date ?? DateTime.now()).hour}: ${TimeOfDay.fromDateTime(widget.model.date ?? DateTime.now()).minute}"),
              )
            ],
          ),
        ],
      ),
    );
  }

  FancyContainer _buildReplyMessage(BuildContext context) {
    return FancyContainer(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      radius: 24,
      backgroundColor: getFigmaColor("111111"),
      child: Column(
        children: [
          Row(
            children: [
              if (widget.repliedMessage?.messagePhotoUrl != null)
                Image.network(widget.repliedMessage!.messagePhotoUrl!),
              Expanded(
                child: Text(
                  widget.repliedMessage!.message ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class TextModelForGroup {
  final String? message;
  final String? messagePhotoUrl;

  final DateTime? date;
  final String? ownerID;
  final bool isMine;
  String? ownerPhoto;
  String? ownerName;

  TextModelForGroup({
    this.message,
    this.messagePhotoUrl,
    required this.date,
    required this.ownerID,
    required this.isMine,
  }) : assert(message != null || messagePhotoUrl != null);

  factory TextModelForGroup.dummy({required bool isMine}) {
    return TextModelForGroup(
        message:
            "The work is fine and finished. Let me send in a picture of the work .",
        date: DateTime.now(),
        isMine: isMine,
        ownerID: "ew21sd212");
  }
  express() async {}
}
