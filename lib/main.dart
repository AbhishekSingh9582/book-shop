import 'package:book_app/provider/user_Provider.dart';
import 'package:book_app/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/book_provider.dart';
import './screens/auth_page.dart';
import './screens/home.dart';
import './screens/single_category_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (ctx) => BookProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: const TextTheme(
              headline1: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              headline2: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
              headline3: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            appBarTheme: const AppBarTheme(
                color: Colors.white,
                shape: Border(
                    bottom: BorderSide(color: Color.fromARGB(255, 69, 66, 66))),
                titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
                iconTheme: IconThemeData(color: Colors.black))),
        routes: {
          SingleCategoryPage.routeArgs: (context) => SingleCategoryPage(),
        },
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong!'));
              } else if (snapshot.hasData) {
                return HomePage();
              } else {
                return AuthPage();
              }
            }),
      ),
    );
  }
}
//HomePage()