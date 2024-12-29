import 'package:bookclub/data/data_model/book_data.dart';
import 'package:bookclub/screens/book_details_screen.dart';
import 'package:bookclub/services/google_api/google_books_api.dart';
import 'package:flutter/material.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("home page"),
//       ),
//       body: Container(
//         width: 200,
//         height: 200,
//         child: Card(
//           child: Center(
//             child: Text("This is HomePage",style: TextStyle(
//               fontSize: 35,
//
//             ),),
//           ),
//         ),
//       ),
//
//     );
//   }
// }






class HomeScreen extends StatefulWidget {

  final String category;

   const HomeScreen({super.key, required this.category});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleBooksApi _api = GoogleBooksApi();
  List<Book> books = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final fetchedBooks = await _api.fetchBooksByCategory(widget.category);
      setState(() {
        books = fetchedBooks;
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Google Books API')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          final volumeInfo = book.volumeInfo;

          // Safeguard against null values
          final thumbnailUrl = volumeInfo.thumbnail ?? '';
          final title = volumeInfo.title ?? 'Unknown Title';
          final authors = volumeInfo.authors?.join(', ') ?? 'Unknown Author';
          final averageRating = volumeInfo.averageRating ?? 0.0;
          final bookId = book.id; // Extract the book ID
          return ListTile(

            leading: thumbnailUrl.isNotEmpty
                ? Image.network(thumbnailUrl, fit: BoxFit.cover)
                : Icon(Icons.book, size: 50),
            title: Text(title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(authors),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      averageRating > 0 ? averageRating.toStringAsFixed(1) : 'No rating',
                    ),
                  ],
                ),
              ],
            ),
            // leading: book.volumeInfo.thumbnail.isNotEmpty
            //     ? Image.network(book.volumeInfo.thumbnail)
            //     : Icon(Icons.book, size: 50),
            // title: Text(book.volumeInfo.title),
            // subtitle: Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(book.volumeInfo.authors.join(', ')),
            //     Row(
            //       children: [
            //         Icon(Icons.star, color: Colors.amber, size: 16),
            //         SizedBox(width: 4),
            //         Text(
            //           book.volumeInfo.averageRating! > 0
            //               ? book.volumeInfo.averageRating!.toStringAsFixed(1)
            //               : 'No rating',
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>BookDetailsPage(bookId: bookId)

              ));
            },
          );
        },
      ),
    );
  }
}
