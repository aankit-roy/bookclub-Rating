import 'package:bookclub/data/data_model/book_data.dart';
import 'package:bookclub/res/constants/text_sizes.dart';
import 'package:bookclub/services/azure_service.dart';
import 'package:bookclub/services/google_api/google_books_api.dart';
import 'package:flutter/material.dart';
import 'package:bookclub/res/colors/app_colors.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:html/parser.dart" show parse;

class BookDetailsPage extends StatefulWidget {
  final String bookId;

  const BookDetailsPage({super.key, required this.bookId});

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  final GoogleBooksApi _api = GoogleBooksApi();
  final AzureService _azureService = AzureService();
  Book? bookDetails;
  String? summary;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
  }

  Future<void> fetchBookDetails() async {
    try {
      final data = await _api.fetchBookById(widget.bookId);
      setState(() {
        bookDetails = data;
      });
      await fetchSummary();
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchSummary() async {
    try {
      final volumeInfo = bookDetails?.volumeInfo;
      final response = await _azureService.getSummary(bookTitle: volumeInfo?.title ?? 'zero to one');
      setState(() {
        summary = response;
      });
    } catch (e) {
      print('Error fetching summary: $e');
    }
  }

  String parseHtmlToPlainText(String? html) {
    // Utility function to strip HTML tags, returning plain text.
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return html?.replaceAll(regex, '').trim() ?? 'No description available.';
  }

  @override
  Widget build(BuildContext context) {
    final volumeInfo = bookDetails?.volumeInfo;
    final saleInfo = bookDetails?.saleInfo;
    final accessInfo = bookDetails?.accessInfo;
    final amount = saleInfo?.priceList?.amount;
    final currency = saleInfo?.priceList?.currencyCode;

    return Scaffold(
      appBar: AppBar(
          // title: Text(
          //   volumeInfo?.title ?? 'Book Details',
          //   overflow: TextOverflow.ellipsis,
          // ),
          ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookDetails == null
              ? const Center(child: Text('Failed to load book details'))
              : SingleChildScrollView(
                  padding:  EdgeInsets.all(16.sp),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      //cover image
                      Container(
                        margin: EdgeInsets.only(top: 20.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Cover Image
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 2.sp,
                                    color:
                                        AppColors.primary.withOpacity(.4)),
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14.0),
                                child: volumeInfo?.thumbnail != null
                                    ? Image.network(
                                        volumeInfo!.thumbnail,
                                        fit: BoxFit.cover,
                                        width: 150.sp,
                                      )
                                    : Icon(
                                        Icons.book,
                                        size: 100,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            SizedBox(height: 8.sp),

                            // Book Details

                            // Buy Button
                            if (saleInfo?.buyLink != null)
                              ElevatedButton(
                                onPressed: () {
                                  // Handle buy link
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .blue, // Set the background color to blue
                                  foregroundColor:
                                      AppColors.black, // Set the text color
                                ),
                                child: Text(
                                  'Buy this Book',
                                  style: TextStyle(color: AppColors.black),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // title of the books
                      Padding(
                        padding:  EdgeInsets.symmetric(vertical: 8.sp,horizontal: 8.sp),
                        child: Text(
                          "${volumeInfo?.title}:" ?? 'Book Details',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: TextSizes.headlineMedium,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      // About Book Section
                      Container(
                        margin: EdgeInsets.only(bottom: 16.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 2.sp,
                            color: AppColors.primary.withOpacity(.4),
                          ),
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        padding: EdgeInsets.all(16.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Author(s): ',
                                style: TextStyle(
                                  fontSize: TextSizes.titleMedium,
                                  color: AppColors.textPrimary, // Label color
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: volumeInfo?.authors?.join(', ') ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: TextSizes.titleMedium,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Category: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: volumeInfo?.categories?.join(', ') ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Language: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: volumeInfo?.language ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 16,
                                     color: AppColors.textSecondary
                                    ),
                                  ),
                                ],
                              ),

                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Pages: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${volumeInfo?.pageCount ?? 'Unknown'}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:  AppColors.textSecondary
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Published: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: volumeInfo?.publishedDate ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                if (volumeInfo?.averageRating != null)
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber, size: 20.sp),
                                      SizedBox(width: 4),
                                      Text(
                                        '${volumeInfo!.averageRating!.toStringAsFixed(1)} / 5.0',
                                        style: TextStyle(
                                          fontSize: TextSizes.titleMedium,
                                          fontWeight: FontWeight.w800
                                        ),
                                      ),
                                    ],
                                  ),
                                if (volumeInfo?.averageRating == null)
                                  Text('', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),

                      // Container(
                      //   margin: EdgeInsets.only(bottom: 16.sp),
                      //
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border.all(
                      //         width: 2.sp,
                      //         color: AppColors.primary.withOpacity(.4)),
                      //     borderRadius: BorderRadius.circular(14.0),
                      //   ),
                      //   padding: EdgeInsets.all(16.sp),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment:
                      //     MainAxisAlignment.spaceBetween,
                      //     children: [
                      //
                      //       Text(
                      //         'Author(s): ${volumeInfo?.authors?.join(', ') ?? 'Unknown'}',
                      //         style: TextStyle(
                      //             fontSize: TextSizes.titleMedium),
                      //         maxLines: 2,
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //       Text(
                      //         'Category: ${volumeInfo?.categories?.join(', ') ?? 'Unknown'}',
                      //         style: TextStyle(fontSize: 16),
                      //         // maxLines: 2,
                      //         // overflow: TextOverflow.ellipsis,
                      //       ),
                      //       Text(
                      //         'Language: ${volumeInfo?.language ?? 'Unknown'}',
                      //         style: TextStyle(fontSize: 16),
                      //         maxLines: 2,
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //       Text(
                      //         'Pages: ${volumeInfo?.pageCount ?? 'Unknown'}',
                      //         style: TextStyle(fontSize: 16),
                      //       ),
                      //       Text(
                      //         'Published: ${volumeInfo?.publishedDate ?? 'Unknown'}',
                      //         style: TextStyle(fontSize: 16),
                      //       ),
                      //       SizedBox(height: 8),
                      //       Row(
                      //         children: [
                      //           if (volumeInfo?.averageRating != null)
                      //             Row(
                      //               children: [
                      //                 Icon(Icons.star,
                      //                     color: Colors.amber,
                      //                     size: 20),
                      //                 SizedBox(width: 4),
                      //                 Text(
                      //                   '${volumeInfo!.averageRating!.toStringAsFixed(1)} / 5.0',
                      //                   style: TextStyle(fontSize: 16),
                      //                 ),
                      //               ],
                      //             ),
                      //           if (volumeInfo?.averageRating == null)
                      //             Text('',
                      //                 style: TextStyle(fontSize: 16)),
                      //         ],
                      //       ),
                      //       SizedBox(height: 8),
                      //     ],
                      //   ),
                      // ),

                      // Short Description Section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 2.sp,
                              color: AppColors.primary.withOpacity(.4)),
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        padding: EdgeInsets.all(16.sp),
                        margin: EdgeInsets.only(bottom: 16.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                fontSize: TextSizes.titleLarge,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.sp),
                            ExpandableText(
                              text: parseHtmlToPlainText(
                                  volumeInfo?.description ?? ''),
                              maxLines: 4,
                              style: TextStyle(fontSize: TextSizes.titleMedium),
                            ),
                          ],
                        ),
                      ),

                      // Summary Section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 2.sp,
                              color: AppColors.primary.withOpacity(.4)),
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        padding: EdgeInsets.all(16.sp),
                        margin: EdgeInsets.only(bottom: 16.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Summary & Key Learning Points',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            ExpandableText(
                              text: summary ?? 'No summary available',
                              maxLines: 4,
                              style: TextStyle(fontSize: TextSizes.titleMedium),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;

  const ExpandableText({
    required this.text,
    required this.maxLines,
    this.style,
    super.key,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: widget.style,
          maxLines: isExpanded ? null : widget.maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? 'Read Less' : 'Read More',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
