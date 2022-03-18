import 'package:bookstore/util/stateful_wrapper.dart';
import 'package:bookstore/widgets/book_app_bar.dart';
import 'package:bookstore/widgets/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../services/api_controller.dart';
import '../util/injector.dart';

class CommonBooksList extends StatelessWidget {
  static const String routeName = '/common-books-list';

  const CommonBooksList({Key? key}) : super(key: key);

  static const pattern = [
    WovenGridTile(1),
    WovenGridTile(
      5 / 7,
      crossAxisRatio: 0.9,
      alignment: AlignmentDirectional.centerEnd,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ApiController controller = Get.put(locator.get<ApiController>());
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: const BookAppBar(title: "Saved Books"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 14.0, right: 14.0),
          child: StatefulWrapper(
            onInit: controller.getSavedBooks,
            child: Obx(
              () => GridView.custom(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverWovenGridDelegate.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 4,
                  pattern: pattern,
                ),
                childrenDelegate: arguments['isRecommended']
                    ? _buildRecommendedBooksSliverDelegate(controller)
                    : _buildNewBooksSliverDelegate(controller),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverChildBuilderDelegate _buildNewBooksSliverDelegate(
      ApiController controller) {
    return SliverChildBuilderDelegate((context, index) {
      final tile = pattern[index % pattern.length];

      return BookTile(
        height: 200,
        width: (200 * tile.aspectRatio).ceil().toDouble(),
        title: controller.newBooks[index].title,
        image: controller.newBooks[index].image,
        shouldShowBookTitle: false,
        onTap: () => Navigator.of(context).pushNamed(
          '/detail-book',
          arguments: controller.newBooks[index].isbn13,
        ),
      );
    }, childCount: controller.newBooks.length);
  }

  SliverChildBuilderDelegate _buildRecommendedBooksSliverDelegate(
      ApiController controller) {
    return SliverChildBuilderDelegate((context, index) {
      final tile = pattern[index % pattern.length];

      return BookTile(
        height: 200,
        width: (200 * tile.aspectRatio).ceil().toDouble(),
        title: controller.recommendedBooks[index].title,
        image: controller.recommendedBooks[index].image,
        shouldShowBookTitle: false,
        onTap: () => Navigator.of(context).pushNamed(
          '/detail-book',
          arguments: controller.recommendedBooks[index].isbn13,
        ),
      );
    }, childCount: controller.recommendedBooks.length);
  }
}
