import 'package:get/get.dart';
import 'package:studymind/bindings/initial.dart';
import 'package:studymind/bindings/library.dart';
import 'package:studymind/layouts/main.dart';
import 'package:studymind/presentation/chatbot/chatbot.dart';
import 'package:studymind/presentation/forgot_password/forgot_password.dart';
import 'package:studymind/presentation/item_create/item_create.dart';
import 'package:studymind/presentation/item_details/item_details.dart';
import 'package:studymind/presentation/library/widgets/item_by_folder.dart';
import 'package:studymind/presentation/library/widgets/item_by_type.dart';
import 'package:studymind/presentation/login/login.dart';
import 'package:studymind/presentation/notification/notification.dart';
import 'package:studymind/presentation/register/register.dart';
import 'package:studymind/presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot_password';
  static const String home = '/home';
  static const String itemByType = '/item_by_type/:type';
  static const String itemByFolder = '/item_by_folder/:uid';
  static const String notification = '/notification';
  static const String itemCreate = '/item_create/:type';
  static const String itemDetails = '/item_details/:uid';
  static const String chatSession = '/chat_session/:uid';

  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
      binding: InitialBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: register,
      page: () => const RegisterScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: home,
      page: () => const MainLayout(),
      binding: LibraryBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: itemByType,
      page: () => const ItemByType(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: itemByFolder,
      page: () => const ItemByFolder(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: notification,
      page: () => const NotificationScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: itemCreate,
      page: () => const ItemCreateScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: itemDetails,
      page: () => const ItemDetailsScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: chatSession,
      page: () => const ChatbotScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
