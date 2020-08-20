class Product {
  final String id;
  final String name;
  final String category;
  final String image;
  final double price;
  final List<Productsize> productatt;
  int selectedquantity;
  double selectedcommission;
  Productsize selectedsize;
  final String desciption;
  Product(
      {this.id,
      this.name,
      this.category,
      this.price,
      this.image,
      this.desciption,
      this.productatt = const [],
      this.selectedsize,
      this.selectedquantity = 0,
      this.selectedcommission = 10.0});

  factory Product.fromJson(Map<String, dynamic> json) {
    final List<Productsize> temp = [];
    Productsize selected = new Productsize();
    ;
    if (json['sizes'] != null)
      for (var i in json['sizes']) {
        if (i != null) {
          String sizeandcolor = i['size'] as String;
          int stock = i['stock'] as int;
          String size;
          String color;
          if (sizeandcolor.contains('-')) {
            List<String> tempsize = sizeandcolor.split('-');
            size = tempsize[0];
            color = tempsize[1];
          } else {
            size = sizeandcolor;
            color = '';
          }

          var a = Productsize(
            size: size,
            color: color,
            stock: stock,
          );
          temp.add(a);
          if (selected.stock == 0) if (stock > 0) {
            selected = a;
          }
        }
      }

    return Product(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        image: 'https://www.modayagmur.com.tr/' + (json['image'] as String),
        price: json['price'] as double,
        productatt: temp,
        desciption: json['description'] as String,
        selectedsize: selected);
  }
}

class Productsize {
  final String size;
  final String color;
  final int stock;

  Productsize({
    this.color = 'Standart',
    this.size = 'Stokta Yok',
    this.stock = 0,
  });
}
