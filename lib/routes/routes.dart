import 'package:get/get.dart';
import 'package:studymind/presentation/document/document.dart';
import 'package:studymind/presentation/notes/notes.dart';
import 'package:studymind/layouts/main.dart';

class AppRoutes {
  List<GetPage<dynamic>> routes = [
    GetPage(name: '/', page: () => const MainLayout()),
    GetPage(name: '/home', page: () => const MainLayout(), transition: Transition.rightToLeft),
    GetPage(name: '/document', page: () => const DocumentScreen(), transition: Transition.rightToLeft),
    GetPage(name: '/notes', page: () => const NotesScreen(), transition: Transition.rightToLeft),
  ];
}
