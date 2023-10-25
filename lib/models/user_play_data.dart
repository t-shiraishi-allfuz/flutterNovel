import 'package:cloud_firestore/cloud_firestore.dart';

// ユーザーのプレイ状況
class UserPlayDataModel {
	static final CollectionReference store = FirebaseFirestore.instance.collection('user_play_data');

	final String uid;
	String nickname;  // ニックネーム
	int shene;    	 // 進行中のシーンID
	int stamina;  	 // 体力
	int academic; 	 // 学力
	int motion;   	 // 運動
	int visual;   	 // 見た目
	int talk;     	 // 話術

	UserPlayDataModel({
		required this.uid,
		this.nickname = "",
		this.shene = 0,
		this.stamina = 100,
		this.academic = 10,
		this.motion = 10,
		this.visual = 10,
		this.talk = 10,
	});

	Map<String, dynamic> toMap() {
		return {
			'uid': uid,
			'nickname': nickname,
			'shene': shene,
			'stamina': stamina,
			'academic': academic,
			'motion': motion,
			'visual': visual,
			'talk': talk,
		};
	}

	factory UserPlayDataModel.fromMap(Map<String, dynamic> map) {
		return UserPlayDataModel(
			uid: map['uid'],
			nickname: map['nickname'],
			shene: map['shene'],
			stamina: map['stamina'],
			academic: map['academic'],
			motion: map['motion'],
			visual: map['visual'],
			talk: map['talk'],
		);
	}

	@override
	String toString() {
		return 'UserPlayDataModel('
			'uid: $uid,'
			'nickname: $nickname,'
			'shene: $shene,'
			'stamina: $stamina,'
			'academic: $academic,'
			'motion: $motion,'
			'visual: $visual,'
			'talk: $talk,'
		')';
	}

	// データ追加
	static Future<void> addData(String uid) async {
		UserPlayDataModel newUser = UserPlayDataModel(uid: uid);
		await store.add(newUser.toMap());
	}

	// データ削除
	static Future<void> deleteData(String id) async {
		await store.doc(id).delete();
	}

	// データ取得
	static Future<UserPlayDataModel> getUserPlayDataByUid(String uid) async {
		final snapshot = await store.where('uid', isEqualTo: uid).get();
		return UserPlayDataModel.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
	}
}
