import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_page.dart';
import 'screens/registration_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Yapilacaklar());
}

class Yapilacaklar extends StatefulWidget {
  const Yapilacaklar({Key? key}) : super(key: key);

  @override
  State<Yapilacaklar> createState() => _YapilacaklarState();
}

class _YapilacaklarState extends State<Yapilacaklar> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, kullaniciVerisi){
            if(kullaniciVerisi.hasData)///kullanıcı verisi varsa
              return HomePage();
            else
              return RegistrationScreen();
          },
      ),
    );
  }
}
