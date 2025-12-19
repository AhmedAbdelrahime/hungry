class OrderRequestModel {
  final List<OrderItemModel> items;

  OrderRequestModel({required this.items});

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderItemModel {
  final int productId;
  final int quantity;
  final double? spicy;
  final List<int> toppings;
  final List<int> sideOptions;

  OrderItemModel({
    required this.productId,
    required this.quantity,
    this.spicy,
    required this.toppings,
    required this.sideOptions,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      if (spicy != null) 'spicy': spicy,
      'toppings': toppings,
      'side_options': sideOptions,
    };
  }
}



/// ✅ Create Order Response

class CreateOrderResponseModel {
  final int code;
  final String message;
  final OrderData data;

  CreateOrderResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponseModel(
      code: json['code'],
      message: json['message'],
      data: OrderData.fromJson(json['data']),
    );
  }
}

class OrderData {
  final int orderId;

  OrderData({required this.orderId});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(orderId: json['order_id']);
  }
}

class GetOrdersResponseModel {
  final int code;
  final String message;
  final List<OrderModel> data;

  GetOrdersResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory GetOrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return GetOrdersResponseModel(
      code: json['code'],
      message: json['message'],
      data: List<OrderModel>.from(
        json['data'].map((e) => OrderModel.fromJson(e)),
      ),
    );
  }
}
class OrderModel {
  final int id;
  final String status;
  final double totalPrice;
  final String createdAt;
  final String productImage;

  OrderModel({
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.productImage,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      status: json['status'],
      totalPrice: double.parse(json['total_price']),
      createdAt: json['created_at'],
      productImage: json['product_image'],
    );
  }
}
