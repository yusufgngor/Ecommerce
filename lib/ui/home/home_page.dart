import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommorce/model/cartbloc.dart';
import 'package:ecommorce/model/category.dart';
import 'package:ecommorce/themes/light_color.dart';
import 'package:ecommorce/themes/theme.dart';
import 'package:ecommorce/ui/home/home_body.dart';
import 'package:ecommorce/ui/shoppingcart/shopping_cart_page.dart';
import 'package:ecommorce/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:ecommorce/extentions/extentions.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String homepage = 'Ana Sayfa';
const String cart = 'Sepetim';
const String profile = 'Profilim';

class Home extends StatefulWidget {
  Home({Key key, this.title, this.categories}) : super(key: key);

  final String title;
  final List<Category> categories;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int bottomSelectedIndex = 0;

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Theme.of(context).backgroundColor,
      ),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget _title(String _title) {
    return Container(
        padding: AppTheme.hPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText(
                  text: _title,
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
                // TitleText(
                //   text: bottomSelectedIndex == 0 ? 'Ürünler' : 'Cart',
                //   fontSize: 27,
                //   fontWeight: FontWeight.w700,
                // ),
              ],
            ),
            bottomSelectedIndex == 1
                ? Container(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.delete_outline,
                      color: LightColor.orange,
                    ),
                  ).ripple(() {
                    bloc.clearCart();
                  }, borderRadius: BorderRadius.all(Radius.circular(13)))
                : SizedBox()
          ],
        ));
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        icon: _icon(Icons.home),
        title: Text(
          homepage,
          // AppLocalizations.of(context).translate('homepage'),
        ),
      ),
      // BottomNavigationBarItem(
      //   icon: _icon(Icons.apps),
      //   title: Text(
      //     'Katogoriler',
      //     // AppLocalizations.of(context).translate('homepage'),
      //   ),
      // ),
      BottomNavigationBarItem(
        icon: _icon(Icons.tablet_android),
        title: Text(
          cart,
          // AppLocalizations.of(context).translate('homepage'),
        ),
      ),
      BottomNavigationBarItem(
        icon: _icon(Icons.person_outline),
        title: Text(
          profile,
          // AppLocalizations.of(context).translate('homepage'),
        ),
      )
    ];
  }

  myAppbar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      actions: <Widget>[
        Padding(
          padding: AppTheme.padding,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color(0xfff8f8f8),
                      blurRadius: 10,
                      spreadRadius: 10),
                ],
              ),
              child: Image.asset("assets/user.png"),
            ),
          ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13))),
        )
      ],
    );
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Widget child;
    String mytitle;
    if (bottomSelectedIndex == 0) {
      mytitle = homepage;
      child = MyHomePage(categories: widget.categories);
    } else if (bottomSelectedIndex == 1) {
      mytitle = cart;
      child = Align(alignment: Alignment.topCenter, child: ShoppingCartPage());
    } else {
      mytitle = profile;
      child = MyProfile();
    }
    return Scaffold(
      drawer: myDrawer(),
      drawerEnableOpenDragGesture: true,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        onTap: (value) {
          bottomTapped(value);
        },
        type: BottomNavigationBarType.fixed,
        iconSize: 25,
        selectedItemColor: Colors.amber[800],
        selectedIconTheme: IconThemeData(color: Colors.amber[800]),
        items: buildBottomNavBarItems(),
      ),
      appBar: myAppbar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _title(mytitle),
            Expanded(
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInToLinear,
                  switchOutCurve: Curves.easeOutBack,
                  child: child),
            )
          ],
        ),
      ),
    );
  }

  myDrawer() {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Moda Sistem'),
            decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  image: CachedNetworkImageProvider(
                      'https://www.modayagmur.com.tr/image/catalog/m-logo.png')),
            ),
          ),
          for (var i in widget.categories)
            ListTile(
              title: Text(i.name),
              onTap: () {
                setState(() {
                  selectedcategoryid = i.id;
                });
              },
            ),
        ],
      ),
    );
  }
}

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          myTile(Icons.shopping_cart, 'Önceki Siparişlerim', () {
            print('object');
          }),
          myTile(Icons.notifications_none, 'Bildirimlerim', () {
            print('object');
          }),
          myTile(Icons.exit_to_app, 'Çıkış yap', () async {
            SharedPreferences localStorage =
                await SharedPreferences.getInstance();
            localStorage.remove('token');
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          }),
        ],
      ),
    );
  }

  myTile(IconData icon, String text, Function ontap) => ListTile(
        leading: Icon(icon),
        title: Text(text),
        onTap: ontap,
      );
}

class Shoplist extends InheritedWidget {
  const Shoplist({
    Key key,
    @required this.color,
    @required Widget child,
  }) : super(key: key, child: child);

  final Color color;

  static Shoplist of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Shoplist>();
  }

  @override
  bool updateShouldNotify(Shoplist old) => color != old.color;
}
