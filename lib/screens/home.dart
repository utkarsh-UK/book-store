import 'package:bookstore/services/api_controller.dart';
import 'package:bookstore/util/injector.dart';
import 'package:bookstore/widgets/book_app_bar.dart';
import 'package:bookstore/widgets/new_launches.dart';
import 'package:bookstore/widgets/recommendend_books.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiController controller = Get.put(locator.get<ApiController>());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const BookAppBar(title: "Home"),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children:  [
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
