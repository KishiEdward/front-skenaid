import 'package:flutter/material.dart';
import '../../data/models/cart_model.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repository = CartRepositoryImpl();

  CartModel? _cart;
  bool _isLoading = false;
  String? _errorMessage;

  CartModel? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCart() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _repository.getCart();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(int productId, int quantity) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.addToCart(productId, quantity);
      await fetchCart();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCartItem(int cartItemId, int quantity) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.updateCartItem(cartItemId, quantity);
      await fetchCart();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeCartItem(int cartItemId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.removeCartItem(cartItemId);
      await fetchCart();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> clearCart() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.clearCart();
      await fetchCart();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
