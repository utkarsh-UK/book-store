import 'package:flutter/material.dart';

class BookTile extends StatelessWidget {
  final double height;
  final double width;
  final String title;
  final String image;
  final int backgroundColorCode;
  final bool shouldShowBookTitle;

  final VoidCallback onTap;

  const BookTile({
    required this.height,
    required this.width,
    required this.title,
    required this.image,
    required this.onTap,
    this.backgroundColorCode = 0xFF7A7787,
    this.shouldShowBookTitle = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              height: height,
              width: width,
              margin: const EdgeInsets.only(right: 14.0, bottom: 6.0),
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Color(backgroundColorCode),
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    image,
                  ),
                ),
              ),
            ),
          ),
          shouldShowBookTitle
              ? Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: width,
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyText2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
