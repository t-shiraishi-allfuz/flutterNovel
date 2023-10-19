import 'package:flutter/material.dart';
import 'package:flutter_novel/utils/googleapi_settings.dart';

class GameController extends StatefulWidget {
	const GameController({super.key});

	@override
	State<GameController> createState() => _GameControllerState();
}

class _GameControllerState extends State<GameController> {
	late Future<List<List<dynamic>>?> dataFuture;

	@override
	void initState() {
		super.initState();
		dataFuture = fetchDataFromGoogleSheets();
	}

	Future<List<List<dynamic>>?> fetchDataFromGoogleSheets() async {
		final data = await GoogleApiSettings.createGoogleSheetsApiGetUrl();

		if (data != null) {
			return data;
		} else {
			return null;
		}
	}

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<List<dynamic>>?>(
			future: dataFuture,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) {
					return Center(child: Text("データ読み込み中"));
				} else if (snapshot.hasError) {
					return Center(child: Text("エラーが発生しました"));
				} else {
					final result = snapshot.data!;
				
					return ListView.builder(
						itemCount: result.length,
						itemBuilder: (context, index) {
							return Column(
								children: [
									Text(result[index][0]),
								],
							);
						},
					);
				}
			}
		);
	}
}
