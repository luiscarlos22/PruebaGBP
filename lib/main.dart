import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_gbp/src/pages/user_list_page.dart';
import 'package:prueba_gbp/src/providers/activities_provider.dart';
import 'package:prueba_gbp/src/providers/user_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => new UserProvider(),
        ),
        ChangeNotifierProvider<ActivitiesProvider>(
          create: (_) => new ActivitiesProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Prueba GBP',
        home: UserListPage(),
      ),
    );
  }
}
