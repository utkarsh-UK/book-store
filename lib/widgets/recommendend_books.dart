import 'package:bookstore/services/api_controller.dart';
import 'package:bookstore/util/injector.dart';
import 'package:bookstore/util/stateful_wrapper.dart';
import 'package:bookstore/util/theme.dart';
import 'package:bookstore/widgets/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class RecommendedBooks extends StatelessWidget {
  /// Height of RecommendedBooks List Widget
  final double widgetHeight;

  /// Renders recommended books from ApiController's [recommendedBooks] list.
  ///
  /// Observes changes in [controller.recommendedBooks] list
  const RecommendedBooks({required this.widgetHeight, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ApiController controller = Get.put(locator.get<ApiController>());
    final size = MediaQuery.of(context).size;

    return StatefulWrapper(
      onInit: controller.getRecommendedBooks,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Recommended", style: textTheme.headline3),
              IconButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed('/common-books-list', arguments: {
                  'screenTitle': "Recommended Books",
                  'isRecommended': true,
                }),
                icon: const Icon(Icons.arrow_right_alt,
                    color: AppTheme.fontDarkColor),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: Obx(
              () => controller.recommendedBooks.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.recommendedBooks.length ~/ 2,
                      itemBuilder: (ctx, index) => AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          horizontalOffset: 80.0,
                          child: FadeInAnimation(
                            child: BookTile(
                              height: widgetHeight * 0.35,
                              width: size.width * 0.4,
                              title: controller.recommendedBooks[index].title,
                              image: controller.recommendedBooks[index].image,
                              onTap: () => Navigator.of(context).pushNamed(
                                  "/detail-book",
                                  arguments:
                                      controller.recommendedBooks[index].isbn13),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
