import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/widgets/markdown/markdown.dart';
import 'package:myitihas/pages/map2/widgets/custom_image_widget.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/plan/booking_operator.dart';
import 'package:myitihas/pages/map2/plan/booking_operator_button.dart';
import 'package:myitihas/pages/map2/plan/travel_booking_config.dart';
import 'package:sizer/sizer.dart';

/// Parses markdown plan into sections by ### headings.
List<({String title, String content})> parsePlanSections(String plan) {
  final trimmed = plan.trim();
  if (trimmed.isEmpty) return [];

  final sections = trimmed.split(RegExp(r'\n(?=#{2,3}\s)'));
  final result = <({String title, String content})>[];

  for (final section in sections) {
    final block = section.trim();
    if (block.isEmpty) continue;

    final lines = block.split('\n');
    String title = 'Overview';
    String content = block;

    final headingMatch =
        RegExp(r'^#{2,3}\s*\*{0,2}(.+?)\*{0,2}\s*$').firstMatch(lines.first);
    if (headingMatch != null) {
      title = headingMatch.group(1)?.trim() ?? 'Section';
      content = lines.length > 1 ? lines.sublist(1).join('\n').trim() : '';
    }

    result.add((title: title.isEmpty ? 'Section' : title, content: content));
  }

  if (result.isEmpty) {
    return [(title: 'Overview', content: trimmed)];
  }
  return result;
}

IconData iconForSectionTitle(String title) {
  final lower = title.toLowerCase();
  if (lower.contains('getting there') ||
      lower.contains('travel') ||
      lower.contains('how to reach') ||
      lower.contains('transport')) {
    return Icons.directions_transit_rounded;
  }
  if (lower.contains('itinerary') ||
      lower.contains('day-by-day') ||
      lower.contains('suggested') ||
      lower.contains('schedule')) {
    return Icons.calendar_month_rounded;
  }
  if (lower.contains('nearby') ||
      lower.contains('temples') ||
      lower.contains('sacred sites') ||
      lower.contains('holy places')) {
    return Icons.temple_hindu_rounded;
  }
  if (lower.contains('what to do') ||
      lower.contains('activities') ||
      lower.contains('darshan') ||
      lower.contains('rituals')) {
    return Icons.handshake_rounded;
  }
  if (lower.contains('tips') ||
      lower.contains('practical') ||
      lower.contains('advice')) {
    return Icons.lightbulb_outline_rounded;
  }
  if (lower.contains('overview') ||
      lower.contains('introduction') ||
      lower.contains('spiritual pilgrimage')) {
    return Icons.auto_awesome_rounded;
  }
  return Icons.info_outline_rounded;
}

/// Reusable widget to display a pilgrimage plan in the same format as Plan tab.
class PlanContentView extends StatelessWidget {
  const PlanContentView({
    super.key,
    required this.plan,
    this.destinationName,
    this.destinationRegion,
    this.destinationImage,
    this.daysCount,
    this.onCopy,
    this.onEdit,
    this.onSave,
    this.onAskGuide,
    this.onReplan,
    this.isEditMode = false,
    this.editController,
    this.onPlanChanged,
    this.isSaving = false,
    this.travelModes = const [],
    this.fromLocation,
    this.startDate,
    this.endDate,
  });

  final String plan;
  final String? destinationName;
  final String? destinationRegion;
  final String? destinationImage;
  final int? daysCount;
  final VoidCallback? onCopy;
  final VoidCallback? onEdit;
  final VoidCallback? onSave;
  final VoidCallback? onAskGuide;
  final VoidCallback? onReplan;
  final bool isEditMode;
  final TextEditingController? editController;
  final VoidCallback? onPlanChanged;
  final bool isSaving;
  final List<TravelMode> travelModes;
  final String? fromLocation;
  final String? startDate;
  final String? endDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();
    final isDark = theme.brightness == Brightness.dark;
    final contentBg = gradients?.glassCardBackground ??
        colorScheme.surface.withValues(alpha: isDark ? 0.5 : 0.85);
    final contentBorder = gradients?.glassCardBorder ??
        colorScheme.primary.withValues(alpha: 0.12);

