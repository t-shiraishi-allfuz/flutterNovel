import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_novel/utils/firebase_options.dart';
import 'package:flutter_novel/views/top.dart';
import 'package:flutter_novel/views/create_acount.dart';
import 'package:flutter_novel/views/login.dart';
import 'package:flutter_novel/views/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String routeName;

  Route<dynamic> generateRoute(RouteSettings settings) {
    return _createRoute(settings);
  }

  PageRoute<dynamic> _createRoute(RouteSettings settings) {
    routeName = settings.name!;
    return _createPageRouteBuilder(settings);
  }

  PageRoute<dynamic> _createPageRouteBuilder(RouteSettings settings) {
    late Widget pageWidget = const SizedBox.shrink();

    if (routeName == '/login') {
      settings = const RouteSettings(name: '/login');
      pageWidget = const LoginView();
    } else if (routeName == '/create_acount') {
      settings = const RouteSettings(name: '/create_acount');
      pageWidget = CreateAcountView();
    } else if (routeName == '/game') {
      settings = const RouteSettings(name: '/game');
      pageWidget = const GameView();
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => pageWidget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ノベル風アプリ',
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: generateRoute,
      home: const TopView(),
    );
  }
}
