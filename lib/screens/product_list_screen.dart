import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management/screens/product_search_screen.dart';
import '../controllers/product_controller.dart';
import 'product_add_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProductListScreen();
}

class _ProductListScreen extends State<ProductListScreen> {
  final ProductController productController = Get.put(ProductController());
  bool _isEditMode = false;
  Set<int> _selectedProductIds = {};

  @override
  void initState() {
    super.initState();
    productController.fetchProduct();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      _selectedProductIds.clear();
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedProductIds.length == productController.productList.length) {
        _selectedProductIds.clear();
      } else {
        _selectedProductIds = Set.from(
            productController.productList.map((product) => product.id!)
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.to(() => ProductSearchScreen());
            },
          ),
          if (!_isEditMode)
            TextButton(
              onPressed: _toggleEditMode,
              child: const Text('Edit Data'),
            )
        ],
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            productController.fetchProduct();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${productController.productList.length} Data ditampilkan'),
                    if (_isEditMode)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _toggleEditMode,
                      )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: productController.productList.length,
                  itemBuilder: (context, index) {
                    final product = productController.productList[index];
                    return ListTile(
                      leading: _isEditMode
                          ? Checkbox(
                        value: _selectedProductIds.contains(product.id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedProductIds.add(product.id!);
                            } else {
                              _selectedProductIds.remove(product.id);
                            }
                          });
                        },
                      )
                          : null,
                      title: Text(product.productName),
                      subtitle: Text(product.categoryName),
                      onTap: () {
                        if (!_isEditMode) {
                          productController.fetchSingleProduct(product.id);
                          Get.toNamed('/detail/${product.id}');
                        }
                      },
                    );
                  },
                ),
              ),
              if (_isEditMode)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _selectedProductIds.length == productController.productList.length,
                            onChanged: (_) => _toggleSelectAll(),
                          ),
                          const Text('Hapus semua'),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: _selectedProductIds.isNotEmpty
                            ? () => productController.deleteSelectedProducts(_selectedProductIds.toList())
                            : null,
                        child: const Text('Hapus Barang'),
                      ),
                    ],
                  ),
                )
            ],
          ),
        );
      }),
      floatingActionButton: _isEditMode ? null : FloatingActionButton(
        onPressed: () {
          Get.to(() => ProductAddScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}