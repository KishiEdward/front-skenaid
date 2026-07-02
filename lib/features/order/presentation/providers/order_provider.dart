import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';

import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repository.dart';

enum OrderStatus { initial, loading, success, error }
enum PaymentCheckStatus { idle, checking, paid }

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository = OrderRepositoryImpl();

  final OrderStatus _checkoutStatus = OrderStatus.initial;

  OrderModel? _lastOrder;
  List<OrderModel> _myOrders = [];
  String? _error;

  PaymentCheckStatus _paymentCheckStatus = PaymentCheckStatus.idle;
  Timer? _pollingTimer;

  OrderStatus get checkoutStatus => _checkoutStatus;
  OrderModel? get lastOrder => _lastOrder;
  List<OrderModel> get myOrders => _myOrders;
  String? get error => _error;
  PaymentCheckStatus get paymentCheckStatus => _paymentCheckStatus;

  
  bool _isLoading = false;
  String? _errorMessage;

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
      final url = Uri.parse('${ApiConstants.baseUrl}/orders');
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

  Future<void> checkPaymentStatus(int orderId) async {
    _paymentCheckStatus = PaymentCheckStatus.checking;
    notifyListeners();
    try {
      final updatedOrder = await _repository.getOrderDetail(orderId);
      _lastOrder = updatedOrder;
      
      if (updatedOrder.status != 'pending') {
        _paymentCheckStatus = PaymentCheckStatus.paid;
      } else {
        _paymentCheckStatus = PaymentCheckStatus.idle;
      }
    } catch (e) {
      _paymentCheckStatus = PaymentCheckStatus.idle;
    }
    notifyListeners();
  }

  void startPaymentPolling(int orderId) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkPaymentStatus(orderId);
      if (_paymentCheckStatus == PaymentCheckStatus.paid) {
        timer.cancel();
      }
    });
  }

  void stopPaymentPolling() {
    _pollingTimer?.cancel();
    _paymentCheckStatus = PaymentCheckStatus.idle;
  }

}
