import 'package:flutter/material.dart';
import 'package:flutter_novel/models/message.dart';
import 'package:flutter_novel/models/logic/game.dart';
import 'package:flutter_novel/utils/loading.dart';
import 'package:flutter_novel/utils/login.dart';
import 'package:flutter_novel/utils/dialog.dart';

class GameView extends StatefulWidget {
	const GameView({super.key});

	@override
	State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
	late Future<GameLogic> gameFuture;
	late List<MessageModel> message_list;
	int sheetIndex = 0;

	@override
	void initState() {
		super.initState();
		gameFuture = getGameData();
	}

	// ユーザーデータを取得
	Future<GameLogic> getGameData() async {
		final user = await Login.getCurrentUser();
		return await GameLogic.getData(user!.uid);
	}

	// セリフを進める
	void nextData() {
		if (sheetIndex < message_list.length) {
			setState(() {
				sheetIndex++;
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<GameLogic>(
			future: gameFuture,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) {
					return LoadingWidget();
				} else if (snapshot.hasError) {
					return Center(child: Text("エラーが発生しました"));
				} else {
					final game = snapshot.data!;
					message_list = game.message_list;
					MessageModel message = message_list[sheetIndex];

					return Scaffold(
						backgroundColor: Colors.black,
						body: Container(
							alignment: Alignment.center,
							decoration: BoxDecoration(
								image: DecorationImage(
									image: AssetImage(message.bg),
								),
							),
							child: Container(
								child: Stack(
									children: [
										Center(
											child: Container(
												alignment: Alignment.bottomCenter,
												child: Image(
													image: AssetImage(message.chara_image),
													width: 320.0,
												),
											),
										),
										CustomDialogWidget.showTextDialog(context, message, nextData),
									],
								),
							),
						),
					);
				}
			},
		);
	}
}
