import 'package:get/get.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/controllers/main.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController(), permanent: true);
    Get.put(LibraryController(), permanent: true);
    Get.put(ItemCreateController(), permanent: true);
    Get.put(ChatController(), permanent: true);
  }
}
