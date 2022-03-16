import 'dart:convert';

import 'package:bookstore/models/book.dart';
import 'package:bookstore/util/constants.dart';
import 'package:bookstore/util/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

/// Abstract class defining core methods to work with API
abstract class BaseApiController {
  /// [limit] is an int denoting no. of books returned from the API result.
  Future<List<Book>> getNewBooks({int limit = 8});

  /// [limit] is an int denoting no. of books returned from the API result.
  Future<List<Book>> getRecommendedBooks({int limit = 8});

  Future<List<Book>> getSavedBooks();

  Future<void> saveBook(int isbn13);

  Future<List<Book>> searchBookByQuery(String query);

  /// Fetch specific book details by [isbn13] number.
  Future<Book> getBookDetails(String isbn13);
}

class ApiController extends GetxController implements BaseApiController {
  final http.Client _connect;
  final SharedPreferences _preferences;

  ApiController(http.Client client, SharedPreferences preferences)
      : _connect = client,
        _preferences = preferences;

  /// Helper function to fetch data  from [url] and parse the JSON response
  /// to Map<>.
  Future<Map<String, dynamic>> _requestData(Uri url) async {
    try {
      final response = await _connect.get(url);

      if (response.statusCode == 200) {
        debugPrint('${json.decode(response.body) as Map<String, dynamic>}');
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        final String error =
            "Request failed with status code ${response.statusCode} "
            "and error ${response.reasonPhrase}";

        debugPrint(error);
        throw BookException(message: error);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw BookException();
    }
  }

  @override
  Future<Book> getBookDetails(String isbn13) async {
    final url = Uri.https(Constants.apiBaseUrl, "/1.0/books/$isbn13");

    try {
      final response = await _requestData(url);

      return Book.fromJson(response);
    } on BookException catch (b) {
      throw BookException(message: b.message);
    }
  }

  @override
  Future<List<Book>> getNewBooks({int limit = 8}) async {
    final url = Uri.https(Constants.apiBaseUrl, "/1.0/new");
    List<Book> newBooks = [];

    try {
      final response = await _requestData(url);

      final List<dynamic> listOfBooks = response['books'] ?? [];

      if (listOfBooks.isNotEmpty) {
        newBooks = listOfBooks
            .map((book) => Book.fromJson(book))
            .toList()
            .sublist(0, limit);
      }

      return newBooks;
    } on BookException catch (b) {
      throw BookException(message: b.message);
    }
  }

  @override
  Future<List<Book>> getRecommendedBooks({int limit = 8}) async {
    final url = Uri.https(Constants.apiBaseUrl, "/1.0/new");
    List<Book> recommendedBooks = [];

    try {
      final response = await _requestData(url);

      final List<dynamic> listOfBooks = response['books'] ?? [];

      if (listOfBooks.isNotEmpty) {
        recommendedBooks = listOfBooks
            .map((book) => Book.fromJson(book))
            .toList()
            .sublist(0, limit);
      }

      return recommendedBooks;
    } on BookException catch (b) {
      throw BookException(message: b.message);
    }
  }

  @override
  Future<List<Book>> getSavedBooks() async {
    try {
      final savedList =
          _preferences.getStringList(Constants.savedBooksKey) ?? [];

      final futures = savedList
          .map((no) =>
              _requestData(Uri.https(Constants.apiBaseUrl, "/1.0/books/$no")))
          .toList();

      final List<Map<String, dynamic>> futureResults =
          await Future.wait<Map<String, dynamic>>(futures);

      return futureResults.map((bookData) => Book.fromJson(bookData)).toList();
    } catch (e) {
      throw BookException(message: e.toString());
    }
  }

  @override
  Future<List<Book>> searchBookByQuery(String query) async {
    final url = Uri.https(Constants.apiBaseUrl, "/1.0/search/$query");
    List<Book> searchedBooks = [];

    try {
      final response = await _requestData(url);

      final List<dynamic> listOfBooks = response['books'] ?? [];

      if (listOfBooks.isNotEmpty) {
        searchedBooks = listOfBooks.map((book) => Book.fromJson(book)).toList();
      }

      return searchedBooks;
    } on BookException catch (b) {
      throw BookException(message: b.message);
    }
  }

  @override
  Future<void> saveBook(int isbn13) async {
    try {
      final savedList =
          _preferences.getStringList(Constants.savedBooksKey) ?? [];

      savedList.add('$isbn13');
      await _preferences.setStringList(Constants.savedBooksKey, savedList);
    } catch (e) {
      throw BookException(message: e.toString());
    }
  }
}
