import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter_novel/utils/custom_shared.dart';
import 'package:flutter_novel/utils/login.dart';
import 'package:flutter_novel/utils/loading.dart';

class TopView extends StatefulWidget {
  const TopView({super.key});

  @override
  State<TopView> createState() => _TopViewState();
}

class _TopViewState extends State<TopView> {
  User? user;
  late Future<String?> uidFuture;

  @override
  void initState() {
    super.initState();
    uidFuture = getUID();
    user = Login.getCurrentUser();
  }

  // キャッシュからUID取得
  Future<String?> getUID() async {
    return await CustomShared.getUID();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: uidFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot.hasError) {
          return const Center(child: Text("エラーが発生しました"));
        } else {
          final uid = snapshot.data;

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
                    child: const Text(
                      "サウンドノベル",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 46.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  BorderedText(
                    strokeWidth: 2.0,
                    strokeColor: Colors.pink,
                    child: const Text(
                      "〜Flutterで作ってみた〜",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      minimumSize: const Size(200.0, 50.0),
                    ),
                    child: const Text(
                      "新しく始める",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pushNamed(context, "/create_acount");
                    },
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      minimumSize: const Size(200.0, 50.0),
                    ),
                    onPressed: uid == null
                        ? null
                        : () {
                            if (user != null) {
                              Navigator.pushNamed(context, "/game");
                            } else {
                              Navigator.pushNamed(context, "/login");
                            }
                          },
                    child: const Text(
                      "続きから",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
