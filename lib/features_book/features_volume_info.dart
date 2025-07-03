class VolumeInfo {
  final String? title;
  final String? subTitle;
  final String? publishedDate;
  final String? description;
  final int? pageCount;
  final ImageLinks? imageLinks;
  final String? previewLink;
  final String? infoLink;
  final List<String>? categories;
  final List<String>? authors;
  final List<IndustryIdentifiers>? industryIdentifiers;

  VolumeInfo({
    this.title,
    this.subTitle,
    this.publishedDate,
    this.description,
    this.pageCount,
    this.imageLinks,
    this.previewLink,
    this.infoLink,
    this.categories,
    this.authors,
    this.industryIdentifiers,
  });

  factory VolumeInfo.fromJson(Map<String, dynamic> json) {
    return VolumeInfo(
      title: json["title"],
      subTitle: json["subtitle"],
      publishedDate: json["publishedDate"],
      description: json["description"],
      pageCount: json["pageCount"],
      categories: (json['categories'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      imageLinks: json["imageLinks"] != null
          ? ImageLinks.fromJson(json["imageLinks"])
          : null,
      previewLink: json["previewLink"],

      infoLink: json["infoLink"],
      authors: (json['authors'] as List?)?.map((e) => e.toString()).toList(),
      industryIdentifiers: (json['industryIdentifiers'] as List?)
          ?.map((e) => IndustryIdentifiers.fromJson(e))
          .toList(),
    );
  }
}

class ImageLinks {
  final String? thumbnail;

  ImageLinks({this.thumbnail});

  factory ImageLinks.fromJson(Map<String, dynamic> json) {
    return ImageLinks(thumbnail: json['thumbnail']);
  }
}

class IndustryIdentifiers {
  final String? type;
  final String? identifier;

  IndustryIdentifiers({this.type, this.identifier});

  factory IndustryIdentifiers.fromJson(Map<String, dynamic> json) {
    return IndustryIdentifiers(
      type: json['type'],
      identifier: json['identifier'],
    );
  }
}
