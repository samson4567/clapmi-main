// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/core/services/image_picker_service.dart';
import 'package:clapmi/features/post/data/models/create_video_post_model.dart';
import 'package:clapmi/features/post/domain/entities/category_entity.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/Video_player_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class NewBrag extends StatefulWidget {
  const NewBrag({super.key});

  @override
  State<NewBrag> createState() => _NewBragState();
}

class _NewBragState extends State<NewBrag> {
  File? videoFile;
  File? thumbnailFile;
  List<String> tags = [];
  CategoryEntity? selectedCategoryEntity;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {
          if (state is SelectPostVideoSuccessState) {
            setState(() {
              videoFile = state.imageFiles;
            });
            if (state.imageFiles == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                generalSnackBar("No video selected"),
              );
            }
          }
          if (state is SelectPostVideoErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(generalSnackBar(state.errorMessage));
          }
          if (state is CreateVideoPostSuccessState) {
            // Navigate to brag screen to see the uploaded video
            context.go(MyAppRouteConstant.bragScreen);
          }
          if (state is CreateVideoPostErrorState) {
            print("sdhbjshfvjsdhvfjdsvfjds>>${state.errorMessage}");
            ScaffoldMessenger.of(context)
                .showSnackBar(generalSnackBar(state.errorMessage));
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                // Header with title and close button
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFF2D2D2D),
                        width: 1,
                      ),
                    ),
                  ),
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          videoFile != null
                              ? "${videoFile?.path.split("/").last}"
                              // "Screen Recording ${_getFormattedDate()}"
                              : "Upload Video",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main content area
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side - Form fields
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Details Header
                              Text(
                                "Details",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 24.h),

                              // Title Field (Required)
                              _buildRequiredLabel("Title (required)",
                                  hasError: titleController.text.isEmpty),
                              SizedBox(height: 8.h),
                              _buildTextField(
                                controller: titleController,
                                hint: "",
                                maxLength: 100,
                                isRequired: true,
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                              SizedBox(height: 24.h),

                              // Description Field
                              Text(
                                "Description",
                                style: TextStyle(
                                  color: Color(0xFFAAAAAA),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              _buildTextField(
                                controller: descriptionController,
                                hint:
                                    "Tell viewers about your video (optional)",
                                maxLines: 5,
                                isRequired: false,
                              ),
                              SizedBox(height: 24.h),

                              // Tags Field (Required)
                              _buildRequiredLabel("Tags (required)",
                                  hasError: tagsController.text.isEmpty),
                              SizedBox(height: 8.h),
                              _buildTextField(
                                controller: tagsController,
                                hint: "Add #tags (required)",
                                isRequired: true,
                                onChanged: (value) {
                                  setState(() {
                                    tags = value
                                        .split(',')
                                        .map((e) => e.trim())
                                        .where((e) => e.isNotEmpty)
                                        .toList();
                                  });
                                },
                              ),
                              SizedBox(height: 24.h),

                              // Thumbnail Section
                              Text(
                                "Thumbnail (optional)",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Select or upload a picture that shows what's in your video. A good thumbnail draws viewers attention.",
                                style: TextStyle(
                                  color: Color(0xFF717171),
                                  fontSize: 12.sp,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 16.h),

                              GestureDetector(
                                onTap: _selectThumbnail,
                                child: Container(
                                  height: 180.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2D2D2D),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Color(0xFF3D3D3D),
                                      width: 1,
                                    ),
                                  ),
                                  child: thumbnailFile != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            thumbnailFile!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_outlined,
                                              color: Color(0xFF717171),
                                              size: 48,
                                            ),
                                            SizedBox(height: 12.h),
                                            Text(
                                              "Upload thumbnail (optional)",
                                              style: TextStyle(
                                                color: Color(0xFF717171),
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Right side - Video preview and trends
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF2D2D2D),
                                width: 1,
                              ),
                            ),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                padding: EdgeInsets.all(24.w),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: constraints.maxWidth - 48.w,
                                    maxWidth: constraints.maxWidth - 48.w,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Video preview section
                                      if (videoFile != null) ...[
                                        Container(
                                          height: 240.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: VideoPlayerWidget(
                                              dataSourceType:
                                                  DataSourceType.file,
                                              resourcePath: videoFile!.path,
                                              height: 240.h,
                                              width: double.infinity,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16.h),

                                        // Filename section
                                        Text(
                                          "Filename",
                                          style: TextStyle(
                                            color: Color(0xFFAAAAAA),
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Container(
                                          padding: EdgeInsets.all(12.w),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF2D2D2D),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "${videoFile?.path.split("/").last}",
                                            // "Screen Recording ${_getFormattedDate()}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 24.h),
                                      ] else ...[
                                        // Upload video button when no video
                                        GestureDetector(
                                          onTap: () async {
                                            ImageSource? imageSource =
                                                await ImagePickerFunctionalities
                                                    .showOptions(context);
                                            if (imageSource != null) {
                                              context.read<PostBloc>().add(
                                                    SelectVideoEvent(
                                                        imageSource:
                                                            imageSource),
                                                  );
                                            }
                                          },
                                          child: Container(
                                            height: 200.h,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF2D2D2D),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Color(0xFF3D3D3D),
                                                width: 1,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.videocam_outlined,
                                                  color: Color(0xFF717171),
                                                  size: 48,
                                                ),
                                                SizedBox(height: 12.h),
                                                Text(
                                                  "Select Video",
                                                  style: TextStyle(
                                                    color: Color(0xFF717171),
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 24.h),
                                      ],

                                      // Trends section
                                      Text(
                                        "Trends (optional)",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 12.h),

                                      // Category dropdown
                                      PopupMenuButton<CategoryEntity>(
                                        offset: Offset(0, 50),
                                        color: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        onSelected: (CategoryEntity category) {
                                          setState(() {
                                            selectedCategoryEntity = category;
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 14.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF2D2D2D),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Color(0xFF3D3D3D),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  selectedCategoryEntity != null
                                                      ? selectedCategoryEntity!
                                                              .name ??
                                                          "Choose trend or category (optional)"
                                                      : "Choose trend or category (optional)",
                                                  style: TextStyle(
                                                    color:
                                                        selectedCategoryEntity !=
                                                                null
                                                            ? Colors.white
                                                            : Color(0xFF717171),
                                                    fontSize: 13.sp,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        itemBuilder: (BuildContext context) {
                                          return listOfCategoryModelG
                                              .map((CategoryEntity category) {
                                            return PopupMenuItem<
                                                CategoryEntity>(
                                              value: category,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.h),
                                                child: Text(
                                                  category.name ?? '',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom action buttons
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFF2D2D2D),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Cancel Button
                      SizedBox(
                        width: 120.w,
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side:
                                BorderSide(color: Color(0xFFCC0000), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color(0xFFCC0000),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Upload Button
                      SizedBox(
                        width: 120.w,
                        child: ElevatedButton(
                          onPressed: _handleUpload,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            backgroundColor: (titleController.text.isEmpty ||
                                    tagsController.text.isEmpty ||
                                    videoFile == null)
                                ? Color(0xFF909090)
                                : Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "Upload",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequiredLabel(
    String text, {
    bool hasError = false,
  }) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: hasError ? Color(0xFFCC0000) : Color(0xFFAAAAAA),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 4.w),
        Icon(
          Icons.help_outline,
          color: Color(0xFFAAAAAA),
          size: 16,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    int? maxLength,
    bool isRequired = false,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isRequired && controller.text.isEmpty
              ? Color(0xFFCC0000)
              : Color(0xFF3D3D3D),
          width: isRequired && controller.text.isEmpty ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            onChanged: onChanged,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: Color(0xFF717171),
                fontSize: 14.sp,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              counterStyle: TextStyle(
                color: Color(0xFF717171),
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} at ${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}.${now.second.toString().padLeft(2, '0')}";
  }

  Future<void> _selectThumbnail() async {
    ImageSource? imageSource =
        await ImagePickerFunctionalities.showOptions(context);
    if (imageSource != null) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          thumbnailFile = File(image.path);
        });
      }
    }
  }

  void _handleUpload() {
    // Validate required fields
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        generalSnackBar("Title is required"),
      );
      return;
    }

    if (tagsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        generalSnackBar("Tags are required"),
      );
      return;
    }

    if (videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        generalSnackBar("Please select a video"),
      );
      return;
    }

    // Create post model
    CreateVideoPostModel createVideoPostModel = CreateVideoPostModel(
      description: descriptionController.text,
      category: selectedCategoryEntity?.uuid,
      video: videoFile,
      tags: tags,
    );
    print("bjdkfbjdkfbdsjfjb=>${videoFile!.path}");

    // Dispatch event - navigation will happen in Bloc listener when upload completes
    context.read<PostBloc>().add(
          CreateVideoPostEvent(createVideoPostModel),
        );
    // Don't navigate immediately - wait for upload to complete
  }
}
