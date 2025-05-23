import 'package:get/get.dart';
import 'package:studymind/layouts/main.dart';
import 'package:studymind/presentation/document/document.dart';
import 'package:studymind/presentation/flashcard/flashcard.dart';
import 'package:studymind/presentation/media/media.dart';
import 'package:studymind/presentation/note/note.dart';
import 'package:studymind/presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String document = '/document';
  static const String note = '/note';
  static const String flashcard = '/flashcard';
  static const String media = '/media';

  List<GetPage<dynamic>> routes = [
    GetPage(name: '/', page: () => const SplashScreen(), transition: Transition.fadeIn),
    GetPage(name: home, page: () => const MainLayout(), transition: Transition.fadeIn),
    GetPage(name: document, page: () => const DocumentScreen(), transition: Transition.fadeIn),
    GetPage(name: note, page: () => const NoteScreen(), transition: Transition.fadeIn),
    GetPage(name: flashcard, page: () => const FlashcardScreen(), transition: Transition.fadeIn),
    GetPage(name: media, page: () => const MediaScreen(), transition: Transition.fadeIn),
  ];
}
