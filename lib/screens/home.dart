import 'package:bookstore/widgets/book_app_bar.dart';
import 'package:bookstore/widgets/new_launches.dart';
import 'package:bookstore/widgets/recommendend_books.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const BookAppBar(title: "Home"),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
                left: 12.0, right: 12.0, top: 10, bottom: size.height * 0.08),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.45,
                  child: NewLaunches(widgetHeight: size.height * 0.45),
                ),
                SizedBox(
                  height: size.height * 0.45,
                  child: RecommendedBooks(widgetHeight: size.height * 0.45),
                ),
                const SizedBox(height: 20.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
