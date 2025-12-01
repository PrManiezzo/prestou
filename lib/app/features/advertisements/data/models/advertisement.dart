class Advertisement {
  final int id;
  final String title;
  final String description;
  final double? price;
  final String status; // 'active', 'inactive', 'banned', 'review'
  final int categoryId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Advertisement({
    required this.id,
    required this.title,
    required this.description,
    this.price,
    required this.status,
    required this.categoryId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      status: json['status'] as String,
      categoryId: json['categoryId'] as int,
      userId: json['userId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'status': status,
      'categoryId': categoryId,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
