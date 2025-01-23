import 'package:get/get.dart';
import 'package:product_management/models/product_category.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductController extends GetxController {
  var productList = <Product>[].obs;
  var searchProductList = <Product>[].obs;
  var categoryList = <ProductCategory>[].obs;
  var isLoading = true.obs;
  var product = Product().obs;
  final ProductService _productService = ProductService();

  @override
  void onInit() {
    super.onInit();

    ever(productList, (_) {
      print("data diupdate");
    });

    fetchProduct();
    fetchCategory();
  }

  void fetchProduct() async {
    isLoading(true);
    try {
      List<Product>? fetchedProduct = await _productService.getProduct();

      if (fetchedProduct != null) {
        productList.assignAll(fetchedProduct);
      } else {
        Get.snackbar("Error", "Gagal memuat data produk");
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchSingleProduct(int id) async {
    isLoading(true);

    try {
      Product? fetchedProduct = await _productService.getSingleProduct(id);
      if (fetchedProduct != null) {
        product.value = fetchedProduct;
      } else {
        Get.snackbar("Error", "Gagal memuat detail produk.");
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchCategory() async {
    isLoading(true);
    try {
      List<ProductCategory>? fetchedCategory = await _productService.getProductCategory();

      if (fetchedCategory != null) {
        categoryList.assignAll(fetchedCategory);
      } else {
        Get.snackbar("Error", "Gagal memuat data kategori");
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchProductSearch(String keyword) async {
    isLoading(true);
    try {
      List<Product>? fetchedProductSearch = await _productService.getProductSearch(keyword);

      if (fetchedProductSearch != null) {
        searchProductList.assignAll(fetchedProductSearch);
      } else {
        searchProductList.clear();
        Get.snackbar("Error", "Gagal memuat hasil pencarian produk");
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      isLoading(true);
      await _productService.postProduct(product);
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      isLoading(true);
      await _productService.putProduct(product);
    } finally {
      isLoading(false);
    }
  }

  void deleteSelectedProducts(List<int> ids) async {
    isLoading(true);
    try {
      await _productService.deleteProducts(ids);
      fetchProduct();
      Get.snackbar('Berhasil', '${ids.length} produk berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus produk: $e');
    } finally {
      isLoading(false);
    }
  }
}