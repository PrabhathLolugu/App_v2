import 'package:flutter/material.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:flutter/services.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myitihas/pages/map2/app_theme.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:jiffy/jiffy.dart';
import 'comment_bloc.dart';

class CommentsScreen extends StatefulWidget {
  final String activityId;
  const CommentsScreen({Key? key, required this.activityId}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? DarkColors.bgColor : LightColors.bgColor;

    return BlocProvider(
      create: (context) => CommentBloc()..add(LoadComments(widget.activityId)),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          title: Text(
            "Comments",
            style: TextStyle(
              color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              fontSize: 16.sp,
            ),
          ),
          leading: BackButton(
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                isDark ? Colors.transparent.withOpacity(0.5) : Colors.transparent,
                DarkColors.glowPrimary.withAlpha(50),

                isDark
                    ? DarkColors.accentSecondary.withOpacity(0.1)
                    : DarkColors.glassBorder,
                isDark ? Colors.transparent.withOpacity(0.4) : Colors.transparent,
              ],
              transform: GradientRotation(2.8 / 1.8),
            ),
          ),
          child: Stack(
            children: [
              BlocBuilder<CommentBloc, CommentState>(
                builder: (context, state) {
                  if (state.isLoading)
                    return const Center(child: CircularProgressIndicator());
                  if (state.comments.isEmpty)
                    return const Center(
                      child: Text("Be the first to share your thoughts"),
                    );

                  return ListView.builder(
                    itemCount: state.threadedComments.length,
                    itemBuilder: (context, index) {
                      final comment = state.threadedComments[index];

                      final int level = comment['nesting_level'] ?? 0;

                      final int displayLevel = level > 2 ? 2 : level;

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (displayLevel > 0)
                              SizedBox(width: (displayLevel * 8).w),

                            if (displayLevel > 0) ...[
                              Container(
                                width: 1.5,
                                margin: EdgeInsets.only(bottom: 1.h, top: 1.h),
                                color: Colors.grey.withOpacity(
                                  0.3,
                                ), // Vertical thread line
                              ),
                              SizedBox(width: 3.w),
                            ],
                            Expanded(
                              child: _CommentTile(
                                comment: comment,
                                activityId: widget.activityId,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              _CommentInputBar(
                activityId: widget.activityId,
                controller: _controller,
                focusNode: _focusNode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final Map<String, dynamic> comment;
  final String activityId;
  const _CommentTile({required this.comment, required this.activityId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String timeAgo = comment['created_at'] != null
        ? Jiffy.parse(comment['created_at'].toString()).fromNow()
        : 'Just now';

    final currentUser = Supabase.instance.client.auth.currentUser;
    final bool isOwnComment = comment['user_id'] == currentUser?.id;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15.sp, // YouTube avatars are slightly smaller
            backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
            backgroundImage: NetworkImage(
              comment['user_avatar']?.toString() ??
                  "https://ui-avatars.com/api/?name=${comment['user_name']}",
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Name • Time
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                    children: [
                      TextSpan(
                        text:
                            "${comment['user_name']?.toString().replaceAll(' ', '') ?? 'pilgrim'}  ",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: timeAgo),
                    ],
                  ),
                ),

                SizedBox(height: 0.5.h),
                // Message body - Clean and readable
                Text(
                  comment['message']?.toString() ?? '',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 15.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 1.h),
                // Action Buttons: Like/Dislike/Reply
                Row(
                  children: [
                    Icon(
                      Icons.comment,
                      size: 15.sp,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: () => context.read<CommentBloc>().add(
                        SetReplyingTo(comment),
                      ),
                      child: Text(
                        "Reply",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (isOwnComment)
                      GestureDetector(
                        onTap: () => _showDeleteDialog(
                          context,
                          comment['id'].toString(),
                          activityId,
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          size: 15.sp,
                          color: Colors.redAccent.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showDeleteDialog(
  BuildContext context,
  String commentId,
  String activityId,
) {
  final bloc = context.read<CommentBloc>();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Comment?"),
      content: const Text("This will permanently remove your contribution."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            try {
              await Supabase.instance.client
                  .from('map_comments')
                  .delete()
                  .eq('id', commentId);

              // ✅ Refresh ForumCommunity count via navigation
              if (activityId.isNotEmpty && context.mounted) {
                bloc.add(LoadComments(activityId));
              }
            } catch (e) {
              debugPrint("Delete Error: $e");
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      toUserFriendlyErrorMessage(
                        e,
                        fallback:
                            'Failed to delete comment. Please try again.',
                      ),
                    ),
                  ),
                );
              }
            }
          },
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

class _CommentInputBar extends StatelessWidget {
  final String activityId;
  final TextEditingController controller;
  final FocusNode focusNode;

  const _CommentInputBar({
    required this.activityId,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withOpacity(0.8) : Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              border: Border(
                top: BorderSide(
                  color: isDark ? DarkColors.glassBorder : Colors.grey.shade200,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.replyingTo != null)
                    Row(
                      children: [
                        Icon(
                          Icons.reply,
                          size: 18.sp,
                          color: AppTheme.navigationOrange,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Replying to ${state.replyingTo!['user_name']}",
                          style: TextStyle(
                            color: AppTheme.navigationOrange,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => context.read<CommentBloc>().add(
                            ResetCommentFocus(),
                          ),
                          child: Icon(
                            Icons.cancel,
                            size: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  TextField(
                    controller: controller,
                    focusNode: focusNode,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: "Add a comment...",
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          VoiceInputButton(
                            controller: controller,
                            compact: true,
                          ),
                          IconButton(
                        icon: ShaderMask(
                          shaderCallback: (bounds) => controller.text.isEmpty
                              ? const LinearGradient(
                                  colors: [Colors.grey, Colors.grey],
                                ).createShader(bounds)
                              : DarkColors.messageUserGradient.createShader(
                                  bounds,
                                ),
                          child: const Icon(Icons.send, color: Colors.white),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _submit(context, state);
                        },
                      ),
                        ],
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submit(BuildContext context, CommentState state) async {
    if (controller.text.trim().isEmpty) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      // 1. Fetch verified profile data instead of using raw metadata
      final profileResponse = await Supabase.instance.client
          .from('profiles')
          .select('full_name, avatar_url')
          .eq('id', user.id)
          .single();

      final String displayName =
          profileResponse['full_name'] ?? 'Anonymous Pilgrim';
      final String displayAvatar =
          profileResponse['avatar_url'] ??
          "https://ui-avatars.com/api/?name=User";

      await Supabase.instance.client.from('map_comments').insert({
        'activity_id': activityId,
        'user_id': user.id,
        'user_name': displayName,
        'user_avatar': displayAvatar,
        'message': controller.text.trim(),
        'parent_id': state.replyingTo?['id'],
      });

      // 3. Clear UI state
      controller.clear();
      if (context.mounted) {
        context.read<CommentBloc>().add(ResetCommentFocus());
        FocusScope.of(context).unfocus();
        context.read<CommentBloc>().add(LoadComments(activityId)); // Refresh
      }
    } catch (e) {
      debugPrint("Submit Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Failed to send comment. Please try again.',
              ),
            ),
          ),
        );
      }
    }
  }
}
