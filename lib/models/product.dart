class Product {
  int id;
  String productName;
  String categoryName;
  int stock;
  String groupProduct;
  int price;
  int categoryId;

  Product({
    this.id = 0,
    this.productName = '',
    this.categoryName = '',
    this.stock = 0,
    this.groupProduct = '',
    this.price = 0,
    this.categoryId = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      productName: json['nama_barang'] ?? '',
      categoryName: json['nama_kategori'] ?? '',
      stock: int.parse(json['stok'].toString()),
      groupProduct: json['Kelompok_barang'] ?? '',
      price: double.parse(json['harga'].toString()).toInt(),
      categoryId: int.parse(json['kategori_id'].toString()),
    );
  }
}