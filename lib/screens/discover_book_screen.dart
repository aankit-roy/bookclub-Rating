import 'dart:math';

import 'package:bookclub/data/data_model/book_data.dart';
import 'package:bookclub/res/colors/app_colors.dart';
import 'package:bookclub/res/constants/text_sizes.dart';
import 'package:bookclub/res/widgets/category_book_list.dart';
import 'package:bookclub/screens/book_details_screen.dart';
import 'package:bookclub/screens/discover_book_screen.dart';
import 'package:bookclub/services/google_api/google_books_api.dart';
import 'package:bookclub/services/riverpod/favourite_book_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

// class DiscoverBookScreen extends StatefulWidget {
//   final String category;
//   const DiscoverBookScreen({super.key, required this.category});
//
//   @override
//   State<DiscoverBookScreen> createState() => _DiscoverBookScreenState();
// }
//
// class _DiscoverBookScreenState extends State<DiscoverBookScreen> {
//
//   final List<Map<String, String>> categories = [
//     {"title": "Startups", "image": "assets/images/startup.jpg"},
//     {"title": "Business", "image": "assets/images/startup.jpg"},
//     {"title": "Romance", "image": "assets/images/startup.jpg"},
//     {"title": "Philosophy", "image":"assets/images/startup.jpg"},
//     {"title": "History", "image": "assets/images/startup.jpg"},
//     {"title": "Startups", "image": "assets/images/startup.jpg"},
//     {"title": "Business", "image": "assets/images/startup.jpg"},
//     {"title": "Romance", "image": "assets/images/startup.jpg"},
//     {"title": "Philosophy", "image":"assets/images/startup.jpg"},
//     {"title": "History", "image": "assets/images/startup.jpg"},
//     {"title": "Startups", "image": "assets/images/startup.jpg"},
//     {"title": "Business", "image": "assets/images/startup.jpg"},
//     {"title": "Romance", "image": "assets/images/startup.jpg"},
//     {"title": "Philosophy", "image":"assets/images/startup.jpg"},
//     {"title": "History", "image": "assets/images/startup.jpg"},
//     {"title": "Startups", "image": "assets/images/startup.jpg"},
//     {"title": "Business", "image": "assets/images/startup.jpg"},
//     {"title": "Romance", "image": "assets/images/startup.jpg"},
//     {"title": "Philosophy", "image":"assets/images/startup.jpg"},
//     {"title": "History", "image": "assets/images/startup.jpg"},
//     {"title": "Startups", "image": "assets/images/startup.jpg"},
//     {"title": "Business", "image": "assets/images/startup.jpg"},
//     {"title": "Romance", "image": "assets/images/startup.jpg"},
//     {"title": "Philosophy", "image":"assets/images/startup.jpg"},
//     {"title": "History", "image": "assets/images/startup.jpg"},
//     // {"title": "Science", "image": "assets/images/science.jpg"},
//     // {"title": "Art", "image": "assets/images/art.jpg"},
//     // {"title": "Technology", "image": "assets/images/technology.jpg"},
//     // {"title": "Self-Help", "image": "assets/images/self_help.jpg"},
//     // {"title": "Fiction", "image": "assets/images/fiction.jpg"},
//     // {"title": "Non-Fiction", "image": "assets/images/non_fiction.jpg"},
//     // {"title": "Biographies", "image": "assets/images/biographies.jpg"},
//     // {"title": "Mystery", "image": "assets/images/mystery.jpg"},
//     // {"title": "Fantasy", "image": "assets/images/fantasy.jpg"},
//     // {"title": "Thriller", "image": "assets/images/thriller.jpg"},
//     // {"title": "Adventure", "image": "assets/images/adventure.jpg"},
//     // {"title": "Education", "image": "assets/images/education.jpg"},
//     // {"title": "Cooking", "image": "assets/images/cooking.jpg"},
//     // {"title": "Health", "image": "assets/images/health.jpg"},
//     // {"title": "Travel", "image": "assets/images/travel.jpg"},
//   ];
//
//
//   final GoogleBooksApi _api = GoogleBooksApi();
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Discover',
//           style: TextStyle(fontSize: TextSizes.headlineMedium),
//         ),
//         // bottom: PreferredSize(
//         //   preferredSize: Size.fromHeight(size.height * 0.1),
//         //   child: const Padding(
//         //     padding:
//         //     EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//         //     child: InkWell(
//         //       // onTap: () {
//         //       //   Navigator.push(
//         //       //     context,
//         //       //     // PageTransition(
//         //       //     //   type: PageTransitionType.bottomToTop,
//         //       //     //   child: const SearchBarScreen(),
//         //       //     // ),
//         //       //   );
//         //       // },
//         //       child: SearchBarHolder(),
//         //     ),
//         //   ),
//         // ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: MasonryGridView.builder(
//           gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//           ),
//           itemCount: categories.length,
//           itemBuilder: (context, index) {
//             return _buildCategoryCard(
//               categories[index]["title"]!,
//               index,
//               categories[index]["image"]!,
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // Widget _buildCategoryCard(String title, String imagePath) {
//   //   return Container(
//   //     width: 140.0,
//   //     height: 200.0,
//   //     margin: const EdgeInsets.symmetric(horizontal: 8.0),
//   //     decoration: BoxDecoration(
//   //       borderRadius: BorderRadius.circular(12.0),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: Colors.black.withOpacity(0.2),
//   //           blurRadius: 2.0,
//   //           offset: const Offset(0, .4),
//   //         ),
//   //       ],
//   //       image: DecorationImage(
//   //         image: AssetImage(imagePath),
//   //         fit: BoxFit.cover,
//   //       ),
//   //     ),
//   //     child: Stack(
//   //       children: [
//   //         Container(
//   //           decoration: BoxDecoration(
//   //             borderRadius: BorderRadius.circular(12.0),
//   //             gradient: LinearGradient(
//   //               begin: Alignment.bottomCenter,
//   //               end: Alignment.topCenter,
//   //               colors: [
//   //                 Colors.black.withOpacity(0.7),
//   //                 Colors.transparent,
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //         Center(
//   //           child: Text(
//   //             title,
//   //             textAlign: TextAlign.center,
//   //             style: const TextStyle(
//   //               fontSize: 18.0,
//   //               fontWeight: FontWeight.bold,
//   //               color: Colors.white,
//   //               shadows: [
//   //                 Shadow(
//   //                   color: Colors.black,
//   //                   blurRadius: 8.0,
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//   Widget _buildCategoryCard(String title,int index, String imagePath) {
//     return Container(
//       margin: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8.0,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         image: DecorationImage(
//           image: AssetImage(imagePath),
//           fit: BoxFit.cover,
//         ),
//       ),
//       height: (120.sp + (index % 4) * 40).toDouble(), // Randomized height
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12.0),
//               gradient: LinearGradient(
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//                 colors: [
//                   Colors.black.withOpacity(0.7),
//                   Colors.transparent,
//                 ],
//               ),
//             ),
//           ),
//           Center(
//             child: Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 shadows: [
//                   Shadow(
//                     color: Colors.black,
//                     blurRadius: 8.0,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }

