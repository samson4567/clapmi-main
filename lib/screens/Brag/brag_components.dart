import 'package:clapmi/Models/comment_model.dart';
import 'package:clapmi/Models/brag_model.dart';
import 'package:clapmi/Models/reply_model.dart';
import 'package:clapmi/features/brag/data/models/post_model.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_event.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CommentBoxForBrags extends StatefulWidget {
  final BragModel? model;
  final SingleVideoPostModel? post;
  final Function()? updateModel;
  final Function(bool toUnfocus) functionToSetTextFieldBoxForReplying;
  final Function(CommentModel commentModel) functionToSetComentModel;

  const CommentBoxForBrags({
    super.key,
    required this.model,
    this.post,
    this.updateModel,
    required this.functionToSetTextFieldBoxForReplying,
    required this.functionToSetComentModel,
  });

  @override
  State<CommentBoxForBrags> createState() => _CommentBoxForBragsState();
}

class _CommentBoxForBragsState extends State<CommentBoxForBrags> {
  List<CommentModel> displayedCommentList = [];
  bool isLoadingItem = false;

  @override
  void initState() {
    print(
        "post length in this place is the vdideo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ${widget.post?.comments.length}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (isLoadingItem) CircularProgressIndicator.adaptive(),
      SizedBox(height: 10),
      ...(List.generate(
        widget.post!.comments.length,
        (index) {
          //  return Text('$index');
          // CommentModel cmodel = displayedCommentList[index];
          return CommentForBragsWidget(
            comment: widget.post!.comments[index],
            // model: cmodel,
            updateModel: widget.updateModel ?? () {},
            functionToSetTextFieldBoxForReplying:
                widget.functionToSetTextFieldBoxForReplying,
            functionToSetComentModel: widget.functionToSetComentModel,
          );
        },
      )),
    ]);
  }
}

class ReplyBoxForBrags extends StatefulWidget {
  final CommentModel? model;
  final Function() updateModel;
  const ReplyBoxForBrags(
      {super.key, required this.model, required this.updateModel});

  @override
  State<ReplyBoxForBrags> createState() => ReplyBoxForBragsState();
}

class ReplyBoxForBragsState extends State<ReplyBoxForBrags> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...List.generate(
        widget.model?.replies?.length ?? 0,
        (index) {
          ReplyModel rmodel =
              ReplyModel.fromOnlinejson(widget.model?.replies?[index]);
          return Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * .1),
              Expanded(
                child: ReplyWidgetForBrags(
                  model: rmodel,
                  updateModel: widget.updateModel,
                ),
              ),
            ],
          );
        },
      ),
    ]);
  }
}

class CommentForBragsWidget extends StatefulWidget {
  final SinglePostComment comment;
  final Function() updateModel;
  final Function(bool toUnfocus) functionToSetTextFieldBoxForReplying;
  final Function(CommentModel commentModel) functionToSetComentModel;

  const CommentForBragsWidget({
    super.key,
    required this.updateModel,
    required this.comment,
    required this.functionToSetTextFieldBoxForReplying,
    required this.functionToSetComentModel,
  });

  @override
  State<CommentForBragsWidget> createState() => _CommentForBragsWidgetState();
}

class _CommentForBragsWidgetState extends State<CommentForBragsWidget> {
  bool rplyVisible = false;
  bool isClaped = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Main row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Avatar
              Container(
                height: 36,
                width: 36,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Image.network(
                  widget.comment.creator_image ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person, size: 20),
                ),
              ),
              const SizedBox(width: 12),

              /// Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Name + badge
                    Row(
                      children: [
                        Text(
                          widget.comment.created_name ?? "N/A",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Visibility(
                          visible: false,
                          child: Image.asset(
                            "assets/icons/Vector (11).png",
                            height: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// Comment text (FULL multiline)
                    Text(
                      widget.comment.comment ?? "N/A",
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Reaction panel
                    ReactionPanelHorizontalForComment(
                      updateModel: widget.updateModel,
                      functionToSetComentModel: widget.functionToSetComentModel,
                    ),
                  ],
                ),
              ),

              /// Clap / Like
              FancyContainer(
                isAsync: false,
                action: () {
                  setState(() => isClaped = !isClaped);
                  ScaffoldMessenger.of(context).showSnackBar(
                    generalSnackBar("reaction changed successfully"),
                  );
                },
                child: Icon(
                  isClaped ? Icons.favorite : Icons.favorite_border,
                  color: isClaped ? Colors.red : null,
                ),
              ),
            ],
          ),

          /// Reply box (like screenshot, stacked below)
          const SizedBox(height: 6),
          Visibility(
            visible: true,
            child: ReplyBoxForBrags(
              model: CommentModel(),
              updateModel: widget.updateModel,
            ),
          ),
        ],
      ),
    );
  }
}

