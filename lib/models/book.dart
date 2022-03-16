class Book {
  final String title;
  final String? subtitle;
  final String? author;
  final String? publisher;
  final String? language;
  final String isbn13;
  final String? pages;
  final String? year;
  final String? rating;
  final String? desc;
  final String price;
  final String image;
  final String url;

  Book(
      {required this.title,
      required this.subtitle,
      required this.author,
      required this.publisher,
      required this.language,
      required this.isbn13,
      required this.pages,
      required this.year,
      required this.rating,
      required this.desc,
      required this.price,
      required this.image,
      required this.url});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? "Unknown",
      subtitle: json['subtitle'] ?? "",
      author: json['authors'] ?? "Unknown",
      publisher: json['publisher'] ?? "Unknown",
      language: json['language'] ?? "English",
      isbn13: json['isbn13'] ?? "",
      pages: json['pages'] ?? "Unknown",
      year: json['year'] ?? "Unknown",
      rating: json['rating'] ?? "Unknown",
      desc: json['desc'] ?? "Unknown",
      price: json['price'] ?? "Unknown",
      image: json['image'] ?? "",
      url: json['url'] ?? "",
    );
  }

  factory Book.toEmptyBook() {
    return Book(
      title: "Unknown",
      subtitle: "",
      author: "Unknown",
      publisher: "Unknown",
      language: "English",
      isbn13: "",
      pages: "Unknown",
      year: "Unknown",
      rating: "Unknown",
      desc: "Unknown",
      price: "Unknown",
      image: "",
      url: "",
    );
  }
}
