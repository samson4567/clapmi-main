import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:flutter/material.dart';

class BuildToper extends StatelessWidget {
  const BuildToper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
