import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/pages/Chat/Widget/share_to_conversation_sheet.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';
import 'package:myitihas/pages/map2/plan/booking_operator.dart';
import 'package:myitihas/pages/map2/plan/plan_replan_modal.dart';
import 'package:myitihas/pages/map2/plan/plan_content_view.dart';
import 'package:myitihas/pages/map2/plan/saved_travel_plan.dart';
import 'package:myitihas/pages/map2/plan/travel_mode_extractor.dart';
import 'package:myitihas/pages/map2/widgets/custom_app_bar.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Full-screen view of a saved travel plan with edit and save.
class SavedPlanDetailPage extends StatefulWidget {
  const SavedPlanDetailPage({super.key, required this.plan});

  final SavedTravelPlan plan;

  @override
  State<SavedPlanDetailPage> createState() => _SavedPlanDetailPageState();
}

class _SavedPlanDetailPageState extends State<SavedPlanDetailPage> {
  late SavedTravelPlan _plan;
  late TextEditingController _editController;
  bool _isEditMode = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _plan = widget.plan;
    _editController = TextEditingController(text: widget.plan.plan);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  Future<void> _savePlan() async {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) return;

    final planText = _isEditMode ? _editController.text.trim() : _plan.plan;
    if (planText.isEmpty) return;

    final updatedTravelModes = TravelModeExtractor.extractTravelModes(planText)
        .map((mode) => mode.id)
        .toList();

    setState(() => _isSaving = true);
    try {
      final updatedPlan = _plan.withUpdatedPlan(
        newPlanText: planText,
        changeNotes: _isEditMode ? 'Manual edit' : 'Plan update',
        updatedTravelModes: updatedTravelModes,
      );

      await Supabase.instance.client.from('saved_travel_plans').update({
        ...updatedPlan.toMap(),
      }).eq('id', _plan.id).eq('user_id', userId);

      setState(() {
        _plan = updatedPlan;
        _isEditMode = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plan updated'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.plan.failedToUpdatePlan(error: e.toString())),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deletePlan() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.plan.deletePlanConfirm),
        content: Text(t.plan.thisPlanPermanentlyDeleted),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.common.delete, style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await Supabase.instance.client
          .from('saved_travel_plans')
          .delete()
          .eq('id', _plan.id)
          .eq('user_id', SupabaseService.client.auth.currentUser!.id);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.plan.planDeleted),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.plan.failedToDeletePlan(error: e.toString())),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleReplan() {
    showDialog(
      context: context,
      builder: (dialogContext) => PlanReplanModal(
        originalPlan: _plan.plan,
        fromLocation: _plan.fromLocation ?? 'Your location',
        startDate: _plan.startDate?.toIso8601String().split('T').first ?? '',
        endDate: _plan.endDate?.toIso8601String().split('T').first ?? '',
        destinationName: _plan.destinationName ?? 'Destination',
        destinationContext: _plan.destinationRegion,
        onReplanSuccess: (newPlan, changeSummary) async {
          final updatedTravelModes = TravelModeExtractor.extractTravelModes(newPlan)
              .map((mode) => mode.id)
              .toList();

          final updatedPlan = _plan.withUpdatedPlan(
            newPlanText: newPlan,
            changeNotes: changeSummary,
            updatedTravelModes: updatedTravelModes,
          );

          final userId = SupabaseService.client.auth.currentUser?.id;
          if (userId != null) {
            await Supabase.instance.client.from('saved_travel_plans').update({
              ...updatedPlan.toMap(),
            }).eq('id', _plan.id).eq('user_id', userId);
          }

          if (mounted) {
            setState(() {
              _plan = updatedPlan;
              _editController.text = newPlan;
              _isEditMode = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(changeSummary),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        onReplanError: (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Replan failed: $error'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _sharePlan(BuildContext context) async {
    final conversationId = await ShareToConversationSheet.show(context);
    if (conversationId == null || !context.mounted) return;

    final chatService = getIt<ChatService>();
    try {
      await chatService.sendMessage(
        conversationId: conversationId,
        content: 'Shared a travel plan',
        type: 'travelPlan',
        sharedContentId: _plan.id,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.plan.planShared),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.plan.failedToSharePlan(error: e.toString())),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradientExt = theme.extension<GradientExtension>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        goBackToMapLanding(context);
      },
      child: Scaffold(
      appBar: CustomAppBar(
        title: _plan.displayTitle,
        variant: CustomAppBarVariant.withBack,
        onBackPressed: () => goBackToMapLanding(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: t.plan.sharePlan,
            onPressed: () => _sharePlan(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: t.plan.deletePlan,
            onPressed: _deletePlan,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradientExt?.screenBackgroundGradient ??
              LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ],
              ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 1.5.h),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.travel_explore_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.5.w),
                  Expanded(
                    child: Text(
                      t.plan.savedPlanDetails,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PlanContentView(
              plan: _plan.plan,
              destinationName: _plan.destinationName,
              destinationRegion: _plan.destinationRegion,
              destinationImage: _plan.destinationImage,
              daysCount: _plan.daysCount,
              travelModes: _plan.travelModes
                  .map(TravelMode.fromString)
                  .whereType<TravelMode>()
                  .toList(),
              fromLocation: _plan.fromLocation,
              startDate: _plan.startDate?.toIso8601String().split('T').first,
              endDate: _plan.endDate?.toIso8601String().split('T').first,
              onCopy: () {},
              onEdit: () {
                if (_isEditMode) {
                  _editController.text = _plan.plan;
                  setState(() => _isEditMode = false);
                } else {
                  _editController.text = _plan.plan;
                  setState(() => _isEditMode = true);
                }
              },
              onSave: _savePlan,
              onAskGuide: () => MapChatbotRoute($extra: 'Guide me visiting ${_plan.destinationName}').push(context),
              onReplan: _handleReplan,
              isEditMode: _isEditMode,
              editController: _editController,
              onPlanChanged: () => setState(() {}),
              isSaving: _isSaving,
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      ),
    );
  }
}
