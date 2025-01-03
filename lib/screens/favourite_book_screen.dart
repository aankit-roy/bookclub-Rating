import 'package:bookclub/data/data_model/book_data.dart';
import 'package:bookclub/res/widgets/book_category_card.dart';
import 'package:bookclub/res/widgets/books_card.dart';
import 'package:bookclub/services/google_api/google_books_api.dart';
import 'package:bookclub/services/riverpod/favourite_book_notifier.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteBooksScreen extends ConsumerWidget {
  FavoriteBooksScreen({super.key});

  final GoogleBooksApi _api = GoogleBooksApi();

  // Fetch books based on the favorite IDs

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteBooks = ref.watch(favoriteBooksProvider);

    Future<List<Book>> fetchFavoriteBooks() async {
      List<Book> books = [];
      for (String bookId in favoriteBooks) {
        final book = await _api.fetchBookById(bookId); // Replace with your API method
        if (book != null) books.add(book);
      }
      return books;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Books'),
      ),
      body: favoriteBooks.isEmpty
          ? const Center(
        child: Text('No favorite books yet!'),
      )
          : FutureBuilder<List<Book>>(
        future: fetchFavoriteBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No books found'));
          } else {
            final books = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                mainAxisSpacing: 16.0, // Spacing between rows
                crossAxisSpacing: 8.0, // Spacing between columns
                childAspectRatio: 2.5 / 3.3, // Aspect ratio for book cards
              ),
              physics: const BouncingScrollPhysics(), // Smooth scrolling behavior
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return BookContainerCard(
                  book: book,
                );
              },
            );
          }
        },
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Favorite Books'),
    //   ),
    //   body: favoriteBooks.isEmpty
    //       ? const Center(child: Text('No favorite books yet!'))
    //       : ListView.builder(
    //           itemCount: favoriteBooks.length,
    //           itemBuilder: (context, index) {
    //             final bookId = favoriteBooks[index];
    //
    //             return FutureBuilder(
    //               future: _api.fetchBookById(bookId), // Your API call
    //               builder: (context, snapshot) {
    //                 if (snapshot.connectionState == ConnectionState.waiting) {
    //                   return const Center(child: CircularProgressIndicator());
    //                 }
    //                 if (snapshot.hasError) {
    //                   return const ListTile(
    //                     title: Text('Error loading book details'),
    //                   );
    //                 }
    //
    //                 final book = snapshot.data; // Replace with your book model
    //
    //                 return ListTile(
    //                   leading: book!.volumeInfo.thumbnail.isNotEmpty
    //                       ? Image.network(book!.volumeInfo.thumbnail)
    //                       : const Icon(Icons.book),
    //                   title: Text(book.volumeInfo.title),
    //                   subtitle: Text(book.volumeInfo.authors.join(', ')),
    //                 );
    //               },
    //             );
    //           },
    //         ),
    // );
  }
}
