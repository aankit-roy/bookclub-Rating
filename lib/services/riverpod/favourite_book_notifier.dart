import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteBooksNotifier extends StateNotifier<List<String>> {
  FavoriteBooksNotifier() : super([]);

  void toggleFavorite(String bookId) {
    if (state.contains(bookId)) {
      // Remove the ID if it already exists
      state = [...state]..remove(bookId);
    } else {
      // Add the ID if it doesn't exist
      state = [...state, bookId];
    }
  }

  bool isFavorite(String bookId) {
    return state.contains(bookId);
  }
}

final favoriteBooksProvider =
StateNotifierProvider<FavoriteBooksNotifier, List<String>>(
      (ref) => FavoriteBooksNotifier(),
);
