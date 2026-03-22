import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostReportPage extends StatefulWidget {
  const PostReportPage({super.key});

  @override
  State<PostReportPage> createState() => _PostReportPageState();
}

class _PostReportPageState extends State<PostReportPage> {
  int? selectedIndex;

  final List<_ReportReason> reportReasons = [
    _ReportReason(
      title: 'Spam or Scam',
      description:
          ' Unwanted ads, fake offers, or \n anything trying to \n trick people.',
    ),
    _ReportReason(
      title: 'Bullying or Unwanted Contact',
      description: 'Harassment, threats, \nor anything making people\nunsafe.',
    ),
    _ReportReason(
      title: 'Violence or Hate',
      description:
          'Anything promoting\nviolence, hate speech \nor taking advantage of others',
    ),
    _ReportReason(
      title: 'Suicide or Self-Injury\nEating Disorders',
      description:
          'Post that suggest or\npromote self-harm\nor unhealthy behaviour.',
    ),
    _ReportReason(
      title: 'False or Misleading information',
      description: 'Content that spreads false\nor misleading facts or claims.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: const [
                  Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Report',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Question
              const Text(
                'Why are you\nreporting this post?',
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),

              // Report options
              ...reportReasons.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = entry.key;
                          });
                        },
                        child: _ReportOption(
                          reason: entry.value,
                          isSelected: selectedIndex == entry.key,
                        ),
                      ),
                    ),
                  ),
              GestureDetector(
                onTap: () {
                  context.pushNamed(MyAppRouteConstant.reportSentPage);
                },
                child: FancyContainer(
                  backgroundColor: AppColors.primaryColor,
                  isAsync: true,
                  height: 55,
                  radius: 50,
                  hasBorder: true,
                  borderColor: AppColors.primaryColor,
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportReason {
  final String title;
  final String? description;

  const _ReportReason({required this.title, this.description});
}

class _ReportOption extends StatelessWidget {
  final _ReportReason reason;
  final bool isSelected;

  const _ReportOption({
    required this.reason,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reason.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (reason.description != null) ...[
                const SizedBox(height: 6),
                Text(
                  reason.description!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          isSelected
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
          color: Colors.white,
        ),
      ],
    );
  }
}
