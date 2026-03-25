import 'dart:ui';

import 'package:clapmi/Models/brag_model.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/feed.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/extraction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class BragDetailScreen extends StatefulWidget {
  final BragModel model;
  const BragDetailScreen({super.key, required this.model});

  @override
  State<BragDetailScreen> createState() => _BragDetailScreenState();
}

class _BragDetailScreenState extends State<BragDetailScreen> {
  bool showCategories = false;

  late BragModel bragModel;
  @override
  void initState() {
    bragModel = widget.model;

    super.initState();
  }

  List<BragModel> localListOfBrags = [];
  bool loadingMore = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: FutureBuilder<String?>(
                  future: () async {
                    return "done";
                  }.call(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          SizedBox(
                            child: Stack(
                              children: [
                                prepareVideo(bragModel),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10.0,
                                      left: 10.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                  child: _buildUserNugget(
                                                      bragModel)),
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                height: 60,
                                                width: 200,
                                                child: Text(
                                                  bragModel.content ?? "N/A",
                                                  maxLines: null,
                                                  softWrap: true,
                                                  overflow: TextOverflow.clip,
                                                  textWidthBasis:
                                                      TextWidthBasis.parent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0, left: 0),
                                            child: SizedBox(
                                              height: 320,
                                              child: ReactionPanelVertical(
                                                  model: bragModel),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 58.0),
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 70),
                                  child: SizedBox(child:
                                      AllFollowingCategoriesSelectorWidget(
                                    indexchangingFunction: (text) {
                                      if (text
                                          .toLowerCase()
                                          .contains("categor")) {
                                        showCategories = true;
                                      } else {
                                        showCategories = false;
                                      }
                                      setState(() {});
                                    },
                                  )),
                                )),
                          ),
                        ],
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error is \n${snapshot.error}"),
                      );
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              height: 300.h,
                              color: Colors.white,
                            ),
                            SizedBox(height: 16.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: double.infinity,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    height: 16.h,
                                    width: 200.w,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    children: List.generate(
                                      3,
                                      (index) => Container(
                                        height: 30.h,
                                        width: 60.w,
                                        margin: EdgeInsets.only(right: 8.w),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20,
                    sigmaY: 20,
                  ),
                  child: const ListTile(
                    leading: Icon(Icons.chevron_left),
                    title: Text("Post"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color col = Colors.black;

  int currentScrollIndex = 0;

  SizedBox _buildUserNugget(BragModel bragModel) {
    return SizedBox(
      child: Row(
        children: [
          Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              height: 32,
              width: 32,
              child: Image.network(
                bragModel.authorImage ?? "",
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person),
              )),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 140),
                    child: Text(
                      bragModel.author ?? "N/A",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Image.asset("assets/icons/Vector (11).png"),
                  const SizedBox(width: 5),
                  Align(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: getFigmaColor("DF7C08")),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: const Text(
                        "upcoming",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                bragModel.humanReadableDate ?? "N/A",
                style: TextStyle(color: getFigmaColor("B5B5B5")),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<BragModel> filterAwayTheNonVideoed(List<BragModel> listOfbrags) {
    listOfbrags.removeWhere(
      (element) => element.video == null,
    );
    return listOfbrags;
  }

  Widget prepareVideo(BragModel modelParam) {
    return FancyContainer(
      child: Icon(
        Icons.video_camera_back_rounded,
        color: Colors.grey,
        size: 100,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AllFollowingCategoriesSelectorWidget extends StatefulWidget {
  final Function(String) indexchangingFunction;
  const AllFollowingCategoriesSelectorWidget(
      {super.key, required this.indexchangingFunction});

  @override
  State<AllFollowingCategoriesSelectorWidget> createState() =>
      _AllFollowingCategoriesSelectorWidgetState();
}

class _AllFollowingCategoriesSelectorWidgetState
    extends State<AllFollowingCategoriesSelectorWidget> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white),
        color: Colors.black.withAlpha(100),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2,
          sigmaY: 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                selectedIndex = 1;
                widget.indexchangingFunction.call("All");
                setState(() {});
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: (selectedIndex == 1) ? Colors.white : Colors.black,
                ),
                height: 30,
                child: Text("All",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          !(selectedIndex == 1) ? Colors.white : Colors.black,
                    )),
              ),
            ),
            const SizedBox(width: 5),
            InkWell(
              onTap: () {
                selectedIndex = 2;
                widget.indexchangingFunction.call("Following");
                setState(() {});
              },
              child: Container(
                height: 30,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: (selectedIndex == 2) ? Colors.white : Colors.black,
                ),
                child: Text("Following",
                    style: TextStyle(
                      color:
                          !(selectedIndex == 2) ? Colors.white : Colors.black,
                    )),
              ),
            ),
            const SizedBox(width: 5),
            InkWell(
              onTap: () {
                selectedIndex = 3;
                widget.indexchangingFunction.call("Category");
                setState(() {});
              },
              child: Container(
                height: 30,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: (selectedIndex == 3) ? Colors.white : Colors.black,
                ),
                child: Text(
                  "Category",
                  style: TextStyle(
                    color: !(selectedIndex == 3) ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentBoxforBrag extends StatefulWidget {
  const CommentBoxforBrag({super.key});

  @override
  State<CommentBoxforBrag> createState() => _CommentBoxforBragState();
}

class _CommentBoxforBragState extends State<CommentBoxforBrag> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (index) => const CommentWidgetForBrag(),
      ),
    );
  }
}

class CommentWidgetForBrag extends StatelessWidget {
  const CommentWidgetForBrag({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        _buildTopBar(),
        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "This just made my day 🔥😂",
          ),
        ),
        const SizedBox(height: 20),
        ReactionPanelHorizontal()
      ],
    );
  }

  SizedBox _buildTopBar() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            height: 32,
            width: 32,
            child: Image.asset("assets/icons/Frame 1000002049.png"),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Zuri Jackson",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                "21hr",
                style: TextStyle(color: getFigmaColor("B5B5B5")),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset("assets/icons/Vector (11).png"),
          ),
          const Expanded(child: SizedBox()),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
        ],
      ),
    );
  }
}

void showBottomBragSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 20.h,
          left: 20.w,
          right: 20.w,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Center(
                child: Text(
                  "GiftCapcoin",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15.h),

              Center(
                child: Column(
                  children: [
                    Text(
                      "Select Team",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white24),
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Logic for selecting team blue
                          },
                          child: Container(
                            height: 40.h, // Reduced height
                            width: 140.w, // Increased width
                            decoration: BoxDecoration(
                              color: getFigmaColor("006FCD", 27),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Text(
                                "Team Blue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        GestureDetector(
                          onTap: () {
                            // Logic for selecting team red
                          },
                          child: Container(
                            height: 40.h, // Reduced height
                            width: 140.w, // Increased width
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Text(
                                "Team Red",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              Text(
                "Select Debit Wallet",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white24),
              ),
              SizedBox(height: 15.h),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,

                  fillColor: const Color(0xFF181919), // Background color
                  hintText: "et",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20), // Border radius 20
                  ),
                ),
                initialValue: null, // Default value
                items: const [
                  DropdownMenuItem(
                    value: "web3",
                    child: Text("Web 3 Wallet"),
                  ),
                  DropdownMenuItem(
                    value: "clapmi",
                    child: Text("Clapmi Wallet"),
                  ),
                ],
                onChanged: (value) {
                  // Handle wallet selection
                },
              ),
              SizedBox(height: 20.h),

              // Amount Section
              Text(
                "Amount",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white24),
              ),
              SizedBox(height: 15.h),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "20,000",
                  prefixIcon:
                      const Icon(Icons.monetization_on, color: Colors.orange),
                  filled: true,
                  fillColor: const Color(0xFF181919), // Background color
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20), // Border radius 20
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Account Password Section
              Text(
                "Account Password",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white24),
              ),
              SizedBox(height: 15.h),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "************",
                  filled: true,
                  fillColor: const Color(0xFF181919), // Background color
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20), // Border radius 20
                  ),
                ),
              ),
              SizedBox(height: 25.h),

              // Gift Button
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Logic for gifting
                    Navigator.pop(context); // Close bottom sheet
                  },
                  child: Container(
                    width: 300.w, // Made button longer
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.blue, // Blue color for the gift button
                      borderRadius:
                          BorderRadius.circular(20), // Border radius 20
                    ),
                    child: const Center(
                      child: Text(
                        "Gift",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
            ],
          ),
        ),
      );
    },
  );
}

class BragWidget extends StatefulWidget {
  final Widget? image;
  final BragModel bragModel;

  const BragWidget({super.key, this.image, required this.bragModel});

  @override
  State<BragWidget> createState() => _BragWidgetState();
}

class _BragWidgetState extends State<BragWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(),
        SizedBox(
          height: MediaQuery.of(context).size.height * .8,
          child: Stack(
            children: [
              widget.image ??
                  Image.asset(
                    "assets/icons/anime-boy 1 (1).png",
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: 90,
                  height: 250,
                  child: ReactionPanelVertical(
                    model: widget.bragModel,
                  ),
                ),
              ),
              const Align(
                  alignment: Alignment.bottomLeft, child: Text("24k Views")),
            ],
          ),
        ),
        Container(
          height: 60,
          width: double.infinity,
          color: AppColors.backgroundColor,
          child: const Text("Lorem Ipsum is simply dummy text of more... "),
        ),
      ],
    );
  }

  SizedBox _buildTopBar() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            height: 32,
            width: 32,
            child: Image.asset("assets/icons/Frame 1000002049.png"),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Zuri Jackson",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                "21hr",
                style: TextStyle(color: getFigmaColor("B5B5B5")),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Align(
            alignment: Alignment.center,
            child: Image.asset("assets/icons/Vector (11).png"),
          ),
          const SizedBox(width: 10),
          Align(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: getFigmaColor("DF7C08")),
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Text(
                "upcoming",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
        ],
      ),
    );
  }
}
