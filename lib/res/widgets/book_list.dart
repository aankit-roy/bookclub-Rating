import 'package:bookclub/data/data_model/book_data.dart';
import 'package:bookclub/res/widgets/books_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookLists extends StatelessWidget {
  final Future<List<Book>> futureBooks;

  const BookLists({super.key, required this.futureBooks});

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
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
          return SizedBox(
            height: size.height*.34,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return BookContainerCard(
                  book: book,
                );
              },
            ),
          );
        }
      },
    );
  }
}