import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  cardColor: const Color.fromRGBO(64, 75, 96, 1.0),
  accentColor: const Color.fromRGBO(186, 205, 239, 1),
  errorColor: Colors.red[600],
  highlightColor: Colors.white,
  fontFamily: 'SourceSansPro',
  textTheme: ThemeData.dark().textTheme.copyWith(
        bodyText1: const TextStyle(
          fontSize: 16,
          fontFamily: 'SourceSansPro',
          color: Colors.white,
        ),
        headline6: const TextStyle(
          fontSize: 30,
          fontFamily: 'SourceSansPro',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
);

ThemeData lightTheme = ThemeData(
  // backgroundColor: const Color.fromRGBO(234, 237, 246, 1),
  backgroundColor: Colors.white,
  brightness: Brightness.light,
  primaryColor: Colors.blueGrey[700],
  accentColor: Colors.blue[600],
  cardColor: const Color.fromRGBO(245, 247, 253, 1),
  highlightColor: Colors.black54,
  errorColor: Colors.red[600],
  fontFamily: 'SourceSansPro',
  textTheme: ThemeData.light().textTheme.copyWith(
        bodyText1: TextStyle(
          fontSize: 16,
          fontFamily: 'SourceSansPro',
          color: Colors.blueGrey[700],
        ),
        headline6: TextStyle(
          fontSize: 30,
          fontFamily: 'SourceSansPro',
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[700],
        ),
      ),
);
