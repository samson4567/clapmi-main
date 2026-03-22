import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Society extends StatefulWidget {
  const Society({super.key});

  @override
  State<Society> createState() => _SocietyState();
}

class _SocietyState extends State<Society> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: buildBackArrow(context),
      ),
      body: SafeArea(
          child: Center(
        child: comingSoonWidget.animate().scale(
              begin: Offset(1.5, 1.5),
              duration: Duration(milliseconds: 500),
            ),
      )),
    );
  }
}
