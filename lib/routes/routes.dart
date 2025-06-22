import 'package:get/get.dart';
import 'package:studymind/bindings/initial.dart';
import 'package:studymind/bindings/main.dart';
import 'package:studymind/layouts/main.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_session.dart';
import 'package:studymind/presentation/edit_profile/edit_profile.dart';
import 'package:studymind/presentation/faq/faq.dart';
import 'package:studymind/presentation/forgot_password/forgot_password.dart';
import 'package:studymind/presentation/item_create/item_create.dart';
import 'package:studymind/presentation/item_details/item_details.dart';
import 'package:studymind/presentation/library/widgets/item_by_folder.dart';
import 'package:studymind/presentation/library/widgets/item_by_type.dart';
import 'package:studymind/presentation/login/login.dart';
import 'package:studymind/presentation/notification/notification.dart';
import 'package:studymind/presentation/register/register.dart';
import 'package:studymind/presentation/removed_chat/removed_chat.dart';
import 'package:studymind/presentation/removed_item/removed_item.dart';
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
  static const String editProfile = '/edit_profile';
  static const String removedItem = '/removed_item';
  static const String removedChat = '/removed_chat';
  static const String faq = '/faq';

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
      binding: MainBinding(),
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
      page: () => const ChatSessionScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfileScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: removedChat,
      page: () => const RemovedChatScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: removedItem,
      page: () => const RemovedItemScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: faq,
      page: () => const FAQScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
