import 'package:bookclub/data/data_model/book_data.dart';
import 'package:bookclub/res/colors/app_colors.dart';
import 'package:bookclub/res/constants/text_sizes.dart';
import 'package:bookclub/res/widgets/book_list.dart';
import 'package:bookclub/res/widgets/books_card.dart';
import 'package:bookclub/res/widgets/section_title.dart';
import 'package:bookclub/screens/home_screen.dart';
import 'package:bookclub/screens/search_bar_screen.dart';
import 'package:bookclub/services/google_api/google_books_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  // final String category;

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final GoogleBooksApi _api = GoogleBooksApi();
  // List<Book> books = [];
  // bool isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchBooks();
  // }

  // Future<void> fetchBooks() async {
  //   try {
  //     final fetchedBooks = await _api.fetchBooksByCategory(widget.category);
  //     setState(() {
  //       books = fetchedBooks;
  //     });
  //   } catch (e) {
  //     print('Error: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('Test Google Books API')),
  //     body: isLoading
  //         ? Center(child: CircularProgressIndicator())
  //         : ListView.builder(
  //       itemCount: books.length,
  //       itemBuilder: (context, index) {
  //         final book = books[index];
  //         final volumeInfo = book.volumeInfo;

  //         // Safeguard against null values
  //         final thumbnailUrl = volumeInfo.thumbnail ?? '';
  //         final title = volumeInfo.title ?? 'Unknown Title';
  //         final authors = volumeInfo.authors?.join(', ') ?? 'Unknown Author';
  //         final averageRating = volumeInfo.averageRating ?? 0.0;
  //         final bookId = book.id; // Extract the book ID
  //         return ListTile(

  //           leading: thumbnailUrl.isNotEmpty
  //               ? Image.network(thumbnailUrl, fit: BoxFit.cover)
  //               : Icon(Icons.book, size: 50),
  //           title: Text(title),
  //           subtitle: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(authors),
  //               Row(
  //                 children: [
  //                   Icon(Icons.star, color: Colors.amber, size: 16),
  //                   SizedBox(width: 4),
  //                   Text(
  //                     averageRating > 0 ? averageRating.toStringAsFixed(1) : 'No rating',
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),

  //           onTap: (){
  //             Navigator.push(context, MaterialPageRoute(
  //                 builder: (context)=>BookDetailsPage(bookId: bookId)

  //             ));
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  final GoogleBooksApi _api = GoogleBooksApi();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Club',
          style: TextStyle(fontSize: TextSizes.headlineMedium),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.1),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: const SearchBarScreen(),
                  ),
                );
              },
              child: SearchBarHolder(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: "Top Picks",
            ),
            BookLists(futureBooks: _api.fetchLatestBooks("Top Books")),
            SizedBox(
              height: 10.sp,
            ),
            const SectionTitle(title: 'Best Sellers'),
            BookLists(futureBooks: _api.fetchLatestBooks("Bestsellers")),
            SizedBox(
              height: 10.sp,
            ),
            const SectionTitle(title: 'Fan Favorites'),
            BookLists(futureBooks: _api.fetchLatestBooks("Top Books")),
            SizedBox(
              height: 10.sp,
            ),
            const SectionTitle(title: 'Newest Books'),
            BookLists(futureBooks: _api.fetchLatestBooks("Top Books")),
            SizedBox(
              height: 10.sp,
            ),
          ],
        ),
      ),
    );
  }

}


class SearchBarHolder extends StatelessWidget {
  const SearchBarHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 46.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.textPrimary),
                const SizedBox(width: 8.0),
                Text(
                  'Search by book title, author, or category...',
                  style: TextStyle(
                      fontSize: TextSizes.titleMedium,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// class BookLists extends StatelessWidget {
//   final Future<List<Book>> futureBooks;
//
//   const BookLists({super.key, required this.futureBooks});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Book>>(
//       future: futureBooks,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (snapshot.hasData && snapshot.data!.isEmpty) {
//           return const Center(child: Text('No books found'));
//         } else {
//           final books = snapshot.data!;
//           return SizedBox(
//             height: 240.sp,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: books.length,
//               itemBuilder: (context, index) {
//                 final book = books[index];
//                 return BookContainerCard(
//                   book: book,
//                 );
//               },
//             ),
//           );
//         }
//       },
//     );
//   }
// }
