import 'package:myitihas/pages/map2/indian_culture/cultural_category.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_item.dart';

class CulturalItemDetailPayload {
  const CulturalItemDetailPayload({
    required this.category,
    required this.stateName,
    required this.item,
  });

  final CulturalCategory category;
  final String stateName;
  final CulturalItem item;
}
