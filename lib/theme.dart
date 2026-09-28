import 'package:flutter/material.dart';

const kPrimary = Color(0xFFFF6B4A);
const kBg = Color(0xFFFFF8F3);
const kText = Color(0xFF2B2B2B);
const kMuted = Color(0xFF8A8A8A);
const kBorder = Color(0xFFEFE3DA);

ThemeData buildTheme() => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: kBg,
  colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
  appBarTheme: const AppBarTheme(
    backgroundColor: kBg,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
    foregroundColor: kText,
    titleTextStyle: TextStyle(
        color: kText, fontSize: 20, fontWeight: FontWeight.w800),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      minimumSize: const Size.fromHeight(52),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),
);

InputDecoration inputDeco(String label, IconData icon, {Widget? suffix}) {
  OutlineInputBorder b(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: c),
  );
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: kPrimary),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    border: b(kBorder),
    enabledBorder: b(kBorder),
    focusedBorder: b(kPrimary),
  );
}

void snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: kText,
    ));
}