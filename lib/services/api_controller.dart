import 'dart:convert';

import 'package:bookstore/models/book.dart';
import 'package:bookstore/util/constants.dart';
import 'package:bookstore/util/exceptions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract class defining core methods to work with API
abstract class BaseApiController {
  /// [limit] is an int denoting no. of books returned from the API result.
  Future<List<Book>> getNewBooks({int limit = 8});

  /// [limit] is an int denoting no. of books returned from the API result.
  Future<List<Book>> getRecommendedBooks({int limit = 8});

  Future<List<Book>> getSavedBooks();

  Future<void> saveBook(String isbn13);

  Future<void> removeSavedBook(String isbn13);

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

  var newBooks = <Book>[].obs;
  List<Book> savedBooks = <Book>[].obs;
  List<Book> recommendedBooks = <Book>[].obs;
  List<Book> searchedBooks = <Book>[].obs;

  final book = Rxn<Book>();

  /// Helper function to fetch data  from [url] and parse the JSON response
  /// to Map<>.
  Future<Map<String, dynamic>> _requestData(Uri url) async {
    try {
      final response = await _connect.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        final String error =
            "Request failed with status code ${response.statusCode} "
            "and error ${response.reasonPhrase}";

        throw BookException(message: error);
      }
    } catch (e) {
      throw BookException();
    }
  }

  @override
  Future<Book> getBookDetails(String isbn13) async {
    final url = Uri.https(Constants.apiBaseUrl, "/1.0/books/$isbn13");

    try {
      final response = await _requestData(url);

      book.value = Book.fromJson(response);

      return Book.fromJson(response);
    } on BookException catch (b) {
      throw BookException(message: b.message);
    }
  }

  @override
  Future<List<Book>> getNewBooks({int limit = 8}) async {
    final url = Uri.https(Constants.apiBaseUrl, "/1.0/new");
    List<Book> newFetchedBooks = [];

    try {
      final response = await _requestData(url);

      final List<dynamic> listOfBooks = response['books'] ?? [];

      if (listOfBooks.isNotEmpty) {
        newFetchedBooks =
            listOfBooks.map((book) => Book.fromJson(book)).toList();
      }

      newBooks.assignAll(newFetchedBooks);

      return newFetchedBooks;
    } on BookException catch (b) {
      throw BookException(message: b.message);
    }
  }

  @override
  Future<List<Book>> getRecommendedBooks({int limit = 8}) async {
    final url = Uri.https(Constants.apiBaseUrl, "/1.0/new");
    List<Book> recommendedFetchedBooks = [];

    try {
      final response = await _requestData(url);

      final List<dynamic> listOfBooks = response['books'] ?? [];

      if (listOfBooks.isNotEmpty) {
        recommendedFetchedBooks =
            listOfBooks.map((book) => Book.fromJson(book)).toList()..shuffle();
      }

      recommendedBooks.assignAll(recommendedFetchedBooks);

      return recommendedFetchedBooks;
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

      final mappedSavedBooks =
          futureResults.map((bookData) => Book.fromJson(bookData)).toList();

      savedBooks.assignAll(mappedSavedBooks);
      return mappedSavedBooks;
    } catch (e) {
      throw BookException(message: e.toString());
    }
  }

  @override
  Future<List<Book>> searchBookByQuery(String query) async {
    final url = Uri.https(Constants.apiBaseUrl, "/1.0/search/$query");
    List<Book> searchedFetchedBooks = [];

    try {
      final response = await _requestData(url);

      final List<dynamic> listOfBooks = response['books'] ?? [];

      if (listOfBooks.isNotEmpty) {
        searchedFetchedBooks =
            listOfBooks.map((book) => Book.fromJson(book)).toList();
      }

      searchedBooks.assignAll(searchedFetchedBooks);

      return searchedFetchedBooks;
    } on BookException catch (b) {
      throw BookException(message: b.message);
    }
  }

  @override
  Future<void> saveBook(String isbn13) async {
    try {
      final savedList =
          _preferences.getStringList(Constants.savedBooksKey) ?? [];

      savedList.addIf(!savedList.contains(isbn13), isbn13);
      await _preferences.setStringList(Constants.savedBooksKey, savedList);
    } catch (e) {
      throw BookException(message: e.toString());
    }
  }

  @override
  Future<void> removeSavedBook(String isbn13) async {
    try {
      final savedList =
          _preferences.getStringList(Constants.savedBooksKey) ?? [];

      savedList.remove(isbn13);
      await _preferences.setStringList(Constants.savedBooksKey, savedList);
    } catch (e) {
      throw BookException(message: e.toString());
    }
  }

  bool isBookSaved(String isbn13) {
    try {
      final savedList =
          _preferences.getStringList(Constants.savedBooksKey) ?? [];

      return savedList.contains(isbn13);
    } catch (e) {
      throw BookException(message: e.toString());
    }
  }
}
