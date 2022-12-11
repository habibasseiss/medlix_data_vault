part of medlix_sso;

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