class DiscoverBookScreen extends StatefulWidget {
  final String category;
  const DiscoverBookScreen({super.key, required this.category});

  @override
  State<DiscoverBookScreen> createState() => _DiscoverBookScreenState();
}

class _DiscoverBookScreenState extends State<DiscoverBookScreen> {
  final List<Map<String, String>> categories = [
    {"title": "Startups"},
    {"title": "Business"},
    {"title": "Romance"},
    {"title": "Philosophy"},
    {"title": "History"},
    {"title": "Science"},
    {"title": "Art"},
    {"title": "Technology"},
    {"title": "Self Help"},
    {"title": "Fiction"},
    {"title": "Non Fiction"},
    {"title": "Biographies"},
    {"title": "Mystery"},
    {"title": "Fantasy"},
    {"title": "Thriller"},
    {"title": "Adventure"},
    {"title": "Education"},
    {"title": "Cooking"},
    {"title": "Health"},
    {"title": "Travel"},
    {"title": "Poetry"},
    {"title": "Psychology"},
    {"title": "Spirituality"},
    {"title": "Autobiographies"},
    {"title": "Science Fiction"},
    {"title": "Comics"},
    {"title": "Drama"},
    {"title": "Politics"},
    {"title": "Economics"},
    {"title": "Parenting"},
    {"title": "Gardening"},
    {"title": "DIY"},
    {"title": "Music"},
    {"title": "Horror"},
    {"title": "Sports"},
    {"title": "Law"},
    {"title": "Anthologies"},
    {"title": "Mythology"},
    {"title": "Animals"},
    {"title": "Environment"},
    {"title": "Relationships"},
  ];

