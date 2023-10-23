import 'package:cloud_firestore/cloud_firestore.dart';

// ユーザーデータ
class UserModel {
	static final CollectionReference store = FirebaseFirestore.instance.collection('user');

	String uid;
	String? mail;

	UserModel({
		required this.uid,
		this.mail,
	});

	Map<String, dynamic> toMap() {
		return {
			'uid': uid,
			'mail': mail,
		};
	}

	factory UserModel.fromMap(Map<String, dynamic> map) {
		return UserModel(
			uid: map['uid'],
			mail: map['mail'],
		);
	}

	@override
	String toString() {
		return 'UserModel('
			'uid: $uid,'
			'mail: $mail,'
		')';
	}

	// データ追加
	static Future<void> addData(String uid, String mail) async {
		UserModel newUser = UserModel(uid: uid, mail: mail);
		await store.add(newUser.toMap());
	}

	// データ削除
	static Future<void> deleteData(String id) async {
		await store.doc(id).delete();
	}

	// データ取得
	static Future<UserModel> getUserDataByUid(String uid) async {
		final snapshot = await store.where('uid', isEqualTo: uid).get();
		return UserModel.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
	}

	// データ取得
	static Future<UserModel> getUserDataByMail(String mail) async {
		final snapshot = await store.where('mail', isEqualTo: mail).get();
		return UserModel.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
	}
}
