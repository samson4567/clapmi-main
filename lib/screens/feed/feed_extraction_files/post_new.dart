import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:clapmi/Models/search/user_search.dart';
import 'package:clapmi/core/services/image_picker_service.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_state.dart';

import 'package:clapmi/features/search/presentation/blocs/search_bloc.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PostEmpty extends StatefulWidget {
  const PostEmpty({super.key});

  @override
  State<PostEmpty> createState() => _PostEmptyState();
}

class _PostEmptyState extends State<PostEmpty> {
  String selectedOption = "Everyone";
  List<File> imageFiles = [];
  FocusNode textFieldNode = FocusNode();
  TextEditingController contentController = TextEditingController();

  // Tagging variables
  List<UserSearch> taggedUsers = [];
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    contentController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    contentController.removeListener(_onTextChanged);
    contentController.dispose();
    textFieldNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() {
    final text = contentController.text;
    final cursorPosition = contentController.selection.baseOffset;

    if (cursorPosition == -1) return;

    // Find if we're typing after an @ symbol
    final beforeCursor = text.substring(0, cursorPosition);
    final lastAtIndex = beforeCursor.lastIndexOf('@');

    if (lastAtIndex != -1) {
      final afterAt = beforeCursor.substring(lastAtIndex + 1);

      // Check if there's a space after @, if yes, hide suggestions
      if (afterAt.contains(' ')) {
        _removeOverlay();
        return;
      }

      // Search for users with the query after @
      if (afterAt.isNotEmpty) {
        context.read<SearchBloc>().add(SearchUsersEvent(afterAt));
      } else {
        _removeOverlay();
      }
    } else {
      _removeOverlay();
    }
  }

  bool _isSvgUrl(String? url) {
    if (url == null) return false;
    return url.toLowerCase().endsWith('.svg');
  }

  Widget _buildUserAvatar(UserSearch user) {
    if (_isSvgUrl(user.image)) {
      return CircleAvatar(
        backgroundColor: Colors.grey.shade800,
        child: ClipOval(
          child: SvgPicture.network(
            user.image,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            placeholderBuilder: (context) => const Icon(Icons.person),
          ),
        ),
      );
    }

    return CircleAvatar(
      backgroundImage: NetworkImage(user.image),
    );
  }

