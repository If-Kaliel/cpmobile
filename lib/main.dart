import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cp1mobile/pages/nightclub_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //Fundo do Scaffold transparente pra aparecer a imagem da balada
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wallpaper.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: NightclubPage(),
      ),
    );
  }
}

