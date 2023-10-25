// シナリオデータ
class MessageModel {
	final String member_id;
	final String name;
	final String body;
	final String bg;
	final String chara_image;

	MessageModel({
		required this.member_id,
		required this.name,
		required this.body,
		required this.bg,
		required this.chara_image,
	});

	@override
	String toString() {
		return 'MessageModel('
			'member_id: $member_id,'
			'name: $name,'
			'body: $body,'
			'bg: $bg,'
			'chara_image: $chara_image,'
		')';
	}
}