import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_management/screens/product_detail_screen.dart';
import 'package:product_management/screens/product_list_screen.dart';

void main() {
  runApp(GetMaterialApp( // Gunakan GetMaterialApp
    title: 'Manajemen Produk',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    debugShowCheckedModeBanner: false,
    initialRoute: '/', // Tentukan rute awal
    getPages: [
      GetPage(name: '/', page: () => ProductListScreen()), // Rute untuk ProdukListScreen
      GetPage(
        name: '/detail/:id',  // Rute untuk ProdukDetailScreen dengan parameter id
        page: () {
          final String id = Get.parameters['id']!;
          return ProductDetailScreen(productId: int.parse(id)); // Kirim id produk ke DetailScreen
        },
      ),
    ],
  ));
}