import 'package:clapmi/Models/brag_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clapmi/features/search/presentation/blocs/search_bloc.dart'; // Add SearchBloc import
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Add Bloc import
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:async'; // for debounce
import 'package:shimmer/shimmer.dart';

class SocialGeeralSearch extends StatefulWidget {
  const SocialGeeralSearch({super.key});

  @override
  State<SocialGeeralSearch> createState() => _SocialGeeralSearchState();
}

class _SocialGeeralSearchState extends State<SocialGeeralSearch> {
  final TextEditingController _searchController = TextEditingController();
  final Duration _debounceDuration = const Duration(milliseconds: 400);
  Timer? _debounce;

  String selecetdTab = "Users"; // Default to Users tab

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  List<UserModel> filteredUserList = [];
  List<BragModel> filteredBragList = [];
  List<CreatePostModel> filteredPostList = [];

  List displayedList = [];

  bool filterBrag(BragModel bragModel) {
    return bragModel.content?.contains(_searchController.text) ?? false;
  }

  bool filterUser(UserModel userModel) {
    return ((userModel.name?.contains(_searchController.text) ?? false) ||
        (userModel.username?.contains(_searchController.text) ?? false) ||
        (userModel.email?.contains(_searchController.text) ?? false));
  }

  bool filterPost(CreatePostModel postModel) {
    return ((postModel.content?.contains(_searchController.text) ?? false) ||
        (postModel.content?.contains(_searchController.text) ?? false));
  }

  // 👇 This method handles typing suggestions with debounce
  void _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(_debounceDuration, () {
      if (text.trim().isNotEmpty) {
        context
            .read<SearchBloc>()
            .add(SearchUsersEvent(text.trim())); // triggers the search
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    buildBackArrow(context),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 46,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF181919),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged:
                                    _onSearchChanged, // 👈 Real-time search
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Search Users...",
                                  hintStyle: TextStyle(
                                      color: Colors.white.withAlpha(50)),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Keep manual Search button (optional)
                    InkWell(
                      onTap: () => context
                          .read<SearchBloc>()
                          .add(SearchUsersEvent(_searchController.text.trim())),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: const CustomText(
                          text: 'Search',
                          fontFamily: 'Geist',
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(height: 16.h),

              // 👇 Results update automatically via Bloc
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (_searchController.text.isEmpty) {
                      return _buildTrendingContent();
                    }
                    if (state is SearchLoading) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[800]!,
                        highlightColor: Colors.grey[700]!,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is SearchLoaded) {
                      if (selecetdTab == "Users") {
                        if (state.users.isEmpty) {
                          return const Center(
                            child: Text(
                              'No users found.',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: state.users.length,
                          itemBuilder: (context, index) {
                            final user = state.users[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    CachedNetworkImageProvider(user.image),
                                child: const Icon(Icons.person),
                              ),
                              title: Text(user.username,
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(user.name,
                                  style: const TextStyle(color: Colors.grey)),
                              onTap: () {
                                context.push(
                                  MyAppRouteConstant.othersAccountPage,
                                  extra: {
                                    "userId": user.pid,
                                  },
                                );
                              },
                            );
                          },
                        );
                      } else if (selecetdTab == "Posts") {
                        return const Center(
                          child: Text(
                            'Post search not implemented yet.',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (selecetdTab == "Brags") {
                        return const Center(
                          child: Text(
                            'Brag search not implemented yet.',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                    } else if (state is SearchError) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is SearchInitial) {
                      return _buildTrendingContent();
                    }
                    return _buildTrendingContent();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingContent() {
    return const Center(
      child: Text(
        'Enter a keyword to search for users',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

Widget buildBackArrow(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
    onPressed: () => Navigator.of(context).pop(),
  );
}

// Placeholder for CustomText
class CustomText extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final Color? color;
  const CustomText(
      {super.key, required this.text, this.fontFamily, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontFamily: fontFamily, color: color));
  }
}

// Placeholder for CustomImageView
class CustomImageView extends StatelessWidget {
  final String? imagePath;
  final BoxFit? fit;
  final double? height;
  final double? width;
  const CustomImageView(
      {super.key, this.imagePath, this.fit, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.network(
        imagePath!,
        fit: fit,
        height: height,
        width: width,
        errorBuilder: (context, error, stackTrace) =>
            Container(color: Colors.grey, height: height, width: width),
      );
    }
    return Container(color: Colors.grey, height: height, width: width);
  }
}

// Placeholder for PostWidget
class PostWidget extends StatelessWidget {
  final dynamic model;
  const PostWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(model?.content ?? 'Post content missing'),
      ),
    );
  }
}