    final displayPlan = isEditMode && editController != null
        ? editController!.text
        : plan;
    final sections = parsePlanSections(displayPlan);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CustomImageWidget(
            imageUrl: destinationImage,
            width: double.infinity,
            height: 20.h,
            fit: BoxFit.cover,
            useSacredPlaceholder: true,
            sacredPlaceholderSeed:
                '${destinationName ?? "destination"}-${destinationRegion ?? ""}-${daysCount ?? ""}',
            semanticLabel: destinationName ?? 'Destination',
          ),
        ),
        SizedBox(height: 1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your pilgrimage plan',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onAskGuide != null)
              IconButton(
                icon: const Icon(Icons.support_agent_rounded, size: 22),
                tooltip: 'Ask guide',
                onPressed: onAskGuide,
              ),
          ],
        ),
        SizedBox(height: 1.h),
        if (destinationName != null || daysCount != null) ...[
          Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: contentBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: contentBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(1.2.w),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.temple_hindu_rounded,
                    size: 24,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (destinationName != null)
                        Text(
                          '${destinationName ?? ''}${destinationRegion != null ? ' ($destinationRegion)' : ''}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      if (daysCount != null)
                        Text(
                          '$daysCount days',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (onCopy != null || onEdit != null || onSave != null || onReplan != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onCopy != null)
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 20),
                          tooltip: 'Copy plan',
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: displayPlan),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Plan copied to clipboard'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            onCopy?.call();
                          },
                        ),
                      if (onEdit != null)
                        IconButton(
                          icon: Icon(
                            isEditMode ? Icons.edit_off_rounded : Icons.edit_rounded,
                            size: 20,
                          ),
                          tooltip: isEditMode ? 'Cancel edit' : 'Edit plan',
                          onPressed: onEdit,
                        ),
                      if (onSave != null)
                        IconButton(
                          icon: isSaving
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onSurface,
                                  ),
                                )
                              : const Icon(Icons.save_rounded, size: 20),
                          tooltip: 'Save plan',
                          onPressed: isSaving ? null : onSave,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
        // Quick Bookings Section
        if (!isEditMode && travelModes.isNotEmpty) ...[
          _buildQuickBookingsSection(
            context,
            theme,
            colorScheme,
            contentBg,
            contentBorder,
          ),
        ],
        if (isEditMode && editController != null) ...[
          SizedBox(height: 1.h),
          TextField(
            controller: editController,
            maxLines: 20,
            minLines: 10,
            decoration: InputDecoration(
              hintText: 'Edit your plan...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: contentBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: contentBg,
            ),
            onChanged: (_) => onPlanChanged?.call(),
          ),
        ] else if (sections.length > 1)
          ...sections.map(
            (s) => _buildSectionCard(
              title: s.title,
              content: s.content,
              icon: iconForSectionTitle(s.title),
              theme: theme,
              colorScheme: colorScheme,
              contentBg: contentBg,
              contentBorder: contentBorder,
              gradients: gradients,
            ),
          )
        else if (sections.isNotEmpty)
          _buildSectionCard(
            title: sections.first.title,
            content: sections.first.content,
            icon: iconForSectionTitle(sections.first.title),
            theme: theme,
            colorScheme: colorScheme,
            contentBg: contentBg,
            contentBorder: contentBorder,
            gradients: gradients,
          ),
        if (!isEditMode && onReplan != null) ...[
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.refresh_rounded),
              label: Text(t.plan.replanWithAi),
              onPressed: onReplan,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Build Quick Bookings section showing travel mode operators
  Widget _buildQuickBookingsSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Color contentBg,
    Color contentBorder,
  ) {
    final modesGrouped = <TravelMode, List<BookingOperator>>{};
    for (final mode in travelModes) {
      modesGrouped[mode] = TravelBookingConfig.getOperatorsForMode(mode);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: contentBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: contentBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(1.2.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_offer_rounded,
                  size: 22,
                  color: Color(0xFF4CAF50),
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                t.plan.quickBookings,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...modesGrouped.entries.map((entry) {
            final mode = entry.key;
            final operators = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: 1.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${mode.emoji} ${_travelModeLabel(t, mode)}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: operators
                          .map(
                            (op) => Padding(
                              padding: EdgeInsets.only(right: 2.w),
                              child: BookingOperatorButton(
                                operator: op,
                                fromLocation: fromLocation,
                                toLocation: destinationName,
                                departDate: startDate,
                                returnDate: endDate,
                                compact: false,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _travelModeLabel(Translations t, TravelMode mode) {
    switch (mode) {
      case TravelMode.train:
        return t.plan.travelModeTrain;
      case TravelMode.flight:
        return t.plan.travelModeFlight;
      case TravelMode.bus:
        return t.plan.travelModeBus;
      case TravelMode.hotel:
        return t.plan.travelModeHotel;
      case TravelMode.car:
        return t.plan.travelModeCar;
    }
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required Color contentBg,
    required Color contentBorder,
    GradientExtension? gradients,
  }) {
    final useExpandable = content.length > 500;
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.fromLTRB(4.w, 4.w, 4.w, 4.w),
      decoration: BoxDecoration(
        color: contentBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: contentBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: (gradients?.electricGlow ?? colorScheme.primary)
                .withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(1.2.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 22, color: colorScheme.primary),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          useExpandable
              ? ExpandableMarkdown(
                  data: preprocessMarkdown(content),
                  maxCollapsedLength: 500,
                  showDropCap: false,
                  readMoreText: 'read more',
                  readLessText: 'read less',
                  selectable: true,
                  toggleButtonStyle: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : AppMarkdownBody(
                  data: preprocessMarkdown(content),
                  selectable: true,
                ),
        ],
      ),
    );
  }
}
