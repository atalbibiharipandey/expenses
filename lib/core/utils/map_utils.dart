class UtilsMap {}

extension CleanMapExtension on Map<String, dynamic> {
  Map<String, dynamic> removeNullOrEmpty() {
    final Map<String, dynamic> newMap = {};

    for (final entry in entries) {
      final value = entry.value;

      if (value == null) continue;
      if (value is String && value.trim().isEmpty) continue;
      if (value is Iterable) {
        final cleanedList = value
            .map((e) {
              if (e is Map<String, dynamic>) {
                return e.removeNullOrEmpty();
              }
              return e;
            })
            .where((e) {
              if (e == null) return false;
              if (e is String && e.trim().isEmpty) return false;
              if (e is Map && e.isEmpty) return false;
              if (e is Iterable && e.isEmpty) return false;
              return true;
            })
            .toList();

        if (cleanedList.isNotEmpty) {
          newMap[entry.key] = cleanedList;
        }
        continue;
      }

      if (value is Map<String, dynamic>) {
        final cleanedMap = value.removeNullOrEmpty();
        if (cleanedMap.isNotEmpty) {
          newMap[entry.key] = cleanedMap;
        }
        continue;
      }

      newMap[entry.key] = value;
    }

    return newMap;
  }
}
