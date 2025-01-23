import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management/controllers/product_controller.dart';
import 'package:product_management/models/product.dart';

class ProductEditScreen extends StatefulWidget {
  final Product product;

  const ProductEditScreen({super.key, required this.product});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final ProductController productController = Get.find();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _productNameController;
  late TextEditingController _stockController;
  late TextEditingController _productGroupController;
  late TextEditingController _priceController;
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    productController.fetchCategory();
  }

  void _initializeControllers() {
    _productNameController = TextEditingController(text: widget.product.productName);
    _stockController = TextEditingController(text: widget.product.stock.toString());
    _productGroupController = TextEditingController(text: widget.product.groupProduct);
    _priceController = TextEditingController(text: widget.product.price.toString());
    selectedCategoryId = widget.product.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Barang'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: _productNameController,
                  label: 'Nama Barang*',
                  hint: 'Masukan Nama Barang',
                ),
                const SizedBox(height: 16),
                _buildCategoryDropdown(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _productGroupController,
                  label: 'Kelompok Barang*',
                  hint: 'Masukan Kelompok Barang',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _stockController,
                  label: 'Stok*',
                  hint: 'Masukan Stok',
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumber(value, 'Stok'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _priceController,
                  label: 'Harga*',
                  hint: 'Masukan Harga',
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumber(value, 'Harga'),
                ),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator ?? _defaultValidator,
    );
  }

  String? _defaultValidator(String? value) {
    return value == null || value.isEmpty
        ? 'Field tidak boleh kosong'
        : null;
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName harus diisi.';
    }
    return int.tryParse(value) == null
        ? '$fieldName harus berupa angka.'
        : null;
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'Kategori Barang*',
        hintText: 'Masukan Kategori Barang',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      value: selectedCategoryId,
      items: productController.categoryList.map((c) {
        return DropdownMenuItem<int>(
          value: c.id,
          child: Text(c.categoryName),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          selectedCategoryId = newValue;
        });
      },
      validator: (value) {
        return value == null ? 'Pilih kategori' : null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: _updateProduct,
      child: const Text(
        'Update Barang',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      if (selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Pilih kategori"))
        );
        return;
      }

      final updatedProduct = Product(
        id: widget.product.id,
        productName: _productNameController.text,
        categoryId: selectedCategoryId!,
        stock: int.parse(_stockController.text),
        groupProduct: _productGroupController.text,
        price: int.parse(_priceController.text),
        categoryName: '',
      );

      try {
        await productController.updateProduct(updatedProduct);
        Get.offAllNamed('/');
        Get.snackbar('Berhasil', 'Produk berhasil diupdate!');
      } catch (e) {
        Get.snackbar("Error", "Gagal update produk: $e");
      }
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _stockController.dispose();
    _productGroupController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}