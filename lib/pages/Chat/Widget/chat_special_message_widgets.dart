import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/models/chat_message.dart';
import 'package:myitihas/models/chat_poll_summary.dart';
import 'package:sizer/sizer.dart';

/// In-thread poll UI (WhatsApp-style bars and percentages).
class ChatPollBubble extends StatelessWidget {
  final ChatPollPayload payload;
  final ChatPollSummary? summary;
  final bool isMe;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final void Function(int optionIndex) onOptionTap;
  final bool voteBusy;

  const ChatPollBubble({
    super.key,
    required this.payload,
    required this.summary,
    required this.isMe,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.onOptionTap,
    this.voteBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t.chat.composerAttachments;
    final total = summary?.totalVotes ?? 0;
    final myIdx = summary?.myOptionIndex;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.2.w, vertical: 1.2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            payload.question,
            style: GoogleFonts.inter(
              color: primaryTextColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          SizedBox(height: 1.h),
          ...List.generate(payload.options.length, (i) {
            final label = payload.options[i];
            final count = (summary != null && i < summary!.counts.length)
                ? summary!.counts[i]
                : 0;
            final pct = total > 0 ? count / total : 0.0;
            final selected = myIdx == i;
            return Padding(
              padding: EdgeInsets.only(bottom: 0.8.h),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: voteBusy ? null : () => onOptionTap(i),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.8.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.outlineVariant.withValues(
                                alpha: 0.65,
                              ),
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                label,
                                style: GoogleFonts.inter(
                                  color: primaryTextColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (total > 0)
                              Text(
                                '${(pct * 100).round()}%',
                                style: GoogleFonts.inter(
                                  color: secondaryTextColor,
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                        if (total > 0) ...[
                          SizedBox(height: 0.5.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct,
                              minHeight: 4,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary.withValues(
                                  alpha: 0.65,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 0.4.h),
          Text(
            total == 0
                ? t.tapToVote
                : (total == 1 ? t.voteCountOne : t.voteCount(count: total)),
            style: GoogleFonts.inter(
              color: secondaryTextColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact location card; tap handled by parent.
class ChatLocationBubble extends StatelessWidget {
  final ChatLocationPayload payload;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final String title;
  final String openMapsLabel;

  const ChatLocationBubble({
    super.key,
    required this.payload,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.title,
    required this.openMapsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final coord =
        '${payload.lat.toStringAsFixed(5)}, ${payload.lng.toStringAsFixed(5)}';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.2.w, vertical: 1.2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 28.sp,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: primaryTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  coord,
                  style: GoogleFonts.inter(
                    color: secondaryTextColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.6.h),
                Text(
                  openMapsLabel,
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