String? ddValue;

class ReplyWidgetForBrags extends StatefulWidget {
  final ReplyModel model;

  final Function() updateModel;
  const ReplyWidgetForBrags(
      {super.key, required this.model, required this.updateModel});

  @override
  State<ReplyWidgetForBrags> createState() => _ReplyWidgetForBragsState();
}

class _ReplyWidgetForBragsState extends State<ReplyWidgetForBrags> {
  bool isClaped = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.model.authorUsername ?? "N/A",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 5),
                  Text(
                    widget.model.humanReadableDate ?? "N/A",
                    style: TextStyle(color: getFigmaColor("B5B5B5")),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                widget.model.content ?? "N/A",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CommentingTextFieldForBrags extends StatefulWidget {
  final bool isUploadingComment;
  final Function() updateModel;
  final Function(bool isProcessing) functionToMonitorProcessing;
  final BragModel bragModel;
  final FocusNode fnode;
  final CommentModel? commentModel;

  const CommentingTextFieldForBrags({
    super.key,
    required this.isUploadingComment,
    required this.updateModel,
    required this.fnode,
    required this.bragModel,
    required this.commentModel,
    required this.functionToMonitorProcessing,
  });

  @override
  State<CommentingTextFieldForBrags> createState() =>
      _CommentingTextFieldForBragsState();
}

class _CommentingTextFieldForBragsState
    extends State<CommentingTextFieldForBrags> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade900,
            width: 0.4,
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 6),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text Field Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.grey.shade800,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          onTapOutside: (event) {
                            widget.fnode.unfocus();
                            setState(() {});
                          },
                          controller: controller,
                          focusNode: widget.fnode,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: widget.isUploadingComment
                                ? "Post your reply"
                                : "Reply this comment",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.open_in_full_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              onPressed: () {
                                // expand field logic here if needed
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0.2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //THESE ARE THE INTERACTION BUTTONS
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.image_outlined),
                                  color: Colors.white.withAlpha(180),
                                  iconSize: 28,
                                  tooltip: "Add image",
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.gif_box_outlined),
                                  color: Colors.white.withAlpha(180),
                                  iconSize: 28,
                                  tooltip: "Add GIF",
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon:
                                      const Icon(Icons.emoji_emotions_outlined),
                                  color: Colors.white.withAlpha(180),
                                  iconSize: 28,
                                  tooltip: "Add emoji",
                                ),
                              ],
                            ),
                            //THIS IS THE REPLY BUTTON
                            GestureDetector(
                              onTap: () {
                                if (widget.bragModel.fromFirebase ?? false) {
                                  comentOnFirebaseBragOrReplyAcomment();
                                } else {
                                  comentOnBackendBragOrReplyAcomment(context);
                                }
                              },
                              child: Container(
                                height: 42,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Reply",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  comentOnBackendBragOrReplyAcomment(BuildContext context) async {
    widget.fnode.unfocus();

    context
        .read<BragBloc>()
        .add(CommentOnAPostEvent(controller.text, widget.bragModel.pid ?? ''));
    print(
        'This is the comment made to the backend in comment ############################');
    controller.clear();
  }

  comentOnFirebaseBragOrReplyAcomment() async {
    widget.functionToMonitorProcessing.call(true);
    widget.fnode.unfocus();
    controller.clear();
  }
}


  // TextButton(
                    //     onPressed: () {
                    //       // rplyVisible = !rplyVisible;
                    //       // widget.functionToSetComentModel
                    //       //     .call(widget.model, !rplyVisible);
                    //       // widget.functionToSetTextFieldBoxForReplying
                    //       //     .call(!rplyVisible);

                    //       setState(() {});
                    //     },
                    //     child: Text(rplyVisible ? "Hide" : "Reply"))