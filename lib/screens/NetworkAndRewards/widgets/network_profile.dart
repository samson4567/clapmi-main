import 'package:clapmi/features/chats_and_socials/data/models/clap_request_model.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NetWorkProfile extends StatefulWidget {
  const NetWorkProfile(
      {super.key,
      required this.requestModel,
      required this.acceptRequest,
      required this.declineRequest});

  final ClapRequestModel? requestModel;
  final VoidCallback acceptRequest;
  final VoidCallback declineRequest;

  @override
  State<NetWorkProfile> createState() => _NetWorkProfileState();
}

class _NetWorkProfileState extends State<NetWorkProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181919),
        borderRadius: BorderRadius.circular(16),
      ),
      width: 210.w,
      height: 250.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //PROFILE PICTURE
          FancyContainer(
            radius: 10,
            height: 135.h,
            backgroundColor: Colors.greenAccent,
            child: CustomImageView(
              imagePath: widget.requestModel?.senderImage,
              // height: 50,
              // width: 50,
              errorWidget: Image.asset("assets/images/empty_avatar_icon.png"),
            ),
          ),
          Gap(20),
          Row(
            children: [
              SizedBox(width: 10.w), // Space between avatar and text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.requestModel?.senderName ?? "No name"} ",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  //  if (widget.requestModel.occupation != null)
                  Text(
                    widget.requestModel?.occupation ?? "No Occupation",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FancyContainer(
                        height: 35,
                        width: 100,
                        radius: 20,
                        isAsync: true,
                        backgroundColor: getFigmaColor("006FCD"),
                        action: widget.acceptRequest,
                        child: const Text(
                          'Accept',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      const SizedBox(width: 8), // Smaller gap between buttons
                      FancyContainer(
                        height: 35,
                        width: 100,
                        radius: 20,
                        isAsync: true,
                        backgroundColor: getFigmaColor("006FCD", 30),
                        action: widget.declineRequest,
                        child: Text(
                          'Decline',
                          style: TextStyle(color: getFigmaColor("006FCD")),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
