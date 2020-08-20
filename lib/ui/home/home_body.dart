import 'dart:convert';

import 'package:ecommorce/model/cartbloc.dart';
import 'package:ecommorce/model/category.dart';
import 'package:ecommorce/model/product.dart';
import 'package:ecommorce/themes/light_color.dart';
import 'package:ecommorce/themes/theme.dart';
import 'package:ecommorce/widgets/product_card.dart';
import 'package:ecommorce/widgets/product_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommorce/extentions/extentions.dart';
import 'package:flutter/services.dart';

List<Product> productlist;
int selectedcategoryid;

Future<List<Product>> _fetchproducts(String id) async {
  productlist.clear();
  String response = await rootBundle.loadString('testjson/$id.json');
  final parsed = json.decode(response);
  print('katagori resimleri başarıyla çekildi.');

  return parsed['products']
      .map<Product>((json) => Product.fromJson(json))
      .toList();
}

class MyHomePage extends StatefulWidget {
  final List<Category> categories;
  MyHomePage({Key key, this.categories}) : super(key: key);

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Product>> fetch;

  @override
  initState() {
    productlist = [];
    selectedcategoryid = widget.categories[0].id;
    fetch = _fetchproducts(widget.categories[selectedcategoryid].id.toString());
    super.initState();
  }

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _categoryWidget() {
    return Container(
      height: 45,
      width: AppTheme.fullWidth(context),

      child: ListView.builder(
        padding: AppTheme.hPadding,
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          return ProductIcon(
            model: widget.categories[index],
            isSelected: selectedcategoryid == widget.categories[index].id,
            onSelected: (value) {
              setState(() {
                selectedcategoryid = value.id;
                fetch = _fetchproducts(selectedcategoryid.toString());
              });
            },
          );
        },
      ),

      // child: ListView(
      //   scrollDirection: Axis.horizontal,
      //   children: widget.categories.map((category) {
      //     return ProductIcon(
      //       model: category,
      //       onSelected: (model) {
      //         category.isSelected = false;
      //         setState(() {
      //           model.isSelected = true;
      //         });
      //       },
      //     );
      //   }).toList(),
      // ),
    );
  }

  Widget _productWidget() {
    final a = MediaQuery.of(context).size;
    final ratio = ((a.height) / (a.width)) * .27;
    return FutureBuilder<List<Product>>(
        future: fetch,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                childAspectRatio: ratio,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.vertical,
              children: snapshot.data
                  .map(
                    (product) => ProductCard(
                      product: product,
                      onSelected: (model) {},
                    ),
                  )
                  .toList(),
            );
          } else
            return Center(child: CupertinoActivityIndicator());
        });
  }

  Widget _search() {
    return Container(
      padding: AppTheme.hPadding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.lightGrey.withAlpha(100),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Ürünleri Ara",
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
                    prefixIcon: Icon(Icons.search, color: Colors.black54)),
              ),
            ),
          ),
          _icon(Icons.filter_list, color: Colors.black54)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _search(),
        _categoryWidget(),
        Expanded(child: _productWidget()),
      ],
    );
  }
}
