import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:product_management/controllers/product_controller.dart';
import 'package:product_management/screens/product_edit_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductController productController = Get.find();
  final currencyFormatter =
  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    productController.fetchSingleProduct(widget.productId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    productController.fetchSingleProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: Obx(
            () => productController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDetailItem(
                  label: 'Nama barang',
                  value: productController.product.value.productName),
              buildDetailItem(
                  label: 'Kategori',
                  value: productController.product.value.categoryName),
              buildDetailItem(
                  label: 'Kelompok',
                  value: productController.product.value.groupProduct),
              buildDetailItem(
                  label: 'Stok',
                  value:
                  productController.product.value.stock.toString()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Harga'),
                    Text(currencyFormatter
                        .format(productController.product.value.price)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.defaultDialog(
                            title: "Hapus Produk",
                            middleText:
                            "Anda yakin untuk hapus product ini?",
                            textConfirm: "Hapus",
                            textCancel: "Batal",
                            confirmTextColor: Colors.white,
                            onConfirm: () async {
                              try {
                                productController.deleteSelectedProducts(
                                    [widget.productId]
                                );
                                Get.offAllNamed("/");
                                Get.snackbar("Berhasil",
                                    "Produk berhasil dihapus");
                              } catch (e) {
                                Get.snackbar(
                                    "Error", "Gagal hapus produk");
                                print("Error hapus product: $e");
                              }
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        "Hapus Barang",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => ProductEditScreen(
                              product: productController.product.value)
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text("Edit Barang",
                            style: TextStyle(color: Colors.white))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildDetailItem({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)],
      ),
    );
  }
}
