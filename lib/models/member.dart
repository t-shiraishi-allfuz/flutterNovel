// メンバーデータ
class MemberModel {
	final String name;
	final String member_id;

	MemberModel({
		required this.name,
		required this.member_id,
	});

	@override
	String toString() {
		return 'MemberModel('
			'name: $name,'
			'member_id: $member_id,'
		')';
	}
}
