import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management/controllers/product_controller.dart';
import 'package:product_management/models/product.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  _ProductAddScreenState createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final ProductController productController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _stockController = TextEditingController();
  final _productGroupController = TextEditingController();
  final _priceController = TextEditingController();
  int? selectedKategoriId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
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
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _priceController,
                  label: 'Harga*',
                  hint: 'Masukan Harga',
                  keyboardType: TextInputType.number,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Field tidak boleh kosong';
        }
        return null;
      },
    );
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
      value: selectedKategoriId,
      items: productController.categoryList.map((c) {
        return DropdownMenuItem<int>(
          value: c.id,
          child: Text(c.categoryName),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          selectedKategoriId = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Pilih kategori';
        }
        return null;
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
      onPressed: _submitProduct,
      child: const Text(
        'Tambah Barang',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  void _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        productName: _productNameController.text,
        categoryId: selectedKategoriId!,
        stock: int.tryParse(_stockController.text) ?? 0,
        groupProduct: _productGroupController.text,
        price: int.tryParse(_priceController.text) ?? 0,
        categoryName: '',
      );

      try {
        await productController.addProduct(newProduct);
        _resetForm();
        Get.offAllNamed("/");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil tambah produk ${newProduct.productName}!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error tambah produk: $e')),
        );
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _productNameController.clear();
    _stockController.clear();
    _productGroupController.clear();
    _priceController.clear();
    setState(() {
      selectedKategoriId = null;
    });
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