import 'package:cached_network_image/cached_network_image.dart';
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
            //**THIS WILL RENDER THE AVATAR */
            child: comment?.user?.avatarConvert != null
                ? Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(comment!.user!.avatarConvert!))),
                  )
                //ELSE IF THE PROFILE PICTURES ARE AVAILABLE, IT WILL RENDER THE IMAGE
                : CachedNetworkImage(
                    imageUrl: comment?.user?.avatar ??
                        user?.user?.image ??
                        giftdata?.giftdata?.sender?.avatar ??
                        '',
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        // height: 10.w,
                        // width: 10.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        // height: 10.w,
                        // width: 10.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.person, size: 30),
                      );
                    },
                  ),
          ),
        ),
        title: Text(
          comment?.user?.username ??
              user?.user?.username ??
              giftdata?.giftdata?.sender?.username ??
              '',
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
                      CachedNetworkImage(
                        imageUrl: giftdata?.giftdata?.sender?.avatar ?? '',
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            height: 10.w,
                            width: 10.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover)),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Container(
                            // height: 10.w,
                            // width: 10.w,
                            margin: EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25)),
                            child: Icon(Icons.person, size: 30),
                          );
                        },
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
