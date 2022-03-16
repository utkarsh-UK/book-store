import 'package:bookstore/util/injector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/api_controller.dart';

class BookDetail extends StatelessWidget {
  const BookDetail({Key? key}) : super(key: key);

  static const routeName = '/detail-book';

  @override
  Widget build(BuildContext context) {
    final ApiController controller = Get.put(locator.get<ApiController>());
    final size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final String bookID = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 18.0),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.add_shopping_cart_outlined,
          ),
          label: Text(
            'Buy for ${controller.book.value!.price}',
            style: textTheme.button,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: controller.getBookDetails(bookID),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Obx(
                () => Container(
                  height: size.height,
                  width: size.width,
                  decoration: const BoxDecoration(color: Color(0xFFE6D6A3)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20,
                            bottom: MediaQuery.of(context).viewPadding.bottom),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: 3.142,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.trending_flat,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: Navigator.of(context).pop,
                              ),
                            ),
                            Text(
                              "Detail Book",
                              style: textTheme.headline3!
                                  .copyWith(color: Colors.white70),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.bookmark_border,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () => controller
                                  .saveBook(controller.book.value!.isbn13),
                            ),
                          ],
                        ),
                      ),
                      Text(controller.book.value!.title,
                          style: textTheme.headline3),
                      SizedBox(height: size.height * 0.3),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 25,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 30.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    controller.book.value!.year,
                                                style: textTheme.button),
                                            const TextSpan(text: "\nYear"),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: controller
                                                    .book.value!.language,
                                                style: textTheme.button),
                                            const TextSpan(text: "\nLanguage"),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: controller
                                                    .book.value!.pages,
                                                style: textTheme.button),
                                            const TextSpan(text: "\nPages"),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 12.0,
                                    left: 12.0,
                                    top: 0.0,
                                    bottom: 8.0,
                                  ),
                                  child: Text(
                                    "Description",
                                    style: textTheme.button!.copyWith(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 12.0,
                                    left: 12.0,
                                    top: 0.0,
                                    bottom: 8.0,
                                  ),
                                  child: Text(
                                    controller.book.value!.desc ??
                                        "No "
                                            "description found",
                                    style: textTheme.bodyText2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
