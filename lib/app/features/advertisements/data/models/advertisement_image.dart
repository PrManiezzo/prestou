class AdvertisementImage {
  final int id;
  final String url;
  final int advertisementId;
  final DateTime createdAt;

  AdvertisementImage({
    required this.id,
    required this.url,
    required this.advertisementId,
    required this.createdAt,
  });

  factory AdvertisementImage.fromJson(Map<String, dynamic> json) {
    return AdvertisementImage(
      id: json['id'] as int,
      url: json['url'] as String,
      advertisementId: json['advertisementId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'advertisementId': advertisementId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
