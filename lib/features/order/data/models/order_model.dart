class OrderItemModel {
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double subtotal;
  final String productImage;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subtotal,
    this.productImage = '',
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    if (json['product'] != null && json['product']['image_url'] != null) {
      imageUrl = json['product']['image_url'];
    }

    return OrderItemModel(
      productId: json['product_id'] as int? ?? 0,
      productName: json['product_name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      productImage: imageUrl,
    );
  }
}

class OrderModel {
  final int id;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String notes;
  final String paymentMethod;
  final String? vaNumber;
  final String? gopayDeeplink;
  final List<OrderItemModel> items;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.notes,
    required this.paymentMethod,
    this.vaNumber,
    this.gopayDeeplink,
    required this.items,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List<dynamic>? ?? [])
        .map((e) => OrderItemModel.fromJson(e))
        .toList();

    return OrderModel(
      id: json['id'] as int? ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
      shippingAddress: json['shipping_address'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      paymentMethod: json['payment_method'] as String? ?? '',
      vaNumber: json['va_number'] as String?,
      gopayDeeplink: json['gopay_deeplink'] as String?,
      items: itemsList,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
