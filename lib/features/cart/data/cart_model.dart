class CartModel {
  final int productid;
  final int quntity;
  final double spicys;
  final List<int> toppings;
  final List<int> options;

  CartModel({
    required this.productid,
    required this.quntity,
    required this.spicys,
    required this.toppings,
    required this.options,
  });

  Map<String, dynamic> toJson() => {
    'product_id': productid,
    'quantity': quntity,
    'spicy': spicys,
    'toppings': toppings,
    'side_options': options,
  };
}

class CartRequestModel {
  // final String token;
  final List<CartModel> cartItems;
  CartRequestModel({required this.cartItems});

  Map<String, dynamic> toJson() => {
    'items': cartItems.map((e) => e.toJson()).toList(),
  };
}

class GetCartResponseModel {
  final CartData data;
  final int code;
  final String message;

  GetCartResponseModel({
    required this.data,
    required this.code,
    required this.message,
  });
  factory GetCartResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCartResponseModel(
      data: CartData.fromJson(json['data']),
      code: json['code'],
      message: json['message'],
    );
  }
}

class CartData {
  final int id;
  final String totalprice;
  final List<CartItem> items;

  CartData({required this.id, required this.totalprice, required this.items});

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json['id'],
      totalprice: json['total_price'].toString(),
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }
}

class CartItem {
  final int itemid;
  final int productid;
  final String name;
  final String image;
  final String price;
  final int quantity;
  final double spicys;
  final List<Toppings> toppings;
  final List<Toppings> options;

  CartItem({
    required this.itemid,
    required this.productid,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.spicys,
    required this.toppings,
    required this.options,
  });

  
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      toppings: (json['toppings'] as List)
          .map((item) => Toppings.fromJson(item))
          .toList(),
      options: (json['side_options'] as List)
          .map((item) => Toppings.fromJson(item))
          .toList(),

      itemid: json['item_id'] ?? 0,
      productid: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['price']?.toString() ?? '0',
      quantity: json['quantity'] ?? 0,
      spicys: double.tryParse(json['spicy']?.toString() ?? '0') ?? 0.0,
    );
  }

}

class Toppings {
  final int id;
  final String name;
  final String image;
  Toppings({required this.id, required this.name, required this.image});
  factory Toppings.fromJson(Map<String, dynamic> json) {
    return Toppings(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}