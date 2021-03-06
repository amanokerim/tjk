import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tjk/const.dart';
import 'package:tjk/models/product.dart';
import 'package:tjk/providers/accountP.dart';
import 'package:tjk/providers/appP.dart';
import 'package:tjk/providers/cartP.dart';
import 'package:tjk/providers/favoritesP.dart';
import 'package:tjk/providers/homeP.dart';
import 'package:tjk/views/mainV.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
  ));
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  await Hive.openBox("tjk");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppP>(create: (context) => AppP()),
        ChangeNotifierProvider<AccountP>(create: (context) => AccountP()),
        ChangeNotifierProxyProvider2<AppP, AccountP, CartP>(
          create: (context) => CartP(),
          update: (context, app, account, cart) => cart
            ..ln = app.ln
            ..account = account,
        ),
        ChangeNotifierProxyProvider<AppP, FavoritesP>(
          create: (context) => FavoritesP(),
          update: (context, app, favorites) => favorites..tjkBox = app.tjkBox,
        ),
        ChangeNotifierProxyProvider<AppP, HomeP>(
          create: (_) => HomeP(),
          update: (_, app, home) => home..ln = app.ln,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.light,
          iconTheme: IconThemeData(
            color: primaryColor,
          ),
          primarySwatch: primaryColor,
        ),
        home: MainV(),
      ),
    );
  }
}
