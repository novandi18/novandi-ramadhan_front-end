class ProductCategory {
  final int id;
  final String categoryName;

  ProductCategory({
    required this.id,
    required this.categoryName,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      categoryName: json['nama_kategori'],
    );
  }
}