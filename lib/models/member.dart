// メンバーデータ
class MemberModel {
  final String name;
  final String memberId;

  MemberModel({
    required this.name,
    required this.memberId,
  });

  @override
  String toString() {
    return 'MemberModel('
        'name: $name,'
        'memberId: $memberId,'
        ')';
  }
}
