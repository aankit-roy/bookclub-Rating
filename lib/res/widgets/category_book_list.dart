

import 'package:bookclub/data/data_model/book_data.dart';
import 'package:bookclub/res/widgets/book_category_card.dart';

import 'package:bookclub/screens/discover_book_screen.dart';

import 'package:flutter/material.dart';


class CategoryBookLists extends StatelessWidget {
  final Future<List<Book>> futureBooks;

  const  CategoryBookLists({super.key, required this.futureBooks});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: futureBooks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(child: Text('No books found'));
        } else {
          final books = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              mainAxisSpacing: 16.0, // Spacing between rows
              crossAxisSpacing: 8.0, // Spacing between columns
              childAspectRatio: 1.8 / 3.5, // Aspect ratio for book cards
            ),
            physics: const BouncingScrollPhysics(), // Smooth scrolling behavior

            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCategoryCard(
                book: book,
              );
            },
          );
        }
      },
    );
  }
}

