import 'dart:io';

import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
// ...

class PhotoViewlet extends StatefulWidget {
  final List galleryItems;
  const PhotoViewlet({super.key, required this.galleryItems});

  @override
  State<PhotoViewlet> createState() => _PhotoViewletState();
}

class _PhotoViewletState extends State<PhotoViewlet> {
  ImageProvider getImageProvider(imageEntity) {
    if (imageEntity is String) {
      String imagePath = imageEntity;

      switch (imagePath.imageType) {
        case ImageType.file:
          return FileImage(
            File(imagePath),
          );
        case ImageType.network:
          return NetworkImage(imagePath);
        case ImageType.png:
        default:
          return AssetImage(imagePath);
      }
    } else {
      return FileImage(imageEntity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          tightMode: true,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.person),
          imageProvider: getImageProvider(widget.galleryItems[index]),
          // Image.network(widget.galleryItems[index] ?? "").image,
          initialScale: PhotoViewComputedScale.contained,
          heroAttributes:
              PhotoViewHeroAttributes(tag: widget.galleryItems[index].hashCode),
        );
      },
      itemCount: widget.galleryItems.length,
      loadingBuilder: (context, event) => Center(
        child: SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 0),
          ),
        ),
      ),
      backgroundDecoration: const BoxDecoration(),
      pageController: PageController(),
      onPageChanged: (index) {},
    ));
  }
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file://') || !startsWith('asset')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }
