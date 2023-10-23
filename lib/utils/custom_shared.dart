import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String uidKey = 'user_uid';

class CustomShared {
	// UIDを保存
	static Future<void> saveUID(String uid) async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.setString(uidKey, uid);
	}

	// UIDを取得
	static Future<String?> getUID() async {
		final prefs = await SharedPreferences.getInstance();

		try {
			return prefs.getString(uidKey);
		} catch (e) {
			throw e;
		}
	}

	// UIDを削除
	static Future<void> deleteUID() async {
		final prefs = await SharedPreferences.getInstance();
		prefs.remove(uidKey);
	}
}
