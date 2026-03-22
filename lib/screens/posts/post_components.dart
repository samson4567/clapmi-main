import 'package:clapmi/Models/comment_model.dart';
import 'package:clapmi/Models/reply_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/feed.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentBox extends StatefulWidget {
  final CreatePostModel? model;
  final Function()? updateModel;
  final Function() functionToSetTextFieldBoxForReplying;
  final Function(CommentModel commentModel) functionToSetComentModel;

  const CommentBox({
    super.key,
    required this.model,
    this.updateModel,
    required this.functionToSetTextFieldBoxForReplying,
    required this.functionToSetComentModel,
  });

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  bool isLoadingItem = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...List.generate(
        widget.model?.comments?.length ?? 0,
        (index) {
          CommentModel cmodel = CommentModel.fromPostComment(
              widget.model?.comments?.reversed.toList()[index]);
          return CommentWidget(
            model: cmodel,
            updateModel: widget.updateModel ?? () {},
            functionToSetTextFieldBoxForReplying:
                widget.functionToSetTextFieldBoxForReplying,
            functionToSetComentModel: widget.functionToSetComentModel,
          );
        },
      ).animate().slideY(begin: -0.5),
    ]);
  }
}

class ReplyBox extends StatefulWidget {
  final CommentModel? model;
  final Function() updateModel;
  const ReplyBox({super.key, required this.model, required this.updateModel});

  @override
  State<ReplyBox> createState() => ReplyBoxState();
}

