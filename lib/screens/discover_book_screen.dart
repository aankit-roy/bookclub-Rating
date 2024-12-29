import 'package:bookclub/data/data_model/book_data.dart';
import 'package:bookclub/res/widgets/section_title.dart';
import 'package:bookclub/screens/book_details_screen.dart';
import 'package:bookclub/services/google_api/google_books_api.dart';
import 'package:flutter/material.dart';

class DiscoverBookScreen extends StatefulWidget {
  const DiscoverBookScreen({super.key});

  @override
  State<DiscoverBookScreen> createState() => _DiscoverBookScreenState();
}

class _DiscoverBookScreenState extends State<DiscoverBookScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GoogleBooksApi _api = GoogleBooksApi();
   List<Book> _searchResults = [];
   bool _isSearching = false;
  // @override
  // void initState() {
  //   super.initState();
  //   fetchedSearchBooks();
  // }


  Future<void> fetchedSearchBooks(String query) async {

    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final results = _api.searchBooks(query);
      setState(() {
        _searchResults = results as List<Book>;
      });
    } catch (e) {
      print('Error searching books: $e');
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Discover Books')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Books, Authors, Categories...',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      fetchedSearchBooks(_searchController.text);
                    },
                  ),
                ),
              ),
            ),

            // Search Results
            if (_isSearching)
              Center(child: CircularProgressIndicator())
            else if (_searchResults.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(title: 'Search Results'),
                  BooksList(futureBooks: Future.value(_searchResults)),
                ],
              )
            else if (_searchController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('No results found.'),
                ),



            // Trending Books Section
            SectionTitle(title: 'Trending Books'),
            BooksList(futureBooks:_api.fetchLatestBooks("Top Books")),

            // Highest Rated Books Section
            SectionTitle(title: 'Highest Rated Books'),
            BooksList(futureBooks: _api.fetchHighestRatedBooks('startup')),

            // Books by Author Section
            SectionTitle(title: 'Books by Author'),
            BooksList(futureBooks: _api.fetchBooksByAuthor('Stephen King')),
          ],
        ),
      ),
    );
  }

}

class BooksList extends StatelessWidget {
  final Future<List<Book>> futureBooks;

  const BooksList({super.key, required this.futureBooks});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: futureBooks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(child: Text('No books found'));
        } else {
          final books = snapshot.data!;
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return BookCard(book: book);
              },
            ),
          );
        }
      },
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookDetailsPage(bookId: book.id)),
        );
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            book.volumeInfo.thumbnail.isNotEmpty
                ? Image.network(book.volumeInfo.thumbnail, height: 100)
                : Icon(Icons.book, size: 100),
            SizedBox(height: 8),
            Text(
              book.volumeInfo.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              book.volumeInfo.authors.join(', '),
              style: TextStyle(fontSize: 14, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

