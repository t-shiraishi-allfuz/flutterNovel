import 'package:cloud_firestore/cloud_firestore.dart';

// ユーザーのプレイ状況
class UserPlayDataModel {
	static final CollectionReference store = FirebaseFirestore.instance.collection('user_play_data');

	String uid;

	UserPlayDataModel({
		required this.uid,
	});

	Map<String, dynamic> toMap() {
		return {
			'uid': uid,
		};
	}

	factory UserPlayDataModel.fromMap(Map<String, dynamic> map) {
		return UserPlayDataModel(
			uid: map['uid'],
		);
	}

	@override
	String toString() {
		return 'UserPlayDataModel('
			'uid: $uid,'
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
	static Future<UserPlayDataModel> getUserDataByUid(String uid) async {
		final snapshot = await store.where('uid', isEqualTo: uid).get();
		return UserPlayDataModel.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
	}
}
