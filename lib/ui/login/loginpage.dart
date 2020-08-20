import 'dart:convert';

import 'package:ecommorce/model/category.dart';
import 'package:ecommorce/ui/home/home_page.dart';
import 'package:ecommorce/utils/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isAuth;

  List<Category> categories = [];

  void _checkIfLoggedIn() async {
    //showDialog(context: context, child: CupertinoActivityIndicator());
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    //  Navigator.pop(context);
    if (token != null) {
      setState(() {
        isAuth = true;
      });
      String response = await rootBundle.loadString('testjson/categories.json');
      print(Network.domain + MyConstants.categories + 'dan veri çekildi');

      var a = json.decode(response);

      if (a['success']) {
        print(a['categories']);
        for (var i in a['categories']) categories.add(Category.fromJson(i));
      }
    }
  }

  @override
  void initState() {
    isAuth = false;
    _checkIfLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isAuth) {
      child = Home(categories: categories);
    } else {
      child = LoginUI(
        cheklogin: _checkIfLoggedIn,
      );
    }
    return child;
  }
}

class LoginUI extends StatelessWidget {
  final Function cheklogin;

  final TextEditingController domain = new TextEditingController();
  final TextEditingController username = new TextEditingController();
  final TextEditingController url = new TextEditingController();
  final TextEditingController password = new TextEditingController();

  LoginUI({Key key, @required this.cheklogin}) : super(key: key);

  _login(BuildContext context) async {
    // var data = {
    //   'email': username.text,
    //   'password': password.text,
    // };
    // var res = Network().authData(data, url.text + '/login');
    // var body = json.decode(res.body);
    // if (body['success']) {
    //   SharedPreferences localStorage = await SharedPreferences.getInstance();
    //   localStorage.setString('token', json.encode(body['token']));
    //   localStorage.setString('user', json.encode(body['user']));
    //   Navigator.push(
    //     context,
    //     new MaterialPageRoute(builder: (context) => Home()),
    //   );
    // }
    //showDialog(context: context, child: CupertinoActivityIndicator());
    bool success = true;

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    if (success) {
      Network.domain = domain.text;
    }
    localStorage.setString('token', 'yusuf');
    if (username.text == 'admin') {
      localStorage.setString('user', 'admin');
      cheklogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    domain.text = 'https://www.modayagmur.com.tr/';
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: loginBody(context),
      ),
    );
  }

  loginBody(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[loginHeader(), loginFields(context)],
        ),
      );

  loginHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset('assets/modasistem.png'),
          Text(
            "Modasistem.com'a hoş geldiniz",
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.green),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "Devam etmek için giriş yapın",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );

  loginFields(BuildContext context) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Site Adresi",
                  labelText: "Modasistem.com",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                controller: username,
                decoration: InputDecoration(
                  hintText: "Kullanıcı Adı",
                  labelText: "Kullanıcı Adı",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                obscureText: true,
                controller: password,
                decoration: InputDecoration(
                  hintText: "Şifre",
                  labelText: "Şifre",
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.all(12.0),
                shape: StadiumBorder(),
                child: Text(
                  "Giriş Yap",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                onPressed: () {
                  _login(context);
                },
              ),
            ),
          ],
        ),
      );
}
