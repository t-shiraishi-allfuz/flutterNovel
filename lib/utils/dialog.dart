import 'package:flutter/material.dart';

// 汎用ダイアログ
class CustomDialogWidget {
	// エラーダイアログ
	static void showErrorDialog(BuildContext context, String title, String message) {
		showDialog(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					backgroundColor: Colors.black,
					shape: RoundedRectangleBorder(
						side: BorderSide(color: Colors.white70),
						borderRadius: BorderRadius.circular(10.0),
					),
					shadowColor: Colors.white70,
					title: Text(
						title,
						style: TextStyle(color: Colors.white),
					),
					content: Text(
						message,
						style: TextStyle(color: Colors.red),
					),
					actions: [
						TextButton(
							child: Text(
								"閉じる",
								style: TextStyle(color: Colors.lightBlue),
							),
							onPressed: () {
								Navigator.of(context).pop();
							}
						),
					],
				);
			},
		);
	}
}
