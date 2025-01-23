import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_management/models/product_category.dart';
import 'package:product_management/models/response_message.dart';
import '../models/product.dart';

class ProductService {
  Future<List<Product>?> getProduct() async {
    try {
      var response = await http.get(
          Uri.parse('https://product-api-1098613385318.asia-southeast2.run.app/barang')
      );
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return List<Product>.from(json.map((item) => Product.fromJson(item)));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Product?> getSingleProduct(int id) async {
    try {
      var response = await http.get(
          Uri.parse('https://product-api-1098613385318.asia-southeast2.run.app/barang/$id')
      );
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return Product.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<ProductCategory>?> getProductCategory() async {
    try {
      var response = await http.get(
          Uri.parse('https://product-api-1098613385318.asia-southeast2.run.app/kategori')
      );
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return List<ProductCategory>.from(json.map((item) => ProductCategory.fromJson(item)));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>?> getProductSearch(String keyword) async {
    try {
      var response = await http.get(
          Uri.parse('https://product-api-1098613385318.asia-southeast2.run.app/barang/search?q=$keyword')
      );
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return List<Product>.from(json.map((item) => Product.fromJson(item)));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<ResponseMessage?> postProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('https://product-api-1098613385318.asia-southeast2.run.app/barang'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nama_barang': product.productName,
          'kategori_id': product.categoryId,
          'stok': product.stock,
          'Kelompok_barang': product.groupProduct,
          'harga': product.price
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return ResponseMessage.fromJson(json);
      } else {
        throw Exception('Failed to add product. Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      return null;
    }
  }

  Future<ResponseMessage?> putProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('https://product-api-1098613385318.asia-southeast2.run.app/barang/${product.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nama_barang': product.productName,
          'kategori_id': product.categoryId,
          'stok': product.stock,
          'Kelompok_barang': product.groupProduct,
          'harga': product.price
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return ResponseMessage.fromJson(json);
      } else {
        throw Exception('Failed to update product. Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      return null;
    }
  }

  Future<ResponseMessage?> deleteProducts(List<int> ids) async {
    try {
      final response = await http.delete(
        Uri.parse('https://product-api-1098613385318.asia-southeast2.run.app/barang'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'ids': ids
        }),
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return ResponseMessage.fromJson(json);
      } else {
        throw Exception('Failed to delete products. Error: ${response.statusCode}');
      }
    } catch (e) {
      return null;
    }
  }
}