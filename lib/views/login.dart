import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter_novel/utils/login.dart';
import 'package:flutter_novel/views/create_acount.dart';

// ログイン
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textMailController = TextEditingController();
  final TextEditingController _textPassController = TextEditingController();

  late String inputMail;
  late String inputPass;
  bool isDisplay = true;

  @override
  void dispose() {
    _textMailController.dispose();
    _textPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          "ログイン",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "メールアドレス",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    controller: _textMailController,
                    autofocus: true,
                    maxLines: 1,
                    cursorColor: Colors.lightBlue,
                    decoration: const InputDecoration(
                      hintText: "登録したメールアドレスを入力して下さい",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue),
                      ),
                    ),
                    validator: (value) {
                      if (value == "" || value == null || value.isEmpty) {
                        return "メールアドレスが入力されていません";
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return "メールアドレスが正しくありません";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      inputMail = value!;
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    "パスワード",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    controller: _textPassController,
                    maxLines: 1,
                    cursorColor: Colors.lightBlue,
                    obscureText: isDisplay,
                    decoration: InputDecoration(
                      hintText: "登録したパスワードを入力して下さい",
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlue),
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(isDisplay
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              isDisplay = !isDisplay;
                            });
                          }),
                    ),
                    validator: (value) {
                      if (value == "") {
                        return "パスワードが入力されていません";
                      }
                    },
                    onSaved: (value) {
                      inputPass = value!;
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        minimumSize: const Size(200.0, 50.0),
                      ),
                      child: const Text(
                        "ログイン",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        // 入力チェック
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          await Login.handleSignIn(
                              context, inputMail, inputPass);
                          if (context.mounted) {
                            Navigator.pushNamed(context, "/game");
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SignInButton(text: "Googleでログイン", Buttons.google,
                  onPressed: () async {
                await Login.handleSignInGoogle(context);
                if (context.mounted) {
                  Navigator.pushNamed(context, "/game");
                }
              }),
            ),
            const SizedBox(height: 10.0),
            const Divider(height: 1.0),
            const SizedBox(height: 10.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                minimumSize: const Size(200.0, 50.0),
              ),
              child: const Text(
                "新規アカウント登録",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAcountView()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
