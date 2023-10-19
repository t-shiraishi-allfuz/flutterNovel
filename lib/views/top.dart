import 'package:flutter/material.dart';
import 'package:bordered_text/bordered_text.dart';

class TopView extends StatefulWidget {
	const TopView({super.key});

	@override
	State<TopView> createState() => _TopViewState();
}

class _TopViewState extends State<TopView> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.black,
			body: Container(
				alignment: Alignment.center,
				decoration: const BoxDecoration(
					image: DecorationImage(
						image: AssetImage("images/bg/bg_1.jpg"),
					),
				),
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						BorderedText(
							strokeWidth: 4.0,
							strokeColor: Colors.pink,
							child: Text(
								"サウンドノベル",
								style: TextStyle(
									color: Colors.white,
									fontSize: 46.0,
									fontWeight: FontWeight.bold,
								),
							),
						),
						SizedBox(height: 5.0),
						BorderedText(
							strokeWidth: 2.0,
							strokeColor: Colors.pink,
							child: Text(
								"〜Flutterで作ってみた〜",
								style: TextStyle(
									color: Colors.white,
									fontSize: 18.0,
								),
							),
						),
						SizedBox(height: 100.0),
						ElevatedButton(
							style: ElevatedButton.styleFrom(
								primary: Colors.lightBlue,
								minimumSize: Size(200.0, 50.0),
							),
							child: Text(
								"新しく始める",
								style: TextStyle(
									color: Colors.white,
									fontSize: 16.0,
								),
							),
							onPressed: () {},
						),
						SizedBox(height: 10.0),
						ElevatedButton(
							style: ElevatedButton.styleFrom(
								primary: Colors.lightBlue,
								minimumSize: Size(200.0, 50.0),
							),
							child: Text(
								"続きから",
								style: TextStyle(
									color: Colors.white,
									fontSize: 16.0,
								),
							),
							onPressed: () {},
						),
					],
				),
			),
		);
	}
}