  final GoogleBooksApi _api = GoogleBooksApi();

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = categories.first["title"]; // Default selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover"),
      ),
      body: Row(
        children: [
          // Categories List
          Container(
            width: MediaQuery.of(context).size.width * 0.3, // 20% of the screen
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final title = category["title"]!;


//               index,
//               categories[index]["image"]!,

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category["title"];
                    });
                  },
                  child: _buildCategoryCard2(title,
                      isSelected: selectedCategory == title),
                );
              },
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: selectedCategory == null
                  ? Center(
                child: Text(
                  "Select a category to view books",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : CategoryBookLists(
                futureBooks:_api.fetchBooksByCategory(selectedCategory!), // Replace with your fetch function
              ),
            ),
          ),

          // Books List
          // Expanded(
          //   child: Container(
          //     padding: const EdgeInsets.all(8.0),
          //     child: selectedCategory == null
          //         ? Center(
          //             child: Text(
          //               "Select a category to view books",
          //               style: TextStyle(fontSize: 18, color: Colors.grey),
          //             ),
          //           )
          //         : GridView.builder(
          //             gridDelegate:
          //                 const SliverGridDelegateWithFixedCrossAxisCount(
          //               crossAxisCount: 2,
          //               mainAxisSpacing: 8.0,
          //               crossAxisSpacing: 8.0,
          //               childAspectRatio: 2 / 3,
          //             ),
          //             itemCount: booksByCategory[selectedCategory]?.length ?? 0,
          //             itemBuilder: (context, index) {
          //               final book = booksByCategory[selectedCategory]![index];
          //               return Container(
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(8.0),
          //                   image: DecorationImage(
          //                     image: AssetImage(book["image"]!),
          //                     fit: BoxFit.cover,
          //                   ),
          //                 ),
          //                 child: Stack(
          //                   children: [
          //                     Container(
          //                       decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(8.0),
          //                         gradient: LinearGradient(
          //                           begin: Alignment.bottomCenter,
          //                           end: Alignment.topCenter,
          //                           colors: [
          //                             Colors.black.withOpacity(0.7),
          //                             Colors.transparent,
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                     Center(
          //                       child: Text(
          //                         book["title"]!,
          //                         textAlign: TextAlign.center,
          //                         style: const TextStyle(
          //                           fontSize: 16,
          //                           fontWeight: FontWeight.bold,
          //                           color: Colors.white,
          //                           shadows: [
          //                             Shadow(
          //                               color: Colors.black,
          //                               blurRadius: 8.0,
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               );
          //             },
          //           ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard2(String title,
      {required bool isSelected}) {
    // Generate a random light color
    final Color bgColor = _generateRandomLightColor();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 4),
      child: Container(
        height: 100.h,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: isSelected
              ? Border.all(width: 4, color: AppColors.primary)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2.0,
              offset: const Offset(0, .4),
            ),
          ],
          color: bgColor,
          // image: DecorationImage(
          //   image: AssetImage(imagePath),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                // gradient: LinearGradient(
                //   begin: Alignment.bottomCenter,
                //   end: Alignment.topCenter,
                //   colors: [
                //     Colors.black.withOpacity(0.7),
                //     Colors.transparent,
                //   ],
                // ),

                boxShadow: [
                  BoxShadow(
                    color: bgColor.withOpacity(0.3),
                    blurRadius: 3.0,
                    offset: const Offset(0, 0.4),
                  ),
                ],
                color: bgColor, // Set the random background color
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: TextSizes.titleSmall,
                    fontWeight: FontWeight.w800,

                    color: isSelected ? AppColors.primary : AppColors.black,
                    // shadows: [
                    //   Shadow(
                    //     color: Colors.black,
                    //     blurRadius: 8.0,
                    //   ),
                    // ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to generate a random light color
  Color _generateRandomLightColor() {
    final Random random = Random();
    return Color.fromRGBO(
      200 + random.nextInt(56), // Red value between 200 and 255
      200 + random.nextInt(56), // Green value between 200 and 255
      200 + random.nextInt(56), // Blue value between 200 and 255
      1.0, // Full opacity
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

// class CategoryBookLists extends StatelessWidget {
//   final Future<List<Book>> futureBooks;
//
//   const  CategoryBookLists({super.key, required this.futureBooks});
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
//           return GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2, // 2 columns
//               mainAxisSpacing: 16.0, // Spacing between rows
//               crossAxisSpacing: 8.0, // Spacing between columns
//               childAspectRatio: 1.8 / 3.5, // Aspect ratio for book cards
//             ),
//             physics: const BouncingScrollPhysics(), // Smooth scrolling behavior
//
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               final book = books[index];
//               return BookCategoryCard(
//                 book: book,
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }
//



// class BookCategoryCard extends ConsumerStatefulWidget {
//   final Book book;
//   const BookCategoryCard({super.key, required this.book});
//
//   @override
//   ConsumerState<BookCategoryCard> createState() => _BookCategoryCardState();
// }
//
// class _BookCategoryCardState extends ConsumerState<BookCategoryCard> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     final averageRating = widget.book.volumeInfo.averageRating ?? 0.0;
//     // Access favoriteBooksProvider state
//     final favoriteBooks = ref.watch(favoriteBooksProvider);
//     final isFavorite = favoriteBooks.contains(widget.book.id);
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//             context,
//             PageTransition(
//                 type: PageTransitionType.rightToLeft,
//                 child: BookDetailsPage(bookId: widget.book.id)));
//       },
//       child: Container(
//         width: 140.sp,
//
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ClipRRect(
//             //   borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
//             //   child: book.volumeInfo.thumbnail.isNotEmpty
//             //       ? Image.network(book.volumeInfo.thumbnail,
//             //           height: 140.sp, width: double.infinity, fit: BoxFit.cover)
//             //       : Icon(
//             //           Icons.book,
//             //           size: 100,
//             //         ),
//             // ),
//
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
//                   child: widget.book.volumeInfo.thumbnail.isNotEmpty
//                       ? Image.network(widget.book.volumeInfo.thumbnail,
//                       height: 130.sp, width: double.infinity, fit: BoxFit.cover)
//                       : const Icon(
//                     Icons.book,
//                     size: 100,
//                   ),
//                 ),
//                 Positioned(
//                   top: -4,
//                   left: -8,
//                   child: GestureDetector(
//                     onTap: () {
//                       // setState(() {
//                       //   isFavorite = !isFavorite;
//                       // });
//                       ref.read(favoriteBooksProvider.notifier).toggleFavorite(widget.book.id);
//
//
//                     },
//                     child: Icon(
//                       isFavorite ? Icons.bookmark : Icons.bookmark_add_outlined,
//                       color: Colors.red,
//                       size: 36.0,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.all(8),
//
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       widget.book.volumeInfo.title,
//                       style: TextStyle(
//                         fontSize: TextSizes.titleSmall,
//                         fontWeight: FontWeight.w700,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     Text(
//                       widget.book.volumeInfo.categories.join(', '),
//                       style: TextStyle(
//                         fontSize: TextSizes.labelLarge,
//                         color: AppColors.textSecondary,
//                         fontWeight: FontWeight.w700,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     Text(
//                       widget.book.volumeInfo.authors.join(', '),
//                       style: TextStyle(
//                           fontSize: TextSizes.labelMedium,
//                           color: AppColors.textSecondary,
//                           fontWeight: FontWeight.w600),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           averageRating > 0
//                               ? averageRating.toStringAsFixed(1)
//                               : ' ',
//                           style: TextStyle(
//                               fontSize: TextSizes.titleMedium,
//                               fontWeight: FontWeight.w700
//                           ),
//                         ),
//                         const SizedBox(width: 4.0),
//                         const Icon(
//                           Icons.star,
//                           color: Colors.amber,
//                           size: 16.0,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//



