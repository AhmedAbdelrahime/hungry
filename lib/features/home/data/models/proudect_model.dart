// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProudectModel {
  int id;
  String name;
  String image;
  String desc;
  String price;
  String rate;
  ProudectModel({
    required this.id,
    required this.name,
    required this.image,
    required this.desc,
    required this.price,
    required this.rate,
  });

  factory ProudectModel.fromJson(Map<String, dynamic> json) {
    return ProudectModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      desc: json['description'],
      price: json['price'],
      rate: json['rating'],
    );
  }
}

class CategoriesModel {
 final  int? id;
final   String name;

  CategoriesModel({ this.id, required this.name});

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(id: json['id'], name: json['name']);
  }
}
