import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/feed.dart';
import 'package:flutter/material.dart';

class PostImageScreen extends StatefulWidget {
  const PostImageScreen({super.key});

  @override
  State<PostImageScreen> createState() => _PostImageScreenState();
}

class _PostImageScreenState extends State<PostImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.chevron_left),
        title: const Text("Post"),
      ),
      body: Column(
        children: [
          Expanded(
              child:
                  Image.asset("assets/icons/Jesus on the street 2@1.5x 1.png")),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class CommentBox extends StatefulWidget {
  const CommentBox({super.key});

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (index) => const CommentWidget(),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key});

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
          IconButton(
              onPressed: () {},
              icon: GestureDetector(child: const Icon(Icons.more_horiz)))
        ],
      ),
    );
  }
}
