import 'package:flutter/material.dart';
import 'package:flutter_novel/models/user.dart';
import 'package:flutter_novel/utils/loading.dart';
import 'package:flutter_novel/utils/login.dart';
import 'package:flutter_novel/utils/googleapi_settings.dart';

class GameView extends StatefulWidget {
	const GameView({super.key});

	@override
	State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
	late Future<UserModel> userFuture;

	@override
	void initState() {
		super.initState();
		user = Login.getCurrentUser();
		userFuture = getUserData(user!.uid);
	}

	// ユーザーデータを取得
	Future<UserModel> getUserData(String uid) async {
		final sheetData = await GoogleApiSettings.createGoogleSheetsApiGetUrl();
		print(sheetData);
		return await UserModel.getUserDataByUid(uid);
	}

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<UserModel>(
			future: userFuture,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) {
					return LoadingWidget();
				} else if (snapshot.hasError) {
					return Center(child: Text("エラーが発生しました"));
				} else {
					final user = snapshot.data!;

					return Scaffold(
						backgroundColor: Colors.black,
						body: Container(
							alignment: Alignment.center,
							decoration: const BoxDecoration(
								image: DecorationImage(
									image: AssetImage("images/bg/bg_2.jpg"),
								),
							),
						),
					);
				}
			},
		);
	}
}
