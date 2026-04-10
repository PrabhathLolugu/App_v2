import 'package:flutter/material.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_category.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_item.dart';
import 'package:sizer/sizer.dart';

class CulturalStatePreviewSheet extends StatelessWidget {
  const CulturalStatePreviewSheet({
    super.key,
    required this.stateName,
    required this.category,
    required this.items,
    required this.onItemTap,
  });

  final String stateName;
  final CulturalCategory category;
  final List<CulturalItem> items;
  final ValueChanged<CulturalItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stateName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 0.4.h),
            Text(
              category.heroLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 1.2.h),
            if (items.isEmpty)
              Text(
                'No catalog entries yet for this state.',
                style: theme.textTheme.bodyMedium,
              ),
            if (items.isNotEmpty)
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, _) => SizedBox(height: 0.8.h),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.itemName),
                        subtitle: Text(
                          item.shortDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () => onItemTap(item),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
