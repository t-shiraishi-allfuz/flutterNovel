import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter_novel/utils/login.dart';

// ログイン
class CreateAcountView extends StatefulWidget {
	CreateAcountView({super.key});
	
	@override
	State<CreateAcountView> createState() => _CreateAcountViewState();
}

class _CreateAcountViewState extends State<CreateAcountView> {
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
	TextEditingController _textMailController = TextEditingController();
	TextEditingController _textPassController = TextEditingController();

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
					"新規アカウント登録",
					style: TextStyle(
						color: Colors.white
					),
				),
			),
			body: Container(
				padding: EdgeInsets.all(16.0),
				alignment: Alignment.center,
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Form(
							key: _formKey,
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										"メールアドレス",
										style: TextStyle(color: Colors.white),
									),
									SizedBox(height: 5.0),
									new TextFormField(
										controller: _textMailController,
										autofocus: true,
										maxLines: 1,
										cursorColor: Colors.lightBlue,
										decoration: InputDecoration(
											hintText: "登録するメールアドレスを入力して下さい",
											hintStyle: TextStyle(color: Colors.grey),
											enabledBorder: UnderlineInputBorder(
												borderSide: BorderSide(color: Colors.white70),
											),
											focusedBorder: UnderlineInputBorder(
												borderSide: BorderSide(color: Colors.lightBlue),
											),
										),
										keyboardType: TextInputType.emailAddress,
										validator: (value) {
											if (value == "" || value == null || value.isEmpty) {
												return "メールアドレスが入力されていません";
											} else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
												return "メールアドレスが正しくありません";
											}
											return null;
										},
										onSaved: (value) {
											inputMail = value!;
										},
										style: TextStyle(color: Colors.white),
									),
									SizedBox(height: 8.0),
									Text(
										"パスワード",
										style: TextStyle(color: Colors.white),
									),
									SizedBox(height: 5.0),
									new TextFormField(
										controller: _textPassController,
										maxLines: 1,
										cursorColor: Colors.lightBlue,
										obscureText: isDisplay,
										decoration: InputDecoration(
											hintText: "英数字8文字以上のパスワードを入力して下さい",
											hintStyle: TextStyle(color: Colors.grey),
											enabledBorder: UnderlineInputBorder(
												borderSide: BorderSide(color: Colors.white70),
											),
											focusedBorder: UnderlineInputBorder(
												borderSide: BorderSide(color: Colors.lightBlue),
											),
											suffixIcon: IconButton(
												icon: Icon(isDisplay ? Icons.visibility_off : Icons.visibility),
												onPressed: () {
													setState(() {
														isDisplay = !isDisplay;
													});
												}
											),
										),
										validator: (value) {
											if (value == "" || value == null || value.isEmpty) {
												return "パスワードが入力されていません";
											} else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value)) {
												return "パスワードは8文字以上の英数字で入力して下さい";
											}
											return null;
										},
										onSaved: (value) {
											inputPass = value!;
										},
										style: TextStyle(color: Colors.white),
									),
								],
							),
						),
						SizedBox(height: 10.0),
						ElevatedButton(
							style: ElevatedButton.styleFrom(
								primary: Colors.lightBlue,
								minimumSize: Size(200.0, 50.0),
							),
							child: Text(
								"登録",
								style: TextStyle(color: Colors.white),
							),
							onPressed: () async {
								// 入力チェック
								if (_formKey.currentState!.validate()) {
									_formKey.currentState?.save();
									await Login.createAuth(context, inputMail, inputPass);
									Navigator.pushNamed(context, "/game");
								}
							},
						),
						SizedBox(height: 10.0),
						Padding(
							padding: EdgeInsets.all(16.0),
							child: SignInButton(
								text: "Googleで登録",
								Buttons.google,
								onPressed: () async {
									await Login.handleSignInGoogle(context);
									Navigator.pushNamed(context, "/game");
								}
							),
						),
					],
				),
			),
		);
	}
}
