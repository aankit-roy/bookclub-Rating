import 'package:bookclub/data/data_model/book_data.dart';
import 'package:bookclub/services/google_api/google_books_api.dart';
import 'package:flutter/material.dart';
import "package:html/parser.dart" show parse;

class BookDetailsPage extends StatefulWidget {
  final String bookId;

  const BookDetailsPage({super.key, required this.bookId});

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  final GoogleBooksApi _api = GoogleBooksApi();
  Book? bookDetails;
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
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  // String parseHtmlToPlainText(String htmlString) {
  //   final document = parse(htmlString);  // Parse HTML string
  //   return document.body!.text;  // Extract plain text
  // }

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
    final amount=saleInfo?.priceList?.amount;
    final currency= saleInfo?.priceList?.currencyCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          volumeInfo?.title ?? 'Book Details',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookDetails == null
          ? Center(child: Text('Failed to load book details'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Title
            Text(
              volumeInfo?.title ?? 'Unknown Title',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            // Authors
            Text(
              volumeInfo?.authors?.join(', ') ?? 'Unknown Author(s)',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),

            // Thumbnail Image
            Center(
              child: volumeInfo?.thumbnail != null
                  ? Image.network(
                volumeInfo!.thumbnail,
                fit: BoxFit.fitHeight,
                height: 250,
                width: 200,
              )
                  : Icon(
                Icons.book,
                size: 100,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),

            // Description
            Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              parseHtmlToPlainText(volumeInfo?.description),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            // Rating
            if (volumeInfo?.averageRating != null)
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  SizedBox(width: 4),
                  Text(
                    '${volumeInfo!.averageRating!.toStringAsFixed(1)} / 5.0 (${volumeInfo.ratingsCount ?? 0} ratings)',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            if (volumeInfo?.averageRating == null)
              Text('No ratings available.',
                  style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),

            // Sale Info
            if (saleInfo != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Purchase Info',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Price: ${amount?.toStringAsFixed(2) ?? 'Unavailable'} ${currency ?? ''}',
                    style: TextStyle(fontSize: 16),
                  ),
                  if (saleInfo.buyLink != null)
                    TextButton(
                      onPressed: () {
                        // Open buy link
                        // Use the appropriate method to open URL
                      },
                      child: Text('Buy this Book'),
                    ),
                ],
              ),
            SizedBox(height: 16),

            // Access Info
            if (accessInfo != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Access Info',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Viewability: ${accessInfo.viewability ?? 'Unknown'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Public Domain: ${accessInfo.publicDomain ?? false ? 'Yes' : 'No'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Embeddable: ${accessInfo.embeddable ?? false ? 'Yes' : 'No'}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }





}
