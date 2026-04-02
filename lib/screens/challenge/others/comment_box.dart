import 'package:clapmi/features/chats_and_socials/domain/entities/live_reactions_entities.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildCommentBox extends StatelessWidget {
  const BuildCommentBox({
    super.key,
    required this.commentData,
  });

  final Map<String, dynamic> commentData;

  @override
  Widget build(BuildContext context) {
    LiveGroundComment? comment;
    LiveUserInteraction? user;
    GiftData? giftdata;

    if (commentData['stateName'] == 'userJoined' ||
        commentData['stateName'] == 'userLeaves') {
      user = commentData['state'];
    } else if (commentData['stateName'] == 'giftLive') {
      giftdata = commentData['state'];
    } else {
      comment = commentData['state'];
    }
    String stateName = commentData['stateName'];
    final avatarUrl = comment?.user?.avatar ??
        user?.user?.image ??
        giftdata?.giftdata?.sender?.avatar;
    final avatarBytes =
        comment?.user?.avatarConvert ?? giftdata?.giftdata?.sender?.avatarConvert;
    final displayName = comment?.user?.username ??
        user?.user?.username ??
        giftdata?.giftdata?.sender?.username ??
        '';
    return Container(
      decoration: BoxDecoration(
        // color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Padding(
          padding: EdgeInsets.zero,
          child: CircularContainer(
            radius: 40,
            child: AppAvatar(
              imageUrl: avatarUrl,
              memoryBytes: avatarBytes,
              name: displayName,
              size: 40,
              backgroundColor: const Color(0xFF1E3A8A),
            ),
          ),
        ),
        title: Text(
          displayName,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            height: 1,
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Row(
          children: [
            stateName == 'clapLive'
                ? Expanded(
                    child: Text(
                      comment?.message ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        height: 1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : stateName == 'commentLive'
                    ? Expanded(
                        child: Text(
                          comment?.user?.message ?? '',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            height: 1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : stateName == 'userJoined'
                        ? Text(
                            user?.message ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              height: 1,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : stateName == 'userLeaves'
                            ? Text(
                                user?.message ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  height: 1,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : stateName == 'giftLive'
                                ? Text(
                                    '${giftdata?.giftdata?.sender?.username} ${giftdata?.message}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      height: 1,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : Text(
                                    comment?.message ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      height: 1,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
            if (stateName == 'giftLive')
              Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(
                    //  vertical: 10,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0XFF5C0E1C)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: AppAvatar(
                          imageUrl: giftdata?.giftdata?.sender?.avatar,
                          memoryBytes: giftdata?.giftdata?.sender?.avatarConvert,
                          name: giftdata?.giftdata?.sender?.username,
                          size: 22.w,
                          backgroundColor: const Color(0xFF1E3A8A),
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(giftdata?.giftdata?.sender?.username ?? '',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            '${giftdata?.giftdata?.amount}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Image.asset(
                            "assets/images/coin_big.png",
                            scale: 2,
                          ),
                        ],
                      ),
                    ],
                  ))
          ],
        ),
      ),
    );
  }
}
