import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

Widget comboDetails(BuildContext context,
    {required ComboEntity combo, required num totalGiftingPot}) {
  return Padding(
    padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'View brag post',
              style: TextStyle(
                color: getFigmaColor("646565"),
                fontFamily: 'Geist',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            FancyContainer(
              hasBorder: true,
              radius: 30,
              borderColor: AppColors.primaryColor,
              action: () {
                context.goNamed(MyAppRouteConstant.postScreen,
                    extra: combo.brag);
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'View brag Post',
                    style: TextStyle(
                        fontFamily: 'Geist',
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: getFigmaColor("FFFFFF")),
                  )),
            )
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Winner",
              style: TextStyle(
                fontFamily: 'Geist',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: getFigmaColor("646565"),
              ),
            ),
            Text(
              "By highest number of points",
              style: TextStyle(
                fontFamily: 'Geist',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: getFigmaColor("FFFFFF"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Live Duration",
              style: TextStyle(
                  fontFamily: 'Geist',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: getFigmaColor("646565")),
            ),
            Text(
              combo.duration ?? '',
              style: TextStyle(
                fontFamily: 'Geist',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: getFigmaColor("FFFFFF"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "Live Pot",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: getFigmaColor("FFFFFF")),
        ),
        const SizedBox(height: 20),
        //THIS IS THE GIFT POINT COMPONENT
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Gift Pot",
              style: TextStyle(
                  fontFamily: 'Geist',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: getFigmaColor("8F9090")),
            ),
            Text(
              totalGiftingPot.toStringAsFixed(0),
              style: TextStyle(
                fontFamily: 'Geist',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: getFigmaColor("FFFFFF"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        //THIS IS THE TOTAL AMOUNT THAT WAS STAKE
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total Stake",
              style: TextStyle(
                  fontFamily: 'Geist',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: getFigmaColor("8F9090")),
            ),
            Row(
              children: [
                Image.asset(
                  'assets/icons/dee.png',
                  width: 32.w,
                  height: 32.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 5.w,
                ),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFFF0BE45),
                      Color(0xFFFFE8B1),
                      Color(0xFFF0BE45),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Text(
                    '${2 * (combo.stake ?? 0)}',
                    style: TextStyle(
                      fontFamily: 'Geist',
                      fontWeight: FontWeight.w600,
                      fontSize: 20.h,
                      color: Colors.white, // required but won't display
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        const SizedBox(height: 20),
        //THIS IS THE ADDITION OF THE POT AMOUNT WITH THE STAKE AMOUNT
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/pot.png',
                  width: 50.w,
                  height: 50.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Total",
                  style: TextStyle(
                      fontFamily: 'Geist',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: getFigmaColor("8F9090")),
                ),
              ],
            ),
            Row(
              children: [
                Image.asset(
                  "assets/icons/Group (11).png",
                  height: 20,
                  width: 20,
                ),
                Text(
                  '${2 * (combo.stake ?? 0) + (totalGiftingPot)}',
                  style: TextStyle(
                    fontFamily: 'Geist',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: getFigmaColor("FFFFFF"),
                  ),
                ),
              ],
            ),
          ],
        ),

        combo.status == 'LIVE'
            ? SizedBox.shrink()
            : Row(
                children: [
                  Text(
                    'Delete Brag Challenge',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: getFigmaColor("FF1C00"),
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/images/trash.svg",
                    color: getFigmaColor("FF1C00"),
                  )
                ],
              )
      ],
    ),
  );
}
