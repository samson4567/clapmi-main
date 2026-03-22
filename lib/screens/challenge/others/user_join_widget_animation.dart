import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveNotification extends StatelessWidget {
  const LiveNotification({
    super.key,
    required this.child,
    required this.controller,
    required this.positionAnimation,
    required this.opacityAnimation,
  });
  final AnimationController controller;
  final Animation<double> positionAnimation;
  final Animation<double> opacityAnimation;
  final Widget child;

  double _wobble(double value) {
    return sin(value * pi * 4) * 20;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final size = MediaQuery.of(context).size;
          final yOffset = size.height * positionAnimation.value;
          final xOffset = size.width / 2 + _wobble(controller.value);
          return Positioned(
            bottom: yOffset,
            left: xOffset - 50, // center horizontally
            child: Opacity(
              opacity: opacityAnimation.value,
              child: Transform.scale(
                scale: 1.0 + controller.value * 0.2, // slight growth
                child: child,
              ),
            ),
          );
        },
        child: child);
  }
}

Widget userJoin({String? imageUrl, String? message, String? userName}) {
  return Container(
    height: 60.h,
    width: 200.w,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      leading: CircularContainer(
          radius: 40,
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? '',
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
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.person,
                  size: 30,
                ),
              );
            },
          )),
      title: Text(
        userName ?? '',
        style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            height: 1,
            fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        message ?? '',
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins',
          height: 1,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

Widget giftWidget(
    {String? imageUrl, String? message, String? userName, String? amount}) {
  return Container(
    height: 60.h,
    width: 350.w,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      leading: Padding(
        padding: EdgeInsets.zero,
        child: CircularContainer(
          radius: 40,
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? '',
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
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.person,
                  size: 30,
                ),
              );
            },
          ),
        ),
      ),
      title: Text(
        userName ?? '',
        style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            height: 1,
            fontWeight: FontWeight.w400),
      ),
      subtitle: Row(
        children: [
          Text(
            '$userName $message',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              height: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
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
                  // CachedNetworkImage(
                  //   imageUrl: imageUrl ?? '',
                  //   imageBuilder: (context, imageProvider) {
                  //     return Container(
                  //       height: 10.w,
                  //       width: 10.w,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           image: DecorationImage(
                  //               image: imageProvider, fit: BoxFit.cover)),
                  //     );
                  //   },
                  //   errorWidget: (context, url, error) {
                  //     return Container(
                  //       height: 10.w,
                  //       width: 10.w,
                  //       margin: EdgeInsets.only(bottom: 4),
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(25)),
                  //       child: Icon(Icons.person, size: 30),
                  //     );
                  //   },
                  // ),
                  // SizedBox(
                  //   width: 3,
                  // ),
                  // Text(userName ?? '',
                  //     style: TextStyle(
                  //         fontFamily: 'Poppins',
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 14)),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Row(
                    children: [
                      Text(
                        amount ?? '',
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

Widget clapLiveWidget(
    {String? imageUrl,
    String? message,
    String? userName,
    Uint8List? myavatar}) {
  return Container(
    height: 60.h,
    width: 200.w,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      //color: Colors.red,
    ),
    child: ListTile(
      leading: Padding(
        padding: EdgeInsets.zero,
        child: CircularContainer(
          radius: 40,
          child: myavatar != null
              ? Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(image: MemoryImage(myavatar))),
                )
              : CachedNetworkImage(
                  imageUrl: imageUrl ?? '',
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    );
                  },
                ),
        ),
      ),
      title: Text(
        userName ?? '',
        style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            height: 1,
            fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        message ?? '',
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins',
          height: 1,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
