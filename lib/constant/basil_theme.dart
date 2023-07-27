// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// @immutable
// class BasilTheme {
//   final Color primaryColor, secondaryColor, neutralColor;

//   const BasilTheme({
//     this.primaryColor = const Color(0xFF1D267D),
//     this.secondaryColor = const Color(0xFF5C469C),
//     this.neutralColor = const Color(0xFFD4ADFC),
//   });

//   ThemeData toThemeData() {
//     ColorScheme colorScheme = ColorScheme.fromSeed(
//       seedColor: const Color(0xFF1D267D),
//       primary: const Color(0xFF554AF0),
//       secondary: const Color(0xFFFABB18),
//       surface: Colors.white,
//       background: Colors.white,
//       error: Colors.red,
//       onPrimary: Colors.white,
//       onSecondary: Colors.white,
//       onSurface: Colors.black,
//       onBackground: Colors.black,
//       onError: Colors.white,
//       brightness: Brightness.light,
//     );

//     final primaryTextTheme = GoogleFonts.montserratTextTheme();
//     // final secondaryTextTheme = GoogleFonts.lektonTextTheme();
//     final textTheme = primaryTextTheme.copyWith(
//       displaySmall: primaryTextTheme.displaySmall,
//       displayMedium: primaryTextTheme.displayMedium,
//       displayLarge: primaryTextTheme.displayLarge,
//     );

//     // final appBarTheme = AppBarTheme(
//     //     backgroundColor: colorScheme.primary,
//     //     centerTitle: true,
//     //     shape: const RoundedRectangleBorder(
//     //         borderRadius: BorderRadius.only(
//     //       bottomLeft: Radius.circular(12.0),
//     //       bottomRight: Radius.circular(12.0),
//     //     )),
//     //     titleTextStyle: TextStyle(color: Colors.white));
//     return ThemeData(
//         useMaterial3: true, textTheme: textTheme, colorScheme: colorScheme);
//   }
// }
