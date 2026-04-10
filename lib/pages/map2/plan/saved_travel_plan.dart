import 'package:myitihas/i18n/strings.g.dart';

/// Model for a saved pilgrimage travel plan persisted in Supabase.
class SavedTravelPlan {
  final String id;
  final String plan;
  final String? fromLocation;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? destinationId;
  final String? destinationName;
  final String? destinationRegion;
  final String? destinationImage;
  final String? title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> travelModes; // Detected travel modes: ['train', 'flight', 'bus', 'hotel', 'car']
  final List<Map<String, dynamic>> versionHistory; // Track plan modifications

  SavedTravelPlan({
    required this.id,
    required this.plan,
    this.fromLocation,
    this.startDate,
    this.endDate,
    this.destinationId,
    this.destinationName,
    this.destinationRegion,
    this.destinationImage,
    this.title,
    required this.createdAt,
    required this.updatedAt,
    this.travelModes = const [],
    this.versionHistory = const [],
  });

  factory SavedTravelPlan.fromJson(Map<String, dynamic> json) {
    // Parse travel_modes array
    final travelModesList = <String>[];
    if (json['travel_modes'] is List) {
      travelModesList.addAll(
        (json['travel_modes'] as List).whereType<String>(),
      );
    }

    // Parse version_history JSONB array
    final versionHistoryList = <Map<String, dynamic>>[];
    if (json['plan_version_history'] is List) {
      versionHistoryList.addAll(
        (json['plan_version_history'] as List).whereType<Map<String, dynamic>>(),
      );
    }

    return SavedTravelPlan(
      id: json['id'] as String,
      plan: json['plan'] as String,
      fromLocation: json['from_location'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'] as String)
          : null,
      destinationId: json['destination_id'] as int?,
      destinationName: json['destination_name'] as String?,
      destinationRegion: json['destination_region'] as String?,
      destinationImage: json['destination_image'] as String?,
      title: json['title'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      travelModes: travelModesList,
      versionHistory: versionHistoryList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plan': plan,
      'from_location': fromLocation,
      'start_date': startDate?.toIso8601String().split('T').first,
      'end_date': endDate?.toIso8601String().split('T').first,
      'destination_id': destinationId,
      'destination_name': destinationName,
      'destination_region': destinationRegion,
      'destination_image': destinationImage,
      'title': title,
      'travel_modes': travelModes,
      'plan_version_history': versionHistory,
    };
  }

  /// Display title for list views.
  String get displayTitle {
    if (title != null && title!.trim().isNotEmpty) return title!;
    if (destinationName != null && destinationName!.trim().isNotEmpty) {
      final parts = [destinationName!];
      if (startDate != null) {
        parts.add(_formatDate(startDate!));
      }
      return parts.join(' - ');
    }
    return t.plan.pilgrimagePlan;
  }

  static String _formatDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year}';

  /// Days count if both dates present.
  int? get daysCount {
    if (startDate == null || endDate == null) return null;
    if (endDate!.isBefore(startDate!)) return null;
    return endDate!.difference(startDate!).inDays + 1;
  }

  /// Create a copy of this plan with updated values
  SavedTravelPlan copyWith({
    String? id,
    String? plan,
    String? fromLocation,
    DateTime? startDate,
    DateTime? endDate,
    int? destinationId,
    String? destinationName,
    String? destinationRegion,
    String? destinationImage,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? travelModes,
    List<Map<String, dynamic>>? versionHistory,
  }) {
    return SavedTravelPlan(
      id: id ?? this.id,
      plan: plan ?? this.plan,
      fromLocation: fromLocation ?? this.fromLocation,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      destinationId: destinationId ?? this.destinationId,
      destinationName: destinationName ?? this.destinationName,
      destinationRegion: destinationRegion ?? this.destinationRegion,
      destinationImage: destinationImage ?? this.destinationImage,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      travelModes: travelModes ?? this.travelModes,
      versionHistory: versionHistory ?? this.versionHistory,
    );
  }

  /// Create a new version entry for the history
  Map<String, dynamic> _createVersionEntry({
    required String planText,
    required String changeNotes,
  }) {
    return {
      'version': (versionHistory.length) + 1,
      'plan_text': planText,
      'created_at': DateTime.now().toIso8601String(),
      'change_notes': changeNotes,
    };
  }

  /// Create a new plan with the updated content and track version history
  SavedTravelPlan withUpdatedPlan({
    required String newPlanText,
    required String changeNotes,
    List<String>? updatedTravelModes,
  }) {
    final newHistory = [...versionHistory];
    newHistory.add(_createVersionEntry(
      planText: plan, // Store the OLD plan in history
      changeNotes: changeNotes,
    ));

    return copyWith(
      plan: newPlanText,
      travelModes: updatedTravelModes ?? travelModes,
      versionHistory: newHistory,
      updatedAt: DateTime.now(),
    );
  }

  /// Get the count of plan modifications
  int get modificationCount => versionHistory.length;

  /// Get the last modification note if available
  String? get lastModificationNote {
    if (versionHistory.isEmpty) return null;
    return versionHistory.last['change_notes'] as String?;
  }
}
