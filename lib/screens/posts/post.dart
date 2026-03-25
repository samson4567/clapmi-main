import 'package:clapmi/Models/comment_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_bloc.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/extraction.dart';
import 'package:clapmi/screens/posts/post_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PostScreen extends StatefulWidget {
  final String? postId;
  const PostScreen({super.key, this.postId});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Future<void> getpostwithItsComment(String postId) async {
    context.read<PostBloc>().add(GetSinglePostEvent(postID: postId));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getpostwithItsComment(widget.postId ?? '');
    });
    super.initState();
  }

  bool? textfieldForComment;
  FocusNode textfieldFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  CreatePostModel? postModel;
  PostModel? post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: buildBackArrow(context),
        title: const Text("Post"),
      ),
      body: BlocConsumer<PostBloc, PostState>(listener: (context, state) {
        if (state is CommentOnAPostSuccessState) {
          textfieldForComment = null;
          textfieldFocusNode.unfocus();
          context
              .read<PostBloc>()
              .add(GetSinglePostEvent(postID: widget.postId ?? ''));
        }
        if (state is GetSinglePostSuccessState) {
          postModel = CreatePostModel.fromPostModel(state.post);
          post = state.post;
        }
      }, builder: (context, state) {
        if (state is GetSinglePostErrorState) {
          return Center(
            child: Text(state.errorMessage),
          );
        }
        return post != null
            ? Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        PostWidget(
                          postModel: post!,
                          updateModel: () async {},
                          //UPDATECLAPPCOUNT
                          updatePostClappCount: (postInfo) {
                            setState(() {
                              print(
                                  "This is the post clapping event acturally ${post?.postId}is ${postInfo.claps}");
                              post?.clapCount = int.tryParse(postInfo.claps ??
                                  post?.clapCount?.toString() ??
                                  '0');
                              print(
                                  "this is the new post clap ${post?.clapCount}");
                            });
                          },
                          //THIS IS THE COMMENT COUNT
                          updatePostCommentCount: (commentCount) {
                            post?.commentCount = int.tryParse(commentCount);
                          },
                          updatePostSharedCount: (sharedCount) {
                            post?.sharedCount = int.tryParse(sharedCount);
                          },
                          authorId: '',
                        ),
                        const SizedBox(height: 20),
                        CommentBox(
                          functionToSetTextFieldBoxForReplying: () {
                            textfieldForComment = false;
                            textfieldFocusNode.requestFocus();
                            if (mounted) setState(() {});
                          },
                          model: postModel,
                          updateModel: () async {},
                          functionToSetComentModel: (cModel) {
                            editedComment = cModel;
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: CommentingTextField(
                        commentModel: editedComment,
                        fnode: textfieldFocusNode,
                        isUploadingComment: textfieldForComment ?? true,
                        updateModel: () async {},
                        postId: widget.postId ?? '',
                      ),
                    ),
                  )
                ],
              )
            : Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[700]!,
                  child: Container(
                    height: 400,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              );
      }),
    );
  }

  CommentModel? editedComment;
}
