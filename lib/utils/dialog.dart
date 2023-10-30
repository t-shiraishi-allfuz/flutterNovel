import 'package:flutter/material.dart';
import 'package:flutter_novel/models/message.dart';
import 'package:flutter_novel/models/user_play_data.dart';
import 'package:flutter_novel/utils/typewriter.dart';

// 汎用ダイアログ
class CustomDialogWidget {
  // セリフウィンドウ
  static dynamic showTextDialog(BuildContext context, MessageModel message,
      UserPlayDataModel user, dynamic callback) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 200.0),
        width: 320.0,
        height: 180.0,
        decoration: BoxDecoration(
          color: Colors.lightBlue.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(5),
              child: Text(
                message.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(5),
              child: TypeWriter(message.body),
            ),
            const SizedBox(height: 10.0),
            Container(
              alignment: Alignment.bottomRight,
              child: FloatingIconButton(callback),
            ),
          ],
        ),
      ),
    );
  }

  // ニックネーム入力ダイアログ
  static void showInputNameDialog(
      BuildContext context, UserPlayDataModel user, dynamic callback) async {
    TextEditingController textController = TextEditingController();

    // ニックネーム登録
    Future<void> addNickname(String nickname) async {
      user.nickname = nickname;
      await UserPlayDataModel.updateData(user);
    }

    // 次のシーンへ
    Future<void> nextScene() async {
      user.scene++;
      await UserPlayDataModel.updateData(user);
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(10.0),
          ),
          shadowColor: Colors.white70,
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  cursorColor: Colors.lightBlue,
                  decoration: const InputDecoration(
                    hintText: "ニックネームを入力して下さい",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlue),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  height: 70.0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();

                        String text = textController.text;
                        await addNickname(text);
                        await nextScene();
                        callback();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                      ),
                      child: const Text(
                        "決定",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      textController.clear();
    });

    textController.dispose();
  }

  // エラーダイアログ
  static void showErrorDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(10.0),
          ),
          shadowColor: Colors.white70,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.red),
          ),
          actions: [
            TextButton(
                child: const Text(
                  "閉じる",
                  style: TextStyle(color: Colors.lightBlue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}

class FloatingIconButton extends StatefulWidget {
  final VoidCallback onPressed;

  const FloatingIconButton(this.onPressed, {super.key});

  @override
  State<FloatingIconButton> createState() => _FloatingIconButtonState();
}

class _FloatingIconButtonState extends State<FloatingIconButton>
    with SingleTickerProviderStateMixin {
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
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.2),
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
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
      ),
    );
  }
}
