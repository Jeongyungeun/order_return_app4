import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static ThemeData myThemeDataForLight = ThemeData(
      textButtonTheme: TextButtonThemeData(
          // text button theme style
          style: TextButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        elevation: 3.0,
        primary: Colors.white,
        minimumSize: Size(48, 48),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      )),
      appBarTheme: const AppBarTheme(
          elevation: 2,
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20.0)),
      hintColor: Colors.grey[400],
      primarySwatch: Colors.purple,
      inputDecorationTheme: const InputDecorationTheme(
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent))),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        // backgroundColor: Colors.grey[800],
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.black12,
      ),
      textTheme: TextTheme(
        headline1: GoogleFonts.lato(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        headline2: GoogleFonts.lato(
            fontSize: 27, fontWeight: FontWeight.bold, color: Colors.black),
        headline3: GoogleFonts.lato(
            fontSize: 25, ),
        headline4: GoogleFonts.lato(
            fontSize: 23, ),

        headline5: GoogleFonts.lato(
            fontSize: 21,),

        headline6: GoogleFonts.lato(
            fontSize: 20,),

        subtitle1: GoogleFonts.lato(
          fontSize: 21,
        ),
        bodyText1: GoogleFonts.lato(
          fontSize: 18,
        ),
        bodyText2: GoogleFonts.lato(
          fontSize: 16,
        ),

      )
      // GoogleFonts.latoTextTheme(
      // ),
      );
}
