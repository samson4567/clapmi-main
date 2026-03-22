import 'package:clapmi/features/brag/data/models/post_model.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_bloc.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_state.dart';
import 'package:clapmi/screens/Brag/brag_components.dart';
import 'package:clapmi/Models/brag_model.dart';
import 'package:clapmi/Models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class CommentSheet extends StatefulWidget {
  final BragModel? model;
  final SingleVideoPostModel? post;

  const CommentSheet({
    super.key,
    this.model,
    this.post,
  });

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  bool? textfieldForComment;

  late BragModel model;
  // BragModel? modelwithComment;
  @override
  void initState() {
    model = widget.model!;
    print(
        "#########################################################This is the brag Model in the comment session ${widget.post?.comments.length}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BragBloc, BragState>(
      listener: (context, state) {
        if (state is CommentOnAPostSuccessState) {
          Fluttertoast.showToast(
              msg: state.message,
              backgroundColor: Colors.green,
              gravity: ToastGravity.BOTTOM);
          context.pop();
        }
        if (state is CommentOnAPostErrorState) {}
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.height * .5 - 80,
                  alignment: (model.comments?.isEmpty ?? false)
                      ? Alignment.center
                      : null,
                  //THIS IS THE WIDGET SHOWING THE LIST OF COMMENTS
                  child: SingleChildScrollView(
                    child: CommentBoxForBrags(
                      post: widget.post,
                      functionToSetTextFieldBoxForReplying: (toUnfocus) {
                        textfieldForComment = toUnfocus;
                        toUnfocus
                            ? textfieldFocusNode.unfocus()
                            : textfieldFocusNode.requestFocus();
                        if (mounted) setState(() {});
                      },
                      model: model,
                      updateModel: () async {
                        await fetchTheBragUnderground();
                        setState(() {});
                      },
                      functionToSetComentModel: (
                        cModel,
                      ) {
                        editedComment = cModel;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              //THIS IS THE TEXTFIELD
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: CommentingTextFieldForBrags(
                    isUploadingComment: textfieldForComment ?? true,
                    updateModel: () async {
                      await fetchTheBragUnderground();
                      setState(() {});
                    },
                    fnode: textfieldFocusNode,
                    bragModel: model,
                    commentModel: editedComment,
                    functionToMonitorProcessing: (isProcessing) {
                      if (textfieldForComment ?? true) {
                        isLoadingMoreComment = isProcessing;
                      } else {
                        isLoadingMoreReplies = isProcessing;
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  bool isLoadingMoreComment = false;
  bool isLoadingMoreReplies = false;

  Widget _buildSheetShimmer() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator.adaptive());
  }

  CommentModel? editedComment;
  FocusNode textfieldFocusNode = FocusNode();
  fetchTheBragUnderground() async {
    if (mounted) setState(() {});
  }

  Future<BragModel> getpostwithItsComment(BragModel model) async {
    if (model.pid == null) return model;

    return model;
  }
}
