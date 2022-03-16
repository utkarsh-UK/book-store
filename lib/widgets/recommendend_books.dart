import 'package:bookstore/services/api_controller.dart';
import 'package:bookstore/util/injector.dart';
import 'package:bookstore/util/stateful_wrapper.dart';
import 'package:bookstore/util/theme.dart';
import 'package:bookstore/widgets/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecommendedBooks extends StatelessWidget {
  final double widgetHeight;

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
              const IconButton(
                onPressed: null,
                icon: Icon(Icons.arrow_right_alt,
                    color: AppTheme.fontDarkColor),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.newBooks.length,
                itemBuilder: (ctx, index) => BookTile(
                  height: widgetHeight * 0.35,
                  width: size.width * 0.4,
                  title: controller.recommendedBooks[index].title,
                  image: controller.recommendedBooks[index].image,
                  onTap: () => Navigator.of(context).pushNamed("/detail-book",
                      arguments: controller.recommendedBooks[index].isbn13),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}