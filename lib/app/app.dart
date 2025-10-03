import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:reaapp/providers/local_provider.dart';
import 'package:reaapp/providers/theme_provider.dart';
import '../core/theme/app_theme.dart';
import '../core/routes/app_routes.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/navigation/main_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class REAApp extends StatelessWidget {
  const REAApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthProvider, ThemeProvider, LocaleProvider>(
      builder: (context, auth, themeProvider, localeProvider, _) {
        return MaterialApp(
          title: 'REA - Real Estate Agent',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('fr', 'FR'),
            Locale('en', 'US'),
          ],

          // Route configuration
          initialRoute: auth.isAuthenticated ? AppRoutes.main : AppRoutes.welcome,
          onGenerateRoute: AppRoutes.generateRoute,

          // Fallback for unknown routes
          onUnknownRoute: (settings) => AppRoutes.generateRoute(
            RouteSettings(name: AppRoutes.welcome),
          ),

          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}