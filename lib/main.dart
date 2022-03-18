import 'package:bookstore/screens/book_detail.dart';
import 'package:bookstore/screens/home.dart';
import 'package:bookstore/screens/common_books_list.dart';
import 'package:bookstore/screens/landing.dart';
import 'package:bookstore/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './util/injector.dart' as di;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();

  GetIt.I.isReady<SharedPreferences>().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getAppThemeData(),
      home: const LandingScreen(),
      routes: {
        BookDetail.routeName: (_) => const BookDetail(),
        CommonBooksList.routeName: (_) => const CommonBooksList(),
      },
    );
  }
}
