class GroupSystemMessageFormatter {
  static const String typeJoined = 'group_system_joined';
  static const String typeLeft = 'group_system_left';
  static const String typeRemoved = 'group_system_removed';

  static const Set<String> _supportedTypes = {
    typeJoined,
    typeLeft,
    typeRemoved,
  };

  static bool isMembershipEventType(String? type) {
    if (type == null) return false;
    return _supportedTypes.contains(type.trim());
  }

  static String formatDisplayText({
    required String? type,
    required String content,
  }) {
    final trimmed = content.trim();
    if (trimmed.isNotEmpty) {
      return trimmed;
    }

    switch (type) {
      case typeJoined:
        return 'A member joined the group';
      case typeLeft:
        return 'A member left the group';
      case typeRemoved:
        return 'A member was removed';
      default:
        return '';
    }
  }
}
