import 'package:clapmi/Models/brag_model.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:shimmer/shimmer.dart';
import 'package:clapmi/features/app/data/models/user_model.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_event.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_state.dart';
import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/extraction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../features/user/data/models/user_model.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  bool showCategories = false;
  List<PostModel> displayedPosts = [];
  List<PostModel> displayedVideoPosts = [];
  UserModel? myprofile;
  // late String? currentUserPid; // No longer needed directly here
  bool displayPosts = true;
  bool displayBrag = false;

  @override
  void initState() {
    context.read<PostBloc>().add(GetUserPostsEvent(profileModelG!.pid));
    context
        .read<AppBloc>()
        .add(GetUserProfileEvent(userId: profileModelG?.pid ?? ''));
    super.initState();
  }

  List socials = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {
          if (state is GetUserProfileSuccess) {
            myprofile = state.userProfile;
          }
        },
        builder: (context, state) {
          return BlocConsumer<PostBloc, PostState>(listener: (context, state) {
            if (state is GetUserPostsErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Error fetching profile: ${state.errorMessage}')),
              );
            }
            if (state is GetUserPostsSuccessState) {
              print(
                  'This is the users Post being sent from the backend ${state.posts}');
              displayedPosts = state.posts
                  .where(
                    (element) => element.type != PostType.video,
                  )
                  .toList();
              displayedVideoPosts = state.posts
                  .where(
                    (element) => element.type == PostType.video,
                  )
                  .toList();

              print(
                  'Displaying the display video which is $displayedVideoPosts');
            }
          }, builder: (context, state) {
            return SafeArea(
              child: BlocConsumer<AppBloc, AppState>(
                listener: (context, state) {
                  // Optional: Show snackbars or dialogs based on state changes
                  if (state is GetUserProfileError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Error fetching profile: ${state.errorMessage}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is GetUserProfileLoading) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[600]!,
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Banner placeholder
                            Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.white,
                            ),
                            SizedBox(height: 20),
                            // Profile info placeholder
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 24,
                                    width: 150,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    height: 16,
                                    width: 100,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Container(
                                        height: 32,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Container(
                                        height: 32,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24),
                                  // Stats placeholders
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: List.generate(
                                        3,
                                        (index) => Container(
                                              height: 40,
                                              width: 60,
                                              color: Colors.white,
                                            )),
                                  ),
                                  SizedBox(height: 24),
                                  // Posts tabs placeholder
                                  Container(
                                    height: 40,
                                    width: double.infinity,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 16),
                                  // Posts placeholder
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 2,
                                      mainAxisSpacing: 2,
                                    ),
                                    itemCount: 6,
                                    itemBuilder: (context, index) => Container(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is GetUserProfileError) {
                    return Scaffold(
                      appBar: AppBar(
                          backgroundColor: AppColors.backgroundColor,
                          elevation: 0),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                'Failed to load profile: ${state.errorMessage}'),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<AppBloc>()
                                    .add(const GetMyProfileEvent(
                                      forceRefresh: true,
                                    ));
                              },
                              child: Text("Try again"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  //**WHEN THERE IS NO USER DATA TO BE DISPLAYED */
                  if (profileModelG == null) {
                    return Scaffold(
                      appBar: AppBar(
                          backgroundColor: AppColors.backgroundColor,
                          elevation: 0),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('User data not available.'),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<AppBloc>()
                                    .add(const GetMyProfileEvent(
                                      forceRefresh: true,
                                    ));
                                context.read<AppBloc>().add(GetUserProfileEvent(
                                    userId: profileModelG?.pid ?? ''));
                              },
                              child: Text("Try again"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      //** THIS IS THE BANNER*/
                      Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      CustomImageView(
                        imagePath: userModelG?.banner ??
                            // myprofile?.banner ??
                            "assets/images/default_banner.png", // Consider using user's banner if available
                        width: double.infinity,
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 100),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 7), // Added padding
                              color: AppColors.backgroundColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  //** THIS IS THE USER DETAILS WITH THE EDIT PROFILE BUTTON */
                                  _buildRow1(
                                      profileModelG!), // Pass the fetched user
                                  Row(
                                    children: List.generate(
                                      0,
                                      (index) => Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0), // Adjusted padding
                                        child: Text(
                                          "",
                                          // "#${displayUser.listOfInterests[index].title}",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10), // Added spacing
                                  Padding(
                                    padding: const EdgeInsets.only(left: 7.0),
                                    child: Visibility(
                                        visible:
                                            myprofile?.bio?.isNotEmpty == true,
                                        child: Text(
                                          myprofile?.bio ?? '',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: getFigmaColor("FFFFFF")),
                                        )),
                                  ),
                                  //** THIS IS THE SOCIAL MEDIA LINK*/
                                  Visibility(
                                    visible: socials.isNotEmpty,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Check me on:",
                                            style: fadedTextStyle),
                                        ...List.generate(
                                          socials.length,
                                          (index) {
                                            // Assuming socials contain map like {'platform': 'url'} or just URLs
                                            // Adjust parsing based on actual data structure
                                            String url = socials[index]
                                                .toString(); // Simplified
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical:
                                                          2.0), // Added padding
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.link, // Changed icon
                                                    size: 20, // Adjusted size
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    url,
                                                    style: TextStyle(
                                                        color: linkColor),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  //** THIS IS THE DETAILS SHOWING CLAPPED AND CLAPPER*/
                                  Padding(
                                    padding: const EdgeInsets.only(left: 7.0),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                "${myprofile?.clapped.toString()}"), // Replace with actual data if available
                                            Text(" Clapped",
                                                style: fadedTextStyle)
                                          ],
                                        ),
                                        const SizedBox(width: 15),
                                        Row(
                                          children: [
                                            Text(
                                                "${myprofile?.clappers.toString()}"), // Replace with actual data if available
                                            Text(" Clappers",
                                                style: fadedTextStyle)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10), // Added spacing
                                  //** THIS ARE THE TWO BUTTONS SHOWING THE POSTS AND BRAGS BUTTON */
                                  Row(
                                    children: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: !displayPosts
                                                ? WidgetStatePropertyAll(
                                                    getFigmaColor("181919"),
                                                  )
                                                : WidgetStatePropertyAll(
                                                    getFigmaColor("006FCD"),
                                                  ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              displayPosts = true;
                                              displayBrag = false;
                                            });
                                          },
                                          child: Text(
                                            "Posts",
                                            style: TextStyle(
                                              color: !displayPosts
                                                  ? getFigmaColor("006FCD")
                                                  : Colors.white,
                                            ),
                                          )),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor: !displayBrag
                                                ? WidgetStatePropertyAll(
                                                    getFigmaColor("181919"))
                                                : WidgetStatePropertyAll(
                                                    getFigmaColor("006FCD"))),
                                        onPressed: () {
                                          setState(() {
                                            displayPosts = false;
                                            displayBrag = true;
                                          });
                                        },
                                        child: Text(
                                          "Brags",
                                          style: TextStyle(
                                            color: !displayBrag
                                                ? getFigmaColor("006FCD")
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  //**THIS IS THE POST CONTENT SESSION OF THE SCREEN */
                                  if (displayedPosts.isNotEmpty && displayPosts)
                                    Column(
                                      children: List.generate(
                                        displayedPosts.length,
                                        (index) {
                                          PostModel postModel =
                                              displayedPosts[index];
                                          return Column(
                                            children: [
                                              PostWidget(
                                                postModel: postModel,
                                                authorId: '',
                                                updateModel: () async {
                                                  // Consider re-fetching post details if needed
                                                  // await fetchTheNewPostUnderground(postModel);
                                                },
                                              ),
                                              if (index <
                                                  displayedPosts.length - 1)
                                                Divider(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  thickness: 1,
                                                  height: 20,
                                                ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  //**THIS IS THE VIDEO POST */
                                  if (displayedVideoPosts.isNotEmpty &&
                                      displayBrag)
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      runSpacing: 10,
                                      spacing: 10,
                                      children: List.generate(
                                          displayedVideoPosts.length, (index) {
                                        BragModel bragModel =
                                            BragModel.fromPostModel(
                                                displayedVideoPosts[index]);
                                        //LIST OF THE VIDEO THUMBNAILS
                                        return SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3 -
                                              16, // Adjusted width
                                          child: AspectRatio(
                                            aspectRatio: 96 / 135,
                                            child: CustomImageView(
                                              imagePath: bragModel.thumbnail,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      }),
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          });
        },
      ),
    );
  }

  Row _buildTags(List<String> tags) {
    return Row(
      children: tags
          .map(
            (e) => Text(
              e,
              style: TextStyle(color: linkColor),
            ),
          )
          .toList(),
    );
  }

  Color? getTagColor(String? colorString) {
    if (colorString == null) {
      return null;
    }
    List colorValueList =
        colorString.split("rgba(")[1].split(")")[0].split(",").map(
      (e) {
        if (colorString.split("rgba(")[1].split(")")[0].split(",").indexOf(e) <
            3) {
          return int.tryParse(e.trim());
        } else {
          return double.tryParse(e.trim());
        }
      },
    ).toList();

    return Color.fromRGBO(
      colorValueList[0],
      colorValueList[1],
      colorValueList[2],
      colorValueList[3],
    );
  }

  Widget _buildRow1(ProfileModel ownUser) {
    return Row(
      children: [
        profileModelG?.myAvatar != null
            ? Container(
                height: 40.w,
                width: 40.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        image: MemoryImage(profileModelG!.myAvatar!))),
              )
            : Container(
                height: 54,
                width: 54,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: CustomImageView(
                  imagePath:
                      ownUser.image ?? "assets/images/empty_avatar_icon.png",
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userModelG?.name ?? profileModelG?.name ?? 'No name',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: getFigmaColor("FFFFFF")),
            ),
            Text(
              myprofile?.occupation ?? '',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: getFigmaColor("FFFFFF")),
            ),
            Text(
              userModelG?.email ?? profileModelG?.email ?? 'No name',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: getFigmaColor("FFFFFF")),
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                getFigmaColor("006FCD"),
              ),
            ),
            onPressed: () {
              context.pushNamed(MyAppRouteConstant.editProfile);
            },
            child: Text(
              "Edit Profile",
              style: TextStyle(
                color: Colors.white,
              ),
            )),
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.more_vert,
        //     color: getFigmaColor("FFFFFF"),
        //   ),
        // )
      ],
    );
  }
}
