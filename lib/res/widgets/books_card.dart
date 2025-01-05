
import 'package:bookclub/data/data_model/book_data.dart';
import 'package:bookclub/res/colors/app_colors.dart';
import 'package:bookclub/res/constants/text_sizes.dart';
import 'package:bookclub/screens/book_details_screen.dart';
import 'package:bookclub/services/riverpod/favourite_book_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class BookContainerCard extends ConsumerStatefulWidget {
  final Book book;
  const BookContainerCard({super.key, required this.book});

  @override
  ConsumerState<BookContainerCard> createState() => _BookContainerCardState();
}

class _BookContainerCardState extends ConsumerState<BookContainerCard> {

  // bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final averageRating = widget.book.volumeInfo.averageRating ?? 0.0;
    // Access favoriteBooksProvider state
    final favoriteBooks = ref.watch(favoriteBooksProvider);
    final isFavorite = favoriteBooks.contains(widget.book.id);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: BookDetailsPage(bookId: widget.book.id)));
      },
      child: Container(
        width: 140.sp,
        margin:   EdgeInsets.symmetric(horizontal: 8.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                  child: widget.book.volumeInfo.thumbnail.isNotEmpty
                      ? Image.network(widget.book.volumeInfo.thumbnail,
                      height: 140.sp, width: double.infinity, fit: BoxFit.cover)
                      : const Icon(
                    Icons.book,
                    size: 100,
                  ),
                ),
                Positioned(
                  top: -4,
                  left: -8,
                  child: GestureDetector(
                    onTap: () {

                      ref.read(favoriteBooksProvider.notifier).toggleFavorite(widget.book.id);
                      // setState(() {
                      //   isFavorite = !isFavorite;
                      // });
                    },
                    child: Icon(
                      isFavorite ? Icons.bookmark : Icons.bookmark_add_outlined,
                      color: Colors.red,
                      size: 36.0,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding:  EdgeInsets.all(8.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.book.volumeInfo.title,
                      style: TextStyle(
                        fontSize: TextSizes.titleMedium,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Text(
                      widget.book.volumeInfo.categories.join(', '),
                      style: TextStyle(
                        fontSize: TextSizes.labelMedium,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Text(
                      widget.book.volumeInfo.authors.join(', '),
                      style: TextStyle(
                          fontSize: TextSizes.labelMedium,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w800),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          averageRating > 0
                              ? averageRating.toStringAsFixed(1)
                              : ' ',
                          style: TextStyle(
                              fontSize: TextSizes.titleMedium,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
