import 'package:clapmi/features/onboarding/data/models/interest_category_model.dart';
import 'package:clapmi/features/onboarding/domain/entities/interest_entity.dart';
import 'package:clapmi/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:clapmi/global_object_folder_jacket/global_classes/global_classes.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/global_object_folder_jacket/routes/api_route.config.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BuildYourFeedScreen extends StatefulWidget {
  const BuildYourFeedScreen({super.key});

  @override
  State<BuildYourFeedScreen> createState() => _BuildYourFeedScreenState();
}

class _BuildYourFeedScreenState extends State<BuildYourFeedScreen> {
  @override
  void initState() {
    context.read<OnboardingBloc>().add(LoadInterestEvent());
    super.initState();
  }

  List<InterestCategoryModel> listOFInterestCategoryModel = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        leading: TextButton(
          onPressed: () {
            context.goNamed(MyAppRouteConstant.connectWithUserScreen);
          },
          child: const Text("Skip"),
        ),
        actions: [
          BlocConsumer<OnboardingBloc, OnboardingState>(
              listener: (context, state) {
            if (state is SaveInterestsErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                generalSnackBar(state.errorMessage),
              );
            }
            if (state is LoadInterestSuccessState) {
              listOFInterestCategoryModel = state.interestCategories;
            }

            if (state is SaveInterestsSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                generalSnackBar(state.message),
              );
              context.pushNamed(MyAppRouteConstant.connectWithUserScreen);
            }
          }, builder: (context, state) {
            return TextButton(
              onPressed: () async {
                context.read<OnboardingBloc>().add(SaveInterestsEvent(
                    interestIDs: selectedInterests
                        .map(
                          (e) => e.interest,
                        )
                        .toList()));
              },
              child: const Text("Continue"),
            );
          }),
        ],
      ),
      backgroundColor: Colors.black45,
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is LoadInterestErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              generalSnackBar(state.errorMessage),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadInterestLoadingState) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if (state is LoadInterestErrorState) {
            return Center(
              child: Text("An Error has occured"),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Build Your Feed",
                  style: titleStyle,
                ),
                Text(
                  "Select at least three (3) interests to continue",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(.56),
                  ),
                ),
                const SizedBox(height: 50),
                Column(
                  children: listOFInterestCategoryModel
                      .map((e) => _buildCategoryAndTagsOFTheCategory(e))
                      .toList(),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Column _buildCategoryAndTagsOFTheCategory(
      InterestCategoryModel tagCategoryModel) {
    return Column(
      children: [
        _buildCategoryHeader(tagCategoryModel.title),
        _buildCategoryTagsList(tagCategoryModel.interests.map(
              (interestModel) {
                return interestModel;
              },
            ).toList() ??
            []),
      ],
    );
  }

  Wrap _buildCategoryTagsList(List<InterestEntity> tags) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: tags
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: RadioButton(
                text: e.title,
                onclick: (text) {
                  if (!selectedInterests.contains(text)) {
                    selectedInterests.add(e);
                  } else {
                    selectedInterests.remove(text);
                  }
                },
              ),
            ),
          )
          .toList(),
    );
  }

  Align _buildCategoryHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(.56)),
      ),
    );
  }

  List<InterestEntity> selectedInterests = [];
}

class RadioButton extends StatefulWidget {
  final String text;
  final Function(String text) onclick;

  const RadioButton({
    super.key,
    required this.text,
    required this.onclick,
  });

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isSelected = !isSelected;
        widget.onclick(widget.text);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: (!isSelected)
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.white),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.white),
                color: AppColors.primaryColor),
        child: Text(
          widget.text,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
