import 'package:flutter/material.dart';
import 'package:flutter_novel/models/message.dart';

// 汎用ダイアログ
class CustomDialogWidget {
	// セリフウィンドウ
	static dynamic showTextDialog(BuildContext context, MessageModel message, dynamic callback) {
		return Center(
			child: Container(
				padding: EdgeInsets.all(10),
				margin: EdgeInsets.only(top: 200.0),
				width: 320.0,
				height: 150.0,
				decoration: BoxDecoration(
					color: Colors.lightBlue.withOpacity(0.8),
					borderRadius: BorderRadius.circular(10.0),
				),
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Container(
							alignment: Alignment.topLeft,
							padding: EdgeInsets.all(5),
							child: Text(
								message.name,
								style: TextStyle(
									color: Colors.white,
									fontWeight: FontWeight.bold,
									fontSize: 16,
								),
							),
						),
						SizedBox(height: 5.0),
						Container(
							alignment: Alignment.centerLeft,
							padding: EdgeInsets.all(5),
							child: Text(
								message.body,
								style: TextStyle(color: Colors.white),
							),
						),
						SizedBox(height: 10.0),
						Container(
							alignment: Alignment.bottomRight,
							child: FloatingIconButton(callback),
						),
					],
				),
			),
		);
	}

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

class FloatingIconButton extends StatefulWidget {
	final VoidCallback onPressed;

	FloatingIconButton(this.onPressed);

	@override
	_FloatingIconButtonState createState() => _FloatingIconButtonState();
}

class _FloatingIconButtonState extends State<FloatingIconButton> with SingleTickerProviderStateMixin {
	late AnimationController _controller;
	late Animation<Offset> _animation;
	
	@override
	void initState() {
		super.initState();

		_controller = AnimationController(
			vsync: this,
			duration: const Duration(milliseconds: 600),
		);
		_animation = Tween<Offset>(
			begin: Offset(0.0, 0.0),
			end: Offset(0.0, 0.2),
		).animate(_controller);

		// ループ
		_controller.addStatusListener((status) {
			if (status == AnimationStatus.completed) {
				_controller.reverse();
			} else if (status == AnimationStatus.dismissed) {
				_controller.forward();
			}
		});

		_controller.forward();
	}

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return SlideTransition(
			position: _animation,
			child: IconButton(
				onPressed: () {
					widget.onPressed();
				},
				icon: Icon(
					Icons.arrow_drop_down,
					color: Colors.white,
				),
			),
		);
	}
}