  Widget _buildChipAvatar(UserSearch user) {
    if (_isSvgUrl(user.image)) {
      return CircleAvatar(
        radius: 12,
        backgroundColor: Colors.grey.shade800,
        child: ClipOval(
          child: SvgPicture.network(
            user.image,
            width: 24,
            height: 24,
            fit: BoxFit.cover,
            placeholderBuilder: (context) => const Icon(Icons.person, size: 14),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 12,
      backgroundImage: NetworkImage(user.image),
    );
  }

  void _showUserSuggestions(List<UserSearch> users) {
    _removeOverlay();

    if (users.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 40.w,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, -210.h),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: BoxConstraints(maxHeight: 200.h),
              decoration: BoxDecoration(
                color: AppColors.lightgrid2,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    leading: _buildUserAvatar(user),
                    title: Text(
                      user.username,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      user.username!,
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                    onTap: () => _onUserSelected(user),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _onUserSelected(UserSearch user) {
    final text = contentController.text;
    final cursorPosition = contentController.selection.baseOffset;
    final beforeCursor = text.substring(0, cursorPosition);
    final lastAtIndex = beforeCursor.lastIndexOf('@');

    if (lastAtIndex != -1) {
      final beforeAt = text.substring(0, lastAtIndex);
      final afterCursor = text.substring(cursorPosition);

      final username = user.username;
      final newText = '$beforeAt@$username $afterCursor';

      contentController.text = newText;
      contentController.selection = TextSelection.fromPosition(
        TextPosition(offset: beforeAt.length + username.length + 2),
      );

      // Add to tagged users list
      if (!taggedUsers.any((u) => u.pid == user.pid)) {
        setState(() {
          taggedUsers.add(user);
        });
      }
    }

    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<PostBloc, PostState>(
            listener: (context, state) {
              if (state is SelectPostImageSuccessState) {
                print("dhgfdsfjdsygfjdshgf${state.imageFiles.map(
                  (e) => e.path,
                )}");
                setState(() {
                  imageFiles = state.imageFiles;
                });
                if (state.imageFiles.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    generalSnackBar("No Image selected"),
                  );
                }
              }
              if (state is SelectPostImageErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(generalSnackBar(state.errorMessage));
              }

              if (state is CreatePostSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  generalSnackBar(state.message),
                );
                context
                    .read<PostBloc>()
                    .add(const GetAllPostsEvent(isRefresh: true));
                context.pop();
              }
              if (state is CreatePostErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(generalSnackBar(state.errorMessage));
              }
            },
          ),
          BlocListener<SearchBloc, SearchState>(
            listener: (context, state) {
              if (state is SearchLoaded) {
                _showUserSuggestions(state.users);
              } else if (state is SearchInitial || state is SearchError) {
                _removeOverlay();
              }
            },
          ),
        ],
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Image.asset(
                          "assets/images/X.png",
                          height: 40.h,
                          width: 24.w,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: FancyContainer(
                          isAsync: true,
                          action: (state is CreatePostLoadingState)
                              ? null
                              : () async {
                                  print("dhgfdsfjdsygfjdshgf${imageFiles.map(
                                    (e) => e.path,
                                  )}");
                                  if (contentController.text.isNotEmpty ||
                                      imageFiles.isNotEmpty) {
                                    CreatePostModel createPostModel =
                                        CreatePostModel(
                                      uuid: const Uuid().v4(),
                                      content: contentController.text,
                                      whoCanSeePost:
                                          selectedOption.toLowerCase(),
                                      tagUsers: taggedUsers.isNotEmpty
                                          ? taggedUsers
                                              .map((u) => u.username)
                                              .toList()
                                          : null,
                                      images: (imageFiles.isNotEmpty)
                                          ? [
                                              ...(imageFiles.map(
                                                (e) => e.path,
                                              ))
                                            ]
                                          : [],
                                    );
                                    context.read<PostBloc>().add(
                                          CreatePostEvent(
                                              postModel: createPostModel),
                                        );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      generalSnackBar(
                                          "Please enter some text or select an image."),
                                    );
                                  }
                                },
                          child: Container(
                            height: 32.h,
                            width: 62.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (state is CreatePostLoadingState)
                                  ? Colors.blue.withOpacity(0.5)
                                  : Colors.blue,
                            ),
                            child: Center(
                              child: (state is CreatePostLoadingState)
                                  ? SizedBox(
                                      height: 16.h,
                                      width: 16.h,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      "Post",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      FancyContainer(
                        radius: 20,
                        child: Image.network(
                          "assets/icons/Frame 1000003940@3x.png",
                          height: 40.h,
                          width: 40.w,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        height: 40.h,
                        width: 130.w,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: getFigmaColor("006FCD", 27)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedOption,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            dropdownColor: AppColors.lightgrid2,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedOption = newValue!;
                              });
                            },
                            items: <String>['Everyone', 'Follow', 'Private']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Tagged users display
                  if (taggedUsers.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 10.h),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: getFigmaColor("006FCD", 20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: taggedUsers.map((user) {
                          return Chip(
                            avatar: _buildChipAvatar(user),
                            label: Text(
                              '@${user.username}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            deleteIcon: const Icon(Icons.close,
                                size: 18, color: Colors.white),
                            onDeleted: () {
                              setState(() {
                                taggedUsers.remove(user);
                              });
                            },
                            backgroundColor: Colors.blue.withOpacity(0.3),
                          );
                        }).toList(),
                      ),
                    ),

                  (imageFiles.isEmpty)
                      ? Expanded(
                          child: GestureDetector(
                            onTap: () {
                              textFieldNode.requestFocus();
                            },
                          ),
                        )
                      : Expanded(
                          child: Swiper(
                            loop: false,
                            itemBuilder: (BuildContext context, int index) {
                              return FancyContainer(
                                child: Image.file(imageFiles[index]),
                              );
                            },
                            itemCount: imageFiles.length,
                            viewportFraction: 0.8,
                            scale: 0.9,
                          ),
                        ),

                  Divider(
                    color: const Color.fromARGB(255, 8, 6, 6),
                    thickness: 1.h,
                  ),
                  SizedBox(height: 10.h),

                  // Row with keyboard input and icons
                  CompositedTransformTarget(
                    link: _layerLink,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: contentController,
                            focusNode: textFieldNode,
                            maxLines: null,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Post Something ",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Row(
                          children: [
                            BlocBuilder<PostBloc, PostState>(
                                builder: (context, state) {
                              return FancyContainer(
                                height: 40,
                                width: 40,
                                isAsync: true,
                                action: () async {
                                  ImageSource? imageSource =
                                      await ImagePickerFunctionalities
                                          .showOptions(context);
                                  if (imageSource != null) {
                                    context.read<PostBloc>().add(
                                          SelectImageEvent(
                                            imageSource: imageSource,
                                          ),
                                        );
                                  }
                                },
                                child: (state is SelectPostImageLoadingState)
                                    ? AspectRatio(
                                        aspectRatio: 1,
                                        child:
                                            CircularProgressIndicator.adaptive(
                                          backgroundColor:
                                              AppColors.backgroundColor,
                                        ),
                                      )
                                    : Image.asset(
                                        "assets/icons/mdi_image-add-outline.png",
                                      ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
