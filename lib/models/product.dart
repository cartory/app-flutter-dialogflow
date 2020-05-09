import "dart:convert";

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String id;
  String name;
  String description;
  double price;
  double stock;
  String urlPhoto;
  bool promo;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.urlPhoto,
    this.promo
  });

  factory Product.fromSnapshot(String key, Map value) => Product(
        id          : key,
        name        : value["name"],
        description : value["description"],
        price       : value["price"].toDouble(),
        stock       : value["stock"].toDouble(),
        urlPhoto    : value["urlPhoto"],
        promo       : value["promo"]
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id          : json["id"],
        name        : json["name"],
        description : json["description"],
        price       : json["price"].toDouble(),
        stock       : json["stock"].toDouble(),
        urlPhoto    : json["urlPhoto"],
        promo       : json["promo"]
      );

  Map<String, dynamic> toJson() => {
        "id"          : id,
        "name"        : name,
        "description" : description,
        "price"       : price,
        "stock"       : stock,
        "urlPhoto"    : urlPhoto,
        "promo"       : promo
      };
}