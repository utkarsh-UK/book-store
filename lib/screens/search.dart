import 'dart:async';

import 'package:bookstore/services/api_controller.dart';
import 'package:bookstore/util/theme.dart';
import 'package:bookstore/widgets/book_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../util/injector.dart';
import '../widgets/book_tile.dart';

class SearchScreen extends StatefulWidget {
  /// Renders search field with search results from [ApiController.searchBookByQuery].
  ///
  /// Implements paginated search results.
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  Timer? _debounceTimer;
  String? _inputText;

  static const pattern = [
    WovenGridTile(1),
    WovenGridTile(
      5 / 7,
      crossAxisRatio: 0.9,
      alignment: AlignmentDirectional.centerEnd,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _scrollController = ScrollController();

    // fetch more search results if user scrolls to end of list.
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
        _onSearchTextChanged(_inputText);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final ApiController controller = Get.put(locator.get<ApiController>());
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const BookAppBar(title: 'Search'),
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 10, bottom: size.height * 0.08),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                    focusColor: AppTheme.primaryColor,
                    hintText: 'Search books',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: AppTheme.primaryColor),
                    ),
                    prefixIcon: const Icon(Icons.search_sharp),
                  ),
                  controller: _searchController,
                  style: textTheme.headline4,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  onChanged: _onSearchTextChanged,
                ),
                const SizedBox(height: 30.0),
                Obx(
                  () => controller.searchedBooks.isEmpty || (_inputText?.isEmpty ?? false)
                      ? Center(
                          child: Text(
                            'Search books by title, author, ISBN or '
                            'keywords.',
                            style: textTheme.button,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Expanded(
                          child: Stack(
                            children: [
                              AnimationLimiter(
                                child: GridView.custom(
                                  controller: _scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate: SliverWovenGridDelegate.count(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 4,
                                    pattern: pattern,
                                  ),
                                  childrenDelegate: SliverChildBuilderDelegate((context, index) {
                                    final tile = pattern[index % pattern.length];

                                    return AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      columnCount: 2,
                                      duration: const Duration(milliseconds: 600),
                                      child: ScaleAnimation(
                                        child: FadeInAnimation(
                                          child: BookTile(
                                            height: 200,
                                            width: (200 * tile.aspectRatio).ceil().toDouble(),
                                            title: controller.searchedBooks[index].title,
                                            image: controller.searchedBooks[index].image,
                                            onTap: () => Navigator.of(context).pushNamed(
                                              '/detail-book',
                                              arguments: controller.searchedBooks[index].isbn13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }, childCount: controller.searchedBooks.length),
                                ),
                              ),
                              // show loading indicator when loading data
                              !controller.isLoading.value
                                  ? const SizedBox.shrink()
                                  : const Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 30.0),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Accepts raw [input] from TextField and calls API if [_debounceTimer] exceeds 600 ms.
  void _onSearchTextChanged(String? input) {
    // if _inputText != input, user has searched new book. Hence, clear previous search results state.
    if (_inputText != (input?.trim().toLowerCase() ?? "")) {
      locator.get<ApiController>().resetSearchTask();
    }

    setState(() => _inputText = input?.trim().toLowerCase() ?? "");

    // check if _debounceTimer is active and cancel if any.
    if (_debounceTimer != null && (_debounceTimer?.isActive ?? false)) {
      _debounceTimer?.cancel();
    }

    // call search API if no text is entered for 600 ms.
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      final String query = input?.trim().toLowerCase() ?? "";

      if (query.isNotEmpty) {
        locator.get<ApiController>().searchBookByQuery(query);
      } else {
        _inputText = "";
      }
    });
  }
}
