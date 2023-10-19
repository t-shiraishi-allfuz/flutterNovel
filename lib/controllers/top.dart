import 'package:flutter/material.dart';
import 'package:flutter_novel/views/top.dart';

class TopController extends StatelessWidget {
	const TopController({super.key});

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
