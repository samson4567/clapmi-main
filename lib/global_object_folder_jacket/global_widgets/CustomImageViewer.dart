import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';

// ignore: must_be_immutable
class CustomImageView extends StatelessWidget {
  String? imagePath;
  double? height;
  double? width;
  Color? color;
  BoxFit? fit;
  final String placeHolder;
  Alignment? alignment;
  VoidCallback? onTap;
  EdgeInsetsGeometry? padding;
  BorderRadius? radius;
  BoxBorder? border;
  Color? errorColor;
  Widget? errorWidget;

  CustomImageView({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.padding,
    this.border,
    this.placeHolder = 'assets/images/image_not_found.png',
    this.errorColor,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath?.isNotEmpty ?? false) {
      switch (imagePath!.imageType) {
        case ImageType.svg:
          return SizedBox(
            height: height,
            width: width,
            child: Builder(builder: (context) {
              // print("greenBeans-greenBeans-imagePath_is${[
              //   imagePath!.startsWith("http"),
              //   imagePath
              // ]}");
              return (imagePath!.startsWith("http"))
                  ? SvgPicture.network(
                      imagePath!,
                      height: height,
                      width: width,
                      fit: fit ?? BoxFit.contain,
                      // colorFilter: ColorFilter.mode(
                      //     color ?? Colors.transparent, BlendMode.srcIn),
                    )
                  : SvgPicture.asset(
                      imagePath!,
                      height: height,
                      width: width,
                      fit: fit ?? BoxFit.contain,
                      // colorFilter: ColorFilter.mode(
                      //     color ?? Colors.transparent, BlendMode.srcIn),
                    );
            }),
          );
        case ImageType.file:
          return Image.file(
            File(imagePath!),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
        case ImageType.network:
          return CachedNetworkImage(
              height: height,
              width: width,
              fit: fit,
              imageUrl: imagePath!,
              color: color,
              placeholder: (context, url) => Center(
                    child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator.adaptive()
                        // LinearProgressIndicator(
                        //   color: AppColors.primaryColor,
                        //   backgroundColor: Colors.grey.withAlpha(20),
                        // ),
                        ),
                  ),
              errorWidget: (context, url, error) => SizedBox(
                    height: height,
                    width: width,
                    child: errorWidget ??
                        Icon(
                          Icons.image,
                          color: Colors.black.withAlpha(
                            100,
                          ),
                        ),
                  ));
        case ImageType.png:
        default:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
      }
    }
    return SizedBox(
      height: height,
      width: width,
      child: Icon(
        Icons.image,
        color: Colors.black.withAlpha(
          100,
        ),
      ),
    );
  }
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file://') || !(startsWith('assets'))) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }
