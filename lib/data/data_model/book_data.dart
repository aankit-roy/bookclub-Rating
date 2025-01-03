// class Book {
//   final String id;
//   final String title;
//   final List<String> authors;
//   final String description;
//   final String thumbnail;
//   final double rating; // New rating property
//
//   Book({
//     required this.id,
//     required this.title,
//     required this.authors,
//     required this.description,
//     required this.thumbnail,
//     required this.rating,
//   });
//
//   factory Book.fromJson(Map<String, dynamic> json) {
//     final volumeInfo = json['volumeInfo'];
//     return Book(
//       id: json['id'],
//       title: volumeInfo['title'] ?? 'No Title',
//       authors: List<String>.from(volumeInfo['authors'] ?? []),
//       description: volumeInfo['description'] ?? 'No Description',
//       thumbnail: volumeInfo['imageLinks']?['thumbnail'] ?? '',
//       rating: volumeInfo['averageRating']?.toDouble() ?? 0.0, // Fetch the rating
//     );
//   }
// }

class Book {
  final String id;
  final VolumeInfo volumeInfo;
  final SaleInfo saleInfo;
  final AccessInfo accessInfo;

  Book({
    required this.id,
    required this.volumeInfo,
    required this.saleInfo,
    required this.accessInfo,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      volumeInfo: VolumeInfo.fromJson(json['volumeInfo'] ?? {}),
      saleInfo: SaleInfo.fromJson(json['saleInfo'] ?? {}),
      accessInfo: AccessInfo.fromJson(json['accessInfo'] ?? {}),
    );
  }
}

class VolumeInfo {
  final String title;
  final List<String> authors;
  final String publisher;
  final String publishedDate;
  final String description;
  final List<String> categories;
  final double? averageRating;
  final int ratingsCount;
  final String? smallThumbnail;
  final String thumbnail;
  final String? language;
  final String? infoLink;
  final String? canonicalVolumeLink;
  final String? isbn10;
  final String? isbn13;
  final int pageCount;

  VolumeInfo({
    required this.title,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.categories,
    this.averageRating,
    required this.ratingsCount,
    this.smallThumbnail,
    required this.thumbnail,
    this.language,
    this.infoLink,
    this.canonicalVolumeLink,
    this.isbn10,
    this.isbn13,
    required this.pageCount,
  });

  factory VolumeInfo.fromJson(Map<String, dynamic> json) {
    return VolumeInfo(
      title: json['title'] ?? 'No Title',
      authors: List<String>.from(json['authors'] ?? []),
      publisher: json['publisher'] ?? 'Unknown Publisher',
      publishedDate: json['publishedDate'] ?? 'Unknown Date',
      description: json['description'] ?? 'No Description',
      categories: List<String>.from(json['categories'] ?? []),
      averageRating: json['averageRating']?.toDouble(),
      ratingsCount: json['ratingsCount'] ?? 0,
      smallThumbnail: json['imageLinks']?['smallThumbnail'],
      thumbnail: json['imageLinks']?['thumbnail'],
      language: json['language'],
      infoLink: json['infoLink'],
      canonicalVolumeLink: json['canonicalVolumeLink'],
      isbn10: json['industryIdentifiers']?.firstWhere(
          (item) => item['type'] == 'ISBN_10',
          orElse: () => {})['identifier'],
      isbn13: json['industryIdentifiers']?.firstWhere(
          (item) => item['type'] == 'ISBN_13',
          orElse: () => {})['identifier'],
      pageCount: json['pageCount'] ?? 0,
    );
  }
}

class SaleInfo {
  final String country;
  final String saleability;
  final bool isEbook;
  final PriceList? priceList;
  final String? buyLink;

  SaleInfo({
    required this.country,
    required this.saleability,
    required this.isEbook,
    this.priceList,
    this.buyLink,
  });

  factory SaleInfo.fromJson(Map<String, dynamic> json) {
    return SaleInfo(
      country: json['country'] ?? 'Unknown',
      saleability: json['saleability'] ?? 'Unknown',
      isEbook: json['isEbook'] ?? false,
      priceList: json['listPrice'] != null
          ? PriceList.fromJson(json['listPrice'])
          : null,
      buyLink: json['buyLink'],
    );
  }
}

class PriceList {
  final double amount;
  final String currencyCode;

  PriceList({
    required this.amount,
    required this.currencyCode,
  });

  factory PriceList.fromJson(Map<String, dynamic> json) {
    return PriceList(
      amount: json['amount']?.toDouble() ?? 0.0,
      currencyCode: json['currencyCode'] ?? 'Unknown',
    );
  }
}




class AccessInfo {
  final String country;
  final String viewability;
  final bool embeddable;
  final bool publicDomain;
  final bool isEpubAvailable;
  final bool isPdfAvailable;
  final String accessViewStatus;
  final String? epubTokenLink;

  AccessInfo({
    required this.country,
    required this.viewability,
    required this.embeddable,
    required this.publicDomain,
    required this.isEpubAvailable,
    required this.isPdfAvailable,
    required this.accessViewStatus,
    this.epubTokenLink,
  });

  factory AccessInfo.fromJson(Map<String, dynamic> json) {
    return AccessInfo(
      country: json['country'] ?? 'Unknown',
      viewability: json['viewability'] ?? 'Unknown',
      embeddable: json['embeddable'] ?? false,
      publicDomain: json['publicDomain'] ?? false,
      isEpubAvailable: json['epub']?['isAvailable'] ?? false,
      isPdfAvailable: json['pdf']?['isAvailable'] ?? false,
      accessViewStatus: json['accessViewStatus'] ?? 'Unknown',
      epubTokenLink: json['epub']?['acsTokenLink'],
    );
  }
}
