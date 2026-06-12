class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String imageUrl;
  final String material;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.imageUrl,
    required this.material,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['ID'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      category: json['category'] ?? '',
      imageUrl: json['image_url'] ?? '',
      material: json['material'] ?? '',
    );
  }
}
