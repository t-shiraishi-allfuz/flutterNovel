import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_novel/utils/firebase_options.dart';
import 'package:flutter_novel/utils/googleapi_settings.dart';
import 'package:flutter_novel/views/top.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp(
		options: DefaultFirebaseOptions.currentPlatform,
	);
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'ノベル風アプリ',
			theme: ThemeData(
				useMaterial3: true,
			),
			initialRoute: '/',
			home: TopView(),
		);
	}
}
