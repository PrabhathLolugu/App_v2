import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/cache/widgets/story_image.dart';
import 'package:myitihas/features/story_generator/presentation/bloc/story_generator_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class HistoryBottomSheet extends StatelessWidget {
  const HistoryBottomSheet({super.key});

  static Future<void> show(BuildContext context) async {
    final bloc = context.read<StoryGeneratorBloc>();
    bloc.add(const StoryGeneratorEvent.loadHistory());
    await Future.delayed(Duration(milliseconds: 100));
    if (!context.mounted) return;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          BlocProvider.value(value: bloc, child: const HistoryBottomSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Trigger history load when sheet is opened
    context.read<StoryGeneratorBloc>().add(
      const StoryGeneratorEvent.loadHistory(),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Your Stories',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: BlocBuilder<StoryGeneratorBloc, StoryGeneratorState>(
              builder: (context, state) {
                if (state.isLoadingHistory) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.history.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_stories_rounded,
                          size: 64.sp,
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No stories generated yet',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  itemCount: state.history.length + (state.hasMoreHistory ? 1 : 0),
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    if (index == state.history.length) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: state.isLoadingHistory
                              ? const CircularProgressIndicator()
                              : TextButton(
                                  onPressed:
                                      () => context
                                          .read<StoryGeneratorBloc>()
                                          .add(
                                            const StoryGeneratorEvent
                                                .loadHistory(loadMore: true),
                                          ),
                                  child: Text(
                                    'Load More',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                        ),
                      );
                    }
                    final story = state.history[index];
                    return GestureDetector(
                      onTap: () {
                        context.pop();
                        StoryDetailRoute(id: story.id).push(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: story.imageUrl == null
                                  ? Icon(
                                      Icons.image_not_supported_rounded,
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.5,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: StoryImage(
                                        imageUrl: story.imageUrl,
                                        fit: BoxFit.cover,
                                        width: 60.w,
                                        height: 60.w,
                                        memCacheWidth: 200,
                                        memCacheHeight: 200,
                                      ),
                                    ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    story.title,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    story.scripture,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    story.updatedAt != null
                                        ? timeago.format(story.updatedAt!)
                                        : 'Just now',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14.sp,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
