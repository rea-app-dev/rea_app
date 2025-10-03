import 'package:flutter/material.dart';
import 'package:reaapp/data/models/property.dart';
import 'package:reaapp/data/models/conversation.dart';

// Screens imports
import '../../screens/auth/welcome_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/kyc_verification_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/navigation/main_navigation.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/home/search_screen.dart';
import '../../screens/home/property_detail_screen.dart';
import '../../screens/chat/conversations_screen.dart';
import '../../screens/chat/chat_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/profile/profile_screen.dart';

class AppRoutes {
  // Route names constants
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String kycVerification = '/kyc-verification';
  static const String main = '/main';
  static const String home = '/home';
  static const String search = '/search';
  static const String propertyDetail = '/property-detail';
  static const String conversations = '/conversations';
  static const String chat = '/chat';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _createRoute(const SplashScreen());

      case welcome:
        return _createRoute(const WelcomeScreen());

      case login:
        return _createRoute(const LoginScreen());

      case register:
        return _createRoute(const RegisterScreen());

      case kycVerification:
        return _createRoute(const KYCVerificationScreen());

      case main:
        return _createRoute(const MainNavigation());

      case home:
        return _createRoute(const HomeScreen());

      case search:
        final args = settings.arguments as Map<String, dynamic>?;
        return _createRoute(SearchScreen(
          searchQuery: args?['searchQuery'],
          country: args?['country'],
          city: args?['city'],
          district: args?['district'],
          propertyType: args?['propertyType'],
          budget: args?['budget'],
        ));

      case propertyDetail:
        final property = settings.arguments as Property;
        return _createRoute(PropertyDetailScreen(property: property));

      case conversations:
        return _createRoute(const ConversationsScreen());

      case chat:
        final conversation = settings.arguments as Conversation;
        return _createRoute(ChatScreen(conversation: conversation));

      case notifications:
        return _createRoute(const NotificationsScreen());

      case profile:
        return _createRoute(const ProfileScreen());

      default:
        return _createRoute(_buildUnknownRoute());
    }
  }

  // Helper to create routes with consistent transitions
  static PageRoute<T> _createRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, _) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Unknown route widget
  static Widget _buildUnknownRoute() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: const Center(
        child: Text('Route not found'),
      ),
    );
  }

  // Navigation helpers
  static Future<T?> pushNamed<T extends Object?>(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      BuildContext context,
      String routeName, {
        Object? arguments,
        TO? result,
      }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
      BuildContext context,
      String routeName,
      bool Function(Route<dynamic>) predicate, {
        Object? arguments,
      }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  // Specific navigation methods for common flows
  static Future<void> goToMain(BuildContext context) {
    return pushNamedAndRemoveUntil(
      context,
      main,
          (route) => false,
    );
  }

  static Future<void> goToAuth(BuildContext context) {
    return pushNamedAndRemoveUntil(
      context,
      welcome,
          (route) => false,
    );
  }

  static Future<void> goToPropertyDetail(BuildContext context, Property property) {
    return pushNamed(
      context,
      propertyDetail,
      arguments: property,
    );
  }

  static Future<void> goToChat(BuildContext context, Conversation conversation) {
    return pushNamed(
      context,
      chat,
      arguments: conversation,
    );
  }

  static Future<void> goToSearch(
      BuildContext context, {
        String? searchQuery,
        String? country,
        String? city,
        String? district,
        PropertyType? propertyType,
        String? budget,
      }) {
    return pushNamed(
      context,
      search,
      arguments: {
        'searchQuery': searchQuery,
        'country': country,
        'city': city,
        'district': district,
        'propertyType': propertyType,
        'budget': budget,
      },
    );
  }
}