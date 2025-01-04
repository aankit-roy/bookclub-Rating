import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier to manage loading state
class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void setLoading(bool value) => state = value;
}

// Riverpod provider for loading state
final loadingProvider = StateNotifierProvider<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
});
