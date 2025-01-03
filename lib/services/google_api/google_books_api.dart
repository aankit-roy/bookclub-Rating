import 'dart:convert';
import 'package:bookclub/data/data_model/book_data.dart';
import 'package:http/http.dart' as http;

class GoogleBooksApi {
  static const String apiKey =
      'AIzaSyDZpR7ynE2Wad2ZvY3DhiqSjfdnaSur9jA'; // Replace with your API key

  static const String baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  // Method to search books
  Future<List<Book>> searchBooks(String searchText) async {
    final url = Uri.parse(
        '$baseUrl?q=$searchText&key=$apiKey&maxResults=20&orderBy=relevance');

    if (searchText.isEmpty) {
      return [];
    }

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data['items'] != null) {
          return (data['items'] as List<dynamic>)
              .map((item) => Book.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          return []; // No books found
        }
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  // Fetch books by category
  Future<List<Book>> fetchBooksByCategory(String category) async {
    final encodedCategory = Uri.encodeComponent(category);
    final url = Uri.parse('$baseUrl?q=$encodedCategory&maxResults=20&key=$apiKey');
    // final url = Uri.parse('$baseUrl?q=$encodedCategory&orderBy=newest&maxResults=20&key=$apiKey');
    try {
      final response = await http.get(url);

      // Print the URL for debugging
      print('Request URL: $url');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Print the full response for debugging
        print(
            '***********************************Response Data: ${response.body}');

        if (data['items'] != null) {
          final books = (data['items'] as List<dynamic>)
              .map((item) => Book.fromJson(item as Map<String, dynamic>))
              .toList(); // Convert Iterable to List<Book>
          return books;
        } else {
          // No books found for the category
          return [];
        }
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching books by category: $e');
    }
  }

  // Fetch details of a specific book by ID
  Future<Book> fetchBookById(String bookId) async {
    final url = Uri.parse('$baseUrl/$bookId?key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Book.fromJson(data); // Use the model class
      } else {
        throw Exception('Failed to load book details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching book details: $e');
    }
  }

  Future<List<Book>> fetchTrendingBooks(String category) async {
    final url = Uri.parse('$baseUrl?q=$category&key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['items'] != null) {
          return (data['items'] as List<dynamic>)
              .map((item) => Book.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception(
            'Failed to load trending books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching trending books: $e');
    }
  }

  Future<List<Book>> fetchNewestBooks() async {
    // final url = Uri.parse('$baseUrl/$bookId?key=$apiKey');
    // final url = Uri.parse('$baseUrl?q=&orderBy=newest&maxResults=10&key=$apiKey');
    final url = Uri.parse('$baseUrl?q=new&orderBy=newest&key=$apiKey');


    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data['items'] != null) {
          return (data['items'] as List<dynamic>)
              .map((item) => Book.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load top books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching top books: $e');
    }
  }

  // its not working
  Future<List<Book>> fetchFanFavouriteBooks() async {
    final url = Uri.parse('$baseUrl?q=*&orderBy=relevance&key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['items'] != null) {
          return (data['items'] as List<dynamic>)
              .map((item) => Book.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception(
            'Failed to load fan-favourite books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching fan-favourite books: $e');
    }
  }


  Future<List<Book>> fetchBooksByAuthor(String author) async {
    final url = Uri.parse('$baseUrl?q=inauthor:$author&key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['items'] != null) {
          return (data['items'] as List<dynamic>)
              .map((item) => Book.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception(
            'Failed to load books by author: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching books by author: $e');
    }
  }
}
