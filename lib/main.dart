// main.dart avec structure séparée
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reaapp/providers/category_provider.dart';
import 'package:reaapp/providers/local_provider.dart';
import 'package:reaapp/providers/theme_provider.dart';
import 'app/app.dart';
import 'providers/auth_provider.dart';
import 'providers/property_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: const REAApp(),
    ),
  );
}