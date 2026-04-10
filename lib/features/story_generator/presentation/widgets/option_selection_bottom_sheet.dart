import 'package:flutter/material.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/features/stories/domain/entities/story_options.dart';
import 'package:myitihas/features/story_generator/presentation/widgets/option_images.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

/// Bottom sheet for selecting story options using smooth_sheets
class OptionSelectionBottomSheet extends StatefulWidget {
  final String title;
  final String category;
  final String? selectedValue;
  final String? parentCategory;

  const OptionSelectionBottomSheet({
    super.key,
    required this.title,
    required this.category,
    this.selectedValue,
    this.parentCategory,
  });

  /// Show the bottom sheet and return selected value
  static Future<Map<String, String>?> show({
    required BuildContext context,
    required String title,
    required String category,
    String? selectedValue,
    String? parentCategory,
  }) {
    return Navigator.of(context).push<Map<String, String>>(
      ModalSheetRoute(
        swipeDismissible: true,
        builder: (context) => OptionSelectionBottomSheet(
          title: title,
          category: category,
          selectedValue: selectedValue,
          parentCategory: parentCategory,
        ),
      ),
    );
  }

  @override
  State<OptionSelectionBottomSheet> createState() =>
      _OptionSelectionBottomSheetState();
}

class _OptionSelectionBottomSheetState
    extends State<OptionSelectionBottomSheet>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  String _searchQuery = '';
  String? _selectedParent;
  String? _selectedValue;
  late AnimationController _handleAnimationController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode()
      ..addListener(() => setState(() {}));
    _selectedValue = widget.selectedValue;
    _handleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _handleAnimationController.dispose();
    super.dispose();
  }

  List<String> _getOptions() {
    final categoryData = storyOptions[widget.category];
    if (categoryData == null) return [];

    final types = categoryData['types'] as List<dynamic>?;
    if (types == null) return [];

    return types.cast<String>();
  }

  Map<String, List<String>>? _getSubtypes() {
    if (widget.category != 'scripture') return null;

    final categoryData = storyOptions[widget.category];
    if (categoryData == null) return null;

    final subtypes = categoryData['subtypes'] as Map<String, dynamic>?;
    if (subtypes == null) return null;

    return subtypes.map(
      (key, value) => MapEntry(key, (value as List<dynamic>).cast<String>()),
    );
  }

  List<String> _getFilteredOptions(List<String> options) {
    if (_searchQuery.isEmpty) return options;
    return options
        .where(
          (option) => option.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final options = _getOptions();
    final subtypes = _getSubtypes();
    final hasSubtypes = subtypes != null && widget.category == 'scripture';

    return Sheet(
      scrollConfiguration: const SheetScrollConfiguration(),
      decoration: MaterialSheetDecoration(
        size: SheetSize.stretch,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        clipBehavior: Clip.antiAlias,
        color: colorScheme.surface,
      ),
      snapGrid: SheetSnapGrid(
        snaps: [SheetOffset(0.5), SheetOffset(0.75), SheetOffset(1)],
      ),
      initialOffset: const SheetOffset(0.75),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar with scale-in animation
            AnimatedBuilder(
              animation: _handleAnimationController,
              builder: (context, child) {
                final scale = 0.6 +
                    0.4 *
                        Curves.easeOutCubic
                            .transform(_handleAnimationController.value);
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            // Title
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
              child: Row(
                children: [
                  if (_selectedParent != null && hasSubtypes)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedParent = null;
                        });
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  if (_selectedParent != null && hasSubtypes)
                    SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      _selectedParent ?? widget.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            // Search field with focus border animation
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Builder(
                builder: (context) {
                  final hasFocus = _searchFocusNode.hasFocus;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: hasFocus
                            ? colorScheme.primary.withValues(alpha: 0.5)
                            : Colors.transparent,
                        width: hasFocus ? 2 : 0,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Search ${widget.title.toLowerCase()}...',
                        suffixIcon: VoiceInputButton(
                          controller: _searchController,
                          compact: true,
                        ),
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor:
                            colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            // Options grid
            Expanded(
              child: hasSubtypes && _selectedParent == null
                  ? _buildParentGrid(options)
                  : _buildOptionsGrid(
                      hasSubtypes && _selectedParent != null
                          ? subtypes[_selectedParent] ?? []
                          : options,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParentGrid(List<String> parents) {
    final filteredParents = _getFilteredOptions(parents);
    final gradient = OptionImages.getGradient(widget.category);

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.2,
      ),
      itemCount: filteredParents.length,
      itemBuilder: (context, index) {
        final parent = filteredParents[index];
        final subtypes = _getSubtypes();
        final hasChildren =
            subtypes != null && subtypes[parent]?.isNotEmpty == true;
        final icon = OptionImages.getIcon(widget.category, parent);

        return _StaggeredCard(
          index: index,
          child: _OptionCard(
            label: parent,
            icon: icon,
            gradient: gradient,
            hasChildren: hasChildren,
            isSelected: false,
            onTap: () {
              HapticFeedback.selectionClick();
              if (hasChildren) {
                setState(() {
                  _selectedParent = parent;
                  _searchQuery = '';
                  _searchController.clear();
                });
              } else {
                Navigator.of(context).pop({'value': parent});
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildOptionsGrid(List<String> options) {
    final colorScheme = Theme.of(context).colorScheme;
    final filteredOptions = _getFilteredOptions(options);
    final gradient = OptionImages.getGradient(widget.category);

    if (filteredOptions.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48.sp,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              SizedBox(height: 16.h),
              Text(
                'No results found',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.2,
      ),
      itemCount: filteredOptions.length,
      itemBuilder: (context, index) {
        final option = filteredOptions[index];
        final isSelected = option == _selectedValue;
        final icon = OptionImages.getIcon(widget.category, option);

        return _StaggeredCard(
          index: index,
          child: _OptionCard(
            label: option,
            icon: icon,
            gradient: gradient,
            isSelected: isSelected,
            hasChildren: false,
            onTap: () {
              HapticFeedback.selectionClick();
              final Map<String, String> result = {'value': option};
              if (_selectedParent != null) {
                result['parent'] = _selectedParent!;
              }
              Navigator.of(context).pop(result);
            },
          ),
        );
      },
    );
  }
}

/// Wraps a card with staggered fade + slide entrance animation
class _StaggeredCard extends StatelessWidget {
  final int index;
  final Widget child;

  const _StaggeredCard({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 250 + (index % 6) * 35),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _OptionCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final bool isSelected;
  final bool hasChildren;
  final VoidCallback onTap;

  const _OptionCard({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.isSelected,
    required this.hasChildren,
    required this.onTap,
  });

  @override
  State<_OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<_OptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = widget.isSelected;

    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: widget.gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected
                    ? null
                    : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.3)
                      : colorScheme.outlineVariant.withValues(alpha: 0.3),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: widget.gradient.first.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 24.sp,
                        color: isSelected ? Colors.white : colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : colorScheme.onSurface,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (widget.hasChildren)
                Positioned(
                  right: 8.w,
                  top: 8.h,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.sp,
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.7)
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              if (isSelected)
                Positioned(
                  right: 8.w,
                  bottom: 8.h,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 14.sp,
                        color: widget.gradient.first,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    ),
    );
  }
}
