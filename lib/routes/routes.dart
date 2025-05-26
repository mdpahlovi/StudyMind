import 'package:get/get.dart';
import 'package:studymind/layouts/main.dart';
import 'package:studymind/presentation/document/document.dart';
import 'package:studymind/presentation/flashcard/flashcard.dart';
import 'package:studymind/presentation/forgot_password/forgot_password.dart';
import 'package:studymind/presentation/library/widgets/item_details.dart';
import 'package:studymind/presentation/login/login.dart';
import 'package:studymind/presentation/media/media.dart';
import 'package:studymind/presentation/note/note.dart';
import 'package:studymind/presentation/register/register.dart';
import 'package:studymind/presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String home = '/home';
  static const String document = '/document';
  static const String note = '/note';
  static const String flashcard = '/flashcard';
  static const String media = '/media';
  static const String library = '/library/:id';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  List<GetPage<dynamic>> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen(), transition: Transition.fadeIn),
    GetPage(name: home, page: () => const MainLayout(), transition: Transition.fadeIn),
    GetPage(name: document, page: () => const DocumentScreen(), transition: Transition.fadeIn),
    GetPage(name: note, page: () => const NoteScreen(), transition: Transition.fadeIn),
    GetPage(name: flashcard, page: () => const FlashcardScreen(), transition: Transition.fadeIn),
    GetPage(name: media, page: () => const MediaScreen(), transition: Transition.fadeIn),
    GetPage(name: library, page: () => const ItemDetails(), transition: Transition.fadeIn),
    GetPage(name: login, page: () => const LoginScreen(), transition: Transition.fadeIn),
    GetPage(name: register, page: () => const RegisterScreen(), transition: Transition.fadeIn),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen(), transition: Transition.fadeIn),
  ];
}
