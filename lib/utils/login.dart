import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_novel/models/user.dart';
import 'package:flutter_novel/models/user_play_data.dart';
import 'package:flutter_novel/utils/custom_shared.dart';
import 'package:flutter_novel/utils/dialog.dart';

FirebaseAuth auth = FirebaseAuth.instance;
User? user;

// 認証機能
class Login {
	// ログイン済みチェック
	static User? getCurrentUser() {
		return auth.currentUser;
	}

	// 匿名ログイン
	static Future<void> login() async {
		try {
			await auth.signInAnonymously();
			user = auth.currentUser;

			// UIDをキャッシュに保存
			await CustomShared.saveUID(user!.uid);
		} catch(e) {
			throw(e);
		}
	}

	// メアド認証
	static Future<void> handleSignIn(BuildContext context, String inputMail, String inputPass) async {
		try {
			final UserCredential authResult = await auth.signInWithEmailAndPassword(
				email: inputMail,
				password: inputPass,
			);
			user = authResult.user;

			// UIDをキャッシュに保存
			await CustomShared.saveUID(user!.uid);
		} on FirebaseAuthException catch (e) {
			print(e);
			String title = "認証エラー";
			String message = "アカウントが存在しません";

			CustomDialogWidget.showErrorDialog(context, title, message);
		}
	}

	// メアド登録
	static Future<void> createAuth(BuildContext context, String inputMail, String inputPass) async {
		try {
			final UserCredential authResult = await auth.createUserWithEmailAndPassword(
				email: inputMail,
				password: inputPass,
			);
			user = authResult.user;

			// UIDをキャッシュに保存
			await CustomShared.saveUID(user!.uid);
			// ユーザーデータを保存
			await UserModel.addData(user!.uid, inputMail);
			await UserPlayDataModel.addData(user!.uid);
		} on FirebaseAuthException catch (e) {
			print("登録エラー：${e.code}");
			String title = "登録エラー";
			String message = "予期せぬエラーが発生しました";

			if (e.code == "email-already-in-use") {
				String message = "登録済みのメールアドレスです";
			}
			CustomDialogWidget.showErrorDialog(context, title, message);
		}
	}

	// Google認証
	static Future<void> handleSignInGoogle(BuildContext context) async {
		if (kIsWeb) {
			GoogleAuthProvider authProvider = GoogleAuthProvider();

			try {
				final UserCredential authResult = await auth.signInWithPopup(authProvider);
				user = authResult.user;

				// UIDをキャッシュに保存
				await CustomShared.saveUID(user!.uid);
				// ユーザーデータを保存
				await UserModel.addData(user!.uid, user!.email!);
				await UserPlayDataModel.addData(user!.uid);
			} on FirebaseAuthException catch (e) {
				String title = "認証エラー";
				String message = "アカウントが存在しません";

				CustomDialogWidget.showErrorDialog(context, title, message);
			}
		} else {
			final GoogleSignIn googleSignIn = GoogleSignIn();
			final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

			if (googleSignInAccount != null) {
				final GoogleSignInAuthentication googleSignInAuthentication =
					await googleSignInAccount.authentication;

				final AuthCredential credential = GoogleAuthProvider.credential(
					accessToken: googleSignInAuthentication.accessToken,
					idToken: googleSignInAuthentication.idToken,
				);

				try {
					final UserCredential authResult = await auth.signInWithCredential(credential);
					user = authResult.user;

					// UIDをキャッシュに保存
					await CustomShared.saveUID(user!.uid);
					// ユーザーデータを保存
					await UserModel.addData(user!.uid, user!.email!);
					await UserPlayDataModel.addData(user!.uid);
				} on FirebaseAuthException catch (e) {
					String title = "認証エラー";
					String message = "アカウントが存在しません";

					CustomDialogWidget.showErrorDialog(context, title, message);
				}
			}
		}
	}
}