class ReplyBoxState extends State<ReplyBox> {
  bool isLoadingItem = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(
          widget.model?.replies?.length ?? 0,
          (index) {
            ReplyModel rmodel =
                ReplyModel.fromOnlinejson(widget.model?.replies?[index]);
            return Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * .1),
                Expanded(
                  child: ReplyWidget(
                    model: rmodel,
                    updateModel: widget.updateModel,
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}

class CommentWidget extends StatefulWidget {
  final CommentModel model;
  final Function() updateModel;
  final Function() functionToSetTextFieldBoxForReplying;
  final Function(CommentModel commentModel) functionToSetComentModel;

  const CommentWidget({
    super.key,
    required this.model,
    required this.updateModel,
    required this.functionToSetTextFieldBoxForReplying,
    required this.functionToSetComentModel,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool rplyVisible = false;
  @override
  Widget build(BuildContext context) {
    return FancyContainer(
      child: Column(
        children: [
          FancyContainer(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 8),
                  child: Text(
                    widget.model.content ?? "N/A",
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: getFigmaColor("FFFFFF")),
                  ),
                ),
                // const SizedBox(height: 10),
                ReactionPanelHorizontalForComment(
                  model: widget.model,
                  updateModel: widget.updateModel,
                  functionToSetTextFieldBoxForReplying:
                      widget.functionToSetTextFieldBoxForReplying,
                  functionToSetComentModel: widget.functionToSetComentModel,
                ),

                Visibility(
                    visible: rplyVisible,
                    child: ReplyBox(
                      model: widget.model,
                      updateModel: widget.updateModel,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.only(left: 2, right: 4),
      //  height: 50.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: getFigmaColor("006FCD"), shape: BoxShape.circle),
            height: 32.w,
            width: 32.w,
            child: Image.network(
              widget.model.authorImage ?? "",
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  //THE USERNAME OF THE COMMENTER
                  Text(
                    widget.model.authorUsername ?? "N/A",
                    style: TextStyle(
                        fontFamily: 'Lato',
                        color: getFigmaColor("FFFFFF"),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4),
                ],
              ),
              Text(
                widget.model.humanReadableDate ?? "N/A",
                style: TextStyle(
                    fontFamily: 'Lato',
                    color: getFigmaColor("B5B5B5"),
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const Expanded(child: SizedBox()),
          DropdownButtonHideUnderline(
              child: DropdownButton2(
            dropdownStyleData: DropdownStyleData(width: 200),
            customButton: Icon(
              Icons.more_horiz,
              color: getFigmaColor("8C8C8C"),
            ),
            items: [
              DropdownMenuItem(
                value: "See replies",
                onTap: () {
                  if (ddValue != "See replies") {
                    ddValue = "See replies";
                  } else {
                    ddValue = null;
                  }
                  rplyVisible = !rplyVisible;
                  setState(() {});
                },
                child: Text(
                  (ddValue != "See replies") ? "See replies" : "Hide replies",
                ),
              )
            ],
            value: ddValue,
            onChanged: (value) {},
          ))
        ],
      ),
    );
  }

  String? ddValue;
}

class ReplyWidget extends StatelessWidget {
  final ReplyModel model;

  final Function() updateModel;
  const ReplyWidget(
      {super.key, required this.model, required this.updateModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(context),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            model.content ?? "N/A",
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  SizedBox _buildTopBar(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    model.authorUsername ?? "N/A",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4),
                  Visibility(
                    visible: false,
                    child: Image.asset(
                      "assets/icons/Vector (11).png",
                    ),
                  ),
                ],
              ),
              Text(
                model.humanReadableDate ?? "N/A",
                style: TextStyle(color: getFigmaColor("B5B5B5")),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class CommentingTextField extends StatefulWidget {
  final bool isUploadingComment;
  final Function() updateModel;
  final String postId;
  final FocusNode fnode;
  final CommentModel? commentModel;

  const CommentingTextField({
    super.key,
    required this.isUploadingComment,
    required this.updateModel,
    required this.fnode,
    required this.postId,
    required this.commentModel,
  });

  @override
  State<CommentingTextField> createState() => _CommentingTextFieldState();
}

class _CommentingTextFieldState extends State<CommentingTextField> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Listen for text changes so we can update button color
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = controller.text.trim().isNotEmpty;

    return Container(
      width: 408.w,
      height: 130.h,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E0E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text Field
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF161616),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TextField(
              controller: controller,
              focusNode: widget.fnode,
              maxLines: 1,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              onTapOutside: (event) {
                widget.fnode.unfocus();
                setState(() {});
              },
              onSubmitted: (value) async {
                widget.fnode.unfocus();
                String typedString = controller.text.trim();
                if (typedString.isNotEmpty) {
                  context
                      .read<PostBloc>()
                      .add(CommentOnAPostEvent(typedString, widget.postId));
                }
              },
              decoration: InputDecoration(
                hintText: "Post your reply",
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 15.5,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                suffixIcon: const Icon(
                  Icons.open_in_full_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Bottom Row
          Row(
            children: [
              Row(
                children: const [
                  Icon(Icons.image_outlined, color: Colors.white70, size: 22),
                  SizedBox(width: 14),
                  Icon(Icons.gif_box_outlined, color: Colors.white70, size: 22),
                  SizedBox(width: 14),
                  Icon(Icons.emoji_emotions_outlined,
                      color: Colors.white70, size: 22),
                ],
              ),
              const Spacer(),
              BlocConsumer<PostBloc, PostState>(
                listener: (context, state) {
                  if (state is CommentOnAPostSuccessState) {
                    controller.clear();
                    context
                        .read<PostBloc>()
                        .add(GetSinglePostEvent(postID: widget.postId));
                  }
                  if (state is CommentOnAPostErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(generalSnackBar(state.errorMessage));
                  }
                },
                builder: (context, state) {
                  final isLoading = state is CommentOnAPostLoadingState;

                  return GestureDetector(
                    onTap: () {
                      if (isLoading) return;

                      widget.fnode.unfocus();
                      String typedString = controller.text.trim();

                      if (typedString.isNotEmpty) {
                        context.read<PostBloc>().add(
                            CommentOnAPostEvent(typedString, widget.postId));
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isLoading
                            ? Colors.grey[700]
                            : hasText
                                ? Color(0XFF003D71) // Blue when text is present
                                : Colors.grey[700], // Grey when empty
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Reply",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
