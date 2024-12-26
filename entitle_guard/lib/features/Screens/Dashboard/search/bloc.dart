// Define SearchBloc class to manage the state of the search screen
import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

class SearchBloc {
  // Stream controller to handle search queries
  final _searchController = StreamController<String>.broadcast();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _googleSignInAccount; // Add this property

  // Stream to emit search queries
  Stream<String> get searchStream => _searchController.stream;

  // Method to update search query
  void updateSearch(String query) async {
    _searchController.sink.add(query);
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    // Set the GoogleSignInAccount property
    _googleSignInAccount = googleSignInAccount;
  }

  // Method to dispose of the stream controller
  void dispose() {
    _searchController.close();
  }

  // Getter to access the GoogleSignInAccount instance
  GoogleSignInAccount? get googleSignInAccount => _googleSignInAccount;
}
