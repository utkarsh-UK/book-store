import 'package:bookstore/services/api_controller.dart';
import 'package:bookstore/util/injector.dart';
import 'package:bookstore/util/stateful_wrapper.dart';
import 'package:bookstore/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'book_tile.dart';

class NewLaunches extends StatelessWidget {
  /// Height of NewLaunches List Widget
  final double widgetHeight;

  /// Renders newly launched books from ApiController's [newBooks] list.
  ///
  /// Observes changes in [controller.newBooks] list
  const NewLaunches({required this.widgetHeight, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    // Dependency injection for [ApiController].
    final ApiController controller = Get.put(locator.get<ApiController>());
    final size = MediaQuery.of(context).size;

    return StatefulWrapper(
      onInit: controller.getNewBooks,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("New Launches", style: textTheme.headline3),
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed('/common-books-list', arguments: {
                  'screenTitle': "New Launches",
                  'isRecommended': false,
                }),
                icon: const Icon(
                  Icons.arrow_right_alt,
                  color: AppTheme.fontDarkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: Obx(
              () => controller.newBooks.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.newBooks.length ~/ 2,
                      itemBuilder: (ctx, index) => AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          horizontalOffset: 80.0,
                          child: FadeInAnimation(
                            child: BookTile(
                              height: widgetHeight * 0.35,
                              width: size.width * 0.4,
                              title: controller.newBooks[index].title,
                              image: controller.newBooks[index].image,
                              backgroundColorCode: 0xFFE6D6A3,
                              onTap: () => Navigator.of(context).pushNamed("/detail-book",
                                  arguments: controller.newBooks[index].isbn13),
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
