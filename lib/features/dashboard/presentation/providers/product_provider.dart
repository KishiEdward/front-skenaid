import 'package:flutter/material.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../data/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    Future.microtask(() => notifyListeners());

    try {
      final response = await DioClient.instance.get(ApiConstants.products);

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        _products = data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        _errorMessage = 'Gagal memuat produk';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan atau server';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
