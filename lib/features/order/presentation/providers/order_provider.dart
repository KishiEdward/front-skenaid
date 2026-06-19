import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';

import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repository.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository = OrderRepositoryImpl();

  List<OrderModel> _myOrders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OrderModel> get myOrders => _myOrders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<OrderModel?> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final order = await _repository.checkout(
        shippingAddress: shippingAddress,
        notes: notes,
        paymentMethod: paymentMethod,
      );
      _isLoading = false;
      notifyListeners();
      return order;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> fetchMyOrders(String customToken) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/v1/orders');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $customToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          _myOrders = (responseData['data'] as List)
              .map((x) => OrderModel.fromJson(x))
              .toList();
        } else {
          _errorMessage = responseData['message'];
        }
      } else {
        _errorMessage = 'Gagal memuat pesanan. Kode: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
