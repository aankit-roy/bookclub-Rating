import 'dart:async';

import 'package:bookclub/data/data_model/book_data.dart';
import 'package:bookclub/res/colors/app_colors.dart';
import 'package:bookclub/screens/book_details_screen.dart';
import 'package:bookclub/services/google_api/google_books_api.dart';
import 'package:flutter/material.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
 
  final GoogleBooksApi _api = GoogleBooksApi();
  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];
  List<String> _suggestions = [];
  bool _isLoading = false;
  Timer? _debounce;

  void _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _api.searchBooks(query);
      setState(() {
        _searchResults = results;
      });

      // Update suggestions with book titles
      _suggestions = results.map((book) => book.volumeInfo.title).take(10).toList();
    } catch (e) {
      print('Error during search: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchTextChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _suggestions = [];
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Your Next Book'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by book title, author, or category...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: _onSearchTextChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Suggestions Section
          if (_suggestions.isNotEmpty)
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _searchController.text = _suggestions[index];
                      _performSearch();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Chip(label: Text(_suggestions[index])),
                    ),
                  );
                },
              ),
            ),
          // Search Results Section
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                ? Center(child: Text('No results found'))
                : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final book = _searchResults[index];
                return ListTile(
                  leading: book.volumeInfo.thumbnail.isNotEmpty
                      ? Image.network(
                    book.volumeInfo.thumbnail,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.book, size: 50),
                  title: Text(book.volumeInfo.title),
                  subtitle: Text(
                    book.volumeInfo.authors.join(', '),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookDetailsPage(bookId: book.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
