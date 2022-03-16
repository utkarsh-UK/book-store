class BookException implements Exception {
  final String message;

  BookException(
      {this.message = 'Ooops! Could not load data at the moment. '
          'Please try again'});

  @override
  String toString() {
    return message;
  }
}
