part of medlix_data_vault;

class IosOptions extends Options {
  final String? _teamId;
  final String? _groupId;

  const IosOptions({String? teamId, String? groupId})
      : _teamId = teamId,
        _groupId = groupId;

  static const IosOptions defaultOptions = IosOptions();

  @override
  Map<String, String> toMap() => <String, String>{
        if (_groupId != null) 'groupId': prefixedGroupId!,
      };

  String? get prefixedGroupId {
    // concatenate the teamId and groupId
    if (_teamId != null && _groupId != null) {
      return '$_teamId.$_groupId';
    } else if (_groupId != null) {
      return _groupId!;
    }
    return null;
  }
}

class AndroidOptions extends Options {
  final List<String>? _packageNames;

  const AndroidOptions({List<String>? packageNames})
      : _packageNames = packageNames;

  static const AndroidOptions defaultOptions = AndroidOptions();

  @override
  Map<String, String> toMap() => <String, String>{
        if (_packageNames != null) 'packageNames': _packageNames!.join(','),
      };
}
