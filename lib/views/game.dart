import 'package:flutter/material.dart';
import 'package:flutter_novel/models/message.dart';
import 'package:flutter_novel/models/user_play_data.dart';
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
  late UserPlayDataModel playData;
  late MessageModel message;
  bool isRender = false;
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

  // 描画を進める
  void nextRender() {
    setState(() {
      isRender = true;
    });
  }

  // セリフを進める
  void nextData() {
    if ((sheetIndex + 1) < message_list.length) {
      setState(() {
        sheetIndex++;
      });
    } else {
      if (message.function == "inputName") {
        CustomDialogWidget.showInputNameDialog(context, playData, nextScene);
      }
    }
  }

  // 次のシーンへ
  void nextScene() {
    setState(() {
      sheetIndex = 0;
      gameFuture = getGameData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GameLogic>(
      future: gameFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot.hasError) {
          return const Center(child: Text("エラーが発生しました"));
        } else {
          final game = snapshot.data!;
          message_list = game.messageList;
          message = message_list[sheetIndex];
          playData = game.userPlayData;

          return Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: Image(image: AssetImage(message.bg)),
                  ),
                  if (message.effect == "fadeout")
                    Center(
                      child: RenderAnimFadeout(nextRender),
                    ),
                  if (message.effect == "fadein")
                    Center(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: RenderAnimFadein(message, nextRender),
                      ),
                    ),
                  if (message.effect != "fadein" && message.charaImage != null)
                    Center(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Image(
                          image: AssetImage(message.charaImage!),
                          width: 320.0,
                        ),
                      ),
                    ),
                  if (isRender || message.effect == null)
                    CustomDialogWidget.showTextDialog(
                        context, message, playData, nextData),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

// フェードアウト
class RenderAnimFadeout extends StatefulWidget {
  final dynamic callback;

  const RenderAnimFadeout(this.callback, {super.key});

  @override
  State<RenderAnimFadeout> createState() => _RenderAnimFadeoutState();
}

class _RenderAnimFadeoutState extends State<RenderAnimFadeout>
    with SingleTickerProviderStateMixin {
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _opacityAnimation =
        Tween<double>(begin: 1, end: 0).animate(_opacityController);

    _opacityController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onAnimationComplete();
      }
    });

    if (opacity == 1.0) {
      _opacityController.forward();
    } else {
      onAnimationComplete();
    }
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  void onAnimationComplete() {
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacityAnimation.value,
      duration: const Duration(seconds: 2),
      child: const Image(
        image: AssetImage("images/bg/bg_black.jpg"),
      ),
    );
  }
}

// フェードイン
class RenderAnimFadein extends StatefulWidget {
  final MessageModel message;
  final dynamic callback;

  const RenderAnimFadein(this.message, this.callback, {super.key});

  @override
  State<RenderAnimFadein> createState() => _RenderAnimFadeinState();
}

class _RenderAnimFadeinState extends State<RenderAnimFadein>
    with SingleTickerProviderStateMixin {
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _opacityAnimation =
        Tween<double>(begin: 0, end: 1).animate(_opacityController);

    _opacityController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onAnimationComplete();
      }
    });

    if (opacity == 0.0) {
      _opacityController.forward(from: 0);
    } else {
      onAnimationComplete();
    }
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RenderAnimFadein oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void onAnimationComplete() {
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacityAnimation.value,
      duration: const Duration(milliseconds: 200),
      child: Image(
        image: AssetImage(widget.message.charaImage!),
        width: 320.0,
      ),
    );
  }
}
