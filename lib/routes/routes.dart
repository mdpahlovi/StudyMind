import 'package:flutter/material.dart';
import '../presentation/community/community.dart';
import '../presentation/flashcard/flashcard.dart';
import '../presentation/home/home.dart';
import '../presentation/library/library.dart';
import '../presentation/notes/notes.dart';
import '../presentation/profile/profile.dart';
import '../widgets/main_layout.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  static const String community = '/community';
  static const String flashcard = '/flashcard';
  static const String library = '/library';
  static const String notes = '/notes';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const MainLayout(child: HomeScreen()),
    home: (context) => const MainLayout(child: HomeScreen()),
    community: (context) => const MainLayout(child: CommunityScreen()),
    flashcard: (context) => const MainLayout(child: FlashcardScreen()),
    library: (context) => const MainLayout(child: LibraryScreen()),
    notes: (context) => const MainLayout(child: NotesScreen()),
    profile: (context) => const MainLayout(child: ProfileScreen()),
  };
}