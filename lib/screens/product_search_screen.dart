import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';

class ProductSearchScreen extends StatelessWidget {
  final ProductController productController = Get.find();

  ProductSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari produk...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              productController.fetchProductSearch(value);
            } else {
              productController.searchProductList.clear();
            }
          },
        ),
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productController.searchProductList.isEmpty) {
          return const Center(
            child: Text('Tidak ada produk yang ditemukan'),
          );
        }

        return ListView.builder(
          itemCount: productController.searchProductList.length,
          itemBuilder: (context, index) {
            final product = productController.searchProductList[index];
            return ListTile(
              title: Text(product.productName),
              subtitle: Text(product.categoryName),
              onTap: () {
                productController.fetchSingleProduct(product.id);
                Get.toNamed('/detail/${product.id}');
              },
            );
          },
        );
      }),
    );
  }
}