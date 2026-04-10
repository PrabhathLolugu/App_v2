import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Enum for replan strategy
enum ReplanStrategy {
  fullRegenerate('FULL_REGENERATE'),
  surgicalModify('SURGICAL_MODIFY');

  const ReplanStrategy(this.id);

  final String id;
}

/// Modal for replanning a travel plan with user feedback
/// Two-step flow: Strategy selection -> Feedback input
class PlanReplanModal extends StatefulWidget {
  const PlanReplanModal({
    super.key,
    required this.originalPlan,
    required this.fromLocation,
    required this.startDate,
    required this.endDate,
    required this.destinationName,
    this.destinationContext,
    this.onReplanInit,
    this.onReplanSuccess,
    this.onReplanError,
  });

  final String originalPlan;
  final String fromLocation;
  final String startDate;
  final String endDate;
  final String destinationName;
  final String? destinationContext;
  final Function(ReplanStrategy strategy)? onReplanInit;
  final Function(String newPlan, String changeSummary)? onReplanSuccess;
  final Function(String error)? onReplanError;

  @override
  State<PlanReplanModal> createState() => _PlanReplanModalState();
}

class _PlanReplanModalState extends State<PlanReplanModal> {
  late PageController _pageController;
  int _currentStep = 0; // 0: Strategy selection, 1: Feedback input
  ReplanStrategy? _selectedStrategy;
  final _feedbackController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _handleReplan() async {
    if (_selectedStrategy == null || _feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a strategy and enter feedback'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    widget.onReplanInit?.call(_selectedStrategy!);
    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'replan-travel-plan',
        body: {
          'originalPlan': widget.originalPlan,
          'userFeedback': _feedbackController.text.trim(),
          'mode': _selectedStrategy!.id,
          'fromLocation': widget.fromLocation,
          'startDate': widget.startDate,
          'endDate': widget.endDate,
          'destinationName': widget.destinationName,
          'destinationContext': widget.destinationContext,
        },
      );

      if (response.data != null && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        final newPlan = data['plan'] as String?;
        final changeSummary = data['changeSummary'] as String?;

        if (newPlan != null && newPlan.isNotEmpty) {
          widget.onReplanSuccess?.call(
            newPlan,
            changeSummary ?? 'Plan modified successfully',
          );

          if (mounted) {
            Navigator.of(context).pop({
              'newPlan': newPlan,
              'changeSummary': changeSummary,
              'strategy': _selectedStrategy == ReplanStrategy.fullRegenerate
                  ? t.plan.fullRegenerate
                  : t.plan.surgicalModify,
              'feedback': _feedbackController.text.trim(),
            });
          }
        } else {
          throw Exception('Empty plan returned from server');
        }
      } else {
        throw Exception('Invalid response from server');
      }
    } catch (e) {
      widget.onReplanError?.call(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _goToNextStep() {
    if (_selectedStrategy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a strategy'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentStep = 1);
  }

  void _goToPreviousStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentStep = 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final colorScheme = theme.colorScheme;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 70.h,
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.plan.replanWithAi,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.sp),
                  Text(
                    '${_currentStep + 1} / 2',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Step 1: Strategy Selection
                  _buildStrategySelectionStep(context),
                  // Step 2: Feedback Input
                  _buildFeedbackInputStep(context),
                ],
              ),
            ),
            // Buttons
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: Row(
                children: [
                  if (_currentStep == 1)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _goToPreviousStep,
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentStep == 1) SizedBox(width: 12.sp),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : (_currentStep == 0 ? _goToNextStep : _handleReplan),
                      child: _isLoading
                          ? SizedBox(
                              height: 20.sp,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _currentStep == 0 ? 'Next' : 'Replan Now',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrategySelectionStep(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                  Text(
                    t.plan.replanWithAi,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.sp),
          Text(
            'Choose a strategy that best fits your needs:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 20.sp),
          // Full Regenerate Option
          _buildStrategyCard(
            context,
            strategy: ReplanStrategy.fullRegenerate,
            title: t.plan.fullRegenerate,
            description: 'Create a completely new plan from scratch with your feedback',
            icon: Icons.refresh,
            isSelected: _selectedStrategy == ReplanStrategy.fullRegenerate,
            onTap: () {
              setState(() => _selectedStrategy = ReplanStrategy.fullRegenerate);
            },
          ),
          SizedBox(height: 12.sp),
          // Surgical Modify Option
          _buildStrategyCard(
            context,
            strategy: ReplanStrategy.surgicalModify,
            title: t.plan.surgicalModify,
            description: 'Keep what works, update only the affected parts',
            icon: Icons.edit,
            isSelected: _selectedStrategy == ReplanStrategy.surgicalModify,
            onTap: () {
              setState(() => _selectedStrategy = ReplanStrategy.surgicalModify);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyCard(
    BuildContext context, {
    required ReplanStrategy strategy,
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? primaryColor : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? primaryColor.withValues(alpha: 0.08)
              : colorScheme.surface,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? primaryColor
                    : colorScheme.onSurface.withValues(alpha: 0.12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : colorScheme.onSurface,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.sp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? primaryColor : null,
                    ),
                  ),
                  SizedBox(height: 4.sp),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Radio<ReplanStrategy>(
              value: strategy,
              groupValue: _selectedStrategy,
              onChanged: (_) => onTap(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackInputStep(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell us what you\'d like to change',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.sp),
          Text(
            'Describe the changes or adjustments you want. Examples:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 8.sp),
          ...[
            '• "Can\'t visit Place A, skip it"',
            '• "Add 2 more days for hiking"',
            '• "Prefer train over flight"',
            '• "Include nearby temples"',
          ].map((e) => Padding(
                padding: EdgeInsets.only(bottom: 6.sp),
                child: Text(
                  e,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )),
          SizedBox(height: 14.sp),
          TextField(
            controller: _feedbackController,
            maxLines: 5,
            minLines: 4,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: 'Enter your feedback here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              contentPadding: EdgeInsets.all(12.sp),
            ),
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 12.sp),
          Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: colorScheme.primary,
                  size: 18.sp,
                ),
                SizedBox(width: 8.sp),
                Expanded(
                  child: Text(
                    'Strategy: ${_selectedStrategy == ReplanStrategy.fullRegenerate ? t.plan.fullRegenerate : t.plan.surgicalModify}. This will ${_selectedStrategy == ReplanStrategy.fullRegenerate ? 'create a completely new plan' : 'update only the affected sections'}.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                    ),
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
